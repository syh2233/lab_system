
interface FavoriteItem {
  id: number
  title: string
  type: string
  detail: string
}

@Entry
@Component
struct FavoritePage {
  private favorites: FavoriteItem[] = [
    { id: 1, title: '物理实验室预约', type: '预约', detail: '2025-06-22 09:00-11:00' },
    { id: 2, title: '示波器设备', type: '设备', detail: '1号楼201室，可用' },
    { id: 3, title: '张三', type: '人员', detail: '管理员，正常' }
  ];

  build() {
    Column() {
      // 页面标题
      Text('我的收藏')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      // 收藏列表
      ForEach(this.favorites, (item: FavoriteItem) => {
        this.FavoriteItemView(item)
      }, (item: FavoriteItem) => item.id.toString())
    }
    .width('100%')
    .height('100%')
    .padding(15)
    .backgroundColor('#F5F5F5')
  }

  @Builder
  FavoriteItemView(item: FavoriteItem) {
    Column() {
      Row() {
        Text(item.title)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text(item.type)
          .fontSize(14)
          .fontColor(Color.Blue)
      }
      .margin({ bottom: 4 })

      Text(item.detail)
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
