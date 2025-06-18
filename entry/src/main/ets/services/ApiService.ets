import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import data_preferences from '@ohos.data.preferences';

// 定义接口类型，替代any
interface LoginResponse {
  token: string;
  id: number;
  username: string;
  role: string;
}

// 导出 Laboratory 接口
export interface Laboratory {
  id: number;
  name: string;
  location: string;
  capacity: number;
  description: string;
  availability: boolean;
}

// 导出 Reservation 接口
export interface Reservation {
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

interface Favorite {
  id?: number;
  userId?: number;
  labId: number;
  laboratory?: Laboratory;
}

interface ApiResponse {
  message: string;
}

// 定义HTTP请求头类
class HttpHeader {
  contentType: string = '';
  authorization: string = '';
  
  setContentType(value: string): void {
    this.contentType = value;
  }
  
  setAuthorization(value: string): void {
    this.authorization = value;
  }
  
  toObject(): Record<string, string> {
    let result: Record<string, string> = {};
    
    if (this.contentType) {
      result['Content-Type'] = this.contentType;
    }
    
    if (this.authorization) {
      result['Authorization'] = this.authorization;
    }
    
    return result;
  }
}

/**
 * API服务类，封装所有与后端的网络请求
 */
export class ApiService {
  private baseUrl: string = 'http://192.168.31.193:8080/api';
  private token: string = '';
  private context: common.UIAbilityContext | null = null;
  private preferencesName: string = 'user_preferences';

  /**
   * 初始化API服务
   * @param context UIAbilityContext用于显示消息
   */
  initContext(context: common.UIAbilityContext) {
    this.context = context;
  }

  /**
   * 设置认证Token
   * @param token JWT Token
   */
  async setToken(token: string) {
    this.token = token;
    try {
      if (this.context) {
        let preferences = await data_preferences.getPreferences(this.context, this.preferencesName);
        await preferences.put('userToken', token);
        await preferences.flush();
      }
    } catch (error) {
      console.error('Failed to save token:', error);
    }
  }

  /**
   * 获取认证Token
   */
  async getToken(): Promise<string> {
    if (!this.token) {
      try {
        if (this.context) {
          let preferences = await data_preferences.getPreferences(this.context, this.preferencesName);
          const value = await preferences.get('userToken', '');
          this.token = value as string;
        }
      } catch (error) {
        console.error('Failed to get token:', error);
      }
    }
    return this.token;
  }

  /**
   * 清除认证Token
   */
  async clearToken() {
    this.token = '';
    try {
      if (this.context) {
        let preferences = await data_preferences.getPreferences(this.context, this.preferencesName);
        await preferences.delete('userToken');
        await preferences.flush();
      }
    } catch (error) {
      console.error('Failed to clear token:', error);
    }
  }

  /**
   * 创建HTTP请求客户端
   */
  private createHttpRequest(): http.HttpRequest {
    let httpRequest = http.createHttp();
    // 设置连接和响应超时时间
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
    return httpRequest;
  }

  /**
   * 处理HTTP请求结果
   * @param result HTTP请求结果
   */
  private handleResult<T>(result: http.HttpResponse): T {
    if (result.responseCode === 200 || result.responseCode === 201) {
      return JSON.parse(result.result.toString()) as T;
    } else if (result.responseCode === 401) {
      // 认证失败，清除Token并提示用户重新登录
      this.clearToken();
      this.showToast('登录已过期，请重新登录');
      throw new Error('认证失败');
    } else {
      let error = JSON.parse(result.result.toString()) as ApiResponse;
      this.showToast(error.message || '请求失败');
      throw new Error(error.message || '请求失败');
    }
  }

  /**
   * 显示提示信息
   * @param message 提示信息
   */
  private showToast(message: string) {
    if (this.context) {
      this.context.eventHub.emit('showToast', { message: message });
    }
  }

  /**
   * 用户登录
   * @param username 用户名
   * @param password 密码
   */
  async login(username: string, password: string): Promise<LoginResponse> {
    try {
      const httpRequest = this.createHttpRequest();
      
      // 创建header
      let header = new HttpHeader();
      header.setContentType('application/json');
      
      class LoginData {
        username: string;
        password: string;
        
        constructor(username: string, password: string) {
          this.username = username;
          this.password = password;
        }
      }
      
      const loginData = new LoginData(username, password);
      
      const result = await httpRequest.request(
        this.baseUrl + '/auth/login',
        {
          method: http.RequestMethod.POST,
          header: header.toObject(),
          extraData: JSON.stringify(loginData)
        }
      );
      
      const data = this.handleResult<LoginResponse>(result);
      if (data.token) {
        await this.setToken(data.token);
        try {
          if (this.context) {
            let preferences = await data_preferences.getPreferences(this.context, this.preferencesName);
            await preferences.put('userId', data.id);
            await preferences.put('userName', data.username);
            await preferences.put('userRole', data.role);
            await preferences.flush();
          }
        } catch (error) {
          console.error('Failed to save user data:', error);
        }
      }
      return data;
    } catch (error) {
      const err = error as Error;
      console.error(`登录失败: ${err.message}`);
      throw new Error(`登录失败: ${err.message}`);
    }
  }

  /**
   * 获取实验室列表
   */
  async getLaboratories(): Promise<Laboratory[]> {
    try {
      const httpRequest = this.createHttpRequest();
      const result = await httpRequest.request(
        this.baseUrl + '/laboratories',
        {
          method: http.RequestMethod.GET,
          header: await this.getAuthHeader().then(header => header.toObject())
        }
      );
      return this.handleResult<Laboratory[]>(result);
    } catch (error) {
      const err = error as Error;
      console.error(`获取实验室列表失败: ${err.message}`);
      return [];
    }
  }

