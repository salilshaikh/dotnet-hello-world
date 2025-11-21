pipeline {

    agent any

    environment {
        IMAGE_NAME = "srdeveloper9081/hello-api"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        DOCKERHUB_USERNAME = credentials('dockerhub-username')
        DOCKERHUB_PASSWORD = credentials('dockerhub-token')
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/salilshaikh/dotnet-hello-world.git'
            }
        }

        stage('Restore Dependencies') {
            steps {
                sh 'dotnet restore hello-world-api/hello-world-api.csproj'
            }
        }

        stage('Build') {
            steps {
                sh 'dotnet build hello-world-api/hello-world-api.csproj -c Release --no-restore'
            }
        }

        stage('Publish') {
            steps {
                sh 'dotnet publish hello-world-api/hello-world-api.csproj -c Release -o out'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Login') {
            steps {
                sh """
                echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin
                """
            }
        }

        stage('Docker Push') {
            steps {
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
                sh "docker push ${IMAGE_NAME}:latest"
            }
        }

        stage('Local Deploy (No AWS)') {
            steps {
                sh """
                docker stop hello-api || true
                docker rm hello-api || true
                docker run -d -p 5000:5000 --name hello-api ${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
