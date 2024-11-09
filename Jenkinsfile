pipeline {
    agent {
        label 'java-slave'
    }
    environment {
        // APP_PORT = '3001'
        // JAR_NAME = 'hello-world-spring-1.0.0.jar'
        // DOCKER_IMAGE = 'spring-boot-app'

        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        DOCKER_IMAGE = 'nguyentutai12/spring-boot-app'
        CI = 'false'
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
        
        stage('Get Git Commit Hash') {
            steps {
                script {
                    def gitCommit = sh(script: 'git rev-parse --short=6 HEAD', returnStdout: true).trim()
                    DOCKER_TAG = gitCommit
                    echo "Git Commit Hash: ${gitCommit}"
                    echo "Git Commit Hash: ${DOCKER_TAG}"
                }
            }
        }

        // stage('Build') {
        //     steps {
        //         dir('spring-boot-app') {
        //             sh 'mvn clean package -DskipTests'
        //         }
        //     }
        // }
        
        // stage('Test') {
        //     steps {
        //         dir('spring-boot-app') {
        //             sh 'mvn test'
        //         }
        //     }
        // }

        stage('Docker Login') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com/', DOCKER_CREDENTIALS_ID) {
                        echo 'Logged into Docker Hub'
                    }
                }
            }
        }

        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
                // dir('spring-boot-app') {
                //     sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} --build-arg JAR_NAME=${JAR_NAME} .'
                // }
            }
        }

        stage('Push') {
            steps {
                // sh '''
                //     docker stop react-app || true
                //     docker rm react-app || true
                //     docker run -d --name react-app -p 3000:80 ${DOCKER_IMAGE}:${DOCKER_TAG}
                // '''
                script {
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        // stage('Deploy') {  
        //     steps {
        //         dir('spring-boot-app') {
        //             sh '''
        //                 # Stop and remove existing container if it exists
        //                 docker ps -q --filter "name=spring-boot-app" | grep -q . && docker stop spring-boot-app || true
        //                 docker ps -aq --filter "name=spring-boot-app" | grep -q . && docker rm spring-boot-app || true
                        
        //                 # Run the new container
        //                 docker run -d \
        //                     --name spring-boot-app \
        //                     -p ${APP_PORT}:${APP_PORT} \
        //                     ${DOCKER_IMAGE}:${DOCKER_TAG}
                            
        //                 # Wait for the application to start
        //                 sleep 10
                        
        //                 # Check if container is running
        //                 docker ps | grep spring-boot-app
                        
        //                 # Check application logs
        //                 docker logs spring-boot-app
        //             ''' 
        //         }

        //     }  
        // }  
    }
}