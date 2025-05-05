# Use a lightweight Python image
FROM python:slim

LABEL maintainer="Samim <samim@example.com>"

# Set environment variables to prevent Python from writing .pyc files & Ensure Python output is not buffered
# This reduces the docker image size further
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Copy only the requirements file 
COPY requirements.txt requirements.txt

# Install required packages but do not store cache files to reduce image size
RUN pip install --no-cache-dir -r requirements.txt


# Copy the application code
COPY test_model.py test_model.py
COPY Jenkinsfile-new Jenkinsfile-new
COPY app.py app.py
COPY train.py train.py
COPY model/iris_model.pkl iris_model.pkl
COPY templates/index.html index.html

# Train the model before running the application
RUN python train.py

# Expose the port that Flask will run on
EXPOSE 5000

# Command to run the app
CMD ["python", "app.py"]
