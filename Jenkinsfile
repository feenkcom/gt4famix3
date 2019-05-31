pipeline {
    agent any
    
    options { 
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds() 
    }
    stages {
        stage('Clean Workspace') {
            steps {
                sh 'git clean -fdx'
                sh 'chmod +x scripts/*.sh'
                slackSend (color: '#FFFF00', message: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
            }
        }
        stage('Load latest master commit') {
            steps {
                sh 'git clean -f -d'
                sh 'rm -rf pharo-local'
                sh 'scripts/load.sh'
            }
        }

        stage('Run examples') {
            steps {
                sh 'scripts/createBaseImage.sh'
            }
        }

        stage('Prepare deploy packages') {
            when {
              expression {
                (currentBuild.result == null || currentBuild.result == 'SUCCESS')
              }
            }
            steps {
                sh 'scripts/package.sh'
            }
        }
    }
    post {
        success {
            slackSend (color: '#00FF00', message: "Successful: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }

        failure {
            slackSend (color: '#FF0000', message: "Failed: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }

        regression {
            slackSend (color: '#FF0000', message: "Regression: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }

        fixed {
            slackSend (color: '#00FF00', message: "Fixed: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }

        unstable {
            slackSend (color: '#FF0000', message: "Unstable: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
    }
}