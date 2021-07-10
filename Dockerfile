FROM node:10

COPY . /tmp/quest
WORKDIR /tmp/quest
# running as ec2-user
RUN chown -R 1000:1000 /tmp/quest
CMD npm install && npm start
