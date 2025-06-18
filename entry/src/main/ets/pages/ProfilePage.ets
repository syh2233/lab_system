
interface Profile {
  name: string
  role: string
  phone: string
  email: string
}

@Entry
@Component
struct ProfilePage {
  private profile: Profile = {
    name: '张三',
    role: '管理员',
    phone: '13800138000',
    email: 'zhangsan@example.com'
  }

  build() {
    Column() {
      // 页面标题
      Text('个人资料')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      // 头像
      Image($r('app.media.admin'))
        .width(90)
        .height(90)
        .margin({ bottom: 16 })

      // 资料详情
      this.InfoRow('姓名', this.profile.name)
      this.InfoRow('身份', this.profile.role)
      this.InfoRow('手机号', this.profile.phone)
      this.InfoRow('邮箱', this.profile.email)
    }
    .width('100%')
    .height('100%')
    .padding(24)
    .backgroundColor('#F5F5F5')
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  InfoRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(18)
        .fontColor(Color.Gray)
      Blank()
      Text(value)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
    .border({ width: { bottom: 1 }, color: '#EEEEEE', style: BorderStyle.Solid })
  }
}
