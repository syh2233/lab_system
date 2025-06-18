import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { apiService } from '../services/ApiService';

// 确保与API服务中的接口定义兼容
interface Laboratory {
  id: number;
  name: string;
  location: string;
  capacity: number;
  description: string;
  availability: boolean;
}

interface Reservation {
  id?: number;
  labId: number;
  userId?: number;
  startTime: string;
  endTime: string;
  purpose: string;
  status?: string;
  laboratory?: Laboratory;
  rejectReason?: string;
}

@Entry
@Component
struct MyReservation {
  @State reservations: Reservation[] = []
  @State isLoading: boolean = false
  @State message: string = ''
  private context: common.UIAbilityContext | null = null

  aboutToAppear() {
    this.context = getContext(this) as common.UIAbilityContext;
    apiService.initContext(this.context);
    this.loadReservations();
  }

  async loadReservations() {
    this.isLoading = true;
    try {
      this.reservations = await apiService.getUserReservations();
      if (this.reservations.length === 0) {
        this.message = '您还没有预约记录';
      }
    } catch (error) {
      console.error('获取预约记录失败:', error);
      this.message = '获取预约记录失败';
    } finally {
      this.isLoading = false;
    }
  }

  async cancelReservation(id?: number) {
    if (!id) {
      return;
    }
    try {
      await apiService.cancelReservation(id);
      await this.loadReservations();
      promptAction.showToast({ message: '取消成功' });
    } catch (error) {
      console.error('取消预约失败:', error);
      promptAction.showToast({ message: '取消失败' });
    }
  }

  @Builder renderReservationItem(reservation: Reservation) {
    Column() {
      Row() {
        Column() {
          Text(reservation.laboratory ? reservation.laboratory.name : "未知实验室")
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 4 })
          
          Text(`地点：${reservation.laboratory ? reservation.laboratory.location : "未知"}`)
            .fontSize(14)
            .margin({ bottom: 2 })
          
          Text(`用途：${reservation.purpose}`)
            .fontSize(14)
            .margin({ bottom: 2 })
          
          Text(`时间：${this.formatTimeRange(reservation.startTime, reservation.endTime)}`)
            .fontSize(14)
            .margin({ bottom: 6 })
          
          if (reservation.status === 'REJECTED' && reservation.rejectReason) {
            Text(`拒绝原因：${reservation.rejectReason}`)
              .fontSize(14)
              .fontColor(Color.Red)
              .margin({ bottom: 6 })
          }
          
          Row() {
            Text(`状态：`)
              .fontSize(14)
            
            Text(this.getStatusText(reservation.status))
              .fontSize(14)
              .fontColor(this.getStatusColor(reservation.status))
          }
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        
        if (reservation.status === 'PENDING') {
          Button("取消")
            .fontSize(14)
            .height(32)
            .backgroundColor('#FF4444')
            .fontColor(Color.White)
            .onClick(() => {
              this.cancelReservation(reservation.id);
            })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      
      Divider().margin({ top: 12, bottom: 12 })
    }
    .padding(12)
  }

  formatTimeRange(startTime?: string, endTime?: string): string {
    if (!startTime || !endTime) return "时间未定";
    try {
      // 格式化开始时间和结束时间
      const start = new Date(startTime);
      const end = new Date(endTime);
      
      const month = start.getMonth() + 1;
      const date = start.getDate();
      
      const startHour = start.getHours().toString().padStart(2, '0');
      const startMinute = start.getMinutes().toString().padStart(2, '0');
      const endHour = end.getHours().toString().padStart(2, '0');
      const endMinute = end.getMinutes().toString().padStart(2, '0');
      
      return `${month}月${date}日 ${startHour}:${startMinute}-${endHour}:${endMinute}`;
    } catch (e) {
      console.error('日期格式化错误:', e);
      return `${startTime} - ${endTime}`;
    }
  }

  getStatusText(status?: string): string {
    if (!status) return "未知";
    switch (status) {
      case 'PENDING': return '待审核';
      case 'APPROVED': return '已通过';
      case 'REJECTED': return '已拒绝';
      case 'COMPLETED': return '已完成';
      case 'CANCELLED': return '已取消';
      default: return status;
    }
  }

  getStatusColor(status?: string): string {
    if (!status) return "#000000";
    switch (status) {
      case 'PENDING': return "#FFA500";
      case 'APPROVED': return "#00AA00";
      case 'REJECTED': return "#FF0000";
      case 'COMPLETED': return "#0000FF";
      case 'CANCELLED': return "#888888";
      default: return "#000000";
    }
  }

  build() {
    Column() {
      // 页面标题
      Text('我的预约')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30, bottom: 26 })
        .alignSelf(ItemAlign.Start)

      if (this.isLoading) {
        LoadingProgress()
          .width(50)
          .height(50)
          .margin({ top: 80 })
      } else if (this.message !== '') {
        Text(this.message)
          .fontSize(16)
          .margin({ top: 60 })
      } else {
        // 预约列表
        List() {
          ForEach(this.reservations, (reservation: Reservation) => {
            ListItem() {
              this.renderReservationItem(reservation)
            }
            .width('100%')
          }, (reservation: Reservation, index: number) => (reservation.id ? reservation.id.toString() : index.toString()))
        }
        .width('100%')
        .layoutWeight(1)
      }
      
      Row() {
        Button("返回主页")
          .width('42%')
          .height(40)
          .backgroundColor('#3366FF')
          .fontColor(Color.White)
          .borderRadius(8)
          .margin({ right: 10 })
          .onClick(() => {
            router.back();
          })
        
        Button("刷新列表")
          .width('42%')
          .height(40)
          .backgroundColor('#33CC33')
          .fontColor(Color.White)
          .borderRadius(8)
          .margin({ left: 10 })
          .onClick(() => {
            this.loadReservations();
          })
      }
      .width('100%')
      .margin({ top: 20, bottom: 20 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding(24)
    .backgroundColor('#F5F5F5')
  }
}