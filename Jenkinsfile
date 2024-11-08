pipeline {
    agent {
        label 'java-slave'
    }
    environment {
        APP_PORT = '3001'
        JAR_NAME = 'hello-world-spring-1.0.0.jar'
        DOCKER_IMAGE = 'spring-boot-app'
        DOCKER_TAG = 'latest'
    }
    stages {
        stage('Verify Tools') {
            steps {
                sh '''
                    java -version
                    mvn -version
                '''
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                dir('spring-boot-app') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        
        stage('Test') {
            steps {
                dir('spring-boot-app') {
                    sh 'mvn test'
                }
            }
        }

        stage('Archive') {
            steps {
                dir('spring-boot-app') {
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('spring-boot-app') {
                    sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} --build-arg JAR_NAME=${JAR_NAME} .'
                }
            }
        }

        stage('Deploy') {  
            steps {
                dir('spring-boot-app') {
                    sh '''
                        # Stop and remove existing container if it exists
                        docker ps -q --filter "name=spring-boot-app" | grep -q . && docker stop spring-boot-app || true
                        docker ps -aq --filter "name=spring-boot-app" | grep -q . && docker rm spring-boot-app || true
                        
                        # Run the new container
                        docker run -d \
                            --name spring-boot-app \
                            -p ${APP_PORT}:${APP_PORT} \
                            ${DOCKER_IMAGE}:${DOCKER_TAG}
                            
                        # Wait for the application to start
                        sleep 10
                        
                        # Check if container is running
                        docker ps | grep spring-boot-app
                        
                        # Check application logs
                        docker logs spring-boot-app
                    ''' 
                }

            }  
        }  
    }
}