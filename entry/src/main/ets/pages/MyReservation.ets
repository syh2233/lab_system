import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

interface ReservationItem {
  id: number
  labName: string
  date: string
  time: string
  status: string
}

@Entry
@Component
struct MyReservation {
  private allReservations: ReservationItem[] = [
    { id: 1, labName: '物理实验室', date: '2025-06-18', time: '14:00-16:00', status: '已通过' },
    { id: 2, labName: '化学实验室', date: '2025-06-20', time: '09:00-11:00', status: '待审核' },
    { id: 3, labName: '生物实验室', date: '2025-06-25', time: '10:00-12:00', status: '已拒绝' },
    { id: 4, labName: '地理实验室', date: '2025-07-01', time: '08:00-10:00', status: '已通过' },
    { id: 5, labName: '物理实验室', date: '2025-07-03', time: '10:00-12:00', status: '待审核' },
    { id: 6, labName: '生物实验室', date: '2025-07-04', time: '13:00-15:00', status: '已通过' },
    { id: 7, labName: '化学实验室', date: '2025-07-08', time: '09:00-11:00', status: '待审核' }
  ]
  private page: number = 1
  private pageSize: number = 3
  private reservations: ReservationItem[] = []

  private message: string = ''

  aboutToAppear() {
    this.loadMore()
  }

  loadMore() {
    const start = (this.page - 1) * this.pageSize
    const end = this.page * this.pageSize
    const next = this.allReservations.slice(start, end)
    if (next.length > 0) {
      this.reservations = this.reservations.concat(next)
      this.page++
    }
  }

  async cancelReservation(id: number) {
    let result = await promptAction.showDialog({
      title: '取消预约',
      message: '确定要取消该预约吗？',
      buttons: [
        { text: '取消', color: '#666' },
        { text: '确定', color: '#FF3333' }
      ]
    })
    if (result && result.index === 1) {
      this.reservations = this.reservations.filter(item => item.id !== id)
      this.allReservations = this.allReservations.filter(item => item.id !== id)
      this.message = '已取消预约'
    }
  }


  showDetail(item: ReservationItem) {
    promptAction.showDialog({
      title: '预约详情',
      message: `实验室：${item.labName}\n日期：${item.date}\n时间：${item.time}\n状态：${item.status}`,
      buttons: [{ text: '确定', color: '#3366FF' }]
    })
  }

  build() {
    Column() {
      Text('我的预约')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 24, bottom: 24 })

      if (this.reservations.length === 0) {
        Text('暂无预约记录')
          .fontSize(18)
          .fontColor(Color.Gray)
          .margin({ top: 40 })
      } else {
        List() {
          ForEach(this.reservations, (item: ReservationItem) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.labName)
                    .fontSize(20)
                    .fontWeight(FontWeight.Medium)
                  Blank()
                  // 状态
                  Text(item.status)
                    .fontSize(15)
                    .fontColor(item.status === '已通过'
                      ? Color.Green
                      : (item.status === '已拒绝' ? Color.Red : Color.Orange))
                }
                .margin({ bottom: 4 })

                Row() {
                  Text(`日期：${item.date}`)
                    .fontSize(15)
                    .fontColor(Color.Gray)
                  Text(`    时间：${item.time}`)
                    .fontSize(15)
                    .fontColor(Color.Gray)
                  Blank()
                  // 详情按钮
                  Text('详情')
                    .fontSize(15)
                    .fontColor('#3366FF')
                    .margin({ left: 18, right: 8 })
                    .onClick(() => this.showDetail(item))
                  // 仅待审核、已通过可取消
                  if (item.status === '待审核' || item.status === '已通过') {
                    Text('取消')
                      .fontSize(15)
                      .fontColor(Color.Red)
                      .onClick(() => this.cancelReservation(item.id))
                  }
                }
              }
              .width('100%')
              .padding(14)
              .backgroundColor(Color.White)
              .borderRadius(10)
              .shadow({ radius: 3, color: '#1A000000' })
              .margin({ bottom: 12 })
            }
          }, (item: ReservationItem) => item.id.toString())
        }
        .width('100%')
      }

      if (this.reservations.length < this.allReservations.length) {
        Button('加载更多')
          .width('100%')
          .height(40)
          .margin({ top: 14 })
          .backgroundColor('#3366FF')
          .fontColor(Color.White)
          .borderRadius(8)
          .onClick(() => this.loadMore())
      }

      if (this.message !== '') {
        Text(this.message)
          .fontSize(15)
          .fontColor(Color.Green)
          .margin({ top: 12, bottom: 8 })
      }
    }
    .width('100%')
    .height('100%')
    .padding(18)
    .backgroundColor('#F5F5F5')
  }
}
