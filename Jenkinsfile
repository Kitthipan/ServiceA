pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'kitthipan55/service-a'
        IMAGE_TAG = '7'
        DOCKER_CREDENTIALS = 'dockerhub-credentials'
        GIT_CREDENTIALS = 'github-credentials'
        SSH_CREDENTIALS = 'ec2-ssh-key'
        EC2_HOST = '34.201.184.184'   // ใส่ Elastic IP ที่เพิ่งทำ
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scmGit(
                    branches: [[name: 'main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Kitthipan/ServiceA.git',
                        credentialsId: "${GIT_CREDENTIALS}"
                    ]]
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: "${DOCKER_CREDENTIALS}", url: "https://index.docker.io/v1/"]) {
                    sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
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
