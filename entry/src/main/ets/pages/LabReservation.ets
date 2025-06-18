import promptAction from '@ohos.promptAction';

interface LabOption {
  id: number
  name: string
}

@Entry
@Component
struct LabReservation {
  private labs: LabOption[] = [
    { id: 1, name: '物理实验室' },
    { id: 2, name: '化学实验室' },
    { id: 3, name: '生物实验室' },
    { id: 4, name: '地理实验室' }
  ]
  private selectedLabIndex: number = 0
  private showPicker: boolean = false
  private date: string = ''
  private time: string = ''
  private usage: string = ''
  private message: string = ''

  build() {
    Column() {
      Text('实验室预约')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30, bottom: 26 })

      // 选择实验室
      Text('选择实验室').fontSize(18).margin({ bottom: 8 })

      // 用按钮触发弹窗选择
      Button(this.labs[this.selectedLabIndex].name)
        .width('90%')
        .height(44)
        .backgroundColor(Color.White)
        .fontColor(Color.Black)
        .onClick(() => {
          this.showPicker = true
        })
        .margin({ bottom: 18 })

      // 手动弹窗选择实验室
      if (this.showPicker) {
        Stack() {
          // 遮罩层
          Column() {}
          .backgroundColor('rgba(0,0,0,0.3)')
          .width('100%').height('100%')
          .onClick(() => { this.showPicker = false })

          // 弹窗内容
          Column() {
            Text('请选择实验室').fontSize(20).margin({ bottom: 12, top: 12 })
            List() {
              ForEach(this.labs, (lab: LabOption, index: number) => {
                ListItem() {
                  Button(lab.name)
                    .width('90%')
                    .margin({ top: 6, bottom: 6 })
                    .backgroundColor(index === this.selectedLabIndex ? '#D6E4FF' : Color.White)
                    .fontColor(Color.Black)
                    .onClick(() => {
                      this.selectedLabIndex = index
                      this.showPicker = false
                    })
                }
              }, (item: LabOption, index: number) => String(item.id))

            }
            .width('100%')
            .height(180) // 设置高度，防止警告

            Button('取消')
              .width('90%')
              .margin({ top: 10, bottom: 10 })
              .backgroundColor('#EEEEEE')
              .fontColor(Color.Gray)
              .onClick(() => { this.showPicker = false })
          }
          .width('80%')
          .backgroundColor(Color.White)
          .borderRadius(16)
          .padding(16)
          .alignSelf(ItemAlign.Center)
        }
        .width('100%').height('100%')
        .zIndex(99)
      }



      // 选择日期
      Text('预约日期').fontSize(18).margin({ bottom: 8 })
      TextInput({ placeholder: '请输入预约日期，如2025-06-21' })
        .width('90%')
        .height(44)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .padding({ left: 12 })
        .margin({ bottom: 18 })
        .onChange((val: string) => {
          this.date = val
        })

      // 选择时间段
      Text('预约时间段').fontSize(18).margin({ bottom: 8 })
      TextInput({ placeholder: '如 14:00-16:00' })
        .width('90%')
        .height(44)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .padding({ left: 12 })
        .margin({ bottom: 18 })
        .onChange((val: string) => {
          this.time = val
        })

      // 填写用途
      Text('预约用途').fontSize(18).margin({ bottom: 8 })
      TextInput({ placeholder: '请填写本次预约用途' })
        .width('90%')
        .height(44)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .padding({ left: 12 })
        .margin({ bottom: 28 })
        .onChange((val: string) => {
          this.usage = val
        })

      if (this.message !== '') {
        Text(this.message)
          .fontSize(16)
          .fontColor(Color.Red)
          .margin({ bottom: 18 })
      }

      Button('提交预约')
        .width('90%')
        .height(48)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#3366FF')
        .fontColor(Color.White)
        .borderRadius(12)
        .onClick(() => {
          if (
            !this.labs[this.selectedLabIndex] ||
              this.date.trim() === '' ||
              this.time.trim() === '' ||
              this.usage.trim() === ''
          ) {
            this.message = '请完整填写所有信息'
            return
          }
          this.message = ''
          promptAction.showToast({ message: '预约提交成功，等待审核' })
          // 提交后清空
          this.date = ''
          this.time = ''
          this.usage = ''
        })
    }
    .width('100%')
    .height('100%')
    .padding(24)
    .backgroundColor('#F5F5F5')
    .alignItems(HorizontalAlign.Center)
  }
}
