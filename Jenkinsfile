pipeline{
    agent{
        label "docker-agent"
        dockerfile {
            filename 'Dockerfile'
        }
    }
    options {
        timestamps()
        parallelsAlwaysFailFast()
    }
    environment {
        BRANCH = "${BRANCH_NAME}"
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
                       echo $MY_TOKEN | sed 's/./& /g'
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
            environment {
                IMAGE_NAME = "alpine-debian"
            }
            steps {
                sh '''
                  echo "Building image"
                  docker build -t "$IMAGE_NAME":1.0.0 .
                  docker image ls
                '''
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