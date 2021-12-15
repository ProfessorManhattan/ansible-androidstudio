import inquirer from 'inquirer'
import { execSync } from 'node:child_process'
import { decorateSystem } from '../lib/decorate-system.js'
import { logInstructions, LOG_DECORATOR_REGEX } from '../lib/log.js'

/**
 * Prompts the user for the operating system they wish to launch and test the
 * Ansible play against.
 *
 * @returns {string} The operating system string, lowercased
 */
async function promptForDesktop() {
  const choices = ['Archlinux', 'CentOS', 'Debian', 'Fedora', 'macOS', 'Ubuntu', 'Windows']
  const choicesDecorated = choices.map((choice) => decorateSystem(choice))
  const response = await inquirer.prompt([
    {
      choices: choicesDecorated,
      message: 'Which desktop operating system would you like to test the Ansible play against?',
      name: 'operatingSystem',
      type: 'list'
    }
  ])

  const DECORATION_LENGTH = 2

  return response.operatingSystem.replace(LOG_DECORATOR_REGEX, '').toLowerCase().slice(DECORATION_LENGTH)
}

/**
 * Main script logic
 */
async function run() {
  logInstructions(
    'Molecule Test',
    'There are currently five different options for running Molecule tests.\n\n' +
      '1. \n' +
      '2. \n' +
      '3. \n' +
      '4. \n' +
      '5. '
  )
  const environment = await promptForDesktop()
  execSync(`task ansible:test:molecule:virtualbox:converge:cli -- ${environment}`, { stdio: 'inherit' })
}

run()
