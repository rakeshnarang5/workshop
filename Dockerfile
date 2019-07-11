FROM tomcat:alpine
MAINTAINER Anupam Agarwal
RUN wget -O /usr/local/tomcat/webapps/devopssampleapplication.war /var/lib/jenkins/.m2/repository/com/nagarro/devops-tools/devops/demosampleapplication/1.0.0-SNAPSHOT/demosampleapplication-1.0.0-SNAPSHOT.war
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run
