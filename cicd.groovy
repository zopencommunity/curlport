node('linux') 
{
        stage ('Poll') {
                checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [],
                        userRemoteConfigs: [[url: 'https://github.com/ZOSOpenTools/curlportport.git']]])
        }

        stage('Build') {
                build job: 'Port-Pipeline', parameters: [string(name: 'PORT_GITHUB_REPO', value: 'curlport'), string(name: 'PORT_DESCRIPTION', value: 'curl is used in command lines or scripts to transfer data.' )]
        }
}