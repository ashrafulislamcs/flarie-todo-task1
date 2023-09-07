FROM node:14
WORKDIR /usr/src/app
RUN mkdir -p /etc/todos
RUN chmod -R 777 /etc/todos
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD [ "npm", "run", "dev" ]