pipeline {
    agent any

    stages {
        stage('Terraform Init & Apply') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-access-key',
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir('infra') {
                        sh 'terraform init -input=false'
                        sh 'terraform apply -auto-approve -input=false'
                    }
                }
            }
        }

        stage('Upload Site to S3') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-access-key',
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        def bucket = sh(script: "terraform -chdir=infra output -raw bucket_name", returnStdout: true).trim()
                        sh "aws s3 sync site/ s3://${bucket} --delete"
                        def url = sh(script: "terraform -chdir=infra output -raw website_endpoint", returnStdout: true).trim()
                        echo "Website URL: ${url}"
                    }
                }
            }
        }
    }
}
