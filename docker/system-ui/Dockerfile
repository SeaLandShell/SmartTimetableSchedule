FROM nginx:1.23.4

# 作者
LABEL org.opencontainers.image.authors="Shell <1769168668@qq.com>"

# 项目的根目录
VOLUME /usr/share/nginx/html

# 指定路径
WORKDIR /usr/share/nginx/html

# 复制conf文件到路径
COPY conf/nginx.conf /etc/nginx/nginx.conf

# 暴露服务端口
# http 端口
EXPOSE 80

# 复制html文件到路径
COPY dist /usr/share/nginx/html
