FROM node:18
WORKDIR /Apijobder
COPY package.json .
RUN npm install

COPY . .
CMD ["sh", "-c", "./start.sh"]
