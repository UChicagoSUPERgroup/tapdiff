FROM ubuntu:xenial

USER root

RUN apt update && apt install -y wget unzip python3-pip
RUN wget -q -O - https://www.lrde.epita.fr/repo/debian.gpg | apt-key add - &&\
    echo 'deb http://www.lrde.epita.fr/repo/debian/ stable/' >> /etc/apt/sources.list &&\
    apt update && apt install -y libbddx0=2.7.5.0-1 libspot0=2.7.5.0-1 libspotltsmin0=2.7.5.0-1 libspotgen0=2.7.5.0-1 libbddx-dev=2.7.5.0-1 libspot-dev=2.7.5.0-1 spot-doc=2.7.5.0-1 python3-spot=2.7.5.0-1 spot=2.7.5.0-1
RUN cd /root && \
    wget http://robertdick.org/python/qm-0.2.tar.gz && \
    tar -zxvf qm-0.2.tar.gz &&\
    cd /root/qm-0.2 && \
    python3 setup.py install
RUN groupadd -r iftttuser && useradd --no-log-init -r -g iftttuser iftttuser

# install z3
RUN cd /root && \
    wget https://github.com/Z3Prover/z3/releases/download/Z3-4.8.5/z3-4.8.5-x64-ubuntu-16.04.zip && \
    unzip z3-4.8.5-x64-ubuntu-16.04 && \
    cd /root/z3-4.8.5-x64-ubuntu-16.04 && \
    cp bin/*.so /usr/lib && \
    cp bin/z3 /usr/bin && \
    cp -r bin/python/z3/ /usr/lib/python3/dist-packages && \
    cp include/* /usr/include

RUN python3 -m pip install sympy

USER iftttuser

COPY --chown=iftttuser . /home/iftttuser/AutoTap
WORKDIR /home/iftttuser/AutoTap
CMD ["/bin/bash"]