import router from '@ohos.router';
import hilog from '@ohos.hilog';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';

@Entry
@Component
struct LoginSelect {
  aboutToAppear() {
    hilog.info(0x0000, 'LoginSelect', '页面即将显示');
  }

  build() {
    Column() {
      // 顶部标题
      Text('实验室预约系统')
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .margin({ top: 60, bottom: 40 })

      // 登录选项
      Column() {
        // 管理员登录按钮
        Button('管理员登录')
          .width('80%')
          .height(50)
          .backgroundColor('#007DFF')
          .fontColor(Color.White)
          .margin({ bottom: 20 })
          .onClick(() => {
            hilog.info(0x0000, 'LoginSelect', '点击管理员登录按钮');
            let context = getContext(this) as common.UIAbilityContext;
            context.eventHub.emit('showToast', { message: '正在跳转到管理员登录页面...' });
            router.pushUrl({
              url: 'pages/AdminLogin'
            }).catch((err: BusinessError) => {
              hilog.error(0x0000, 'LoginSelect', `路由跳转失败: ${err}`);
              context.eventHub.emit('showToast', { message: '页面跳转失败' });
            });
          })

        // 用户登录按钮
        Button('用户登录')
          .width('80%')
          .height(50)
          .backgroundColor('#4CAF50')
          .fontColor(Color.White)
          .onClick(() => {
            hilog.info(0x0000, 'LoginSelect', '点击用户登录按钮');
            let context = getContext(this) as common.UIAbilityContext;
            context.eventHub.emit('showToast', { message: '正在跳转到用户登录页面...' });
            router.pushUrl({
              url: 'pages/UserLogin'
            }).catch((err: BusinessError) => {
              hilog.error(0x0000, 'LoginSelect', `路由跳转失败: ${err}`);
              context.eventHub.emit('showToast', { message: '页面跳转失败' });
            });
          })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      // 底部版权信息
      Text('© 2025 实验室预约系统')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ bottom: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
} 