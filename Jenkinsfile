pipeline {
    agent any
    environment {
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
        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    // Assuming the Kubernetes manifests are in the `k8s` directory of the repository
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
            echo 'Build completed successfully. Kubernetes manifests updated.'
        }
        failure {
            echo 'Build or manifest update failed.'
        }
    }
}
