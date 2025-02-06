FROM ubuntu:20.04

# 更新并安装依赖
RUN apt update -y && \
    apt install -y wget unzip nginx supervisor qrencode net-tools && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /etc/mysql /usr/local/mysql
COPY config.json /etc/mysql/
COPY entrypoint.sh /usr/local/mysql/

# 下载并解压 v2ray
RUN wget -q -O /tmp/v2ray-linux-64.zip https://github.com/v2fly/v2ray-core/releases/download/v4.45.0/v2ray-linux-64.zip && \
    unzip -d /usr/local/mysql /tmp/v2ray-linux-64.zip && \
    mv /usr/local/mysql/v2ray /usr/local/mysql/mysql && \
    chmod a+x /usr/local/mysql/entrypoint.sh && \
    rm /tmp/v2ray-linux-64.zip

# 设置入口点
ENTRYPOINT ["/usr/local/mysql/entrypoint.sh"]
