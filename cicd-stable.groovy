node('linux')
{
        stage ('Poll') {
              checkout([
                      $class: 'GitSCM',
                      branches: [[name: '*/main']],
                      doGenerateSubmoduleConfigurations: false,
                      extensions: [],
                      userRemoteConfigs: [[url: 'https://github.com/zopencommunity/curlport.git']]])
        }

        stage('Build') {
                build job: 'Port-Pipeline', parameters: [string(name: 'PORT_GITHUB_REPO', value: 'https://github.com/zopencommunity/curlport.git'), string(name: 'PORT_DESCRIPTION', value: 'curl is used in command lines or scripts to transfer data.' ), string(name: 'BUILD_LINE', value: 'STABLE')]
        }
}
