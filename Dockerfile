# Create a base
#
FROM node:13.5-alpine AS base
ARG WORKDIR

# Install OS libs necessary by some packages during `npm i` (e.g.: node-canvas)
RUN apk add --update --no-cache \
  make \
  g++

WORKDIR ${WORKDIR}

COPY package*.json ${WORKDIR}/
COPY next.config.js ${WORKDIR}/

RUN npm config list --json \
  && npm ci \
  && npm cache clean --force

# CMD ls