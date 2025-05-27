FROM --platform=arm64 node:22-bookworm

WORKDIR /app
COPY .. .

RUN apt-get update && apt-get install build-essential
RUN npm install
