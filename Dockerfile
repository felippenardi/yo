# DOCKER-VERSION 0.10.0
FROM ubuntu:13.10

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y wget

# required for phantomjs
RUN apt-get install -y bzip2
RUN apt-get install -y freetype*
RUN apt-get install -y fontconfig

# ruby (sass/compass)
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ruby2.0
RUN gem install sass
RUN gem install compass

# Define volume that will be mounted
VOLUME ["/src"]

# Install Node
RUN   \
  cd /opt && \
  wget http://nodejs.org/dist/v0.10.28/node-v0.10.28-linux-x64.tar.gz && \
  tar -xzf node-v0.10.28-linux-x64.tar.gz && \
  mv node-v0.10.28-linux-x64 node && \
  cd /usr/local/bin && \
  ln -s /opt/node/bin/* . && \
  rm -f /opt/node-v0.10.28-linux-x64.tar.gz

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
RUN npm install -g karma-phantomjs-launcher
RUN npm dedupe

CMD /bin/bash
