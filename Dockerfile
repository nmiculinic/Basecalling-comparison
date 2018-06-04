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
        libbz2-dev \
        libncurses-dev \
        liblzma-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

ENV SAMTOOLS_VERSION="1.8"
RUN wget --quiet https://github.com/samtools/samtools/releases/download/$SAMTOOLS_VERSION/samtools-$SAMTOOLS_VERSION.tar.bz2 -O samtools.tar.bz2 && \
    tar -xjf samtools.tar.bz2 && \
    rm samtools.tar.bz2 && \
    cd /opt/samtools-$SAMTOOLS_VERSION && \
    make -j && \
    make prefix=/usr/bin install && \
    cd /opt && rm -Rf /opt/samtools-$SAMTOOLS_VERSION 

RUN python3 --version
RUN curl https://bootstrap.pypa.io/get-pip.py | python3

RUN curl -L https://github.com/lh3/minimap2/releases/download/v2.10/minimap2-2.10_x64-linux.tar.bz2 | tar -jxvf - && \
    mv ./minimap2-2.10_x64-linux/minimap2 /usr/bin/minimap2 && \
    rm -Rf ./minimap2-2.10_x64-linux


ENV FILTLONG_VERSION="0.2.0"
RUN wget --quiet https://github.com/rrwick/Filtlong/archive/v$FILTLONG_VERSION.zip -O ft.zip && \
    unzip -q ft.zip && \
    rm ft.zip && \
    cd /opt/Filtlong-$FILTLONG_VERSION && \
    make -j && \
    cp ./bin/filtlong /usr/bin/ && \ 
    cd /opt && rm -Rf /opt/Filtlong-$FILTLONG_VERSION 

ENV PORECHOP_VERSION="v0.2.3"
RUN pip --no-cache-dir install git+https://github.com/rrwick/Porechop.git@$PORECHOP_VERSION

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

ENV REBALER_VERSION="v0.1.1"
RUN pip --no-cache-dir install git+https://github.com/rrwick/Rebaler.git@$REBALER_VERSION

ENV NANOPOLISH_VERSION="v0.9.0"
RUN git clone --recursive https://github.com/jts/nanopolish.git nanopolish && \
    cd nanopolish && \
    git checkout $NANOPOLISH_VERSION && \
    make &&  \ 
    mv ./nanopolish /usr/bin && \ 
    cd /opt && \
    rm -Rf nanopolish 


RUN ln -s /usr/bin/python3 -T /usr/bin/python
ENV MEDAKA_VERSION="0.2.0"
RUN wget --quiet https://github.com/nanoporetech/medaka/archive/v$MEDAKA_VERSION.zip -O medaka.zip && \
    unzip -q medaka.zip && \
    rm medaka.zip && \
    cd /opt/medaka-$MEDAKA_VERSION && \
    mkdir venv && \
    make -j -e IN_VENV="true" install && \
    cd /opt && rm -Rf /opt/medaka-$MEDAKA_VERSION

WORKDIR /opt/bcmp
COPY . . 
