#!/bin/bash

# 设置镜像仓库路径
REPOSITORY_PATH='registry.cn-hangzhou.aliyuncs.com/course-schedule/'
PAT_TOKEN='@Brother0303'
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
  # 认证服务
  course_AUTH='../course-auth/target/course-auth.jar'
  if [ -f "${course_AUTH}" ]; then
    # 如果认证服务jar文件存在，则移动到java目录下
    if [ ! -d './course-auth/java' ]; then
      mkdir ./course-auth/java
    fi
    mv ${course_AUTH} ./course-auth/java
  fi
  # 网关服务
  course_GATEWAY='../course-gateway/target/course-gateway.jar'
  if [ -f "${course_GATEWAY}" ]; then
    # 如果网关服务jar文件存在，则移动到java目录下
    if [ ! -d './course-gateway/java' ]; then
      mkdir ./course-gateway/java
    fi
    mv ${course_GATEWAY} ./course-gateway/java
  fi
  # 所有module模块
  # shellcheck disable=SC2012
  # 此脚本用于将课程模块的JAR文件移动到对应的java目录下
  # 该脚本不接受参数且无返回值

  course_MODULES=$(ls -lh course-modules | awk '{print $9}') # 获取课程模块目录下的所有文件名

  for course_MODULE in ${course_MODULES}; do
    MODULE_JAR="../course-modules/${course_MODULE}/target/${course_MODULE}.jar" # 构建模块JAR文件的路径
    MODULE_DIR="./course-modules/${course_MODULE}/java" # 构建模块对应的java目录路径

    # 检查JAR文件是否存在
    if [ -f "${MODULE_JAR}" ]; then
      # 如果java目录不存在，则创建
      if [ ! -d "${MODULE_DIR}" ]; then
        mkdir "${MODULE_DIR}"
      fi
      # 将JAR文件移动到java目录下
      mv "${MODULE_JAR}" "${MODULE_DIR}"
    fi
  done
  course_MODULES_APP=$(ls -lh course-modules-app | awk '{print $9}')
  for course_MODULE_APP in ${course_MODULES_APP}; do
      MODULE_APP_JAR="../course-modules-app/${course_MODULE_APP}/target/${course_MODULE_APP}.jar"
      MODULE_DIR_APP="./course-modules-app/${course_MODULE_APP}/java"
      if [ -f "${MODULE_APP_JAR}" ]; then
        # 如果模块的jar文件存在，则移动到java目录下
        if [ ! -d "${MODULE_DIR_APP}" ]; then
          mkdir "${MODULE_DIR_APP}"
        fi
        mv "${MODULE_APP_JAR}" "${MODULE_DIR_APP}"
      fi
    done
  # 监控服务
  course_MONITOR='../course-visual/course-monitor/target/course-monitor.jar'
  if [ -f "${course_MONITOR}" ]; then
    # 如果监控服务jar文件存在，则移动到java目录下
    if [ ! -d './course-visual/course-visual-monitor/java' ]; then
      mkdir ./course-visual/course-visual-monitor/java
      mv ${course_MONITOR} ./course-visual/course-visual-monitor/java
    fi
  fi
  # 前端服务
  UI_DIR='../system-ui/dist'
  if [ -d "${UI_DIR}" ]; then
    # 如果前端服务目录存在，则移动到当前目录下的system-ui目录
    if [ -d "./system-ui/dist" ]; then
      rm -rf ./system-ui/dist
    fi
    mv ${UI_DIR} ./system-ui
  fi
  # 数据库
   # 准备数据库SQL文件
   # 该脚本会首先检查是否存在一个名为'course-mysql/sql'的目录，
   # 如果存在，它将被删除。接着，从上一级目录复制'sql'目录到'course-mysql'下。
   # 最后，脚本会在'course-mysql/sql'目录下压缩所有SQL文件为tar.gz格式，并删除原始的SQL文件。

   SQL_DIR='./course-mysql/sql'
   if [ -d "${SQL_DIR}" ]; then
     # 如果数据库目录存在，则删除该目录
     rm -rf "${SQL_DIR}"
   fi
   cp -r ../sql ./course-mysql
   cd course-mysql/sql || exit
   # 压缩数据库SQL文件为tar.gz格式
   tar -zcvf init_sql.tar.gz *.sql
   # 删除压缩前的SQL文件
   rm -rf *.sql
}

# 构建Docker镜像
# build函数用于构建所有找到的Dockerfile对应的镜像。
# 该函数不需要参数，并且没有返回值。
build() {
  # 获取当前工作目录
  CURRENT_DIR=$(pwd)
  # 查找当前目录及其子目录下所有名为Dockerfile的文件
  DOCKERFILES=$(find . -name Dockerfile)
  for DOCKERFILE in ${DOCKERFILES}; do
    # 提取Dockerfile所在目录，并去除可能的前缀命名空间部分
    BUILD_DIR="${DOCKERFILE%/*}"
    # 提取目录名称（去除前面可能的目录层级路径）
    MODULE_NAME=${BUILD_DIR##*-}
    # 组合当前目录和Dockerfile所在目录，形成完整的路径
    BUILD_DIR="${CURRENT_DIR}${BUILD_DIR#*.}"
    # 切换到Dockerfile所在目录
    cd "${BUILD_DIR}" || exit
    # 使用Docker构建镜像，标签格式为<仓库路径><模块名称>:<标签>
    docker build -t "${REPOSITORY_PATH}${MODULE_NAME}:${TAG}" .
  done
}


# 推送Docker镜像
docker login -u aliyun6415635881 --password-stdin <<< "$PAT_TOKEN" registry.cn-hangzhou.aliyuncs.com
push() {
  IMAGE_LIST=$(docker images | grep "${REPOSITORY_PATH}" | awk '{print $1":"$2}')
  if [ -n "${IMAGE_LIST}" ]; then
    for IMAGE in ${IMAGE_LIST}; do
      # 推送镜像到指定镜像仓库
      docker push "${IMAGE}"
    done
  fi
}

# 清理操作
clean() {
  mvn clean -f ../pom.xml
  ALL_JAVA_DIRS=$(find . -name java)
  if [ -n "${ALL_JAVA_DIRS}" ]; then
    for JAVA_DIR in ${ALL_JAVA_DIRS}; do
      # 删除所有Java目录
      rm -rf "${JAVA_DIR}"
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