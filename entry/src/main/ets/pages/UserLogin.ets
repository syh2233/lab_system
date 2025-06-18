import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { apiService } from '../services/ApiService';
import { BusinessError } from '@ohos.base';

@Entry
@Component
struct UserLogin {
  private username: string = ''
  private password: string = ''
  private message: string = ''
  @State isLoading: boolean = false;

  aboutToAppear() {
    // 初始化API服务
    apiService.initContext(getContext(this) as common.UIAbilityContext);
  }

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

      if (this.isLoading) {
        LoadingProgress()
          .width(24)
          .height(24)
          .margin({ bottom: 16 })
      }

      Button('登录')
        .width('90%')
        .height(48)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#3366FF')
        .fontColor(Color.White)
        .borderRadius(12)
        .enabled(!this.isLoading)
        .onClick(async () => {
          await this.handleLogin();
        })
    }
    .width('100%')
    .height('100%')
    .padding(24)
    .backgroundColor('#F5F5F5')
    .alignItems(HorizontalAlign.Center)
  }

  async handleLogin() {
    if (this.username.trim() === '' || this.password.trim() === '') {
      this.message = '请输入账号和密码';
      return;
    }

    this.isLoading = true;
    this.message = '';

    try {
      // 调用API服务登录
      const response = await apiService.login(this.username, this.password);
      
      // 登录成功
      let context = getContext(this) as common.UIAbilityContext;
      context.eventHub.emit('showToast', { message: '登录成功' });
      
      // 根据角色跳转到不同页面
      if (response.role === 'ADMIN') {
        router.pushUrl({ url: 'pages/AdminHome' });
      } else {
        router.pushUrl({ url: 'pages/UserHome' });
      }
    } catch (error) {
      const err = error as BusinessError;
      this.message = '登录失败: ' + err.message;
    } finally {
      this.isLoading = false;
    }
  }
}