pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'learndevops119/spring-crud-app'
        DOCKER_IMAGE_TAG = 'latest'
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
                    sh "docker login -u learndevops119 -p learndevops1"
                    // Build and push Docker image using Docker Hub credentials
                    
                        sh 'docker build -t learndevops119/spring-crud-app:latest .'
                        sh 'docker push learndevops119/spring-crud-app:latest'
                    
                }
            }
        }
    }
}
