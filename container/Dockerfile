#Latest (release) version
FROM carlosantagiustina/cocalc
MAINTAINER Carlo R. M. A. Santagiustina (carlosantagiustina@gmail.com)
ENV DEBIAN_FRONTEND noninteractive
#ENV VERSION 0.1

# Remove microsoft proprietary tools with telemetry
#RUN rm /etc/apt/sources.list.d/vscode.list; 
#RUN rm /etc/apt/trusted.gpg.d/microsoft.gpg /microsoft.gpg


# Add useful repos
RUN \
    curl https://dbeaver.io/debs/dbeaver.gpg.key | gpg --dearmor > /etc/apt/trusted.gpg.d/dbeaver.gpg; \
    echo "deb https://dbeaver.io/debs/dbeaver-ce /" > /etc/apt/sources.list.d/dbeaver.list


# Install additional software
# RUN apt-get update
    
RUN \
    apt-get -y install \
        dbeaver-ce emacs gimp \
        scilab geogebra sqlitebrowser mysql-workbench \
        gmysqlcc default-jdk nano

#Install Anaconda
#echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
RUN \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh
    
RUN export PATH=/opt/conda/bin:$PATH
    
#Re-start CoCalc
#CMD /root/run.py
