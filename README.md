# docker_python3_selenium
以下の記事を基に作成しました python3 google-chrome selenium 環境です。

https://laid-back-scientist.com/docker-webscraping

DISPLAY環境変数がセット済ですので、ホストOS側にX Windowを用意
頂ければ、コンテナ内のgoogle-chromeを表示可能です。:w

export DISPLAY=host.docker.internal:0.0
