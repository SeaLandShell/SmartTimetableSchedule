import request from '@/utils/request'

// 查询智课表用户列表
export function listCuser(query) {
  return request({
    url: '/cuser/cuser/list',
    method: 'get',
    params: query
  })
}

// 查询智课表用户详细
export function getCuser(userId) {
  return request({
    url: '/cuser/cuser/' + userId,
    method: 'get'
  })
}

// 新增智课表用户
export function addCuser(data) {
  return request({
    url: '/cuser/cuser',
    method: 'post',
    data: data
  })
}

// 修改智课表用户
export function updateCuser(data) {
  return request({
    url: '/cuser/cuser',
    method: 'put',
    data: data
  })
}

// 删除智课表用户
export function delCuser(userId) {
  return request({
    url: '/cuser/cuser/' + userId,
    method: 'delete'
  })
}
