import router from '@ohos.router';

@Entry
@Component
struct UserLogin {
  private username: string = ''
  private password: string = ''
  private message: string = ''

  build() {
    Column() {
      Text('用户登录')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40, bottom: 30 })

      // 账号输入
      Text('账号').fontSize(18).margin({ bottom: 8 })
      TextInput()
        .width('90%')
        .height(44)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .padding({ left: 12 })
        .margin({ bottom: 18 })
        .onChange((val: string) => {
          this.username = val
        })

      // 密码输入
      Text('密码').fontSize(18).margin({ bottom: 8 })
      TextInput()
        .type(InputType.Password)
        .width('90%')
        .height(44)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .padding({ left: 12 })
        .margin({ bottom: 28 })
        .onChange((val: string) => {
          this.password = val
        })

      if (this.message !== '') {
        Text(this.message)
          .fontSize(16)
          .fontColor(Color.Red)
          .margin({ bottom: 18 })
      }

      Button('登录')
        .width('90%')
        .height(48)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#3366FF')
        .fontColor(Color.White)
        .borderRadius(12)
        .onClick(() => {
          if (this.username.trim() === '' || this.password.trim() === '') {
            this.message = '请输入账号和密码'
            return
          }
          // 默认用户校验
          if (this.username === 'lisi' && this.password === '123456') {
            this.message = ''
            router.pushUrl({ url: 'pages/UserHome' })  // 跳转到UserHome.ets页面
          } else {
            this.message = '账号或密码错误'
          }
        })
    }
    .width('100%')
    .height('100%')
    .padding(24)
    .backgroundColor('#F5F5F5')
    .alignItems(HorizontalAlign.Center)
  }
}
