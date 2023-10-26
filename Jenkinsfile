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
        stage('Deploy Docker Container') { 
            steps {
                script {
                    def remoteUser = 'ubuntu'
                    def remoteHost = 'ec2-3-72-21-112.eu-central-1.compute.amazonaws.com'
                    
                    def containerName = 'htmld'
                    def imageName = 'exidinus/php-apache:latest'
                    
                    def hostPort = 8088
                    def containerPort = 80 
                    
                    sshagent(credentials : ['SH_PRIVATE_KEY_TO_ENVIRONMENT']){
                        sh "ssh ${remoteUser}@${remoteHost} 'docker stop ${containerName} && docker rm ${containerName}' || true"
                        sh "ssh ${remoteUser}@${remoteHost} 'docker pull ${imageName}'"
                        sh "ssh ${remoteUser}@${remoteHost} 'docker images'"
                        sh "ssh ${remoteUser}@${remoteHost} 'docker run -d --name ${containerName} -p ${hostPort}:${containerPort} ${imageName}'"
                        sh "ssh ${remoteUser}@${remoteHost} 'docker ps'"
                        
                    }
                }
            }
        }
    }
}

