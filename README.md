# MLOps01

Use pylint for logic and bug detection.

Use flake8 for lightweight style checking.

Use black to auto-format the code before committing.

*******************************************************************************

Post-build actions:
*******************************************************************************
junit:

Parses pytest-report.xml and shows detailed test results (pass/fail, test duration, etc.) in Jenkins UI.

archiveArtifacts:

Saves pytest-report.xml as a build artifact, allowing you to download it or reference it later.

****************************************************************************************
Trivy (by Aqua Security) is a fast, easy-to-use vulnerability scanner.
*******************************************************************************************
This stage helps you:

Detect known vulnerabilities (CVEs) in source code, dependencies, and configs.

Prevent shipping insecure apps.

Automate security checks before deployment.

***********************************************************************************************
Use Cases for pytest
**********************************************************************************************
Unit testing	Test small units of code (e.g., functions, methods) in isolation.

Integration testing	Test how components interact (e.g., API + database).

Regression testing	Ensure that code changes don’t break existing features.

Test automation in CI/CD	Run tests automatically in pipelines like Jenkins, GitHub Actions, etc.

Fixtures & mocking	Manage setup/teardown logic for tests (e.g., database connection, test client).

******************************************************************************************************
Framework	      Test Client Used	           Main Test Tool
Flask	           app.test_client()	          pytest
FastAPI	         TestClient(app)	            pytest
******************************************************************************************************

FastAPI App + pytest Test Example
✅ FastAPI App (main.py)
****************************************************************************************************
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class AddRequest(BaseModel):
    a: int
    b: int

@app.post("/add")
def add(data: AddRequest):
    return {"result": data.a + data.b}

**********************************************************************************
FastAPI Test (test_main.py)
*********************************************************************************
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_add():
    response = client.post("/add", json={"a": 5, "b": 6})
    assert response.status_code == 200
    assert response.json()["result"] == 11    
*******************************************************************************
Flask App + pytest Test Example
✅ Flask App (app.py)
******************************************************************************
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/add', methods=['POST'])
def add():
    data = request.get_json()
    result = data['a'] + data['b']
    return jsonify({'result': result})
***************************************************************************************
Flask Test (test_app.py)
**************************************************************************************
import pytest
from app import app

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_add(client):
    response = client.post('/add', json={'a': 3, 'b': 4})
    json_data = response.get_json()
    assert response.status_code == 200
    assert json_data['result'] == 7
*********************************************************************************************
