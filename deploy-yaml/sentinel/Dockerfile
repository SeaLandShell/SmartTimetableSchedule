FROM openjdk:11-jre

# 作者
LABEL org.opencontainers.image.authors="Shell <1769168668@qq.com>"

# jar 包下载地址：https://github.com/alibaba/Sentinel/releases/download/1.8.6/sentinel-dashboard-1.8.6.jar
# 将可执行的jar包放到容器当中去
ADD sentinel-dashboard-1.8.6.jar app.jar

# 设置暴露的端口
ENV SERVER_PORT=8718
ENV API_PORT=8719

# 暴露8080端口
EXPOSE 8718
EXPOSE 8719

# JVM 调优参数
ENV JAVA_OPTION="-Dfile.encoding=UTF-8 -XX:+UseParallelGC -XX:+PrintGCDetails -Xloggc:/var/log/devops-example.gc.log -XX:+HeapDumpOnOutOfMemoryError -XX:+DisableExplicitGC"

# JVM 内存默认值
ENV XMX=2g
ENV XMS=2g
ENV XMN=1g

# 设置sentinel的用户名和密码
ENV SENTINEL_USERNAME="sentinel"
ENV SENTINEL_PASSWORD="sentinel"

# 运行程序
ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -jar -Dsentinel.dashboard.auth.username=${SENTINEL_USERNAME} -Dsentinel.dashboard.auth.password=${SENTINEL_PASSWORD} -Xmx${XMX} -Xms${XMS} -Xmn${XMN} ${JAVA_OPTION} -Dserver.port=${SERVER_PORT} -Dcsp.sentinel.api.port=${API_PORT} /app.jar"]