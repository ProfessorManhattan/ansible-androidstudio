/* eslint-disable no-console, sonarjs/no-nested-template-literals */
import chalk from 'chalk'
import * as stringBreak from 'string-break'

const MESSAGE_MAX_WIDTH = 80

/**
 * Logs an informational message with pleasent styling
 *
 * @param {string} title - The title to show in emphasized styling
 * @param {string} message - The instructions for the operation
 */
export function logInstructions(title, message) {
  console.log(`\n${chalk.white.bgBlueBright.bold(`   ${title}   `)}`)
  const formattedMessage =
    process.stdout.columns > MESSAGE_MAX_WIDTH ? stringBreak(message, MESSAGE_MAX_WIDTH).join('\n') : message
  console.log(`\n${formattedMessage}\n`)
}
