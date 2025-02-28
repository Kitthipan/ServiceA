pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'kitthipan55/service-a'
        EC2_IP = '44.202.53.23'
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
                sshagent(['ec2-ssh-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ec2-user@${EC2_IP} <<EOF
                    docker stop service-a || true
                    docker rm service-a || true
                    docker pull ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    docker run -d --name service-a -p 8081:8081 ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    EOF
                    """
                }
            }
        }
    }
}
