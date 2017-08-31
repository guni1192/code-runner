FROM ubuntu:latest

# ミラーサーバをjaist優先
RUN sed -i'~' -E "s@http://(..\.)?(archive|security)\.ubuntu\.com/ubuntu@http://ftp.jaist.ac.jp/pub/Linux/ubuntu@g" /etc/apt/sources.list

RUN apt update -y && apt upgrade -y
# 使用言語
RUN apt install -y gcc python3-dev ruby


# システムのデフォルト文字コードをen_US.UTF-8にする
RUN apt install -y language-pack-ja
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# タイムゾーンの設定
ENV TZ Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
