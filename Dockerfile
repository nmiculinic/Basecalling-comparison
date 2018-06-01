FROM ubuntu

RUN apt-get update && apt-get install -y --no-install-recommends \
        software-properties-common \
        build-essential \
        curl \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libpng-dev \
        libzmq3-dev \
        pkg-config \
        python3.6 \
        python3.6-dev \
        python3-distutils \
        rsync \
        software-properties-common \
        unzip \
        wget \
        cmake \
        git \ 
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python3 --version
RUN curl https://bootstrap.pypa.io/get-pip.py | python3

WORKDIR /opt
RUN curl -L https://github.com/lh3/minimap2/releases/download/v2.10/minimap2-2.10_x64-linux.tar.bz2 | tar -jxvf - && mv ./minimap2-2.10_x64-linux/minimap2 /usr/bin/minimap2


ENV FILTLONG_VERSION="0.2.0"
RUN wget --quiet https://github.com/rrwick/Filtlong/archive/v$FILTLONG_VERSION.zip -O ft.zip && \
    unzip -q ft.zip && \
    rm ft.zip && \
    cd /opt/Filtlong-$FILTLONG_VERSION && \
    make -j && \
    cp ./bin/filtlong /usr/bin/ && \ 
    cd /opt && rm -Rf /opt/Filtlong-$FILTLONG_VERSION 

ENV PORECHOP_VERSION="0.2.3"
RUN wget --quiet https://github.com/rrwick/Porechop/archive/v$PORECHOP_VERSION.zip -O pc.zip && \
    unzip -q pc.zip && \
    rm pc.zip && \
    cd /opt/Porechop-$PORECHOP_VERSION && \
    python3 setup.py install && \ 
    cd /opt && rm -Rf /opt/Porechop-$PORECHOP_VERSION

ENV RACON_VERSION="1.3.1"
RUN git clone --recursive https://github.com/isovic/racon.git racon && \
    cd racon && \
    git checkout $RACON_VERSION && \
    mkdir build && \ 
    cd build && \ 
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make &&  \ 
    mv ./bin/racon /usr/bin && \ 
    cd /opt && \
    rm -Rf racon 
