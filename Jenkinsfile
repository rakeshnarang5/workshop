#!groovy

/*********************************************************************
***** Description :: This template is used to setup Pipeline *****
* *** Author :: Ravindra Mittal ( ravindra.mittal@nagarro.com) *******
***** Date        :: 08/23/2017                                  *****
***** Revision    :: 1.0                                       *****
**********************************************************************/  

LABEL_EXPR='Linux_Slave'
JAVA_HOME='JDK_1.8'
MAVEN_PATH='Maven3.2.1'
ANT_PATH='ant'
GIT_CREDS_ID=''
GIT_REPO=''
GIT_BRANCH=''
COMMAND='install'
SONAR_BRANCH='master'
SONAR_URL='http://10.127.128.32:9000'
DEFAULT_RECIPIENTS='dsc.admin@nagarro.com'
SVN_REPO='http://svn.nagarro.local:8080/svn/DevOps/codebase/sampleprojects/java/branches/launchstation_java_pipeline'
SVN_CREDS_ID='dsc-admin'
SCM='SVN'
BUILDTOOL='MVN'
TARGET='main'
COMMENT='Pipeline has been successfully executed'
ISSUE_ID='DEVOC-322'
JIRA_SITE='jira-nagarro'
SONAR_INTEGRATION ='sonar_linux_slave' 
ARTIFACTORY_NAME='1508412728@1439723571527'
ARTIFACTORY_REPO='CI-Automation-JAVA-Pipeline'
BIND_PORT='8090:8080'
CLOUD_URL='dtr.nagarro.com:443'
CLOUD_NAME='Docker.host.74'
IMAGE_NAME='tomcat:alpine'
VOLUMES_STRING='devopssampleapplication.war'
SELENIUM_POM='DemoSampleApp_selenium'
SELENIUM_TARGETS='test'
SELENIUM_HOSTNAME='10.127.127.160'
SELENIUM_PORT='8090'
SELENIUM_CONTEXT='devopssampleapplication'
PERFORMANCE_MAVEN_TEST_RESULT='$PERFORMANCE_MAVEN_TEST_RESULT'
PERFORMANCE_POM='DemoSampleApp_Jmeter'
PERFORMANCE_TARGETS='verify -Pperformance'
PERFORMANCE_HOSTNAME='10.127.127.160'
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
checkout([$class: 'GitSCM', branches: [[name: "*/"]], doGenerateSubmoduleConfigurations: false, extensions: [], gitTool: 'Default', submoduleCfg: [], userRemoteConfigs: [[credentialsId: "", url: "$GIT_URL"]]])
} 

def  funCodeCheckoutSvn()
{
 echo  "\u2600 **********SVN Code Checkout Stage Begins*******"
checkout([$class: 'SubversionSCM', additionalCredentials: [], excludedCommitMessages: '', excludedRegions: '', excludedRevprop: '', excludedUsers: '', filterChangelog: false, ignoreDirPropChanges: false, includedRegions: '', locations: [[credentialsId: "dsc-admin", depthOption: 'infinity', ignoreExternalsOption: true, local: '.', remote: "http://svn.nagarro.local:8080/svn/DevOps/codebase/sampleprojects/java/branches/launchstation_java_pipeline"]], workspaceUpdater: [$class: 'UpdateUpdater']])
}

def fununitTestMvn()
{
 echo  "\u2600 **********Running Unit test cases******************"
sh "${MAVEN_HOME}/bin/mvn test"
}

def funCodeBuildMvn()
{ 
 echo  "\u2600 **********Build started******************" 
sh "${MAVEN_HOME}/bin/mvn install"
stash includes: 'target/*.war', name: 'warfile'
} 

def funCodeBuildAnt()
{
 echo  "\u2600 **********Build started******************" 
sh "${ANT_HOME}/bin/ant main" 
}

