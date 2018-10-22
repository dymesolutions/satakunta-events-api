FROM openjdk:8-jre-alpine

RUN apk update && apk upgrade

WORKDIR /linkedevents/app
COPY ./build/libs/linkedevents-api-*.jar /linkedevents/app/linkedevents-api.jar
