pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(daysToKeepStr: '40'))
        skipDefaultCheckout()
        timestamps()
        timeout(time: 10, unit: 'MINUTES')
        ansiColor('xterm')
    }
    environment {
        clientid = credentials('client-id')
        clientsecret = credentials('client-secret')
    }

    parameters {
        string(name: 'BRANCH', defaultValue: 'master', description: 'Branch to build.')
        choice(name: 'Project-key', choices: 'foodl-dev-36\nfoodl-prod-1\nfoodl-acc-1', description: 'Project Key to export')
        booleanParam(name: 'DEBUG', defaultValue: false, description: 'Whether or not to enable debug logging.')
        choice(name: 'DO_CLEAN', choices: 'true\nfalse\nauto\n', description: 'Whether or not to clean the workspace.')
    }
    stages {

        stage('Pre') {
            parallel {
                stage('Version: bash') { steps { sh 'bash --version' } }
                stage('Version: docker') { steps { sh 'docker -v' } }
                stage('Version: git') { steps { sh 'git --version' } }
                stage('Version: curl') { steps { sh 'curl --version' } }
                stage('Determine Clean') {
                    steps {
                        script {
                            if (currentBuild.previousBuild == null) {
                                echo 'No previous build. Setting FIRST_BUILD_OF_DAY=true'
                                env.FIRST_BUILD_OF_DAY = 'true'
                            } else {
                                long previousBuildDays = currentBuild.previousBuild.startTimeInMillis / (1000 * 60 * 60 * 24)
                                long currentBuildDays = currentBuild.startTimeInMillis / (1000 * 60 * 60 * 24)
                                if (previousBuildDays != currentBuildDays) {
                                    echo 'Previous build was before today. Setting FIRST_BUILD_OF_DAY=true'
                                    env.FIRST_BUILD_OF_DAY = 'true'
                                } else {
                                    echo 'Previous build was today. Setting FIRST_BUILD_OF_DAY=false'
                                    env.FIRST_BUILD_OF_DAY = 'false'
                                  }
                              } 

                            env.DO_CLEAN = params.DO_CLEAN == 'true' || (params.DO_CLEAN != 'false' && env.FIRST_BUILD_OF_DAY == 'true')
                            echo "DO_CLEAN resolved to: ${env.DO_CLEAN}"
                        }
                    }
                }
                stage('Determine Debug Mode') {
                    steps {
                        script {
                            env.DEBUG = params.DEBUG ? 'yes' : 'no'
                        }
                    }
                }
            }
        }
        stage('exporting Data type Product') {
            steps {
                sh "./ct-docker/ct-productexport-docker.sh ${params.Project-key}"
            }
        }
        stage('exporting Data type Price') {
            steps {
                sh "./ct-docker/ct-priceexport-docker.sh ${params.Project-key}"
            }
        }
        stage('exporting Data type inventory') {
            steps {
                sh "./ct-docker/ct-inventoryexport-docker.sh ${params.Project-key}"
            }
        }
        stage('exporting Data type category') {
            steps {
                sh "./ct-docker/ct-categoryexport-docker.sh ${params.Project-key}"
            }
        }
    }
}
