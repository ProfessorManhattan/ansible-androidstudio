'use strict'

/* eslint-disable max-len, max-nested-callbacks */

const stringWidth = require('string-width')
const stringBreak = require('../index.js')

const chai = require('chai')
chai.should()

describe('String Break Test', function () {
  const strObjs = [
    {
      title: '英文',
      text: 'At first I used to say to myself, "There are no dangers which will stop him; he is terrible." Now I have ended by getting used to it. I make a sign to Madam Magloire that she is not to oppose him. He risks himself as he sees fit.I carry off Madam Magloire, I enter my chamber, I pray for him and fall asleep.I am at ease, because I know that if anything were to happen to him, it would be the end of me.I should go to the good God with my brother and my bishop.It has cost Madam Magloire more trouble than it did me to accustom herself to what she terms his imprudences. But now the habit has been acquired.We pray together, we tremble together, and we fall asleep.If the devil were to enter this house, he would be allowed to do so.After all, what is there for us to fear in this house?There is always some one with us who is stronger than we.The devil may pass through it, but the good God dwells here.'
    },
    {
      title: '中文',
      text: '永和九年，岁在癸丑，暮春之初，会于会稽山阴之兰亭，修禊事也。群贤毕至，少长咸集。此地有崇山峻岭，茂林修竹；又有清流激湍，映带左右，引以为流觞曲水，列坐其次。虽无丝竹管弦之盛，一觞一咏，亦足以畅叙幽情。是日也，天朗气清，惠风和畅，仰观宇宙之大，俯察品类之盛，所以游目骋怀，足以极视听之娱，信可乐也。 夫人之相与，俯仰一世，或取诸怀抱，悟言一室之内；或因寄所托，放浪形骸之外。虽趣舍万殊，静躁不同，当其欣于所遇，暂得于己，快然自足，不知老之将至。及其所之既倦，情随事迁，感慨系之矣。向之所欣，俯仰之间，已为陈迹，犹不能不以之兴怀。况修短随化，终期于尽。古人云：“死生亦大矣。”岂不痛哉！(不知老之将至 一作：曾不知老之将至) 每览昔人兴感之由，若合一契，未尝不临文嗟悼，不能喻之于怀。固知一死生为虚诞，齐彭殇为妄作。后之视今，亦犹今之视昔。悲夫！故列叙时人，录其所述，虽世殊事异，所以兴怀，其致一也。后之览者，亦将有感于斯文。'
    },
    {
      title: '英文 + 中文',
      text: '《Better Me》 远处海港传来阵阵船笛 我一直飘零到被你拣起 如今望著反映窗户玻璃 有个我陌生又熟悉 I can Smile a little more Sing a little more Feel a little more 全因为你 说好了要为幸福 一天天地练习 练习 Laugh a little more Love myself a little more 要学会更加善待我自己 为你我变成了 Better me 甚麼距离都不算是真的分离 想念和默契能代替一切言语 有一天生命会老去 还好谢谢有你 在你眼中 I see the better in me Coz I can Smile a little more Sing a little more Feel a little more 全因为你 说好了要为幸福 一天天地练习 练习 Laugh a little more Love myself a little more 要学会更加善待我自己 为你我变成了 Better me 就是那麼神奇 从前的错都有意义 教我抛开所有猜疑 也许 我也美丽 值得一个奇迹 我的眼泪会坠落 绝不是因为懦弱 而是感谢天让我遇见你 不然今天就不能 如此地有勇气 Now I promise to you And I can swear to you 为你我 一定加倍 爱护我自己 做一个值得你 骄傲的 Better me 一个值得你爱的Better me'
    }
  ]

  for (let width = 20; width <= 21; width++) {
    strObjs.forEach(({ title, text }) => {
      it(`${title} width: ${width}`, () => {
        return stringBreak(text, width).map(line => {
          return stringWidth(line).should.most(width)
        })
      })
    })
  }

  it('宽度小于2', () => {
    return function () {
      stringBreak('keenwon', 1)
    }.should.throw()
  })
})
