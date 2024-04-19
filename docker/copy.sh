#!/bin/sh

# 复制项目的文件到对应docker路径，便于一键生成镜像。
usage() {
	echo "Usage: sh copy.sh"
	exit 1
}


# copy sql
echo "begin copy sql "
cp ../sql/ry_20230706.sql ./mysql/db
cp ../sql/ry_config_20220929.sql ./mysql/db

# copy html
echo "begin copy html "
cp -r ../course-ui/dist/** ./nginx/html/dist


# copy jar
echo "begin copy course-gateway "
cp ../course-gateway/target/course-gateway.jar ./course/gateway/jar

echo "begin copy course-auth "
cp ../course-auth/target/course-auth.jar ./course/auth/jar

echo "begin copy course-visual "
cp ../course-visual/course-monitor/target/course-visual-monitor.jar  ./course/visual/monitor/jar

echo "begin copy course-modules-system "
cp ../course-modules/course-system/target/course-modules-system.jar ./course/modules/system/jar

echo "begin copy course-modules-file "
cp ../course-modules/course-file/target/course-modules-file.jar ./course/modules/file/jar

echo "begin copy course-modules-job "
cp ../course-modules/course-job/target/course-modules-job.jar ./course/modules/job/jar

echo "begin copy course-modules-gen "
cp ../course-modules/course-gen/target/course-modules-gen.jar ./course/modules/gen/jar

