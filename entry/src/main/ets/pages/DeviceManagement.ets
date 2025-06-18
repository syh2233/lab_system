
interface Device {
  id: number
  name: string
  status: string
  location: string
}

@Entry
@Component
struct DeviceManagement {
  private devices: Device[] = [
    { id: 1, name: '示波器', status: '可用', location: '1号楼201室' },
    { id: 2, name: '电子天平', status: '维修中', location: '1号楼202室' },
    { id: 3, name: '离心机', status: '报废', location: '1号楼203室' }
  ];

  build() {
    Column() {
      // 页面标题
      Text('设备管理')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      // 设备列表标题
      Text('设备列表')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      // 设备列表
      ForEach(this.devices, (item: Device) => {
        this.DeviceItem(item)
      }, (item: Device) => item.id.toString())
    }
    .width('100%')
    .height('100%')
    .padding(15)
    .backgroundColor('#F5F5F5')
  }

  @Builder
  DeviceItem(item: Device) {
    Column() {
      Row() {
        Text(item.name)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text(item.status)
          .fontSize(16)
          .fontColor(
            item.status === '可用' ? Color.Green :
              item.status === '维修中' ? Color.Orange : Color.Red
          )
      }
      .margin({ bottom: 4 })

      Text('位置：' + item.location)
        .fontSize(14)
        .fontColor(Color.Gray)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .shadow({ radius: 4, color: '#1A000000' })
    .margin({ bottom: 10 })
  }
}
