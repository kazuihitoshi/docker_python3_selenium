##### building stage #####
FROM python:3.10 as builder

RUN apt-get update && apt-get install -y \
    unzip

# chrome driver
ADD https://chromedriver.storage.googleapis.com/101.0.4951.41/chromedriver_linux64.zip /opt/chrome/
RUN cd /opt/chrome/ && \
    unzip chromedriver_linux64.zip && \
    rm -f chromedriver_linux64.zip

# python package
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r  requirements.txt


##### production stage #####
FROM python:3.10-slim
COPY --from=builder /opt/ /opt/
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY 51-local.conf.patch /tmp
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    patch

# chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    apt-get -y clean && \
    cd /usr/share/fontconfig/conf.avail/ && patch -p1 < /tmp/51-local.conf.patch && \
    rm -rf /var/lib/apt/lists/* 

ENV DISPLAY host.docker.internal:0.0
WORKDIR /work
#COPY main.py .

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/chrome

