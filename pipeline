pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'GITHUB_TOKEN')]) {
                        checkout([$class: 'GitSCM',
                            branches: [[name: 'main']],
                            userRemoteConfigs: [[url: "https://${GITHUB_TOKEN}@github.com/exidinus/devops_learning_3.git"]]])
                    }
                }
            }   
        }
        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build('exidinus/php-apache:latest')
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'DOCKER_REGISTRY_TOKEN', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_TOKEN')]) {
                        sh "docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_TOKEN"
                        sh "docker push exidinus/php-apache:latest"
                        sh "docker logout"
                        }
                }
            }
        }
        stage('Cleanup') {
            steps {
                script {
                    sh "docker rmi exidinus/php-apache:latest"
                }
            }
        }
    }
}

