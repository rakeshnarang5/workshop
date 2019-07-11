FROM tomcat:alpine
MAINTAINER Anupam Agarwal
COPY /var/lib/jenkins/.m2/repository/com/nagarro/devops-tools/devops/demosampleapplication/1.0.0-SNAPSHOT/demosampleapplication-1.0.0-SNAPSHOT.war /var/lib/jenkins/workspace/deployment_pipeline/
COPY /var/lib/jenkins/workspace/deployment_pipeline/demosampleapplication-1.0.0-SNAPSHOT.war /usr/local/tomcat/webapps/demosampleapplication-1.0.0-SNAPSHOT.war
RUN /usr/local/tomcat/webapps/demosampleapplication-1.0.0-SNAPSHOT.war
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run
