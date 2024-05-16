# 使用 MySQL 5.7.43 作为基础镜像
FROM mysql:5.7.43

# 设置作者信息
LABEL org.opencontainers.image.authors="Shell <1769168668@qq.com>"

# 设置 MySQL 的环境变量
# 例如，设置 root 用户密码，数据库名称，以及其他配置
ENV MYSQL_ROOT_PASSWORD=@Brother0303

# 复制初始化数据到容器中
# 此行代码用于向 docker 容器的初始化数据库目录中添加 SQL 初始化脚本
# 通过 ADD 指令，将本地的 init_sql.tar.gz 文件打包压缩后添加到容器的 /docker-entrypoint-initdb.d 目录下
# 这个目录是 Docker 容器在启动时用于执行初始化数据库脚本的默认目录
# 参数说明：
# ./sql/init_sql.tar.gz：本地文件路径，指定要添加到容器的压缩文件
# /docker-entrypoint-initdb.d：容器内的目标路径，指定压缩文件在容器内的解压位置
ADD ./sql/init_sql.tar.gz /docker-entrypoint-initdb.d
