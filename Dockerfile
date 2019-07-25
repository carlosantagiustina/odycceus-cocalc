#Development version
FROM carlosantagiustina/cocalc
MAINTAINER Carlo R. M. A. Santagiustina (carlosantagiustina@gmail.com)
ENV DEBIAN_FRONTEND noninteractive
ENV VERSION 0.01

# Remove microsoft proprietary tools with telemetry
RUN rm /etc/apt/sources.list.d/vscode.list; rm /etc/apt/trusted.gpg.d/microsoft.gpg /microsoft.gpg; apt-get -y remove code

# Add useful repos
RUN \
    curl https://dbeaver.io/debs/dbeaver.gpg.key | gpg --dearmor > /etc/apt/trusted.gpg.d/dbeaver.gpg; \
    echo "deb https://dbeaver.io/debs/dbeaver-ce /" > /etc/apt/sources.list.d/dbeaver.list

# Update everything
RUN apt-get update;apt-get -y install apt-transport-https; apt-get -y dist-upgrade ; rm -rf /var/lib/apt/lists/*

# Install additional software
RUN apt-get update; \
    apt-get -y install \
        dbeaver-ce emacs gimp \
        scilab geogebra sqlitebrowser mysql-workbench \
        gmysqlcc default-jdk nano

#Re-start CoCalc

CMD /root/run.py

EXPOSE 80 443
