node('linux') 
{
        stage('Build') {
                build job: 'Port-Pipeline', parameters: [string(name: 'REPO', value: 'curlport'), string(name: 'DESCRIPTION', 'curl is used in command lines or scripts to transfer data.' )]
        }
}