def funSonarAnalysisMVN()
{ 
 echo  "\u2600 **********Sonar analysis started*****************" 
withSonarQubeEnv("sonar_linux_slave") {
     sh "${MAVEN_HOME}/bin/mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar"
    }
} 
def funJiraIssueUpdate()
{
echo  "\u2600 **********JIRA ISSUE UPDATING*****************" 
jiraComment body: "Pipeline has been successfully executed", issueKey: "DEVOC-322"
}

def funartifactoryUpload()
{
echo  "\u2600 **********Uploading to artifactory*****************" 
def server = Artifactory.server '1508412728@1439723571527'
     def buildInfo = Artifactory.newBuildInfo()
      buildInfo.env.capture = true
      buildInfo.env.collect()
      def rtMaven = Artifactory.newMavenBuild()
      rtMaven.tool = 'Maven3.2.1'
      rtMaven.deployer releaseRepo:'CI-Automation-JAVA-Pipeline', snapshotRepo:'CI-Automation-JAVA-Pipeline', server: server
    rtMaven.run pom: 'pom.xml', goals: 'clean install', buildInfo: buildInfo
    buildInfo.retention maxBuilds: 10, maxDays: 7, deleteBuildArtifacts: true
	server.publishBuildInfo buildInfo
	sh 'sshpass -p "Ggn@12345" ssh -o StrictHostKeyChecking=no root@10.127.127.160 mkdir -p $JENKINS_HOME/workspace/$JOB_NAME'
	sh 'sshpass -p "Ggn@12345" scp -r *ock* root@10.127.127.160:$JENKINS_HOME/workspace/$JOB_NAME/'
}
def funDockerCreateImage()
{
		echo  "\u2600 **********CREATE DOCKER IMAGE*****************"
		sh returnStdout: true, script: '/bin/docker build -t dtr.nagarro.com:443/devopssampleapplication:${BUILD_NUMBER} -f $JENKINS_HOME/workspace/$JOB_NAME/Dockerfile .'
} 
def funDockerPushImage()
{
	echo  "\u2600 **********PUSH DOCKER IMAGE to DTR*****************"
	sh returnStdout: true, script: '/bin/docker push dtr.nagarro.com:443/devopssampleapplication:${BUILD_NUMBER}'
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
	sh 'docker run --name devopssampleapplication -d -p 12001:8080 dtr.nagarro.com:443/devopssampleapplication:${BUILD_NUMBER}'
	echo  "\u2600 ACCESS DEV ENVIRONMENT HERE: http://10.127.127.160:12001/devopssampleapplication "
}
def funseleniumTest()
{
	echo  "\u2600 **********SELENIUM TESTING*****************"
	sh "${MAVEN_HOME}/bin/mvn -f DemoSampleApp_selenium/pom.xml -Dhostname=10.127.127.160  -Dport=12001 -Dcontext=devopssampleapplication -Dmaven.test.failure.ignore=$PERFORMANCE_MAVEN_TEST_RESULT test"
	publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true, reportDir: "DemoSampleApp_selenium/target/surefire-reports", reportFiles: "emailable-report.html", reportName: "Selenium Report", reportTitles: ''])
}
def funperformanceTest() 
{
	echo  "\u2600 **********PERFORMANCE TESTING: JMETER*****************"
	sh "${MAVEN_HOME}/bin/mvn -f DemoSampleApp_Jmeter/pom.xml -Dhostname=10.127.127.160 -Dport=12001 -Dcontext=devopssampleapplication clean verify -Pperformance"
	publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true, reportDir: "DemoSampleApp_Jmeter/target/reports", reportFiles: "index.html", reportName: "PERFORMANCE_REPORTNAME", reportTitles: ''])
}
def funSetupPG()
{
	echo  "\u2600 **********SETUP PROMETHEUS/GRAFANA*****************"
	funDockerContainerStop(7090)
	funDockerContainerStop(7091)
	funDockerContainerStop(7093)
	funDockerContainerStop(7000)
	sh returnStdout: true, script: 'cd dockprom;chmod -R 777 *;/usr/local/bin/docker-compose down;/usr/local/bin/docker-compose up -d'
	echo  "\u2600 ACCESS PROMETHEUS ENVIRONMENT HERE: http://10.127.127.160:7090 "
	echo  "\u2600 ACCESS PUSH GATEWAY ENVIRONMENT HERE: http://10.127.127.160:7091 "
	echo  "\u2600 ACCESS ALERT MANAGER ENVIRONMENT HERE: http://10.127.127.160:7093 "
	echo  "\u2600 ACCESS GRAFANA ENVIRONMENT HERE: http://10.127.127.160:7000 "
}
def funReleaseEnv()
{
	echo  "\u2600 **********DEPLOY RELEASE ENVIRONMENT*****************"
	sh 'ifconfig'
	sh 'sshpass -p "Ggn@12345" ssh root@10.127.126.48 rm -rf /tmp/devopssampleapplication.war'
	sh 'sshpass -p "Ggn@12345" scp $JENKINS_HOME/workspace/$JOB_NAME/target/*.war root@10.127.126.48:/tmp/'
    sh 'sshpass -p "Ggn@12345" ssh root@10.127.126.48 bash -x /opt/deployment-scripts/AutomateDeploy.sh --application_type=tomcat'
	echo "\u2600 ACCESS RELEASE ENVIRONMENT HERE: http://10.127.126.48:12002/demosampleapplication/ "
}

