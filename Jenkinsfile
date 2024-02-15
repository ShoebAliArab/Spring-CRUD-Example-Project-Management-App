pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
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
                    // Build and push Docker image using Docker Hub credentials
                    withCredentials([string(credentialsId: DOCKER_HUB_CREDENTIALS, variable: 'DOCKER_HUB_CREDENTIALS')]) {
                        sh 'docker build -t learndevops119/spring-crud-app:latest .'
                        sh 'docker push learndevops119/spring-crud-app:latest'
                    }
                }
            }
        }
    }
}
