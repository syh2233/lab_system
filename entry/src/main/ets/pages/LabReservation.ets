import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { apiService, Reservation, Laboratory } from '../services/ApiService';

// 使用类声明代替接口字面量
class LabOption {
  id: number = 0;
  name: string = '';
}

// 确保与ApiService中的Reservation接口兼容
class ReservationRequest implements Reservation {
  id?: number;
  labId: number = 0;
  userId?: number;
  startTime: string = '';
  endTime: string = '';
  purpose: string = '';
  status?: string;
  laboratory?: Laboratory;
  rejectReason?: string;
}

@Entry
@Component
struct LabReservation {
  @State labs: LabOption[] = []
  @State selectedLabIndex: number = 0
  @State showPicker: boolean = false
  @State date: string = ''
  @State startTime: string = ''
  @State endTime: string = ''
  @State purpose: string = ''
  @State message: string = ''
  @State isLoading: boolean = false
  private context: common.UIAbilityContext | null = null

  aboutToAppear() {
    this.context = getContext(this) as common.UIAbilityContext;
    apiService.initContext(this.context);
    this.loadLaboratories();
  }

  async loadLaboratories() {
    this.isLoading = true;
    try {
      const labsData = await apiService.getLaboratories();
      if (labsData && labsData.length > 0) {
        this.labs = labsData.map(lab => {
          const option = new LabOption();
          option.id = lab.id;
          option.name = lab.name;
          return option;
        });
        this.selectedLabIndex = 0;
      } else {
        this.message = '无可用实验室';
        if (this.context) {
          this.context.eventHub.emit('showToast', { message: '无可用实验室' });
        }
      }
    } catch (error) {
      console.error('获取实验室列表失败:', error);
      this.message = '获取实验室列表失败';
      if (this.context) {
        this.context.eventHub.emit('showToast', { message: '获取实验室列表失败' });
      }
    } finally {
      this.isLoading = false;
    }
  }

  async submitReservation() {
    if (
      this.labs.length === 0 ||
      this.date.trim() === '' ||
      this.startTime.trim() === '' ||
      this.endTime.trim() === '' ||
      this.purpose.trim() === ''
    ) {
      this.message = '请完整填写所有信息';
      return;
    }

    // 验证日期格式
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(this.date)) {
      this.message = '请使用正确的日期格式 (YYYY-MM-DD)';
      return;
    }

    // 验证时间格式
    const timeRegex = /^\d{2}:\d{2}$/;
    if (!timeRegex.test(this.startTime) || !timeRegex.test(this.endTime)) {
      this.message = '请使用正确的时间格式 (HH:MM)';
      return;
    }

    this.isLoading = true;
    this.message = '';

    // 创建请求数据对象
    const requestData = new ReservationRequest();
    requestData.labId = this.labs[this.selectedLabIndex].id;
    requestData.startTime = this.date + ' ' + this.startTime + ':00';
    requestData.endTime = this.date + ' ' + this.endTime + ':00';
    requestData.purpose = this.purpose;

    try {
      // 确保ReservationRequest类型与API服务期望的Reservation类型兼容
      const result = await apiService.createReservation(requestData);
      promptAction.showToast({ message: '预约提交成功，等待审核' });
      
      // 清空表单
      this.date = '';
      this.startTime = '';
      this.endTime = '';
      this.purpose = '';
    } catch (error) {
      console.error('预约提交失败:', error);
      this.message = '预约提交失败';
      if (this.context) {
        this.context.eventHub.emit('showToast', { message: '预约提交失败' });
      }
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      Text('实验室预约')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30, bottom: 26 })

      if (this.isLoading) {
        LoadingProgress()
          .width(50)
          .height(50)
          .margin({ top: 80 })
      } else {
        // 选择实验室
        Text('选择实验室').fontSize(18).margin({ bottom: 8 })

        // 用按钮触发弹窗选择
        Button(this.labs.length > 0 ? this.labs[this.selectedLabIndex].name : '无可用实验室')
          .width('90%')
          .height(44)
          .backgroundColor(Color.White)
          .fontColor(Color.Black)
          .enabled(this.labs.length > 0)
          .onClick(() => {
            this.showPicker = true;
          })
          .margin({ bottom: 18 })

        // 手动弹窗选择实验室
        if (this.showPicker && this.labs.length > 0) {
          Stack() {
            // 遮罩层
            Column() {}
            .backgroundColor('rgba(0,0,0,0.3)')
            .width('100%').height('100%')
            .onClick(() => { this.showPicker = false })

            // 弹窗内容
            Column() {
              Text('请选择实验室').fontSize(20).margin({ bottom: 12, top: 12 })
              List() {
                ForEach(this.labs, (lab: LabOption, index: number) => {
                  ListItem() {
                    Button(lab.name)
                      .width('90%')
                      .margin({ top: 6, bottom: 6 })
                      .backgroundColor(index === this.selectedLabIndex ? '#D6E4FF' : Color.White)
                      .fontColor(Color.Black)
                      .onClick(() => {
                        this.selectedLabIndex = index;
                        this.showPicker = false;
                      })
                  }
                }, (item: LabOption) => item.id.toString())

              }
              .width('100%')
              .height(180) // 设置高度，防止警告

              Button('取消')
                .width('90%')
                .margin({ top: 10, bottom: 10 })
                .backgroundColor('#EEEEEE')
                .fontColor(Color.Gray)
                .onClick(() => { this.showPicker = false })
            }
            .width('80%')
            .backgroundColor(Color.White)
            .borderRadius(16)
            .padding(16)
            .alignSelf(ItemAlign.Center)
          }
          .width('100%').height('100%')
          .zIndex(99)
        }

        // 选择日期
        Text('预约日期').fontSize(18).margin({ bottom: 8 })
        TextInput({ placeholder: '请输入预约日期，如2025-06-21' })
          .width('90%')
          .height(44)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .padding({ left: 12 })
          .margin({ bottom: 18 })
          .onChange((val: string) => {
            this.date = val;
          })

        // 选择开始时间
        Text('开始时间').fontSize(18).margin({ bottom: 8 })
        TextInput({ placeholder: '如 14:00' })
          .width('90%')
          .height(44)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .padding({ left: 12 })
          .margin({ bottom: 18 })
          .onChange((val: string) => {
            this.startTime = val;
          })

        // 选择结束时间
        Text('结束时间').fontSize(18).margin({ bottom: 8 })
        TextInput({ placeholder: '如 16:00' })
          .width('90%')
          .height(44)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .padding({ left: 12 })
          .margin({ bottom: 18 })
          .onChange((val: string) => {
            this.endTime = val;
          })

        // 填写用途
        Text('预约用途').fontSize(18).margin({ bottom: 8 })
        TextInput({ placeholder: '请填写本次预约用途' })
          .width('90%')
          .height(44)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .padding({ left: 12 })
          .margin({ bottom: 28 })
          .onChange((val: string) => {
            this.purpose = val;
          })

        if (this.message !== '') {
          Text(this.message)
            .fontSize(16)
            .fontColor(Color.Red)
            .margin({ bottom: 18 })
        }

        Button('提交预约')
          .width('90%')
          .height(48)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#3366FF')
          .fontColor(Color.White)
          .borderRadius(12)
          .enabled(!this.isLoading && this.labs.length > 0)
          .onClick(() => {
            this.submitReservation();
          })
      }
    }
    .width('100%')
    .height('100%')
    .padding(24)
    .backgroundColor('#F5F5F5')
    .alignItems(HorizontalAlign.Center)
  }
}