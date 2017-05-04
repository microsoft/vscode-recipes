FROM node:6.5.0-slim

WORKDIR /server

COPY . /server
RUN npm install
RUN npm run build

CMD [ "npm", "start" ]
