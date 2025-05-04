pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIAL_ID = 'mlops-jenkins-dockerhub-token'
        DOCKERHUB_REGISTRY = 'https://registry.hub.docker.com'
        DOCKERHUB_REPOSITORY = 'samimbsnl/mlops'
        VENV_PATH = 'venv'
        DOCKER_IMAGE_TAG = 'latest'
    }

    stages {

        stage('Clone Repository') {
            steps {
                script {
                    echo '📥 Cloning GitHub Repository...'
                    checkout scmGit(
                        branches: [[name: '*/main']],
                        userRemoteConfigs: [[
                            credentialsId: 'mlops-git-token',
                            url: 'https://github.com/iQuantC/MLOps01.git'
                        ]]
                    )
                }
            }
        }

        stage('Setup Python Environment') {
            steps {
                script {
                    echo '🐍 Setting up Python environment...'
                    sh '''
                        apt-get update
                        apt-get install -y python3.11-venv python3-pip
                        python3 -m venv ${VENV_PATH}
                        . ${VENV_PATH}/bin/activate
                        pip install --upgrade pip
                        pip install -r requirements.txt pylint flake8 black pytest
                    '''
                }
            }
        }

        stage('Lint Code') {
            steps {
                script {
                    echo '🔍 Running linters...'
                    sh '''
                        . ${VENV_PATH}/bin/activate
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
                script {
                    echo '🧪 Running unit tests...'
                    sh '''
                        . ${VENV_PATH}/bin/activate
                        pytest --junitxml=pytest-report.xml tests/
                    '''
                }
            }
            post {
                always {
                    junit 'pytest-report.xml'
                }
            }
        }

        stage('Trivy FS Scan') {
            steps {
                script {
                    echo '🛡️ Scanning local project files with Trivy...'
                    sh '''
                        trivy fs ./ \
                          --severity HIGH,CRITICAL \
                          --exit-code 0 \
                          --format table \
                          -o trivy-fs-report.html || true
                    '''
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
                script {
                    echo '🐳 Building Docker image...'
                    sh '''
                        if ! command -v docker >/dev/null; then
                            echo "❌ Docker not installed in Jenkins."
                            exit 1
                        fi
                        echo "🧱 Validating Dockerfile..."
                        test -f Dockerfile || (echo "❌ Dockerfile not found!" && exit 1)

                        echo "🚀 Building Docker image..."
                        docker build -t ${DOCKERHUB_REPOSITORY}:${DOCKER_IMAGE_TAG} .
                    '''
                }
            }
        }

        stage('Trivy Docker Image Scan') {
            steps {
                script {
                    echo '🔎 Scanning Docker image with Trivy...'
                    sh '''
                        trivy image ${DOCKERHUB_REPOSITORY}:${DOCKER_IMAGE_TAG} \
                          --format table \
                          -o trivy-image-report.html || true
                    '''
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'trivy-image-report.html', allowEmptyArchive: true
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo '📤 Pushing Docker image to DockerHub...'
                    docker.withRegistry("${DOCKERHUB_REGISTRY}", "${DOCKERHUB_CREDENTIAL_ID}") {
                        docker.image("${DOCKERHUB_REPOSITORY}:${DOCKER_IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                script {
                    echo '🚀 Deploying to Amazon ECS...'
                    sh '''
                        aws ecs update-service \
                          --cluster iquant-ecs \
                          --service iquant-ecs-svc \
                          --force-new-deployment
                    '''
                }
            }
        }
    }

    post {
        failure {
            echo "❌ Pipeline failed. Please check the logs for more info."
        }
        success {
            echo "✅ Pipeline executed successfully."
        }
    }
}
