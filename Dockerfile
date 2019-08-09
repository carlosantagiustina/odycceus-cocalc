#Latest (release) version
FROM carlosantagiustina/cocalc AS cleanCocalc
MAINTAINER Carlo R. M. A. Santagiustina (carlosantagiustina@gmail.com)
ENV DEBIAN_FRONTEND noninteractive
#ENV VERSION 0.1

# Remove microsoft proprietary tools with telemetry
#RUN rm /etc/apt/sources.list.d/vscode.list; 
#RUN rm /etc/apt/trusted.gpg.d/microsoft.gpg /microsoft.gpg



# Install additional software
 RUN apt-get update --fix-missing
    
RUN \
    apt-get -y install \
        emacs gimp \
        scilab geogebra sqlitebrowser mysql-workbench \
        gmysqlcc default-jdk nano




#Install Anaconda from container  continuumio/anaconda3 https://hub.docker.com/r/continuumio/anaconda3/dockerfile
#FROM continuumio/anaconda3 AS anaconda

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# RUN apt-get install -y curl grep sed dpkg && \
#    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
#    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
#   dpkg -i tini.deb && \
#    rm tini.deb

RUN export PATH=/opt/conda/bin:$PATH

#Install Miniconda manually
#echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
#RUN \
#    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/anaconda.sh && \
#    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
#    rm ~/anaconda.sh
    
# RUN export PATH=/opt/conda/bin:$PATH
 
#Add Conda kernel to Jupyter
RUN source activate sympy && \
    python -m ipykernel install --prefix=/usr/local/ --name "python3"&& \
    source deactivate 
    
    
    
ENV DEBIAN_FRONTEND=newt 


#Re-start CoCalc
#CMD /root/run.py
