#Development (may not be stable)
#version
FROM carlosantagiustina/cocalc AS cleanCocalc
MAINTAINER Carlo R. M. A. Santagiustina (carlosantagiustina@gmail.com)
ENV DEBIAN_FRONTEND noninteractive
#ENV VERSION 0.1

# Remove microsoft proprietary tools with telemetry
#RUN rm /etc/apt/sources.list.d/vscode.list; 
#RUN rm /etc/apt/trusted.gpg.d/microsoft.gpg /microsoft.gpg



#repostiries 
RUN wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
RUN sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'

# Install additional software
 RUN apt-get update --fix-missing

#Install ubuntu libraries
RUN \
    apt-get install -y  --no-install-recommends  \
        emacs \
        gimp \
        scilab \
        geogebra \
        sqlitebrowser \
        mysql-workbench \
        gmysqlcc \
        default-jdk \
        nano \
        apt-transport-https \
        software-properties-common \
        sbcl \
        unrar \
        idle3 \
        firefox \
        atom \
        libtool \
        libffi-dev \
        make \
        libzmq3-dev \
        libczmq-dev \
         wget \
        software-properties-common
#        ruby \
#        ruby-dev \        

RUN octave --eval 'pkg install -forge dataframe'
################################
#########   Chrome     #########
################################

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
RUN  apt-get update 
RUN  apt-get install -y  google-chrome-stable

################################
#########   Python     #########
################################
#install python3 minimal IDE



#text mining tools
RUN \ 
python3 -m pip install tensorflow
RUN \ 
python3 -m pip install keras
RUN \
python3 -m pip install spacy
RUN \
python3  -m spacy download it_core_news_sm
RUN \
python3  -m spacy download de_core_news_sm
RUN \
python3  -m spacy download nl_core_news_sm
RUN \
python3  -m spacy download es_core_news_sm

###############################
### SoS : Script of Scripts ###
###############################
RUN \ 
python3 -m pip install sos
RUN \ 
python3 -m pip install sos-pbs

RUN \ 
python3 -m pip install sos-notebook

RUN \ 
python3 -m sos_notebook.install

#SoS languages
RUN \ 
python3 -m pip install sos-r
RUN \ 
python3 -m pip install sos-python
RUN \ 
python3 -m pip install  sos-julia feather-format  
RUN \ 
python3 -m pip install  sos-matlab
RUN \ 
python3 -m pip install sos-ruby
RUN \ 
python3 -m pip install sos-xeus-cling
#
RUN \ 
python3 -m pip install sos-essentials
RUN \ 
python3 -m pip install markdown-kernel
RUN \ 
python3 -m markdown_kernel.install

RUN \ 
python3 -m pip install bash_kernel
RUN \ 
python3 -m bash_kernel.install

