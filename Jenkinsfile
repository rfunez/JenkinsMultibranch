pipeline{
    agent{
        label "docker-agent"
    }
    options {
        timestamps()
        parallelsAlwaysFailFast()
    }
    environment {
        BRANCH = "${env.BRANCH_NAME}"
        USERNAME = "rfunez"
        IMAGE_NAME = "alpine-debian"
        TAG = "${env.BUILD_NUMBER}"
        FULL_IMAGE = "${USERNAME}/${BRANCH}/${IMAGE_NAME}:${TAG}"
    }
    stages{
        stage('Check cache') {
            steps {
                echo "Checking cache usage in ${env.BRANCH}"
            }
        }
        stage('Check credentials') {
            steps {
                withCredentials([string(credentialsId: 'my-secret', variable: 'MY_TOKEN')]) {
                    sh '''
                       echo '$MY_TOKEN'
                       echo "$MY_TOKEN"
                       TOKEN=$(echo $MY_TOKEN | base64)
                       echo "Secret decrypted: $TOKEN"
                    '''
                }
            }
        }
        stage("Build"){
            steps {
                sh '''
                   echo "Building app"
                   echo "mvn clean install -P $BRANCH"
                '''
            }
        }
        stage("Test"){
            parallel {
                stage('Testing backend') {
                    steps {
                        sh '''
                          echo "Testing mvn in $BRANCH"
                          echo "mvn clean test -P $BRANCH"
                        '''
                    }
                }
                stage('Testing frontend') {
                    steps {
                        sh '''
                          echo "Testing backend in $BRANCH"
                          echo "npm check install"
                        '''
                    }
                }
            }
        }
        stage('Build image') {
            when {
                branch 'feature/docker'
            }
            steps {
                echo "BUILD NUMBER from Groovy :${env.BUILD_NUMBER}"
                sh '''
                  echo "Building image"
                  docker build -t "$FULL_IMAGE" .
                  docker image ls | grep "feature"
                '''
            }
        }
        stage("Push image") {
            steps {
                withCredentials([string(credentialsId: 'DockerHub_PAT', variable: 'DOCKERHUB_TOKEN')]) {
                    sh '''
                       echo "Pushung docker image"
                       if echo "$DOCKERHUB_TOKEN" | docker login -u $USERNAME --password-stdin;then
                          echo "Login success"
                          docker push $FULL_IMAGE
                       else
                          echo "Login failed"
                       fi
                    '''
                }
            }
        }
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo "Deploy in artifactory"
            }
            post {
                cleanup { cleanWs() }
            }
        }
    }
}