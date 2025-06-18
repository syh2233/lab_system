import router from '@ohos.router';

interface SettingItem {
  itemKey: string
  title: string
  description: string
}

@Entry
@Component
struct SystemSettings {
  private settings: SettingItem[] = [
    { itemKey: 'password', title: '修改密码', description: '修改管理员登录密码' },
    { itemKey: 'rules', title: '预约规则', description: '设置预约时间段及限制' },
    { itemKey: 'permission', title: '权限管理', description: '设置不同角色的操作权限' }
  ];

  build() {
    Column() {
      Text('系统设置')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      ForEach(this.settings, (item: SettingItem) => {
        Column() {
          Row() {
            Text(item.title)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
            Blank()
          }
          .margin({ bottom: 4 })

          Text(item.description)
            .fontSize(14)
            .fontColor(Color.Gray)
        }
        .width('100%')
        .padding(12)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .shadow({ radius: 4, color: '#1A000000' })
        .margin({ bottom: 10 })
        .onClick(() => {
          if (item.itemKey === 'password') {
            router.pushUrl({ url: 'pages/ChangePasswordPage' })
          }
          if (item.itemKey === 'rules') {
            router.pushUrl({ url: 'pages/BookingRulePage' })
          }
          if (item.itemKey === 'permission') {
            router.pushUrl({ url: 'pages/PermissionPage' })
          }
        })
      }, (item: SettingItem) => item.itemKey)
    }
    .width('100%')
    .height('100%')
    .padding(15)
    .backgroundColor('#F5F5F5')
  }
}
