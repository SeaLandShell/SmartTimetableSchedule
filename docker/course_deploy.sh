#!/bin/bash

# 设置镜像仓库路径
REPOSITORY_PATH='registry-vpc.cn-hangzhou.aliyuncs.com/course_schedule/'
DOCKER_USERNAME="aliyun6415635881"
DOCKER_PASSWORD="@Brother0303"
# 设置镜像标签
TAG='1.0.0'

# 打包项目
package() {
  # 使用Maven清理并打包项目
  mvn clean package -Dmaven.test.skip -f ../pom.xml
  # 进入前端项目目录
  cd ../system-ui || exit
  # 使用npm安装依赖
  npm install --registry=https://registry.npmmirror.com --unsafe-perm
  # 运行前端项目的生产构建
  npm run build:prod
}


# 移动项目文件
move() {
  sh ./copy.sh
}

# 构建Docker镜像
build() {
  docker-compose up
#  CURRENT_DIR=$(pwd)
#  # 查找所有Dockerfile
#  DOCKERFILES=$(find . -name Dockerfile)
#  for DOCKERFILE in ${DOCKERFILES}; do
#    BUILD_DIR="${DOCKERFILE%/*}"
#    MODULE_NAME=${BUILD_DIR##*-}
#    BUILD_DIR="${CURRENT_DIR}${BUILD_DIR#*.}"
#    cd "${BUILD_DIR}" || exit
#    # 使用Docker构建镜像
#    docker build -t "${REPOSITORY_PATH}${MODULE_NAME}:${TAG}" .
#  done
}


# 推送Docker镜像
push() {
  # 登录到Docker仓库
  echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin registry-vpc.cn-hangzhou.aliyuncs.com

  IMAGE_LIST=$(docker images | grep "${REPOSITORY_PATH}" | awk '{print $1":"$2}')
  if [ -n "${IMAGE_LIST}" ]; then
    for IMAGE in ${IMAGE_LIST}; do
      # 推送镜像到指定镜像仓库
      docker push "${IMAGE}"
    done
  fi
  # 登出Docker仓库
  docker logout registry-vpc.cn-hangzhou.aliyuncs.com
}

# 清理操作
clean() {
  mvn clean -f ../pom.xml
  ALL_JAVA_DIRS=$(find . -name jar)
  if [ -n "${ALL_JAVA_DIRS}" ]; then
    for JAVA_DIR in ${ALL_JAVA_DIRS}; do
      # 删除目录下的所有.jar文件
      find "${JAVA_DIR}" -type f -name "*.jar" -exec rm -f {} \;
    done
  fi
  if [ -d "../system-ui/dist" ]; then
    # 删除前端服务dist目录
    rm -rf ../system-ui/dist
  fi
  if [ -d "./system-ui/dist" ]; then
    # 删除当前目录下的前端服务dist目录
    rm -rf ./system-ui/dist
  fi
  if [ -d "./course-mysql/sql" ]; then
    # 如果存在数据库目录，则删除该目录
    rm -rf ./course-mysql/sql
  fi
  echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin registry-vpc.cn-hangzhou.aliyuncs.com
  IMAGE_LIST=$(docker images | grep "${REPOSITORY_PATH}" | awk '{print $1":"$2}')
  if [ -n "${IMAGE_LIST}" ]; then
    for IMAGE in ${IMAGE_LIST}; do
      # 强制删除所有镜像
      docker rmi -f "${IMAGE}"
    done
  fi
}

# 根据输入命令执行相应操作
case $1 in
"package")
  package
  ;;
"move")
  move
  ;;
"build")
  build
  ;;
"push")
  push
  ;;
"clean")
  clean
  ;;
*)
  # 默认输出帮助信息
  echo "未找到命令$1，命令执行格式："
  echo "course.sh command"
  echo "command: {package|move|build|push|clean}"
  echo "package: 将项目打包"
  echo "move: 将打包好的项目移动到构建空间"
  echo "build: 将项目打成docker包"
  echo "push: 推送构建好的docker包"
  echo "clean: 清理构建残余"
  ;;
esac