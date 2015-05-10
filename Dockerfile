# DOCKER-VERSION 0.10.0
FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y sudo curl openssh-client ruby git wget build-essential \
    subversion postgresql postgresql-contrib

# required for phantomjs
RUN apt-get install -y bzip2
RUN apt-get install -y freetype*
RUN apt-get install -y fontconfig

# required for selenium webdriver-manage
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get update && apt-get clean
RUN apt-get install -y oracle-java8-installer

# Define volume that will be mounted
VOLUME ["/src"]

# Install Node
RUN   \
  wget -O - http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x64.tar.gz \
  | tar xzf - --strip-components=1 --exclude="README.md" --exclude="LICENSE" \
  --exclude="ChangeLog" -C "/usr/local"

# Make Docker use a nonroot user
RUN useradd -ms /bin/bash node
RUN chown -R node:node /src /opt /usr
ENV HOME /home/node
USER node

# Set the working directory
WORKDIR   /src

# Install NPM dependencies
RUN npm install -g yo
RUN npm install -g generator-angular
RUN npm install -g bower
RUN npm install -g grunt-cli
RUN npm install -g karma
RUN npm install -g grunt-karma
RUN npm install -g phantomjs
RUN npm install -g casperjs
RUN npm install -g karma-phantomjs-launcher
RUN npm install -g protractor
RUN npm install -g browserstack-webdriver
RUN npm install -g lineman
RUN webdriver-manager update
RUN npm dedupe

CMD /bin/bash
