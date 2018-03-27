FROM node:8-slim

# crafted and tuned by pierre@ozoux.net and sing.li@rocket.chat
MAINTAINER kellis5137@gmail.com

RUN groupadd -r rocketchat \
&&  useradd -r -g rocketchat rocketchat \
&&  mkdir -p /app/uploads \
&&  chown rocketchat.rocketchat /app/uploads

VOLUME /app/uploads

# gpg: key 4FD08014: public key "Rocket.Chat Buildmaster <buildmaster@rocket.chat>" imported
#RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0E163286C20D07B9787EBE9FD7F9D0414FD08104

ENV RC_VERSION 0.63.0

WORKDIR /app

COPY Rocket.Chat.tar.gz .
RUN  tar zxvf Rocket.Chat.tar.gz \
&&  rm Rocket.Chat.tar.gz \
&&  cd bundle/programs/server \
&&  npm install

USER rocketchat

WORKDIR /app/bundle

# needs a mongoinstance - defaults to container linking with alias 'db'
ENV DEPLOY_METHOD=docker-official \
    MONGO_URL=mongodb://db:27017/meteor \
    HOME=/tmp \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 3000

CMD ["node", "main.js"]
