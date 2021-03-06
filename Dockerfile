FROM mhart/alpine-node:14 AS build

ENV NODE_PATH=/node_modules
ENV PATH=$PATH:/node_modules/.bin

RUN apk --no-cache update && apk --no-cache add bash

WORKDIR /app
ADD . /app