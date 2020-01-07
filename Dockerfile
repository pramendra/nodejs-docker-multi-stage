# Create a base
#
FROM node:13.5-alpine AS base
ARG WORKDIR
ARG PORT

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

# create a dev build
FROM node:13.5-alpine AS basetest
ARG PORT
ARG WORKDIR
ENV NODE_ENV=development
ENV PATH=${WORKDIR}/node_modules/.bin:$PATH
WORKDIR ${WORKDIR}
COPY --from=base ${WORKDIR} .
RUN chown -R node:node .

RUN npx next telemetry disable
RUN npm install --only=development
USER node
EXPOSE ${PORT}
CMD npm run dev
