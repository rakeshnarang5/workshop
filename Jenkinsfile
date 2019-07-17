#!groovy

/*********************************************************************
***** Description :: This template is used to setup Pipeline *****
* *** Author :: Anupam Aggarwal (anupam.aggarwal@nagarro.com) *******
***** Date        :: 07/10/2017                                  *****
***** Revision    :: 1.0                                       *****
**********************************************************************/  

JAVA_HOME='JDK_1.8'
MAVEN_PATH='Maven3.6.1'
MAVEN_HOME='/opt/apache-maven-3.6.1/bin'
GIT_CREDS_ID='0f7aa54e-0259-438b-a1dd-3e0d686c0680'
GIT_URL='https://github.com/anupam0611/anu-deployment.git'
COMMAND='install'
SONAR_BRANCH='master'
SCM='GIT'
BUILDTOOL='MVN'
TARGET='main'
COMMENT='Pipeline has been successfully executed'
SONAR_INTEGRATION ='sonar_linux_slave' 
ARTIFACTORY_NAME='1508412728@1439723571527'
ARTIFACTORY_REPO='CI-Automation-JAVA-Pipeline'
BIND_PORT='8090:8080'
IMAGE_NAME='tomcat:alpine'
VOLUMES_STRING='devopssampleapplication.war'
SELENIUM_POM='DemoSampleApp_selenium'
SELENIUM_TARGETS='test'
SELENIUM_HOSTNAME='3.222.9.172'
SELENIUM_PORT='8090'
SELENIUM_CONTEXT='devopssampleapplication'
PERFORMANCE_MAVEN_TEST_RESULT='$PERFORMANCE_MAVEN_TEST_RESULT'
PERFORMANCE_POM='DemoSampleApp_Jmeter'
PERFORMANCE_TARGETS='verify -Pperformance'
PERFORMANCE_HOSTNAME='3.222.9.172'
PERFORMANCE_PORT='8090'
PERFORMANCE_CONTEXT='devopssampleapplication'
SELENIUM_FILENAME='emailable-report.html'
SELENIUM_REPORTNAME='Selenium Report'
PERFORMANCE_FILENAME='index.html'
PERFORMANCE_REPORTNAME='Performance report'
PORT = '8090'

def  funCodeCheckoutGit()
{ 
 echo  "\u2600 **********GIT Code Checkout Stage Begins*******"
checkout([$class: 'GitSCM', branches: [[name: "launchstation_java_pipeline"]], doGenerateSubmoduleConfigurations: false, extensions: [], gitTool: 'Default', submoduleCfg: [], userRemoteConfigs: [[credentialsId: "$GIT_CREDS_ID", url: "$GIT_URL"]]])
} 

def fununitTestMvn()
{
 echo  "\u2600 **********Running Unit test cases******************"
sh "${MAVEN_HOME}/mvn test"
}

def funCodeBuildMvn()
{ 
 echo  "\u2600 **********Build started******************" 
sh "${MAVEN_HOME}/mvn install"
stash includes: 'target/*.war', name: 'warfile'
} 

def funSonarAnalysisMVN()
{ 
 echo  "\u2600 **********Sonar analysis started*****************" 
} 
def funJiraIssueUpdate()
{
echo  "\u2600 **********JIRA ISSUE UPDATING*****************" 
jiraComment body: "Pipeline has been successfully executed", issueKey: "DEVOC-322"
}

def funartifactoryUpload()
{
echo  "\u2600 **********Uploading to artifactory*****************" 
}

def funDockerCreateImage()
{
		echo  "\u2600 **********CREATE DOCKER IMAGE*****************"
		sh 'sudo service docker start'
		sh 'sudo cp -p /var/lib/jenkins/.m2/repository/com/nagarro/devops-tools/devops/demosampleapplication/1.0.0-SNAPSHOT/demosampleapplication-1.0.0-SNAPSHOT.war $WORKSPACE/'
		sh returnStdout: true, script: '/bin/docker build -t anupam0611/anu-deployment:devopssampleapplication_${BUILD_NUMBER} -f $JENKINS_HOME/workspace/$JOB_NAME/Dockerfile .'
} 
def funDockerPushImage()
{
withCredentials([usernamePassword(credentialsId: 'DOCKER', passwordVariable: 'pass', usernameVariable: 'user')])
{
	echo  "\u2600 **********PUSH DOCKER IMAGE to DTR*****************"
	sh """docker login -u='$user' -p='$pass' """
    sh returnStdout: true, script: '/bin/docker push anupam0611/anu-deployment:devopssampleapplication_${BUILD_NUMBER}'
	}
	
}

def funDockerContainerStop(int p)
{
    echo  "\u2600 **********VERIFY IF RUNNING INSTANCE EXIST*****************"
	env.p=p;
    sh '''
    ContainerID=$(docker ps | grep $p | cut -d " " -f 1)
    if [  $ContainerID ]
    then
        docker stop $ContainerID
		docker rm -f $ContainerID
    fi
    '''
	unstash 'warfile'
}
def fundockercontRun()
{
	echo  "\u2600 **********STARTING DOCKER APPLICATION*****************"
	sh 'sudo docker run --name devopssampleapplication -d -p 12001:8080 anupam0611/anu-deployment:devopssampleapplication_${BUILD_NUMBER}'
	echo  "\u2600 ACCESS DEV ENVIRONMENT HERE: http://3.222.9.172:12001/demosampleapplication-1.0.0-SNAPSHOT "
}
def funSetupPG()
{
	echo  "\u2600 **********SETUP PROMETHEUS/GRAFANA*****************"
	funDockerContainerStop(7090)
	funDockerContainerStop(7091)
	funDockerContainerStop(7093)
	funDockerContainerStop(7000)
	sh returnStdout: true, script: 'cd $WORKSPACE/dockprom;sudo chmod -R 777 *;sudo /usr/local/bin/docker-compose down;sudo /usr/local/bin/docker-compose up -d'
	echo  "\u2600 ACCESS PROMETHEUS ENVIRONMENT HERE: http://3.222.9.172:7090 "
	echo  "\u2600 ACCESS PUSH GATEWAY ENVIRONMENT HERE: http://3.222.9.172:7091 "
	echo  "\u2600 ACCESS ALERT MANAGER ENVIRONMENT HERE: http://3.222.9.172:7093 "
	echo  "\u2600 ACCESS GRAFANA ENVIRONMENT HERE: http://3.222.9.172:7000 "
}
def funseleniumTest()
{
	echo  "\u2600 **********SELENIUM TESTING*****************"
}
def funperformanceTest() 
{
	echo  "\u2600 **********PERFORMANCE TESTING: JMETER*****************"
}
node("test")
{
stage 'GITCHEKOUT'
funCodeCheckoutGit()
stage 'MvnTest'
fununitTestMvn()
stage 'MvnBuild'
funCodeBuildMvn()
stage 'SonarAnalysis'
funSonarAnalysisMVN()
stage 'ArtifactoryUpload'
funartifactoryUpload()
stage 'CreateImage'
funDockerCreateImage()
stage 'Push to DockerHUb'
funDockerPushImage()
stage 'Docker Deployment'
funDockerContainerStop (12001)
fundockercontRun()
stage 'Monitoring'
funSetupPG()
stage 'Selenium Testing'
funseleniumTest()
stage 'Performance Test'
funperformanceTest()
}
