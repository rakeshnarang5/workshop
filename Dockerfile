FROM tomcat:alpine
MAINTAINER Anupam Agarwal
WORKDIR $JENKINS_HOME/workspace/deployment_pipeline/
COPY demosampleapplication-1.0.0-SNAPSHOT.war /usr/local/tomcat/webapps/
RUN chown -R tomcat /usr/local/tomcat/webapps/demosampleapplication-1.0.0-SNAPSHOT.war
RUN /usr/local/tomcat/webapps/demosampleapplication-1.0.0-SNAPSHOT.war
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run
