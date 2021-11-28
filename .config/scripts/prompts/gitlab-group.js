import inquirer from 'inquirer'
import signale from 'signale'

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
 * Main script logic
 */
async function run() {
  signale.info(
    'Enter the URL of the GitLab group and this program will run a script on all projects in' +
      ' that group and its subgroup. After you enter the URL, an editor will open up where you can' +
      ' write/paste a bash script.'
  )
  const choice = await promptForGroup()
  // eslint-disable-next-line no-console
  console.log(choice)
}

run()
