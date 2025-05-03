FROM jenkins/jenkins:lts

USER root

# Install Docker CLI
RUN apt-get update -y && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list && \
    apt-get update -y && \
    apt-get install -y docker-ce-cli

# Install other dependencies
RUN apt-get install -y \
    unzip \
    groff \
    less \
    python3 \
    sudo \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install Trivy
RUN mkdir -p /usr/share/keyrings && \
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor -o /usr/share/keyrings/trivy.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/trivy.list && \
    apt-get update && apt-get install -y trivy && \
    rm -rf /var/lib/apt/lists/*

# ✅ Fix: Create docker group manually before adding user
RUN groupadd docker && usermod -aG docker jenkins

# Optional: Enable DinD
RUN mkdir -p /var/lib/docker
VOLUME /var/lib/docker

