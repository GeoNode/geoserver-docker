// Return Repository Name
String getRepoName() {
    return scm.getUserRemoteConfigs()[0].getUrl().tokenize('/')[3].split("\\.")[0]
}
pipeline {
    agent {
        kubernetes {
            defaultContainer 'kaniko'
            yaml """
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /kaniko/.docker
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: harbor-registry-1
          items:
            - key: .dockerconfigjson
              path: config.json
"""
        }
    }
    stages {
        stage('Checkout Repository') {
            steps {
                // Checkout Repository
                checkout scm
                // Get Repository Name
                script {
                    env.repoName = getRepoName()
                }
            }
            post {
                always {
                    //echo 'Build Started for '
                    notifyBuild('STARTED')
                }
            }
        }
        //stage('Run Code Tests') {
        //}
        stage('Build with Kaniko and push to Harbor') {
            steps {
                container(name: 'kaniko', shell: '/busybox/sh') {
                    withEnv(['PATH+EXTRA=/busybox']) {
                        sh '''#!/busybox/sh
            /kaniko/executor -f /Dockerfile -c `pwd` --destination=core.harbor.solspec.io:443/slpc/$repoName:$GIT_BRANCH
            '''
                    }
                }
            }
            post {
                success {
                    //echo 'Build Started for '
                    notifyBuild('SUCCESSFUL')
                }
                failure{
                    notifyBuild("FAILED")
                }
            }
        }
    }
}
def notifyBuild(String buildStatus = 'STARTED') {
    // build status of null means successful
    buildStatus = buildStatus ?: 'SUCCESSFUL'
    // Default values
    def colorName = 'RED'
    def colorCode = '#FF0000'
    def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
    def summary = "${subject} (${env.BUILD_URL})"
    def details = """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
    <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>"""
    // Override default values based on build status
    if (buildStatus == 'STARTED') {
        color = 'YELLOW'
        colorCode = '#FFFF00'
    } else if (buildStatus == 'SUCCESSFUL') {
        color = 'GREEN'
        colorCode = '#00FF00'
    } else {
        color = 'RED'
        colorCode = '#FF0000'
    }
    // Send notifications
    slackSend(color: colorCode, message: summary)
    //emailext(
    //        subject: subject,
    //        body: details,
    //        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
    //)
}
