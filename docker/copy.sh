#!/bin/sh

# 复制项目的文件到对应docker路径，便于一键生成镜像。
usage() {
	echo "Usage: sh copy.sh"
	exit 1
}


# copy sql
echo "begin copy sql "
cp ../sql/course_cloud.sql ./mysql/db
cp ../sql/ctimetable.sql ./mysql/db
cp ../sql/quartz.sql ./mysql/db
cp ../sql/ry_20231130.sql ./mysql/db
cp ../sql/ry_config_20231204.sql ./mysql/db
cp ../sql/ry_seata_20210128.sql ./mysql/db

# copy html
echo "begin copy html "
cp -r ../system-ui/dist/** ./nginx/html/dist


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

echo "begin copy course-modules-cuser "
cp ../course-modules/course-cuser/target/course-modules-cuser.jar ./course/modules/cuser/jar

echo "begin copy course-modules-ctimetable "
cp ../course-modules/course-ctimetable/target/course-modules-ctimetable.jar ./course/modules/ctimetable/jar

echo "begin copy course-modules-app-cuser "
cp ../course-modules-app/app-cuser/target/app-cuser.jar ./course/modules_app/acuser/jar

echo "begin copy course-modules-app-ctimetable "
cp ../course-modules-app/app-ctimetable/target/app-ctimetable.jar ./course/modules_app/actimetable/jar

echo "begin copy course-modules-app-cschedule "
cp ../course-modules-app/app-cschedule/target/app-cschedule.jar ./course/modules_app/acschedule/jar

