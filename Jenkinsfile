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
                    credentialsId: 'AWS_credentials', 
                ]]) {
                    dir('Terraform') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
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
