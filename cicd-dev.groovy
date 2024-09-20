node('linux')
{
      stage ('Poll') {
            // Poll from upstream:
            checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    userRemoteConfigs: [[url: "https://github.com/curl/curl.git"]]])
            // Poll from local
            checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/zopencommunity/curlport.git']]])
      }

      stage('Build') {
                build job: 'Port-Pipeline', parameters: [string(name: 'PORT_GITHUB_REPO', value: 'https://github.com/zopencommunity/curlport.git'), string(name: 'PORT_DESCRIPTION', value: 'curl is used in command lines or scripts to transfer data.' ), string(name: 'BUILD_LINE', value: 'DEV')]
      }
}
