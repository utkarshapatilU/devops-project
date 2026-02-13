pipeline {
    agent any
    environment {
        // Use Jenkins credentials (create these first in Jenkins)
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'ap-south-1' // Replace with your AWS region
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'feature-utkarsha',
                    url: 'https://github.com/utkarshapatilU/devops-project.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('Terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('Terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy App with Ansible') {
            steps {
                dir('Ansible') {
                    sh 'ansible-playbook -i inventory.ini playbook.yml'
                }
            }
        }
    }
}
