pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    // Assuming you're using Maven to build a Spring Boot app
                    sh 'mvn clean package'
                }
            }
        }
        stage('Docker Build and Push') {
            steps {
                script {
                    // Commands to build and push Docker image
                    sh 'docker build -t yourusername/springboot-helloworld:latest .'
                    sh 'docker push yourusername/springboot-helloworld:latest'
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Commands to deploy to Kubernetes using kubectl or helm
                    sh 'kubectl apply -f k8s/'
                }
            }
        }
    }
    post {
        success {
            echo 'Deployment has been completed successfully.'
        }
    }
}
