import hilog from '@ohos.hilog';
import window from '@ohos.window';

@Entry
@Component
struct LaboratoryDetail {
  build() {
    Column() {
      // 页面标题
      Text('实验室管理系统')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      // 实验室信息
      Column() {
        Text('实验室信息')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 10 })

        this.InfoRow('实验室编号', '101')
        this.InfoRow('物理实名称', '物理实验室')
        this.InfoRow('位置', '1号楼201室')
        this.InfoRow('管理员', '张三')
      }
      .width('90%')
      .padding(15)
      .backgroundColor(Color.White)
      .borderRadius(10)
      .shadow({ radius: 5, color: '#1A000000' })
      .margin({ bottom: 20 })

      // 简介
      Column() {
        Text('简介')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 10 })

        Text('物理实验室于101室施，物理实验室使用于培物理实验的装备和设备等，满足教学和研究需求，严格遵守安全洁洁。')
          .fontSize(16)
          .lineHeight(22)
          .textAlign(TextAlign.Start)
      }
      .width('90%')
      .padding(15)
      .backgroundColor(Color.White)
      .borderRadius(10)
      .shadow({ radius: 5, color: '#1A000000' })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  InfoRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(18)
        .fontColor(Color.Gray)
      Blank()
      Text(value)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
    .border({ width: { bottom: 1 }, color: '#EEEEEE', style: BorderStyle.Solid })
  }
} 