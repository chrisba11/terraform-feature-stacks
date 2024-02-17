#!/bin/bash

set -u # Exit if there is an undefined variable

# Function to check command exit status
check_status() {
    if [ $1 -ne 0 ]; then
        echo "Error encountered: $2"
        exit 1
    fi
}

# Check for Python version and set the Python command
PYTHON_CMD=""
if python --version 2>&1 | grep -q "Python 3.11"; then
    PYTHON_CMD="python"
elif python3 --version 2>&1 | grep -q "Python 3.11"; then
    PYTHON_CMD="python3"
else
    echo "Python 3.11 is required."
    exit 1
fi

# Check if lambda name and stack name arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <lambda_name> <stack_name>"
    exit 1
fi

LAMBDA_NAME=$1
STACK_NAME=$2
SCRIPT_DIR=$(realpath $(dirname "$0"))
ROOT_DIR=$(dirname "$SCRIPT_DIR")
LAMBDA_DIR="${ROOT_DIR}/src/lambdas/${LAMBDA_NAME}"
ARTIFACT_DIR="${ROOT_DIR}/infra/tf/stacks/${STACK_NAME}/artifacts"

# Navigate to the lambda directory
if [ ! -d "$LAMBDA_DIR" ]; then
    echo "The directory ${LAMBDA_DIR} does not exist."
    exit 1
fi

cd "$LAMBDA_DIR/lambda_function"
check_status $? "Failed to change directory to lambda_function."

# Create a Python virtual environment and activate it
$PYTHON_CMD -m venv venv
check_status $? "Failed to create a virtual environment."

source venv/bin/activate
check_status $? "Failed to activate the virtual environment."

# Upgrade pip and install requirements
pip install --upgrade pip
check_status $? "Failed to upgrade pip."

pip install -r requirements.txt
check_status $? "Failed to install requirements."

# Deactivate the virtual environment
deactivate

# Go back up one level
cd ..

# Build with SAM and create the zip file
sam build
check_status $? "SAM build failed."

cd .aws-sam/build/LambdaFunction
check_status $? "Failed to change directory to SAM build output."

# Ensure the artifact directory exists
mkdir -p "${ARTIFACT_DIR}"
check_status $? "Failed to create the artifact directory: ${ARTIFACT_DIR}"

zip -r "${ARTIFACT_DIR}/${LAMBDA_NAME}.zip" . >/dev/null 2>&1
check_status $? "Zip operation failed."

echo "Lambda package for ${LAMBDA_NAME} is ready."
