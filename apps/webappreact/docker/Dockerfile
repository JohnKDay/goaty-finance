FROM ubuntu:18.04 as sealer

RUN apt-get update && apt-get upgrade -y && apt-get install -y gnupg wget nodejs npm

ARG REACT_APP_QUANDL_KEY
ENV REACT_APP_QUANDL_KEY ${REACT_APP_QUANDL_KEY}
ARG REACT_APP_WEB_SERVER
ENV REACT_APP_WEB_SERVER ${REACT_APP_WEB_SERVER}

ADD server /app/server
ADD public /app/public
ADD Procfile /app/Procfile
ADD package-lock.json /app/
ADD package.json /app/
ADD config /app/config
ADD src /app/src
ADD scripts /app/scripts
ADD node_modules /app/node_modules
WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

EXPOSE 3000
CMD ["npm", "start"]
