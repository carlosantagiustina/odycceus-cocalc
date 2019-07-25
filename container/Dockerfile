#Latest (release) version
FROM carlosantagiustina/cocalc
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

#Install Anaconda
#echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
RUN \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh
    
RUN export PATH=/opt/conda/bin:$PATH
 
ENV DEBIAN_FRONTEND=newt 

#Re-start CoCalc
#CMD /root/run.py
