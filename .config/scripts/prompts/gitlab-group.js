import inquirer from 'inquirer'
import { execSync } from 'node:child_process'
import { writeFileSync } from 'node:fs'
import { logInstructions } from './lib/log.js'

/**
 * Prompts the user for the GitLab group they wish to run bulk commands on.
 *
 * @returns {string} The group path string
 */
async function promptForGroup() {
  const response = await inquirer.prompt([
    {
      message: 'Enter the URL of the group you wish to target:',
      name: 'groupURL',
      type: 'input'
    }
  ])

  return response.groupURL.replace('https://gitlab.com/', '').replace('gitlab.com/', '')
}

/**
 * Open editor where user can create the bash script they wish to run.
 *
 * @returns {string} The bash script the user created
 */
async function promptForScript() {
  const response = await inquirer.prompt([
    {
      message: 'Enter the bash script',
      name: 'bashScript',
      type: 'editor'
    }
  ])

  return response.bashScript
}

/**
 * Main script logic
 */
async function run() {
  logInstructions(
    'GitLab Group Command',
    'Enter the URL of the GitLab group and this program will run a script on all projects in' +
      ' that group and its subgroup. After you enter the URL, an editor will open up where you can' +
      ' write/paste a bash script.'
  )
  const choice = await promptForGroup()
  const script = await promptForScript()
  writeFileSync('.cache/gitlab-group-script.sh', script)
  execSync(`task git:gitlab:group:exec:cli -- ${choice} ---- 'bash ${process.cwd()}/.cache/gitlab-group-script.sh'`, {
    stdio: 'inherit'
  })
}

run()
