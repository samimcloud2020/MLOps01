# Use a Jenkins image as base image
FROM jenkins/jenkins:lts

# Install Docker
USER root
RUN apt-get update -y && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update -y && \
    apt-get install -y docker-ce-cli docker-ce
    
# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    groff \
    less \
    python3 \
    sudo \
    wget \
    lsb-release \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws


# Add Trivy GPG key and repo
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor -o /usr/share/keyrings/trivy.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" | \
    tee -a /etc/apt/sources.list.d/trivy.list

# Install Trivy
RUN apt-get update && apt-get install -y trivy && \
    rm -rf /var/lib/apt/lists/*



# Configure Docker to run as a non-root user
RUN usermod -aG docker jenkins

# Enable DinD
RUN mkdir -p /var/lib/docker
VOLUME /var/lib/docker
