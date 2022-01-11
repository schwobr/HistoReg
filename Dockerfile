FROM cbica/captk_centos7:devtoolset-4_superbuild

LABEL authors="CBICA_UPenn <software@cbica.upenn.edu>"

RUN yum update -y && yum clean all

RUN yum install git

RUN mkdir data && mkdir data/inputs && mkdir data/outputs

RUN git clone https://github.com/schwobr/HistoReg.git; \
    cd HistoReg && mkdir bin; \
    git submodule init && git submodule update

RUN cd HistoReg/bin; \
    cmake .. ; \
    make -j40 ; \
    cmake -DCMAKE_INSTALL_PREFIX="./install/" -DBUILD_TESTING=OFF ..; \
    make -j40 && make install/strip; 
    #cd .. && ./scripts/captk-pkg

RUN cd HistoReg/greedy && mkdir build; \
    cd build; \
    cmake -DCMAKE_INSTALL_PREFIX="/work/HistoReg/bin/install" -DITK_DIR="/work/HistoReg/bin/ITK-build" ..;\
    make -j40 && make install/strip;

# set up the docker for GUI
ENV QT_X11_NO_MITSHM=1
ENV QT_GRAPHICSSYSTEM="native"
ENV PATH="/work/HistoReg/bin/install/bin:${PATH}"

WORKDIR /data
