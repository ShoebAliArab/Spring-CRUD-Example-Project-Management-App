pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'learndevops119/spring-crud-app'
        DOCKER_IMAGE_TAG = 'latest'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_HUB_USERNAME = 'learndevops119'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub
                    // Log in to Docker Hub using --password-stdin
                    sh "echo 'learndevops1' | docker login -u $DOCKER_HUB_USERNAME --password-stdin $DOCKER_REGISTRY"
                    // Build and push Docker image using Docker Hub credentials
                    
                    sh "docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG ."
                    sh "docker push $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"
                    
                }
            }
        }
    }
}
