pipeline{
    agent{
        label "agent1"
    }
    stages{
        stage("Build"){
            steps{
                echo "========executing Build========"
            }
            post{
                always{
                    echo "========always========"
                    cleanup
                }
            }
        }
        stage("Test"){
            steps{
                echo "Running test"
            }
        }
    }
}