pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIAL_ID = 'mlops-jenkins-dockerhub-token'
        DOCKERHUB_REGISTRY = 'https://registry.hub.docker.com'
        DOCKERHUB_REPOSITORY = 'samimbsnl/mlops'
    }
    stages {
        stage('Clone Repository') {
            steps {
                // Clone Repository
                script {
                    echo 'Cloning GitHub Repository...'
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'mlops-git-token', url: 'https://github.com/iQuantC/MLOps01.git']])
                }
            }
        }
      stage('Lint Code') {
    steps {
        script {
            echo 'Linting Python Code...'
            sh '''
                # Clean broken sources
                sed -i '/download.docker.com/d' /etc/apt/sources.list /etc/apt/sources.list.d/*.list || true

                # Update and install required packages
                apt-get update
                apt-get install -y python3.11-venv python3-pip

                # Setup virtual environment
                python3 -m venv venv
                . venv/bin/activate

                # Install linting tools
                pip install --upgrade pip
                pip install -r requirements.txt pylint flake8 black

                # Run linters
                pylint app.py train.py --output=pylint-report.txt --exit-zero
                flake8 app.py train.py --ignore=E501,E302 --output-file=flake8-report.txt
                black app.py train.py
            '''
        }
    }
    post {
        always {
            archiveArtifacts artifacts: '**/*lint-report.txt', allowEmptyArchive: true
        }
    }
}



        
        stage('Test Code') {
            steps {
                // Pytest code
                script {
                    echo 'Testing Python Code...'
                    sh "pytest --junitxml=pytest-report.xml tests/"
                }
            }
            post {
                always {
                    junit 'pytest-report.xml'
                    archiveArtifacts artifacts: 'pytest-report.xml', allowEmptyArchive: true
            }
        }
    }
        stage('Trivy FS Scan') {
            steps {
                script {
                    echo 'Scanning Filesystem with Trivy...'
                    sh "trivy fs ./ --severity HIGH,CRITICAL --exit-code 0 --format table -o trivy-fs-report.html"
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'trivy-fs-report.html', allowEmptyArchive: true
                }
            }
        }

        
        stage('Build Docker Image') {
            steps {
                // Build Docker Image
                script {
                    echo 'Building Docker Image...'
                    dockerImage = docker.build("${DOCKERHUB_REPOSITORY}:latest") 
                }
            }
        }
        stage('Trivy Docker Image Scan') {
            steps {
                // Trivy Docker Image Scan
                script {
                    echo 'Scanning Docker Image with Trivy...'
                    sh "trivy image ${DOCKERHUB_REPOSITORY}:latest --format table -o trivy-image-report.html"
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                // Push Docker Image to DockerHub
                script {
                    echo 'Pushing Docker Image to DockerHub...'
                    docker.withRegistry("${DOCKERHUB_REGISTRY}", "${DOCKERHUB_CREDENTIAL_ID}"){
                        dockerImage.push('latest')
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                // Deploy Image to Amazon ECS
                script {
                    echo 'Deploying to production...'
                        sh "aws ecs update-service --cluster iquant-ecs --service iquant-ecs-svc --force-new-deployment"
                    }
                }
            }
        }
    }
