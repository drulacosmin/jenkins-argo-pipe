pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'drulacosmin/springboot-helloworld:latest'
        GIT_CREDENTIALS_ID = 'github-token' // ID of the GitHub personal access token credential in Jenkins
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials' // ID of the DockerHub credentials in Jenkins
    }
    stages {
        stage('Build') {
            steps {
                script {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        stage('Docker Build and Push') {
            steps {
                script {
                    docker.withRegistry('', env.DOCKER_CREDENTIALS_ID) {
                        def app = docker.build(env.DOCKER_IMAGE)
                        app.push()
                    }
                }
            }
        }
        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    withCredentials([string(credentialsId: env.GIT_CREDENTIALS_ID, variable: 'GIT_TOKEN')]) {
                        sh '''
                        git clone https://github.com/drulacosmin/jenkins-argo-pipe.git
                        cd jenkins-argo-pipe/k8s
                        sed -i 's|image: .*$|image: ${DOCKER_IMAGE}|' deployment.yaml
                        git config user.email "jenkins@example.com"
                        git config user.name "Jenkins"
                        git commit -am "Update image to ${DOCKER_IMAGE}"
                        git push https://${GIT_TOKEN}:x-oauth-basic@github.com/drulacosmin/jenkins-argo-pipe.git
                        '''
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'Build and deployment completed successfully.'
        }
        failure {
            echo 'Build, Docker push, or manifest update failed.'
        }
    }
}
