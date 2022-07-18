node('linux') 
{
        stage('Build') {
                build job: 'Port-Pipeline', parameters: [string(name: 'REPO', value: 'curlport'), string(name: 'DESCRIPTION', 'curlport' )]
        }
}
