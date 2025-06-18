
interface UsageStat {
  title: string
  value: string
  description: string
}

@Entry
@Component
struct StatisticsPage {
  private stats: UsageStat[] = [
    { title: '实验室总数', value: '5', description: '当前管理的实验室数量' },
    { title: '本月预约次数', value: '86', description: '本月所有实验室被预约的总次数' },
    { title: '设备可用数', value: '13', description: '当前可用设备数量' },
    { title: '活跃用户数', value: '24', description: '最近30天内登录过系统的用户数' }
  ];

  build() {
    Column() {
      // 页面标题
      Text('数据统计')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      // 数据卡片列表
      ForEach(this.stats, (item: UsageStat) => {
        this.StatCard(item)
      }, (item: UsageStat) => item.title)
    }
    .width('100%')
    .height('100%')
    .padding(15)
    .backgroundColor('#F5F5F5')
  }

  @Builder
  StatCard(item: UsageStat) {
    Column() {
      Row() {
        Text(item.title)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text(item.value)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Blue)
      }
      .margin({ bottom: 6 })

      Text(item.description)
        .fontSize(14)
        .fontColor(Color.Gray)
    }
    .width('100%')
    .padding(14)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .shadow({ radius: 4, color: '#1A000000' })
    .margin({ bottom: 15 })
  }
}
