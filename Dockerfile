FROM node:10

COPY . /tmp/quest
WORKDIR /tmp/quest
RUN chown -R 1000:1000 /tmp/quest
CMD npm install && npm start
