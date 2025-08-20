pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {
        stage('Terraform Init & Apply') {
            steps {
                withAWS(credentials: 'aws-access-key', region: "${AWS_DEFAULT_REGION}") {
                    dir('infra') {
                        sh 'terraform init -input=false'
                        sh 'terraform apply -auto-approve -input=false'
                    }
                }
            }
        }

        stage('Upload Site to S3') {
            steps {
                withAWS(credentials: 'aws-access-key', region: "${AWS_DEFAULT_REGION}") {
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
