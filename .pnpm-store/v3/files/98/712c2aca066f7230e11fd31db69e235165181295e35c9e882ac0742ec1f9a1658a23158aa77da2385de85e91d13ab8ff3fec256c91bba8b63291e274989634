'use strict'

/* eslint-disable no-extra-parens, max-params */

const stringWidth = require('string-width')

// "开"标点
let openPunctuations = [
  // 中文
  '“', '‘', '（', '《', '〈', '〔', '【',

  // 英文
  '(', '[', '{'
]

function isOpenPunctuation (char) {
  return openPunctuations.includes(char)
}

// "闭"标点
let closePunctuations = [
  // 中文
  '。', '？', '！', '，', '、', '；', '”',
  '’', '）', '》', '〉', '〕', '】',

  // 英文
  '.', '?', '!', ',', ';', ')', ']', '}'
]

function isClosePunctuation (char) {
  return closePunctuations.includes(char)
}

// "其他"标点
let otherPunctuations = [
  // 中文
  '：', '─', '…', '·',

  // 英文
  // eslint-disable-next-line quotes
  ':', '-', '–', '—', '"', "'"
]

function isPunctuation (char) {
  return openPunctuations.includes(char) ||
    closePunctuations.includes(char) ||
    otherPunctuations.includes(char)
}

// 中文
function isFullWidthChar (char) {
  return /[\u4e00-\u9fa5]/.test(char)
}

// 获取下一个分割点
function getNextBreakPoint (str, width, from, lastIndex) {
  let idealIndex = from
  let length = str.length
  let subWidth = 0

  // 获取下一个理论上的分割点的索引
  do {
    idealIndex++
    subWidth = stringWidth(str.slice(from, idealIndex))
  } while ((subWidth <= width) && (idealIndex <= length))

  // 获取下一个实际分割点（只退不进）
  let index = idealIndex - 1

  if (index >= length) {
    return length
  }

  while (index > lastIndex) {
    let preValue = str.charAt(index - 1)
    let value = str.charAt(index)
    let canBreak = preValue === ' ' || value === ' ' ||
      (isFullWidthChar(value) && isFullWidthChar(preValue)) ||
      (isClosePunctuation(preValue) && !isPunctuation(value)) ||
      (!isPunctuation(preValue) && isOpenPunctuation(value)) ||
      (isClosePunctuation(preValue) && isOpenPunctuation(value))

    if (canBreak) {
      break
    } else {
      index--
    }
  }

  // 强制截断
  if (index <= lastIndex) {
    index = idealIndex
  }

  return index
}

function breaker (str, width) {
  if (width < 2) {
    throw new Error('Width must be greater than 2')
  }

  let length = str.length
  let index = 0
  let breakPoint = 0
  let line; let lines = []

  while (index < length) {
    breakPoint = getNextBreakPoint(str, width, index, breakPoint)
    line = str.slice(index, breakPoint).trim()

    lines.push(line)

    index = breakPoint
  }

  return lines
}

module.exports = breaker
