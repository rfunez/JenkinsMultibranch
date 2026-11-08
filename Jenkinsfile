pipeline{
    agent{
        label "docker-agent"
    }
    options {
        timestamps()
        parallelsAlwaysFailFast()
    }
    environment {
        BRANCH = "${env.BRANCH_NAME.replace('/','-')}"
        USERNAME = "rfunez"
        IMAGE_NAME = "alpine-debian"
        TAG = "${BRANCH}-${env.BUILD_NUMBER}"
        FULL_IMAGE = "${USERNAME}/${IMAGE_NAME}:${TAG}"
    }
    stages{
        stage('Check cache') {
            steps {
                echo "Checking cache usage in ${env.BRANCH}"
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
            steps {
                echo "BUILD NUMBER from Groovy :${env.BUILD_NUMBER}"
                sh '''
                  echo "Building image"
                  docker build -t "$FULL_IMAGE" .
                  docker image ls | grep $BRANCH
                '''
            }
        }
        stage("Push image") {
            when {
                branch 'main'
            }
            steps {
                withCredentials([string(credentialsId: 'DockerHub_PAT', variable: 'DOCKERHUB_TOKEN')]) {
                    sh '''
                       echo "Pushung docker image"
                       if echo "$DOCKERHUB_TOKEN" | docker login -u $USERNAME --password-stdin;then
                          echo "Login success"
                          docker push $FULL_IMAGE
                       else
                          echo 'Login failed'
                          exit 1
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