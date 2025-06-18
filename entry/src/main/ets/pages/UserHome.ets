import router from '@ohos.router';

@Entry
@Component
struct UserHome {
  build() {
    Column() {
      // 顶部欢迎和头像栏
      Row() {
        // 用户默认头像
        Image($r('app.media.admin'))
          .width(56).height(56)
          .borderRadius(28)
        Column() {
          Text('欢迎使用实验室管理系统')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10, bottom: 4 })
          Text('普通用户')
            .fontSize(16)
            .fontColor(Color.Gray)
            .margin({ left: 10 })
        }
        .margin({ left: 10 })
        Blank()
        // 右上角进入“我的”页面
        Image($r('app.media.personnel'))
          .width(36).height(36)
          .borderRadius(18)
          .onClick(() => {
            router.pushUrl({ url: 'pages/MyPage' })
          })
      }
      .margin({ top: 24, bottom: 28, left: 16, right: 16 })
      .width('100%')

      // 快捷功能区
      Grid() {
        GridItem() {
          Column() {
            Image($r('app.media.ic_reservation'))
              .width(40).height(40)
            Text('预约实验室')
              .fontSize(16)
              .margin({ top: 6 })
          }
          .onClick(() => {
            router.pushUrl({ url: 'pages/LabReservation' })
          })
        }
        GridItem() {
          Column() {
            Image($r('app.media.ic_my_reservation'))
              .width(40).height(40)
            Text('我的预约')
              .fontSize(16)
              .margin({ top: 6 })
          }
          .onClick(() => {
            router.pushUrl({ url: 'pages/MyReservation' })
          })
        }
        GridItem() {
          Column() {
            Image($r('app.media.lab_info'))
              .width(40).height(40)
            Text('实验室一览')
              .fontSize(16)
              .margin({ top: 6 })
          }
          .onClick(() => {
            router.pushUrl({ url: 'pages/LaboratoryList' })
          })
        }
        GridItem() {
          Column() {
            Image($r('app.media.profile'))
              .width(40).height(40)
            Text('个人资料')
              .fontSize(16)
              .margin({ top: 6 })
          }
          .onClick(() => {
            router.pushUrl({ url: 'pages/ProfilePage' })
          })
        }
      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .columnsGap(40)
      .rowsGap(18)
      .margin({ left: 24, right: 24, bottom: 18 })

      // 公告区
      Column() {
        Text('实验室公告')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 10 })
        Text('1. 实验室仅支持持卡预约。\n2. 请提前取消无法到场的预约。\n3. 进出请遵守实验室安全规定。')
          .fontSize(15)
          .fontColor(Color.Gray)
      }
      .width('90%')
      .padding(16)
      .backgroundColor(Color.White)
      .borderRadius(12)
      .shadow({ radius: 5, color: '#1A000000' })
      .margin({ top: 10, bottom: 24 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