  /**
   * 获取实验室详情
   * @param id 实验室ID
   */
  async getLaboratory(id: number): Promise<Laboratory> {
    try {
      const httpRequest = this.createHttpRequest();
      const result = await httpRequest.request(
        `${this.baseUrl}/laboratories/${id}`,
        {
          method: http.RequestMethod.GET,
          header: await this.getAuthHeader().then(header => header.toObject())
        }
      );
      return this.handleResult<Laboratory>(result);
    } catch (error) {
      const err = error as Error;
      console.error(`获取实验室详情失败: ${err.message}`);
      throw new Error(`获取实验室详情失败: ${err.message}`);
    }
  }

  /**
   * 获取用户预约列表
   */
  async getUserReservations(): Promise<Reservation[]> {
    try {
      const httpRequest = this.createHttpRequest();
      const result = await httpRequest.request(
        this.baseUrl + '/reservations/my',
        {
          method: http.RequestMethod.GET,
          header: await this.getAuthHeader().then(header => header.toObject())
        }
      );
      return this.handleResult<Reservation[]>(result);
    } catch (error) {
      const err = error as Error;
      console.error(`获取用户预约列表失败: ${err.message}`);
      return [];
    }
  }

  /**
   * 提交实验室预约
   * @param reservation 预约信息
   */
  async createReservation(reservation: Reservation): Promise<Reservation> {
    try {
      const httpRequest = this.createHttpRequest();
      
      let header = await this.getAuthHeader();
      header.setContentType('application/json');
      
      const result = await httpRequest.request(
        this.baseUrl + '/reservations',
        {
          method: http.RequestMethod.POST,
          header: header.toObject(),
          extraData: JSON.stringify(reservation)
        }
      );
      
      return this.handleResult<Reservation>(result);
    } catch (error) {
      const err = error as Error;
      console.error(`创建预约失败: ${err.message}`);
      throw new Error(`创建预约失败: ${err.message}`);
    }
  }

  /**
   * 取消预约
   * @param id 预约ID
   */
  async cancelReservation(id: number): Promise<ApiResponse> {
    try {
      const httpRequest = this.createHttpRequest();
      const result = await httpRequest.request(
        `${this.baseUrl}/reservations/${id}`,
        {
          method: http.RequestMethod.DELETE,
          header: await this.getAuthHeader().then(header => header.toObject())
        }
      );
      return this.handleResult<ApiResponse>(result);
    } catch (error) {
      const err = error as Error;
      console.error(`取消预约失败: ${err.message}`);
      throw new Error(`取消预约失败: ${err.message}`);
    }
  }

  /**
   * 获取收藏列表
   */
  async getFavorites(): Promise<Favorite[]> {
    try {
      const httpRequest = this.createHttpRequest();
      const result = await httpRequest.request(
        this.baseUrl + '/favorites/my',
        {
          method: http.RequestMethod.GET,
          header: await this.getAuthHeader().then(header => header.toObject())
        }
      );
      return this.handleResult<Favorite[]>(result);
    } catch (error) {
      const err = error as Error;
      console.error(`获取收藏列表失败: ${err.message}`);
      return [];
    }
  }

  /**
   * 添加收藏
   * @param labId 实验室ID
   */
  async addFavorite(labId: number): Promise<ApiResponse> {
    try {
      const httpRequest = this.createHttpRequest();
      const result = await httpRequest.request(
        `${this.baseUrl}/favorites/${labId}`,
        {
          method: http.RequestMethod.POST,
          header: await this.getAuthHeader().then(header => header.toObject())
        }
      );
      return this.handleResult<ApiResponse>(result);
    } catch (error) {
      const err = error as Error;
      console.error(`添加收藏失败: ${err.message}`);
      throw new Error(`添加收藏失败: ${err.message}`);
    }
  }

  /**
   * 移除收藏
   * @param labId 实验室ID
   */
  async removeFavorite(labId: number): Promise<ApiResponse> {
    try {
      const httpRequest = this.createHttpRequest();
      const result = await httpRequest.request(
        `${this.baseUrl}/favorites/${labId}`,
        {
          method: http.RequestMethod.DELETE,
          header: await this.getAuthHeader().then(header => header.toObject())
        }
      );
      return this.handleResult<ApiResponse>(result);
    } catch (error) {
      const err = error as Error;
      console.error(`移除收藏失败: ${err.message}`);
      throw new Error(`移除收藏失败: ${err.message}`);
    }
  }

  /**
   * 检查是否已收藏
   * @param labId 实验室ID
   */
  async checkFavorite(labId: number): Promise<boolean> {
    try {
      const httpRequest = this.createHttpRequest();
      const result = await httpRequest.request(
        `${this.baseUrl}/favorites/check/${labId}`,
        {
          method: http.RequestMethod.GET,
          header: await this.getAuthHeader().then(header => header.toObject())
        }
      );
      const data = this.handleResult<ApiResponse>(result);
      return data.message === 'true';
    } catch (error) {
      const err = error as Error;
      console.error(`检查收藏状态失败: ${err.message}`);
      return false;
    }
  }

  /**
   * 获取认证请求头
   */
  private async getAuthHeader(): Promise<HttpHeader> {
    const header = new HttpHeader();
    const token = await this.getToken();
    
    if (token) {
      header.setAuthorization(`Bearer ${token}`);
    }
    
    return header;
  }
}

// 创建单例
export const apiService = new ApiService();