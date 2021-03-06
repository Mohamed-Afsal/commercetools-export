pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(daysToKeepStr: '40'))
        skipDefaultCheckout()
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
        ansiColor('xterm')
    }
    environment {
        acc_clientid = credentials('acc_clientid')
        acc_clientsecret = credentials('acc_clientsecret')
        dev_clientid = credentials('dev_clientid')
        dev_clientsecret = credentials('dev_clientsecret')
        prod_clientid = credentials('prod_clientid')
        prod_clientsecret = credentials('prod_clientsecret')
        TRY_COUNT = 5
    }

    parameters {
        string(name: 'BRANCH', defaultValue: 'master', description: 'Branch to build.')
        choice(name: 'Projectkey', choices: 'foodl-dev-36\nfoodl-prod-1\nfoodl_acc-1', description: 'Project Key to export')
        booleanParam(name: 'DEBUG', defaultValue: false, description: 'Whether or not to enable debug logging.')
        choice(name: 'DO_CLEAN', choices: 'true\nfalse\nauto\n', description: 'Whether or not to clean the workspace.')
        booleanParam(name: 'DO_CHECKOUT', defaultValue: true, description: 'Whether or not to perform a checkout.')
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
        stage('Checkout') {
            when { expression { params.DO_CHECKOUT } }
            steps {
                retry(env.TRY_COUNT) {
                    timeout(time: 150, unit: 'SECONDS') {
                       checkout scm
                    }
                }
            }
        }

        stage('Exporting Data type Product') {
            steps {
                sh "ct-docker/ct-productexport-docker.sh ${params.Projectkey}"
            }
        }
        stage('Exporting Data type Price') {
            steps {
                sh "ct-docker/ct-priceexport-docker.sh ${params.Projectkey}"
            }
        }
        stage('Exporting Data type inventory') {
            steps {
                sh "ct-docker/ct-inventoryexport-docker.sh ${params.Projectkey}"
            }
        }
        stage('Exporting Data type category') {
            steps {
                sh "ct-docker/ct-categoryexport-docker.sh ${params.Projectkey}"
            }
        }
    }
}
