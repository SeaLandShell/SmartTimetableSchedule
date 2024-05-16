FROM openjdk:11-jre

# 作者
LABEL org.opencontainers.image.authors="1769168668@qq.com"

# 将可执行的jar包放到容器当中去
ADD java/course-gateway.jar app.jar

# 暴露8080端口
EXPOSE 8080

# JVM 调优参数
#设置一个名为JAVA_OPTION的环境变量，该变量包含了一系列Java虚拟机的选项参数，这些参数会在Java应用程序启动时被传递给Java虚拟机。
 #-Dfile.encoding=UTF-8指定了Java应用程序的文件编码为UTF-8，确保应用程序能正确处理UTF-8编码的文件。
 #-XX:+UseParallelGC指定了使用并行垃圾回收器，以提高垃圾回收的效率。
 #-XX:+PrintGCDetails指定了在控制台输出详细的垃圾回收信息。
 #-Xloggc:/var/log/devops-example.gc.log指定了将垃圾回收日志输出到/var/log/devops-example.gc.log文件中。
 #-XX:+HeapDumpOnOutOfMemoryError指定了在发生内存溢出错误时生成堆转储文件。
 #-XX:+DisableExplicitGC指定了禁用显式的垃圾回收调用
ENV JAVA_OPTION="-Dfile.encoding=UTF-8 -XX:+UseParallelGC -XX:+PrintGCDetails -Xloggc:/var/log/devops-example.gc.log -XX:+HeapDumpOnOutOfMemoryError -XX:+DisableExplicitGC"

# JVM 内存默认值
ENV XMX=2g
ENV XMS=2g
ENV XMN=1g

# 运行程序
# 使用sh -c命令来执行后面的命令，-c表示将后面的字符串作为命令进行解释执行。
  #执行java命令，启动一个Java应用程序。
  #-Djava.security.egd=file:/dev/./urandom指定了Java的安全随机数生成器。
  #-jar表示要执行的Java程序是一个jar包。
  #-Xmx${XMX} -Xms${XMS} -Xmn${XMN}用来设置Java虚拟机的堆内存大小，其中${XMX}、${XMS}、${XMN}是环境变量，具体的值在运行容器时通过环境变量传入。
  #$JAVA_OPTION是Java的其他选项，包括了文件编码、垃圾回收等配置。
  #-Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}设置Spring Boot应用程序的配置文件。
  #/app.jar是要执行的Java应用程序的jar包路径。
ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -jar -Xmx${XMX} -Xms${XMS} -Xmn${XMN} $JAVA_OPTION -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE} /app.jar"]
