First of All, I have forked this repository https://github.com/mistryflarie/flarie-todo to my own account and keep it public https://github.com/ashrafulislamcs/flarie-todo-task1

Step1: Clone this repo https://github.com/ashrafulislamcs/flarie-todo-task1 and try to run this application manually
but I'm getting an error whenever I try to up the application manually, to check the error I found the exact cause 
then I created a "mkdir /etc/todos" and "sudo chown -R user:user todos/" where SQLIGT DB use this path
that was not created that's why I'm getting this error. Finally, the application is up Manually.

Step2: After running the application manually then dockerize the application with the below set of instructions.
#Dockerfile
FROM node:14
WORKDIR /usr/src/app
RUN mkdir -p /etc/todos
RUN chmod -R 777 /etc/todos
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD [ "npm", "run", "dev" ]

Step3: created a Docker Hub public repository.
https://hub.docker.com/repository/docker/ashrafulislamcs/flarie/general


Step4:
Step4: To build the Docker image and push it to Docker Hub I have used GitHub Action CI

name: Docker Image CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:

  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: docker login
      env:
        DOCKER_USER: ${{secrets.DOCKER_USER}}
        DOCKER_PASSWORD: ${{secrets.DOCKER_PASSWORD}}
      run: |
        docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
    - name: Build the Docker image
      run: docker build . --file Dockerfile --tag ashrafulislamcs/flarie:latest
    - name: Docker Push
      run: docker push ${{secrets.DOCKER_USER}}/flarie:latest
	  
Step5: Finally to Deploy the application in Kubernetes I have written down this simple manifest file
apiVersion: apps/v1
kind: Deployment
metadata:
    name: task-1
spec:
    replicas: 1
    selector:
        matchLabels:
            component: task-1
    template:
        metadata:
            labels:
                component: task-1
        spec:
            containers:
                - name: flarie-todo
                  image: ashrafulcse/flarie:latest
                  ports:
                    - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
    name: tasks-1-service
spec:
    type: NodePort
    selector:
        component: tasks-1
    ports:
        - port: 80
          targetPort: 80
          nodePort: 30567
		  
Although the requirement of the task was mentioned to use NodePort service 34567
but the Kubernetes NodePort range is 30000-32767 so I'm using 30567 instead of 34567.