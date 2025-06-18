
interface User {
  id: number
  name: string
  role: string
  status: string
}

@Entry
@Component
struct UserManagement {
  private users: User[] = [
    { id: 1, name: '张三', role: '管理员', status: '正常' },
    { id: 2, name: '李四', role: '教师', status: '禁用' },
    { id: 3, name: '王五', role: '学生', status: '正常' }
  ];

  build() {
    Column() {
      // 页面标题
      Text('人员管理')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      // 人员列表标题
      Text('用户列表')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      // 人员列表
      ForEach(this.users, (item: User) => {
        this.UserItem(item)
      }, (item: User) => item.id.toString())
    }
    .width('100%')
    .height('100%')
    .padding(15)
    .backgroundColor('#F5F5F5')
  }

  @Builder
  UserItem(item: User) {
    Column() {
      Row() {
        Text(item.name)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text(item.role)
          .fontSize(16)
          .fontColor(Color.Blue)
      }
      .margin({ bottom: 4 })

      Row() {
        Text('状态：' + item.status)
          .fontSize(14)
          .fontColor(
            item.status === '正常' ? Color.Green : Color.Red
          )
        Blank()
        // 这里可以添加操作按钮，如“禁用/启用”
        // Button('禁用').fontSize(14)
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .shadow({ radius: 4, color: '#1A000000' })
    .margin({ bottom: 10 })
  }
}
