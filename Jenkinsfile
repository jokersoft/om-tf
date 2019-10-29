pipeline {

    /**
     * Agent defines where this pipeline should be executed.
     */
    agent {
        node { label "docker-builder" }
    }

    /**
     * Define Jenkins build general options, usually this parameters
     * are regarding the Jenkins date format, jenkins output, enable/disable
     * colored formating among other supported build configuration.
     */
    options {
        timestamps()
        disableConcurrentBuilds()
        ansiColor("xterm")
        timeout(time: 1, unit: "HOURS")
        buildDiscarder(logRotator(numToKeepStr: "30"))
    }

    /**
     * Define the parameters that will be exported and environment variable during the build
     *
     * Note: It's important to understand a current limitation from the Jenkins Pipeline, changes
     * that requires changes on the Jenkins UI job like parameters do not appear until you run the
     * pipeline for the first time with the target code. For example, you will only the parameters
     * after running the pipeline for the first time and jenkins ran through the pipeline definitions.
     */
    parameters {

        // defines whether to run terraform apply or not.
        booleanParam(
            name: 'RUN_TERRAFORM_APPLY',
            defaultValue: true,
            description: 'Enable/Disable the terraform plan execution'
        ) 
    }

    /**
     * Define global environment variables that is going to be used during the build
     */
    environment {
        // AWS exporting variables
        AWS_DEFAULT_REGION = "eu-west-1"

        // return only the first 7 characters from git
        SHORT_GIT_COMMIT = "${env.GIT_COMMIT.trim().take(7)}"

        // define the ECR repository URL for this job
        DOCKER_REPO_BASE_URL = "???.dkr.ecr.eu-west-1.amazonaws.com"
        DOCKER_REPO_NAME = "workshop/${JOB_BASE_NAME}"
        DOCKER_REPO_URL = "${DOCKER_REPO_BASE_URL}/${DOCKER_REPO_NAME}"
    }

    /**
     * Defines all the stages that this pipeline will be executed during the pipeline.
     */
    stages {

        /**
         * Running and defining 
         */
        stage("Setup") {
            steps {
                echo "TODO: Define setup steps to prepare the build"
                sleep 5

                sh 'env' // display current environment variable.
            }
        }

        /**
         * Leverage docker build and Dockerfiles to compile that GO Binary package.
         */
        stage("Build: Go Binary") {
            steps {

                // running docker build only on the compile stage
                sh "docker build --target=compile ."
            }
        }

        /**
         * TODO: Add real test here.
         */
        stage("Test") {
            steps {
                echo "TODO: Define the test to be executed on this project"
                sleep 5
            }
        }

        /**
         * Build the docker final image using the docker build and Dockerfiles instruction.
         *
         * Note that stage will call the docker build command again similar to the binary compilation
         * however this will execute all the stages on the dockerfile. Docker cache will be used during the
         * final image build and the `compile` state will not be executed again.
         */
        stage("Build: Docker Image") {
            steps {
                sh "docker build . -t ${env.DOCKER_REPO_URL}:latest -t ${env.DOCKER_REPO_URL}:${env.SHORT_GIT_COMMIT}"
            }
        }

        /**
         * Craeting a ECR repository in case is doesn't exists
         */
        stage("Push Docker Image") {
            steps {

                // Create ECR repository in case the repository doesn't exists
                sh """
                    aws ecr describe-repositories --repository-name ${env.DOCKER_REPO_NAME} ||
                        aws ecr create-repository --repository-name ${env.DOCKER_REPO_NAME}
                """

                // Push docker built image to the ECR repository
                sh "docker push ${env.DOCKER_REPO_URL}:latest"
                sh "docker push ${env.DOCKER_REPO_URL}:${env.SHORT_GIT_COMMIT}"
            }
        }

        /**
         * Initialize terraform and execute a terraform plan saving into a file to
         * used later on the terraform apply stage.
         */
        stage("Terraform Plan") {
            steps {
                echo "Running terraform init, and plan"
                dir ('./terraform') {
                    sh "rm -rf .terraform deploy.plan"

                    sh "terraform init"
                    sh "terraform plan -out=deploy.plan"
                }
            }
        }

        /**
         * Execute the terraform apply during the build
         *
         * Note that this pipeline has a stage condition configuration, which determines
         * whether or not to run this build based on a parameters. This enables the ability
         * to run only terraform plan in before actually running in Production.
         */
        stage("Terraform Apply") {
            when {
                environment name: "RUN_TERRAFORM_APPLY", value: "true"
            }

            steps {
                echo "Running terraform apply to perform real changes"
                dir ('./terraform') {
                    sh "terraform apply deploy.plan"
                }
            }
        }
    }
}
