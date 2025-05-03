FROM jenkins/jenkins:lts

# Switch to root for installing system dependencies
USER root

# Add Debian Bullseye repository for openjdk-11-jdk
RUN echo "deb http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list.d/bullseye.list

# Install required system packages, including dependencies for Ansible
RUN apt-get update && \
    apt-get install -y lsb-release openjdk-11-jdk unzip python3-pip python3-dev libffi-dev libssl-dev python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/bullseye.list

# Create a virtual environment and install Ansible
RUN python3 --version && \
    python3 -m venv /opt/ansible && \
    /opt/ansible/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/ansible/bin/pip install --no-cache-dir ansible

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install Docker CLI
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
    https://download.docker.com/linux/debian/gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
    https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch back to the Jenkins user
USER jenkins

# Install Jenkins plugins
RUN jenkins-plugin-cli --plugins blueocean docker-workflow
