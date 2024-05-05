import request from '@/utils/request'

// 查询课表列表
export function listCtimetable(query) {
  return request({
    url: '/ctimetable/ctimetable/list',
    method: 'get',
    params: query
  })
}

// 查询课表详细
export function getCtimetable(uuid) {
  return request({
    url: '/ctimetable/ctimetable/' + uuid,
    method: 'get'
  })
}

// 新增课表
export function addCtimetable(data) {
  return request({
    url: '/ctimetable/ctimetable',
    method: 'post',
    data: data
  })
}

// 修改课表
export function updateCtimetable(data) {
  return request({
    url: '/ctimetable/ctimetable',
    method: 'put',
    data: data
  })
}

// 删除课表
export function delCtimetable(uuid) {
  return request({
    url: '/ctimetable/ctimetable/' + uuid,
    method: 'delete'
  })
}
