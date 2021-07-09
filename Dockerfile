FROM node:10

COPY . /tmp/quest
WORKDIR /tmp/quest
CMD npm install && npm start
