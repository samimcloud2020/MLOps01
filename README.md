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
