pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'kitthipan55/service-a'
        EC2_IP = '34.201.184.184'
    }
    stages {
        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
            }
        }
        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-credentials', url: '']) {
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                sshagent(credentials: ["${SSH_CREDENTIALS}"]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} <<EOF
                    docker pull ${DOCKER_IMAGE}:${IMAGE_TAG}
                    docker stop service-a || true
                    docker rm service-a || true
                    docker run -d --name service-a -p 8080:8080 ${DOCKER_IMAGE}:${IMAGE_TAG}
                    EOF
                    """
                }
            }
        }
    }
}
