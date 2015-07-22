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

# Install utilitary to watch file changes and run command
RUN gem install filewatcher

# Define volume that will be mounted
VOLUME ["/src"]

# Install Node
RUN   \
  wget -O - http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x64.tar.gz \
  | tar xzf - --strip-components=1 --exclude="README.md" --exclude="LICENSE" \
  --exclude="ChangeLog" -C "/usr/local"

# Install Xvfb to run GUI applications on a virtual display
RUN apt-get install -y xvfb
# Download Xvfb config file for running GUI apps on a virtual :10 display
RUN wget https://gist.githubusercontent.com/felippenardi/0f22affde64629b46f64/raw/2b46205fab4ef3b7c295618010f47004c084127c/xvfb \
    -P /etc/init.d/
# Install packages required by Browsers to run on Xvfb
RUN apt-get install -y x11-xkb-utils xfonts-100dpi xfonts-75dpi
RUN apt-get install -y xfonts-scalable xserver-xorg-core
RUN apt-get install -y dbus-x1
# Install package that prevents Phantomjs from failing silently
RUN apt-get install -y libfontconfig1-dev
# Install browsers
RUN apt-get install -y chromium-browser firefox
# Make sure xvfb is executable and own by root,
# and the service definitions are updated
RUN chown root:root /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb
RUN update-rc.d  /etc/init.d/xvfb defaults

# Make Docker use a nonroot user
RUN useradd -ms /bin/bash node
RUN chown -R node:node /src /opt /usr
ENV HOME /home/node

# Install Heroku toolbelt
#RUN wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
RUN echo "deb http://toolbelt.heroku.com/ubuntu ./" > /etc/apt/sources.list.d/heroku.list
RUN wget -O- https://toolbelt.heroku.com/apt/release.key | apt-key add -
RUN apt-get update
RUN apt-get install -y heroku-toolbelt

USER node

# Set the working directory
WORKDIR   /src

# Install NPM dependencies
RUN npm install -g yo
RUN npm install -g redis
RUN npm install -g generator-angular
RUN npm install -g bower
RUN npm install -g grunt-cli
RUN npm install -g karma
RUN npm install -g grunt-karma
RUN npm install -g chromedriver
RUN npm install -g phantomjs
RUN npm install -g casperjs
RUN npm install -g karma-phantomjs-launcher
RUN npm install -g protractor
RUN npm install -g browserstack-webdriver
RUN npm install -g lineman
RUN npm install -g less
RUN npm install -g sass
RUN webdriver-manager update
RUN npm dedupe

CMD /bin/bash
