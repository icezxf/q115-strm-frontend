// src/utils/avApi.ts
import axios from 'axios'

const http = axios.create({
  baseURL: '',
  timeout: 30000,
})

http.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 获取 AV 刮削配置
export function getAVConfig() {
  return http.get('/api/avscrape/config')
}

// 保存 AV 刮削配置
export function saveAVConfig(data: any) {
  return http.post('/api/avscrape/config', data)
}

// 触发刮削
export function startScrape(code: string) {
  return http.post('/api/avscrape/scrape', { code })
}

// 获取媒体库列表
export function getAVLibrary(params: { page: number; page_size: number }) {
  return http.get('/api/avscrape/library', { params })
}

// 获取单条详情
export function getAVDetail(id: number) {
  return http.get(`/api/avscrape/library/${id}`)
}