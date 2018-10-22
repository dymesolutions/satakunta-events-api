#!/bin/bash

./gradlew clean build
docker-compose -f docker-compose.yml build
