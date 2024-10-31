FROM node:20 AS dev
COPY . /app
WORKDIR /app

CMD while sleep 1000; do :; done
