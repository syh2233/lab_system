@Entry
@Component
struct ReservationManagement {
  private reservations: Reservation[] = [
    { id: 1, name: '李四', lab: '物理实验室', time: '2025-06-20 09:00-11:00', status: '已通过' },
    { id: 2, name: '王五', lab: '化学实验室', time: '2025-06-21 14:00-16:00', status: '待审批' },
    { id: 3, name: '赵六', lab: '生物实验室', time: '2025-06-22 10:00-12:00', status: '已拒绝' },
  ];

  build() {
    Column() {
      // 页面标题
      Text('预约管理')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      // 预约记录标题
      Text('预约记录')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      // 预约列表展示
      ForEach(this.reservations, (item: Reservation) => {
        this.ReservationItem(item)
      }, (item: Reservation) => item.id.toString())
    }
    .width('100%')
    .height('100%')
    .padding(15)
    .backgroundColor('#F5F5F5')
  }

  @Builder
  ReservationItem(item: Reservation) {
    Column() {
      Row() {
        Text(`${item.name} - ${item.lab}`)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text(item.status)
          .fontSize(16)
          .fontColor(item.status === '已通过' ? Color.Green :
            item.status === '已拒绝' ? Color.Red : Color.Orange)
      }
      .margin({ bottom: 4 })

      Text(item.time)
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

// 定义预约数据类型
interface Reservation {
  id: number
  name: string
  lab: string
  time: string
  status: string
}
