import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { apiService } from '../services/ApiService';

class User {
  id: number = 0;
  username: string = '';
  fullName: string = '';
}

class LabItem {
  id: number = 0;
  name: string = '';
  location: string = '';
  manager: User | null = null;
  description: string = '';
  capacity: number = 0;
  availability: boolean = false;
}

@Entry
@Component
struct LaboratoryList {
  @State labs: LabItem[] = []
  @State loading: boolean = false
  @State message: string = ''
  private context: common.UIAbilityContext | null = null

  aboutToAppear() {
    this.context = getContext(this) as common.UIAbilityContext;
    apiService.initContext(this.context);
    this.loadLaboratories();
  }

  async loadLaboratories() {
    this.loading = true;
    try {
      const labsData = await apiService.getLaboratories();
      // 将API返回的实验室数据转换为UI所需的格式
      this.labs = labsData.map(lab => {
        const labItem = new LabItem();
        labItem.id = lab.id;
        labItem.name = lab.name;
        labItem.location = lab.location;
        labItem.description = lab.description;
        labItem.capacity = lab.capacity;
        labItem.availability = lab.availability;
        
        // 假设API暂时没有返回manager数据
        labItem.manager = null;
        
        return labItem;
      });
      
      if (this.labs.length === 0) {
        this.message = '暂无实验室数据';
      }
    } catch (error) {
      console.error('获取实验室列表失败:', error);
      this.message = '获取实验室列表失败';
      if (this.context) {
        this.context.eventHub.emit('showToast', { message: '获取实验室列表失败' });
      }
    } finally {
      this.loading = false;
    }
  }

  showLabDetail(lab: LabItem) {
    const managerName = lab.manager ? lab.manager.fullName || lab.manager.username : '未指定';
    
    promptAction.showDialog({
      title: lab.name,
      message: `位置：${lab.location}\n容量：${lab.capacity}人\n管理员：${managerName}\n简介：${lab.description}`,
      buttons: [{ text: '确定', color: '#3366FF' }]
    });
  }

  build() {
    Column() {
      Text('实验室一览')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 24, bottom: 24 })

      if (this.loading) {
        LoadingProgress()
          .width(50)
          .height(50)
          .margin({ top: 80 })
      } else if (this.message) {
        Text(this.message)
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
                  Text(`容量：${lab.capacity}人`)
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

        Button('刷新')
          .width('100%')
          .height(40)
          .margin({ top: 14 })
          .backgroundColor('#3366FF')
          .fontColor(Color.White)
          .borderRadius(8)
          .onClick(() => this.loadLaboratories())
      }
    }
    .width('100%')
    .height('100%')
    .padding(18)
    .backgroundColor('#F5F5F5')
  }
}