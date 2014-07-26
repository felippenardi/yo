# DOCKER-VERSION 0.10.0
FROM ubuntu:13.10

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y wget

# Define volume that will be mounted
VOLUME ["/src"]

# Install Node
RUN   \
  wget -O - http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x64.tar.gz \
  | tar xzf - --strip-components=1 --exclude="README.md" --exclude="LICENSE" \
  --exclude="ChangeLog" -C "/usr/local"

# Make Docker use a nonroot user
RUN useradd -ms /bin/bash node
RUN chown -R node /src /opt /usr
ENV HOME /home/node
USER node

# Set the working directory
WORKDIR   /src

# Install NPM dependencies
RUN npm install -g yo
RUN npm install -g generator-angular

CMD /bin/bash
