import chalk from 'chalk'
import inquirer from 'inquirer'
import { execSync } from 'node:child_process'
import signale from 'signale'
import { decorateFiles } from './lib/decorate-files.js'
import { logInstructions, LOG_DECORATOR_REGEX } from './lib/log.js'

const DECORATION_LENGTH = 2

/**
 * Prompts for the name of the project
 *
 * @returns {string} The project name
 */
async function promptForName() {
  logInstructions(
    'Project Name',
    'The project name should be a short, capitalized title for the project. The name is used' +
      ' for the GitLab project title, references to the project in documentation,' +
      ' and as a title for the README.md when the blueprint.title is not specified.'
  )
  const response = await inquirer.prompt([
    {
      message: 'Enter a short, descriptive name for the project:',
      name: 'name',
      type: 'input'
    }
  ])

  return response.name
}

/**
 * Prompts for a brief description of the project
 *
 * @returns {string} The description
 */
async function promptForDescription() {
  logInstructions(
    'Description Instructions',
    `${
      'The brief description should describe the project in as few words as possible while' +
      ' still giving users enough information to know exactly what the project is all about.' +
      ' The description should make sense when placed in the following contexts:\n\n'
    }${chalk.white('●')} A project that {{ description }}\n${chalk.white(
      '●'
    )} This repository is home to a project that {{ description }}`
  )
  const response = await inquirer.prompt([
    {
      message: 'Enter a brief description of the project (no more than 100 characters):',
      name: 'description',
      type: 'input'
    }
  ])

  return response.description
}

/**
 * Asks what group the project belongs to
 *
 * @param {string} gitUrl - The GitLab URL
 * @returns {string} The group
 */
async function promptForGroup(gitUrl) {
  const guesses = {
    angular: '/apps/',
    ansible: '/ansible-roles/',
    docker: '/docker/',
    go: '/go/',
    npm: '/npm/',
    packer: '/packer/',
    python: '/python/'
  }
  const guess = Object.entries(guesses)
    .map((value) => (gitUrl.includes(value[1]) ? value[0] : false))
    .find((exists) => exists)
  if (guess) {
    return guess
  }
  const choices = ['Angular', 'Ansible', 'Docker', 'Go', 'Node.js', 'Packer', 'Python', 'Other']
  const decoratedChoices = choices.map((choice) => decorateFiles(choice))
  const response = await inquirer.prompt([
    {
      choices: decoratedChoices,
      message: 'What group does this project belong to?',
      name: 'group',
      type: 'list'
    }
  ])

  return response.group
    .replace('Node.js', 'npm')
    .replace(LOG_DECORATOR_REGEX, '')
    .toLowerCase()
    .slice(DECORATION_LENGTH)
    .replace(' ', '-')
}

const subgroups = {
  angular: {
    app: '/apps/',
    website: '/website/'
  },
  ansible: {
    playbook: '/non-existant-currently/',
    role: '/ansible-roles/'
  },
  docker: {
    'ansible-molecule': '/ansible-molecule/',
    app: '/docker/app/',
    'ci-pipeline': '/ci-pipeline/',
    'docker-compose': '/docker-compose/',
    software: '/docker/software/'
  },
  go: {
    cli: '/go/cli/',
    library: '/go/library/'
  },
  npm: {
    app: '/npm/app/',
    cli: '/npm/cli/',
    config: '/npm/config/',
    library: '/npm/library/',
    plugin: '/npm/plugin/'
  },
  packer: {
    desktop: 'desktop',
    server: 'server'
  },
  python: {
    cli: '/python/cli/',
    library: '/python/library/'
  }
}

const choiceOptions = {
  angular: ['Application', 'Website', 'Other'],
  ansible: ['Playbook', 'Role', 'Other'],
  docker: ['Ansible Molecule', 'Application', 'CI Pipeline', 'Docker Compose', 'Software', 'Other'],
  go: ['CLI', 'Library', 'Other'],
  npm: ['Application', 'CLI', 'Configuration', 'Library', 'Plugin', 'Other'],
  packer: ['Desktop', 'Server', 'Other'],
  python: ['CLI', 'Library', 'Other']
}

/**
 * Asks what subgroup the project belongs to
 *
 * @param {string} gitUrl - The GitLab URL
 * @param {string} group - The project's group
 * @returns {string} The subgroup
 */
