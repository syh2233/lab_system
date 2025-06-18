import router from '@ohos.router';
import hilog from '@ohos.hilog';

// 定义CustomMenuItem作为独立的Component
@Component
struct CustomMenuItem {
  @Prop title: string;
  @Prop icon: Resource = $r('app.media.blank'); // 设置默认值为空白SVG图标
  @State isClicked: boolean = false;
  onItemClick?: () => void;

  aboutToAppear() {
    hilog.info(0x0000, 'CustomMenuItem', `Rendering ${this.title}, icon: ${JSON.stringify(this.icon)}`);
  }

  build() {
    Row() {
      if (this.icon) { // 恢复图片相关的代码
        Image(this.icon)
          .width(24)
          .height(24)
          .margin({ right: 15 })
      }

      Text(this.title)
        .fontSize(18)
        .fontColor('#333333')

      Blank()

      Text('>')
        .fontSize(20)
        .fontColor('#999999')
    }
    .width('100%')
    .height(60)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .padding({ left: 20, right: 20 })
    .margin({ bottom: 10 })
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      hilog.info(0x0000, 'CustomMenuItem', `CustomMenuItem clicked: ${this.title}`);
      this.isClicked = true;
      hilog.info(0x0000, 'AdminHome', `点击${this.title}`);
      if (this.onItemClick) {
        this.onItemClick();
      }
    })
  }
}

@Entry
@Component
struct AdminHome {
  aboutToAppear() {
    hilog.info(0x0000, 'AdminHome', '页面即将显示');
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.admin')) // 恢复管理员头像
          .width(36)
          .height(36)
          .borderRadius(18)
          .margin({ left: 20, right: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/MyPage' })
          })
        Text('管理员主页')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
      }
      .width('100%')
      .height(60)
      .padding({ left: 20, right: 20 })
      .backgroundColor(Color.White)
      .margin({ bottom: 20 })

      // 主要内容区域
      Column() {
        CustomMenuItem({
          title: '实验室信息',
          icon: $r('app.media.lab_info'), // 恢复图片
          onItemClick: () => {
            hilog.info(0x0000, 'AdminHome', '点击实验室信息，跳转到LaboratoryDetail');
            router.pushUrl({
              url: 'pages/LaboratoryDetail',
              params: {
                mode: 'full'
              }
            });
          }
        })

        CustomMenuItem({
          title: '预约管理',
          icon: $r('app.media.booking'), // 恢复图片
          onItemClick: () => {
            hilog.info(0x0000, 'AdminHome', '点击预约管理，跳转到ReservationManagement');
            router.pushUrl({
              url: 'pages/ReservationManagement',
              params: {
                mode: 'full'
              }
            });
          }
        })

        CustomMenuItem({
          title: '设备管理',
          icon: $r('app.media.device'), // 恢复图片
          onItemClick: () => {
            hilog.info(0x0000, 'AdminHome', '点击预约管理，跳转到DeviceManagement');
            router.pushUrl({
              url: 'pages/DeviceManagement',
              params: {
                mode: 'full'
              }
            });
          }
        })

        CustomMenuItem({
          title: '人员管理',
          icon: $r('app.media.personnel'), // 恢复图片
          onItemClick: () => {
            hilog.info(0x0000, 'AdminHome', '点击预约管理，跳转到UserManagement');
            router.pushUrl({
              url: 'pages/UserManagement',
              params: {
                mode: 'full'
              }
            });
          }
        })

        CustomMenuItem({
          title: '数据统计',
          icon: $r('app.media.statistics'), // 恢复图片
          onItemClick: () => {
            hilog.info(0x0000, 'AdminHome', '点击预约管理，跳转到StatisticsPage');
            router.pushUrl({
              url: 'pages/StatisticsPage',
              params: {
                mode: 'full'
              }
            });
          }
        })

        CustomMenuItem({
          title: '系统设置',
          icon: $r('app.media.settings'), // 恢复图片
          onItemClick: () => {
            hilog.info(0x0000, 'AdminHome', '点击预约管理，跳转到SystemSettings');
            router.pushUrl({
              url: 'pages/SystemSettings',
              params: {
                mode: 'full'
              }
            });
          }
        })
      }
      .width('100%')
      .padding({ left: 15, right: 15 })
      .layoutWeight(1)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}