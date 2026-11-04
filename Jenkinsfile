pipeline{
    agent{
        label "agent1"
    }
    stages{
        stage("Build"){
            steps{
                echo "========executing Build in lab========"
            }
            post{
                always{
                    echo "========always========"
                    cleanWs()
                }
            }
        }
        stage("Test"){
            steps{
                echo "Running test in lab"
            }
        }
    }
}