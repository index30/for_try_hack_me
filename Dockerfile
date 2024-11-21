FROM kalilinux/kali-rolling AS kali

# 8分くらいかかる。DEBIAN_FRONTENDはapt installと同コマンド内で指定する必要がある（入力待ちのブロックをしない）
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y kali-linux-headless

# kaliのツール
RUN apt update && apt install -y \
    kali-defaults \
    kali-tools-web \
    kali-desktop-xfce \
    burpsuite

# その他
# x11vnc: リモート接続系のライブラリ
# novnc: ブラウザでリモートデスクトップ接続
# dbus-x11: シンプルなプロセス間メッセージングシステム
# tigervnc-standalone-server: VNCサーバのライブラリ
# htop: タスクマネージャー
# inetutils-ping: ICMPエコーツール
RUN apt update && apt install -y \
    x11vnc \
    xvfb \
    novnc \
    dbus-x11 \
    tigervnc-standalone-server \
    htop \
    fish \
    inetutils-ping

# パッケージ整理
RUN apt autoremove -y && apt autoclean

# VPN用のディレクトリ作成
RUN mkdir -p /dev/net && mknod /dev/net/tun c 10 200 && chmod 600 /dev/net/tun

# 環境変数の設定
ENV DISPLAY=:1

# ユーザーの追加
RUN useradd -m -s /bin/bash kali && \
    echo "kali:kali" | chpasswd && \
    usermod -aG sudo kali

# ユーザーの切り替え
USER kali

# ユーザーのホームディレクトリに移動
WORKDIR /home/kali