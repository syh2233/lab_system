@Entry
@Component
struct ChangePasswordPage {
  private oldPassword: string = ''
  private newPassword: string = ''
  private confirmPassword: string = ''
  private message: string = ''

  build() {
    Column() {
      Text('修改密码')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 30 })

      // 原密码
      Text('原密码').fontSize(18).margin({ bottom: 6 })
      TextInput()
        .type(InputType.Password) // 注意必须链式写
        .width('100%')
        .height(44)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .padding({ left: 12 })
        .margin({ bottom: 18 })
        .onChange((value: string) => {
          this.oldPassword = value
        })

      // 新密码
      Text('新密码').fontSize(18).margin({ bottom: 6 })
      TextInput()
        .type(InputType.Password)
        .width('100%')
        .height(44)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .padding({ left: 12 })
        .margin({ bottom: 18 })
        .onChange((value: string) => {
          this.newPassword = value
        })

      // 确认新密码
      Text('确认新密码').fontSize(18).margin({ bottom: 6 })
      TextInput()
        .type(InputType.Password)
        .width('100%')
        .height(44)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .padding({ left: 12 })
        .margin({ bottom: 28 })
        .onChange((value: string) => {
          this.confirmPassword = value
        })

      if (this.message !== '') {
        Text(this.message)
          .fontSize(16)
          .fontColor(Color.Red)
          .margin({ bottom: 18 })
      }

      Button('确认修改')
        .width('100%')
        .height(48)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#3366FF')
        .fontColor(Color.White)
        .borderRadius(12)
        .onClick(() => {
          if (!this.oldPassword || !this.newPassword || !this.confirmPassword) {
            this.message = '请填写完整信息'
            return
          }
          if (this.newPassword !== this.confirmPassword) {
            this.message = '两次输入的新密码不一致'
            return
          }
          // 此处写你的修改逻辑
          this.message = '密码修改成功'
        })
    }
    .width('100%')
    .height('100%')
    .padding(24)
    .backgroundColor('#F5F5F5')
    .alignItems(HorizontalAlign.Center)
  }
}
