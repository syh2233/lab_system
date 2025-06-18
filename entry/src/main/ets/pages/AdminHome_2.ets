import router from '@ohos.router';

@Entry
@Component
struct AdminHome_2 {
  build() {
    Column() {
      Button('进入实验室详情页')
        .onClick(() => {
          router.pushUrl({ url: 'pages/LaboratoryDetail' });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
