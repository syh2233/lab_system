@Entry
@Component
struct BookingRulePage {
  private advanceDays: number = 7    // 可提前预约天数
  private maxDuration: number = 4    // 单次预约最大小时数
  private dailyLimit: number = 2     // 每日最多预约次数
  private ruleDescription: string = '预约需提前申请，审核通过后方可使用实验室。'
  private message: string = ''

  build() {
    Column() {
      Text('预约规则')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 24 })

      // 可提前预约天数
      Row() {
        Text('可提前预约天数：').fontSize(18)
        Blank()
        TextInput()
          .width(70)
          .height(36)
          .backgroundColor(Color.White)
          .borderRadius(6)
          .margin({ right: 4 })
          .onChange((val: string) => {
            // 只取数字
            this.advanceDays = Number(val.replace(/[^0-9]/g, '')) || 0
          })
        Text('天').fontSize(18)
      }
      .width('100%').margin({ bottom: 14 })

      // 单次最大预约时长
      Row() {
        Text('单次最大预约时长：').fontSize(18)
        Blank()
        TextInput()
          .width(70)
          .height(36)
          .backgroundColor(Color.White)
          .borderRadius(6)
          .margin({ right: 4 })
          .onChange((val: string) => {
            this.maxDuration = Number(val.replace(/[^0-9]/g, '')) || 0
          })
        Text('小时').fontSize(18)
      }
      .width('100%').margin({ bottom: 14 })

      // 每日最多预约次数
      Row() {
        Text('每日最多预约次数：').fontSize(18)
        Blank()
        TextInput()
          .width(70)
          .height(36)
          .backgroundColor(Color.White)
          .borderRadius(6)
          .margin({ right: 4 })
          .onChange((val: string) => {
            this.dailyLimit = Number(val.replace(/[^0-9]/g, '')) || 0
          })
        Text('次').fontSize(18)
      }
      .width('100%').margin({ bottom: 18 })

      // 规则说明
      Text('详细说明：')
        .fontSize(18)
        .margin({ bottom: 6 })

      TextInput()
        .height(80)
        .width('100%')
        .backgroundColor(Color.White)
        .borderRadius(6)
        .margin({ bottom: 26 })
        .onChange((val: string) => {
          this.ruleDescription = val
        })

      if (this.message !== '') {
        Text(this.message)
          .fontSize(16)
          .fontColor(Color.Red)
          .margin({ bottom: 18 })
      }

      Button('保存修改')
        .width('100%')
        .height(44)
        .backgroundColor('#3366FF')
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .fontSize(18)
        .borderRadius(12)
        .onClick(() => {
          if (
            this.advanceDays <= 0 ||
              this.maxDuration <= 0 ||
              this.dailyLimit <= 0 ||
              !this.ruleDescription
          ) {
            this.message = '请填写完整且正确的规则信息'
            return
          }
          // 这里写保存逻辑，比如请求后端或本地持久化
          this.message = '保存成功！'
        })
    }
    .width('100%')
    .height('100%')
    .padding(24)
    .backgroundColor('#F5F5F5')
  }
}
