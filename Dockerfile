FROM tomcat:alpine
MAINTAINER Shrey Sangal
RUN wget -O /usr/local/tomcat/webapps/devopssampleapplication.war http://artifactory.nagarro.local/artifactory/CI-Automation-JAVA-Pipeline/com/nagarro/devops-tools/devops/demosampleapplication/1.0.0-SNAPSHOT/demosampleapplication-1.0.0-SNAPSHOT.war
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run