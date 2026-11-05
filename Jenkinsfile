pipeline{
    agent{
        label "agent1"
    }
    options {
        timestamps()
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
                          mvn clean test -P $BRANCH
                        '''
                    }
                }
                stage('Testing frontend') {
                    steps {
                        sh '''
                          echo "Testing backend in $BRANCH"
                          npm check install
                        '''
                    }
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