import router from '@ohos.router';
import hilog from '@ohos.hilog';

// 自定义菜单项组件
@Component
struct CustomMenuItem {
  @Prop title: string
  @Prop icon: Resource
  @State isClicked: boolean = false;
  onItemClick?: () => void;

  build() {
    Row() {
      // 图标
      if (this.icon) {
        Image(this.icon)
          .width(28)
          .height(28)
          .margin({ right: 14 })
      }
      // 标题
      Text(this.title)
        .fontSize(18)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .shadow({ radius: 2, color: '#1A000000' })
    .margin({ bottom: 12 })
    .onClick(() => {
      if (this.onItemClick) {
        this.onItemClick()
      }
    })
  }
}

// 我的页面
@Entry
@Component
struct MyPage {
  build() {
    Column() {
      // 顶部头像
      Image($r('app.media.admin'))
        .width(90)
        .height(90)
        .margin({ top: 30, bottom: 16 })
        .onClick(() => {
          hilog.info(0x0000, 'MyPage', '点击头像，跳转到ProfilePage');
          router.pushUrl({ url: 'pages/ProfilePage' });
        })
      // 用户名称
      Text('管理员张三')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      // 菜单项
      Column() {
        CustomMenuItem({
          title: '个人资料',
          icon: $r('app.media.profile'),
          onItemClick: () => {
            hilog.info(0x0000, 'MyPage', '点击个人资料，跳转到ProfilePage');
            router.pushUrl({ url: 'pages/ProfilePage' });
          }
        })
        CustomMenuItem({
          title: '我的收藏',
          icon: $r('app.media.collection'),
          onItemClick: () => {
            hilog.info(0x0000, 'MyPage', '点击个人资料，跳转到FavoritePage');
            router.pushUrl({ url: 'pages/FavoritePage' });
          }
        })
        CustomMenuItem({
          title: '设置',
          icon: $r('app.media.settings'),
          onItemClick: () => {
            hilog.info(0x0000, 'MyPage', '点击设置，跳转到SystemSettings');
            router.pushUrl({ url: 'pages/SystemSettings' });
          }
        })
      }
      .width('100%')
      .margin({ bottom: 30 })

      // 退出登录按钮
      Button('退出登录')
        .width('100%')
        .height(48)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#FF5454')
        .fontColor(Color.White)
        .borderRadius(12)
        .onClick(() => {
          hilog.info(0x0000, 'MyPage', '点击退出登录，返回登录页面');
          router.replaceUrl({ url: 'pages/LoginSelect' })
        })
    }
    .width('100%')
    .height('100%')
    .padding(22)
    .backgroundColor('#F5F5F5')
    .alignItems(HorizontalAlign.Center)
  }
}
