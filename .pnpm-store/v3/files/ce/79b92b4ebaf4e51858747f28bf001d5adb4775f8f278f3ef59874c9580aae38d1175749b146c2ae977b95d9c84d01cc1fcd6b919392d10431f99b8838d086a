'use strict'

const stringBreak = require('../index')
const clear = require('cli-clear')

const str = '远处海港传来阵阵船笛 我一直飘零到被你拣起 如今望著反映窗户玻璃 有个我陌生又熟悉 I can Smile a little more Sing a little more Feel a little more 全因为你 说好了要为幸福 一天天地练习 练习 Laugh a little more Love myself a little more 要学会更加善待我自己 为你我变成了 Better me 甚麼距离都不算是真的分离 想念和默契能代替一切言语 有一天生命会老去 还好谢谢有你 在你眼中 I see the better in me Coz I can Smile a little more Sing a little more Feel a little more 全因为你 说好了要为幸福 一天天地练习 练习 Laugh a little more Love myself a little more 要学会更加善待我自己 为你我变成了 Better me 就是那麼神奇 从前的错都有意义 教我抛开所有猜疑 也许 我也美丽 值得一个奇迹 我的眼泪会坠落 绝不是因为懦弱 而是感谢天让我遇见你 不然今天就不能 如此地有勇气 Now I promise to you And I can swear to you 为你我 一定加倍 爱护我自己 做一个值得你 骄傲的 Better me 一个值得你爱的Better me'

let width = 50

function output () {
  clear()
  console.log(`width: ${width}`)
  console.log('')
  console.log(stringBreak(str, width).join('\n'))

  width = width + 2

  if (width <= 80) {
    setTimeout(output, 500)
  }
}

output()
