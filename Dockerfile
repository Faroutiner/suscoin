FROM ubuntu:16.04

# Fix to docker being stuck at selecting timezone 
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./suscoin.conf /root/.suscoin/suscoin.conf
COPY . /suscoin
WORKDIR /suscoin
#shared libraries and dependencies
RUN apt update
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
RUN apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
#BerkleyDB for wallet support
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev
#upnp
RUN apt-get install -y libminiupnpc-dev
#ZMQ
RUN apt-get install -y libzmq3-dev
#build suscoin source
RUN ./autogen.sh
RUN ./configure --with-incompatible-bdb
RUN make
RUN make install
#open service port
EXPOSE 9696 19696

WORKDIR /suscoin/src
CMD ["suscoin", "--printtoconsole"]