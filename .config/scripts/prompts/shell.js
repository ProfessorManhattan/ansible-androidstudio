import inquirer from 'inquirer'
import signale from 'signale'
import { decorateSystem } from './lib/decorate-system'

/**
 * Prompts the user for the operating system they wish to launch a shell session with.
 *
 * @returns {string} The selected operating system, lowercased, in the format the Taskfile is expecting
 */
async function promptForShell() {
  const choices = [
    'Archlinux',
    'CentOS 7',
    'CentOS 8',
    'Debian 9',
    'Debian 10',
    'Fedora 33',
    'Fedora 34',
    'Ubuntu 18.04',
    'Ubuntu 20.04',
    'Ubuntu 21.04'
  ]
  const choicesDecorated = choices.map((choice) => decorateSystem(choice))
  const response = await inquirer.prompt([
    {
      choices: choicesDecorated,
      message: 'Which operating system would you like to open up a terminal session with?',
      name: 'operatingSystem',
      type: 'list'
    }
  ])

  return response.operatingSystem.replace('● ', '').toLowerCase().replace(' ', '-')
}

/**
 * Main script logic
 */
async function run() {
  signale.info(
    'Open a shell session quickly, safely, and easily using Docker.' +
      'Select an option from the prompt below to download and shell into a Docker environment.'
  )
  const choice = await promptForShell()
  // eslint-disable-next-line no-console
  console.log(choice)
}

run()
