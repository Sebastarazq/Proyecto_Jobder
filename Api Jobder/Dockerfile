FROM node:18
WORKDIR /apijobder
COPY package.json .
RUN npm install

COPY . .
CMD npm start