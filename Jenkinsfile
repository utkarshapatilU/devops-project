pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'feature-utkarsha',
                    url: 'https://github.com/utkarshapatilU/devops-project.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'jenkins-creds'
                ]]) {
                    dir('Terraform') {
                        sh 'rm -rf .terraform && rm -f .terraform.lock.hcl'
                        sh 'terraform init -upgrade'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

    }
}
