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
