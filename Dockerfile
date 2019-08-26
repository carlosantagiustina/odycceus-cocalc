#Development (may not be stable)
#version
FROM carlosantagiustina/cocalc AS cleanCocalc
MAINTAINER Carlo R. M. A. Santagiustina (carlosantagiustina@gmail.com)
ENV DEBIAN_FRONTEND noninteractive
#ENV VERSION 0.1

# Remove microsoft proprietary tools with telemetry
#RUN rm /etc/apt/sources.list.d/vscode.list; 
#RUN rm /etc/apt/trusted.gpg.d/microsoft.gpg /microsoft.gpg



# Install additional software
 RUN apt-get update --fix-missing

#Install ubuntu libraries
RUN \
    apt-get -y install \
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
        ruby-full \

######################################################################################################################
####################################
###########    Julia     ###########
####################################
RUN \
echo '\
ENV["JUPYTER"] = "/usr/local/bin/jupyter"; \
ENV["JULIA_PKGDIR"] = "/opt/julia/share/julia/site"; \
Pkg.init(); \
Pkg.add("IJulia");' | julia 



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
RUN \ 
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'

RUN \ 
    gpg --keyserver pgpkeys.mit.edu --recv-key 51716619E084DAB9  

RUN \ 
    gpg -a --export 51716619E084DAB9 | sudo apt-key add -

RUN \ 
    apt update

RUN \ 
    apt install r-base r-base-dev

RUN \ 
    apt install libxml2-dev


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

RUN \ 
    R -e 'install.packages(c("tidyverse","pillar","quanteda", "tm","formatR", "RMarkdown"),lib="/usr/lib/R/library")'
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


######################################################################################################################
####################################
#########  finalization  ###########
####################################
ENV DEBIAN_FRONTEND=newt 


#Re-start CoCalc
CMD /root/run.py
