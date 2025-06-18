import router from '@ohos.router';
import hilog from '@ohos.hilog';
import common from '@ohos.app.ability.common';
import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';

// 定义管理员账号接口
interface AdminAccount {
  username: string;
  password: string;
}

@Entry
@Component
struct AdminLogin {
  @State username: string = '';
  @State password: string = '';
  @State isLoading: boolean = false;

  // 默认管理员账号
  private defaultAdmin: AdminAccount = {
    username: 'admin',
    password: 'admin123'
  };

  aboutToAppear() {
    hilog.info(0x0000, 'AdminLogin', '页面即将显示');
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.back'))
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .fillColor('#333333')
          .onClick(() => {
            router.back();
          })
        Text('管理员登录')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
      }
      .width('100%')
      .height(56)
      .backgroundColor('#FFFFFF')

      // 登录表单
      Column() {
        // 标题
        Text('实验室预约系统')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ top: 48, bottom: 48 })

        // 用户名输入框
        TextInput({ placeholder: '请输入用户名' })
          .width('90%')
          .height(50)
          .margin({ bottom: 16 })
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.username = value;
          })

        // 密码输入框
        TextInput({ placeholder: '请输入密码' })
          .width('90%')
          .height(50)
          .margin({ bottom: 32 })
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .padding({ left: 16, right: 16 })
          .type(InputType.Password)
          .onChange((value: string) => {
            this.password = value;
          })

        // 登录按钮
        Button('登录')
          .width('90%')
          .height(50)
          .backgroundColor('#007DFF')
          .fontColor(Color.White)
          .enabled(!this.isLoading)
          .onClick(() => {
            this.handleLogin();
          })

        if (this.isLoading) {
          LoadingProgress()
            .width(24)
            .height(24)
            .margin({ top: 16 })
        }
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  private handleLogin() {
    if (!this.username || !this.password) {
      let context = getContext(this) as common.UIAbilityContext;
      context.eventHub.emit('showToast', { message: '请输入用户名和密码' });
      return;
    }

    this.isLoading = true;
    hilog.info(0x0000, 'AdminLogin', '开始登录验证');

    // 模拟网络请求
    setTimeout(() => {
      if (this.username === this.defaultAdmin.username && 
          this.password === this.defaultAdmin.password) {
        hilog.info(0x0000, 'AdminLogin', '登录成功');
        let context = getContext(this) as common.UIAbilityContext;
        context.eventHub.emit('showToast', { message: '登录成功' });
        router.pushUrl({
          url: 'pages/AdminHome'
        }).catch((err: BusinessError) => {
          hilog.error(0x0000, 'AdminLogin', `路由跳转失败: ${err}`);
          context.eventHub.emit('showToast', { message: '页面跳转失败' });
        });
      } else {
        hilog.error(0x0000, 'AdminLogin', '用户名或密码错误');
        let context = getContext(this) as common.UIAbilityContext;
        context.eventHub.emit('showToast', { message: '用户名或密码错误' });
      }
      this.isLoading = false;
    }, 1000);
  }
} 