interface PermissionUser {
  id: number
  name: string
  role: string
  canBook: boolean
  canBorrow: boolean
  canManage: boolean
}

@Entry
@Component
struct PermissionPage {
  private users: PermissionUser[] = [
    { id: 1, name: '张三', role: '管理员', canBook: true, canBorrow: true, canManage: true },
    { id: 2, name: '李四', role: '教师', canBook: true, canBorrow: true, canManage: false },
    { id: 3, name: '王五', role: '学生', canBook: true, canBorrow: false, canManage: false }
  ]
  private message: string = ''

  build() {
    Column() {
      Text('权限管理')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 24, bottom: 20 })

      ForEach(this.users, (user: PermissionUser) => {
        Column() {
          Row() {
            Text(`${user.name}（${user.role}）`)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
            Blank()
          }
          .margin({ bottom: 6 })

          Row() {
            // 可预约
            Text('可预约').fontSize(16)
            Toggle({ type: ToggleType.Switch, isOn: user.canBook })
              .onChange((checked: boolean) => {
                user.canBook = checked
                this.message = ''
              })

            // 可借设备
            Text('   可借设备').fontSize(16).margin({ left: 12 })
            Toggle({ type: ToggleType.Switch, isOn: user.canBorrow })
              .onChange((checked: boolean) => {
                user.canBorrow = checked
                this.message = ''
              })

            // 可管理
            Text('   可管理').fontSize(16).margin({ left: 12 })
            Toggle({ type: ToggleType.Switch, isOn: user.canManage })
              .onChange((checked: boolean) => {
                user.canManage = checked
                this.message = ''
              })
          }
          .margin({ bottom: 10 })
        }
        .width('100%')
        .padding(14)
        .backgroundColor(Color.White)
        .borderRadius(10)
        .shadow({ radius: 4, color: '#1A000000' })
        .margin({ bottom: 16 })
      }, (user: PermissionUser) => user.id.toString())

      if (this.message !== '') {
        Text(this.message)
          .fontSize(16)
          .fontColor(Color.Red)
          .margin({ bottom: 18 })
      }

      Button('保存设置')
        .width('100%')
        .height(44)
        .backgroundColor('#3366FF')
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .fontSize(18)
        .borderRadius(12)
        .onClick(() => {
          // 这里写保存权限修改的逻辑，比如请求后端
          this.message = '权限保存成功！'
        })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#F5F5F5')
  }
}
