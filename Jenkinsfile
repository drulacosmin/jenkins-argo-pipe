pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials' // Jenkins credentials ID for Docker Hub
        DOCKER_IMAGE = 'drulacosmin/springboot-helloworld:latest'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    sh 'mvn clean package'
                }
            }
        }
        stage('Docker Build and Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        def app = docker.build(DOCKER_IMAGE)
                        app.push()
                    }
                }
            }
        }
        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    sh '''
                    git clone https://github.com/drulacosmin/jenkins-argo-pipe.git
                    cd jenkins-argo-pipe/k8s
                    sed -i 's|image: .*$|image: ${DOCKER_IMAGE}|' deployment.yaml
                    git config user.email "jenkins@example.com"
                    git config user.name "Jenkins"
                    git commit -am "Update image to ${DOCKER_IMAGE}"
                    git push origin main
                    '''
                }
            }
        }
    }
    post {
        success {
            echo 'Build and push completed successfully. Kubernetes manifests updated.'
        }
        failure {
            echo 'Build or push failed.'
        }
    }
}
