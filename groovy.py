stage('Deploy Faulty Release & Auto-Rollback Management') {
    steps {
        script {
            try {
                echo "Deploying Faulty Release State..."
                sh "kubectl set image deployment/industrial-monitor dashboard=your-dockerhub-username/industrial-monitor:faulty-v2"
                
                // Track Rollout Status closely. 
                // Because Readiness Probes will fail, this step triggers a timeout error.
                sh "kubectl rollout status deployment/industrial-monitor --timeout=30s"
            } catch (Exception e) {
                echo "⚠️ ERROR IDENTIFIED: Rollout failed to reach healthy operations state parameters."
                echo "Initiating automated recovery rollback sequence..."
                
                // Execute rollback command instantly to restore operations
                sh "kubectl rollout undo deployment/industrial-monitor"
                sh "kubectl rollout status deployment/industrial-monitor"
                echo "✅ Core Infrastructure Successfully Restored to Prior Stable Release Engine Context."
            }
        }
    }
}
