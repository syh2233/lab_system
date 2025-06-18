import promptAction from '@ohos.promptAction';

interface LabItem {
  id: number
  name: string
  location: string
  manager: string
  desc: string
}

@Entry
@Component
struct LaboratoryList {
  private allLabs: LabItem[] = [
    { id: 1, name: '物理实验室', location: '1号楼201室', manager: '张三', desc: '装备齐全，支持物理实验教学与科研。' },
    { id: 2, name: '化学实验室', location: '2号楼301室', manager: '李四', desc: '配备现代化化学设备，注重安全管理。' },
    { id: 3, name: '生物实验室', location: '3号楼102室', manager: '王五', desc: '适合基础和高级生物实验。' },
    { id: 4, name: '地理实验室', location: '4号楼104室', manager: '赵六', desc: '地理学及相关领域实验。' },
    { id: 5, name: '计算机实验室', location: '5号楼201室', manager: '钱七', desc: '高性能计算环境，适合编程及人工智能项目。' }
  ]
  private page: number = 1
  private pageSize: number = 3
  private labs: LabItem[] = []

  aboutToAppear() {
    this.loadMore()
  }

  loadMore() {
    const start = (this.page - 1) * this.pageSize
    const end = this.page * this.pageSize
    const next = this.allLabs.slice(start, end)
    if (next.length > 0) {
      this.labs = this.labs.concat(next)
      this.page++
    }
  }

  showLabDetail(lab: LabItem) {
    promptAction.showDialog({
      title: lab.name,
      message: `位置：${lab.location}\n管理员：${lab.manager}\n简介：${lab.desc}`,
      buttons: [{ text: '确定', color: '#3366FF' }]
    })
  }

  build() {
    Column() {
      Text('实验室一览')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 24, bottom: 24 })

      if (this.labs.length === 0) {
        Text('暂无实验室信息')
          .fontSize(18)
          .fontColor(Color.Gray)
          .margin({ top: 40 })
      } else {
        List() {
          ForEach(this.labs, (lab: LabItem) => {
            ListItem() {
              Column() {
                Row() {
                  Text(lab.name)
                    .fontSize(20)
                    .fontWeight(FontWeight.Medium)
                  Blank()
                  Text('详情')
                    .fontSize(15)
                    .fontColor('#3366FF')
                    .onClick(() => this.showLabDetail(lab))
                }
                .margin({ bottom: 4 })

                Row() {
                  Text(`位置：${lab.location}`)
                    .fontSize(15)
                    .fontColor(Color.Gray)
                  Blank()
                  Text(`管理员：${lab.manager}`)
                    .fontSize(15)
                    .fontColor(Color.Gray)
                }
              }
              .width('100%')
              .padding(14)
              .backgroundColor(Color.White)
              .borderRadius(10)
              .shadow({ radius: 3, color: '#1A000000' })
              .margin({ bottom: 12 })
            }
          }, (lab: LabItem) => lab.id.toString())
        }
        .width('100%')
        .height(300)
      }

      if (this.labs.length < this.allLabs.length) {
        Button('加载更多')
          .width('100%')
          .height(40)
          .margin({ top: 14 })
          .backgroundColor('#3366FF')
          .fontColor(Color.White)
          .borderRadius(8)
          .onClick(() => this.loadMore())
      }
    }
    .width('100%')
    .height('100%')
    .padding(18)
    .backgroundColor('#F5F5F5')
  }
}
