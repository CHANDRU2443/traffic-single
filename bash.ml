# 1. Build Image Locally
docker build -t your-dockerhub-username/industrial-monitor:latest .

# 2. Local Container Runtime Instantiation
docker run -d -p 8080:80 --name local_equipment_check your-dockerhub-username/industrial-monitor:latest

# 3. Execution Verification via CLI Target
curl -I http://localhost:8080

# 4. Exporting Local Configuration to Hub Hub Registry
docker login -u your-dockerhub-username
docker push your-dockerhub-username/industrial-monitor:latest
