pipeline {
    agent any
    environment {
        DOCKER_CREDS  = credentials('docker-hub-credentials')
        KUBECONFIG_ID = credentials('kube-config-token')
    }
    stages {
        stage('Build & Push to Registry') {
            steps {
                script {
                    sh "docker login -u ${DOCKER_CREDS_USR} -p ${DOCKER_CREDS_PSW}"
                    sh "docker build -t ${DOCKER_CREDS_USR}/industrial-monitor:${BUILD_NUMBER} ."
                    sh "docker tag ${DOCKER_CREDS_USR}/industrial-monitor:${BUILD_NUMBER} ${DOCKER_CREDS_USR}/industrial-monitor:latest"
                    sh "docker push ${DOCKER_CREDS_USR}/industrial-monitor:${BUILD_NUMBER}"
                    sh "docker push ${DOCKER_CREDS_USR}/industrial-monitor:latest"
                }
            }
        }
        stage('Deploy Rollout out to Kubernetes') {
            steps {
                script {
                    // Update deployment manifest targets to inject dynamic build strings
                    sh "sed -i 's/DOCKERHUB_USERNAME/${DOCKER_CREDS_USR}/g' deployment.yaml"
                    
                    // Native Apply
                    sh "kubectl apply -f deployment.yaml --kubeconfig=${KUBECONFIG_ID}"
                    
                    // Monitor Rollout Status
                    sh "kubectl rollout status deployment/industrial-monitor --timeout=60s"
                }
            }
        }
    }
}