async function promptForSubgroup(gitUrl, group) {
  if (group === 'other') {
    return 'other'
  }
  // eslint-disable-next-line security/detect-object-injection
  const guesses = subgroups[group] ? subgroups[group] : {}
  const guess = Object.entries(guesses)
    .map((value) => (gitUrl.includes(value[1]) ? value[0] : false))
    .find((exists) => exists)
  if (guess) {
    return guess
  }
  // eslint-disable-next-line security/detect-object-injection
  const choices = choiceOptions[group]
  const decoratedChoices = choices.map((choice) => decorateFiles(choice))
  const response = await inquirer.prompt([
    {
      choices: decoratedChoices,
      message: 'What sub-group does this project belong to?',
      name: 'subgroup',
      type: 'list'
    }
  ])

  return response.subgroup
    .replace('Application', 'app')
    .replace('Configuration', 'config')
    .replace(LOG_DECORATOR_REGEX, '')
    .toLowerCase()
    .slice(DECORATION_LENGTH)
    .replace(' ', '-')
}

/**
 * Prompts for the GitHub repository
 *
 * @returns {string} The GitHub repository
 */
async function githubPrompt() {
  const response = await inquirer.prompt([
    {
      message:
        'What is planned GitHub repository HTTPS address' +
        ' (e.g. https://github.com/ProfessorManhattan/ansible-androidstudio)?',
      name: 'github',
      type: 'input'
    }
  ])

  return response.github
}

/**
 * Prompts for the GitLab repository
 *
 * @returns {string} The GitLab repository
 */
async function gitlabPrompt() {
  const response = await inquirer.prompt([
    {
      message: 'What is planned GitLab repository HTTPS address (e.g. https://gitlab.com/megabyte-labs/gas-station)?',
      name: 'gitlab',
      type: 'input'
    }
  ])

  return response.gitlab
}

/**
 * This step acquires the git repositories by first checking `git remote get-url origin` and
 * then prompting the user for missing information
 *
 * @returns {*} An object containing the GitLab and GitHub repositories
 */
// eslint-disable-next-line max-statements, require-jsdoc
async function getGitRepositories() {
  // eslint-disable-next-line functional/no-try-statement
  try {
    const gitOrigin = execSync(`git remote get-url origin'`, {
      stdio: 'inherit'
    })
    if (gitOrigin.includes('gitlab.com')) {
      signale.info('Detected GitLab address automatically')
      const github = await githubPrompt()

      return {
        github,
        gitlab: gitOrigin
          .replace('git@gitlab', 'https://gitlab')
          .replace('gitlab.com:', 'gitlab.com/')
          .replace('.git', '')
      }
    } else if (gitOrigin.includes('github.com')) {
      signale.info('Detected GitHub address automatically')
      const gitlab = await gitlabPrompt()

      return {
        github: gitOrigin
          .replace('git@github', 'https://gitlab')
          .replace('github.com:', 'github.com/')
          .replace('.git', ''),
        gitlab
      }
    }
    // eslint-disable-next-line functional/no-throw-statement, fp/no-throw
    throw Error
  } catch {
    const gitlab = await gitlabPrompt()
    const github = await githubPrompt()

    return {
      github,
      gitlab
    }
  }
}

/**
 * Open editor where user can add markdown for the overview.
 *
 * @returns {string} The markdown used for the overview
 */
async function promptForOverview() {
  const response = await inquirer.prompt([
    {
      message: 'Enter an overview for the project',
      name: 'overview',
      type: 'editor'
    }
  ])

  return response.overview
}

/**
 * Writes to package.json with jq
 *
 * @param {string} value - The value being written
 * @param {string} location - The jq key of package.json being written to
 * @returns {void}
 */
function writeField(value, location) {
  execSync(`jq --arg field "${value}" '.blueprint.${location} = $field' package.json`, {
    stdio: 'inherit'
  })
}

/**
 * Main script logic
 */
// eslint-disable-next-line max-statements, require-jsdoc
async function run() {
  logInstructions(
    'Package Initialization',
    'Provide answers to the following prompts to initialize the project. Some parts of the build process' +
      ' are dependent on some of the answers, so it is important to answer the questions.'
  )
  const name = await promptForName()
  writeField(name, 'name')
  const title = name
  writeField(title, 'title')
  const desc = await promptForDescription()
  writeField(desc, 'description')
  const gits = await getGitRepositories()
  writeField(gits.gitlab, 'repository.gitlab')
  writeField(gits.github, 'repository.github')
  const group = await promptForGroup(gits.gitlab)
  writeField(group, 'group')
  const subgroup = await promptForSubgroup(gits.gitlab, group)
  writeField(subgroup, 'subgroup')
  const overview = await promptForOverview()
  writeField(overview, 'overview')
  const slug = gits.gitlab.split('/').at(-1)
  writeField(slug, 'slug')
}

run()