################
### Ruby      ##
################
RUN apt-get update && apt-get install -yq libtool pkg-config autoconf zlib1g-dev libssl-dev && \
    apt-get clean && cd ~ && \
    git clone --depth=1 https://github.com/zeromq/libzmq && \
    git clone --depth=1 https://github.com/zeromq/czmq && \
    cd libzmq && ./autogen.sh && ./configure && make && make install && \
    cd ../czmq && ./autogen.sh && ./configure && make && make install && \
    cd .. && rm -rf ./libzmq ./czmq && \
    wget https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.1.tar.gz && tar xf ruby-2.4.1.tar.gz && cd ruby-2.4.1 && \
    ./configure && make && make install && \
    rm -rf ./ruby-2.4* && \
    gem install cztop iruby rbplotly daru daru_plotly && \
    rm -rf /var/lib/apt/lists/* && ldconfig

# iruby register --force



######################################################################################################################
####################################
###########  Anaconda    ###########
####################################
#Install Anaconda from container  continuumio/anaconda3 https://hub.docker.com/r/continuumio/anaconda3/dockerfile
#FROM continuumio/anaconda3 AS anaconda

# RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
#    libglib2.0-0 libxext6 libsm6 libxrender1 \
#    git mercurial subversion

# RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && \
#   /bin/bash ~/anaconda.sh -b -p /opt/conda && \
#    rm ~/anaconda.sh && \
#    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
#    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
#    echo "conda activate base" >> ~/.bashrc

# RUN apt-get install -y curl grep sed dpkg && \
#    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
#    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
#   dpkg -i tini.deb && \
#    rm tini.deb

# RUN export PATH=/opt/conda/bin:$PATH

#Install Miniconda manually
#echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
#RUN \
#    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/anaconda.sh && \
#    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
#    rm ~/anaconda.sh
    
# RUN export PATH=/opt/conda/bin:$PATH
 
#Add Conda kernel to Jupyter
# RUN  python -m ipykernel install --prefix=/usr/local/ --name "python3" 

######################################################################################################################
####################################
###########      R       ###########
####################################

ARG R_VERSION
ARG BUILD_DATE
ENV R_VERSION=${R_VERSION:-3.6.1} \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TERM=xterm

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash-completion \
    ca-certificates \
    file \
    fonts-texgyre \
    g++ \
    gfortran \
    gsfonts \
    libblas-dev \
    libbz2-1.0 \
    libcurl3 \
    curl
  

RUN cd tmp/ \
  ## Download source code
  && curl -O https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz \
  ## Extract source code
  && tar -xf R-${R_VERSION}.tar.gz \
  && cd R-${R_VERSION} \
  ## Set compiler flags
  && R_PAPERSIZE=letter \
    R_BATCHSAVE="--no-save --no-restore" \
    R_BROWSER=xdg-open \
    PAGER=/usr/bin/pager \
    PERL=/usr/bin/perl \
    R_UNZIPCMD=/usr/bin/unzip \
    R_ZIPCMD=/usr/bin/zip \
    R_PRINTCMD=/usr/bin/lpr \
    LIBnn=lib \
    AWK=/usr/bin/awk \
    CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
  ## Configure options
  ./configure --enable-R-shlib \
               --enable-memory-profiling \
               --with-readline \
               --with-blas \
               --with-tcltk \
               --disable-nls \
               --with-recommended-packages \
  ## Build and install
  && make \
  && make install \
  ## Add a default CRAN mirror
  && echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site \
  ## Add a library directory (for user-installed packages)


#update rlang and other R packages

RUN \ 
    R -e '.libPaths("/usr/lib/R/library")'
RUN \ 
    R -e 'install.packages(c("rlang"),lib="/usr/lib/R/library")'
RUN \ 
    R -e 'install.packages(c("Rcpp"),lib="/usr/lib/R/library")'
RUN \ 
    R -e 'update.packages(lib.loc = "/usr/lib/R/library", ask = FALSE, checkBuilt = TRUE)'
RUN \ 
    R -e 'install.packages(c("ps","processx","fs","usethis"),lib="/usr/lib/R/library")'
RUN \ 
    R -e 'update.packages(lib.loc = "/usr/lib/R/library", ask = FALSE, checkBuilt = TRUE)'

RUN \ 
    R -e 'install.packages(c("devtools"),lib="/usr/lib/R/library")'
RUN \ 
    R -e 'devtools::install_github("IRkernel/IRkernel",lib="/usr/lib/R/library")'

######################################################################################################################
####################################
###########  RStudio     ###########
####################################

#install gdebi-core (for deb command)
RUN \ 
    apt install gdebi-core

#update Rstudio
RUN \ 
    cd /projects/tmp
RUN \ 
    wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.2.1335-amd64.deb
RUN \ 
    mv rstudio-1.2.1335-amd64.deb rstudio.deb
RUN \ 
    dpkg -i rstudio.deb

RUN \ 
     apt --fix-broken install


######################################################################################################################
##################################
###########  Tensor flow #########
##################################

#install reticulate, tensorflow and keras

RUN \ 
     R -e 'install.packages(c("reticulate"),lib="/usr/lib/R/library")'
RUN \ 
     R -e 'reticulate::virtualenv_create("py3-virtualenv", python = "/usr/bin/python3")'
RUN \ 
     R -e 'reticulate::use_virtualenv("py3-virtualenv")'
RUN \ 
     R -e 'devtools::install_github("rstudio/tensorflow")'
RUN \ 
      R -e 'tensorflow::install_tensorflow(method ="virtualenv", envname = "py3-virtualenv")'
RUN \ 
     R -e 'devtools::install_github("rstudio/keras")'
RUN \ 
      R -e 'keras::install_keras(method ="virtualenv", envname = "py3-virtualenv")'

################
### Julia     ##
################
# install Julia packages in /opt/julia instead of $HOME
ENV JULIA_DEPOT_PATH=/opt/julia
ENV JULIA_PKGDIR=/opt/julia
ENV JULIA_VERSION=1.2.0

RUN mkdir /opt/julia-${JULIA_VERSION} && \
    cd /tmp && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    echo "926ced5dec5d726ed0d2919e849ff084a320882fb67ab048385849f9483afc47 *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - && \
    tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 && \
    rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz
RUN ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia

RUN julia -e 'import Pkg; Pkg.update()' && \
    (test $TEST_ONLY_BUILD || julia -e 'import Pkg; Pkg.add("HDF5")') && \
    julia -e "using Pkg; pkg\"add IJulia\"; pkg\"precompile\"" 
    
#julia
#using Pkg
#using Pkg
#Pkg.add("Feather")
#Pkg.add("DataFrames")
#Pkg.add("NamedArrays")
#ENV["JUPYTER"] = "/usr/bin/jupyter"
#Pkg.add("IJulia")

  
######################################################################################################################


########################
#Kernels' permissions ##
#######################

RUN  cd /usr/share/jupyter/ && \
chmod o+rx  -R kernels/ && \
chmod u+rx -R kernels/ && \
chmod g+rxw -R kernels/

RUN cd /usr/local/share/jupyter/ && \
chmod o+rxw  -R kernels/ && \
chmod u+rxw -R kernels/ && \
chmod g+rxw -R kernels/ 

#############################################
###permissions all libs (read and execute)###
#############################################
RUN cd /usr/local/ && \
chmod g+rwx -R lib/ && \
chmod o+rx -R lib/ && \
chmod u+rx -R lib/


####################################
#########  finalization  ###########
####################################

ENV DEBIAN_FRONTEND=newt




#Re-start CoCalc
CMD /root/run.py

