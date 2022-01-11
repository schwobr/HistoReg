FROM cbica/captk_centos7:devtoolset-4_superbuild

LABEL authors="CBICA_UPenn <software@cbica.upenn.edu>"

RUN yum update -y && yum clean all

RUN yum install git

RUN mkdir /HistoReg

WORKDIR /HistoReg

COPY . .

RUN mkdir bin; \
    git submodule init && git submodule update

RUN cd bin; \
    cmake .. ; \
    make -j40 ; 

RUN cd bin; \   
    cmake -DCMAKE_INSTALL_PREFIX="./install/" -DBUILD_TESTING=OFF ..; \
    make -j40 && make install/strip; 
    #cd .. && ./scripts/captk-pkg

RUN cd greedy && mkdir build; \
    cd build; \
    cmake -DCMAKE_INSTALL_PREFIX="/HistoReg/bin/install" -DITK_DIR="/HistoReg/bin/ITK-build" ..;\
    make -j40 && make install/strip;

# set up the docker for GUI
ENV QT_X11_NO_MITSHM=1
ENV QT_GRAPHICSSYSTEM="native"
ENV PATH="/HistoReg/bin/install/bin:${PATH}"
