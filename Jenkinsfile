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
                        // Clean old plugins/cache to avoid timeout
                        sh 'rm -rf .terraform && rm -f .terraform.lock.hcl'
                        sh 'terraform init -upgrade'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Deploy App with Ansible') {
            steps {
                dir('Ansible') {
                    script {
                        // Get EC2 public IP from Terraform outputs
                        def ec2_ip = sh(
                            script: "terraform -chdir=../Terraform output -raw ec2_public_ip",
                            returnStdout: true
                        ).trim()

                        // Generate inventory dynamically
                        sh "echo '[servers]' > inventory.ini"
                        sh "echo '${ec2_ip} ansible_user=ubuntu ansible_ssh_private_key_file=../Terraform/jenkins-key.pem' >> inventory.ini"

                        // Run Ansible playbook
                        sh 'ansible-playbook -i inventory.ini playbook.yml'
                    }
                }
            }
        }
    }
}
