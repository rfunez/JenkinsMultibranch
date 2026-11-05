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
                   echo "mvn clean install -P $BRANCH
                '''
            }
        }
        stage("Test"){
            parallel {
                stage('Testing backend') {
                    steps {
                        echo "Testing mvn in ${env.BRANCH}"
                    }
                }
                stage('Testing frontend') {
                    steps {
                        echo "Testing backend in ${env.BRANCH}"
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