node("Linux_Slave")
{
	MAVEN_HOME = tool "Maven3.2.1"
	ANT_HOME = tool "ant"
	env.PATH = "${env.JAVA_HOME}/bin:${env.MAVEN_HOME}/bin:${env.ANT_HOME}/bin:${env.PATH}"
	try 
	{
		stage 'Checkout'
		if (SCM == 'SVN')
		{
			funCodeCheckoutSvn()
		}
		stage 'Build'
		if (BUILDTOOL == 'MVN')
		{
			funCodeBuildMvn()
		}
		stage 'Unit Test'
		if (BUILDTOOL == 'MVN')
		{
			fununitTestMvn()
		}
		stage 'Sonar Analysis'
		if (BUILDTOOL == 'MVN')
        {
			funSonarAnalysisMVN()
        }
        stage 'Upload to Artifactory'
			funartifactoryUpload()
    }
    catch (any)
    {
		currentBuild.result = 'FAILURE'
		throw any //rethrow exception to prevent the build from proceeding
    }
}
node("Devops_POC_Linux")
{
	stage 'Docker Image'
	funDockerCreateImage()
	stage 'Push to DTR'
	funDockerPushImage()
	stage 'Docker Deployment'
	funDockerContainerStop (12001)
	fundockercontRun()
	stage 'Setup Infrastructure Monitoring'
	funSetupPG()
}
node("Linux_Slave")
{
	MAVEN_HOME = tool "Maven3.2.1"
	ANT_HOME = tool "ant"
	env.PATH = "${env.JAVA_HOME}/bin:${env.MAVEN_HOME}/bin:${env.ANT_HOME}/bin:${env.PATH}"
	try 
	{
		stage 'Function Testing using Selenium'
		funseleniumTest()
		stage 'Performance Testing  using Jmeter'
		funperformanceTest()
        stage 'JIRA UPDATION'
        funJiraIssueUpdate()
	}
	catch (any) 
	{
        currentBuild.result = 'FAILURE'
        throw any //rethrow exception to prevent the build from proceeding
    } finally {
        emailext body: '${JELLY_SCRIPT,template="health"}', mimeType: 'text/html', recipientProviders: [[$class: 'RequesterRecipientProvider']], replyTo: 'shrey.sangal@nagarro.com', subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', to: 'vipin.choudhary@nagarro.com'
    }
}