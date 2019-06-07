FROM openjdk
COPY ./libs/torrssen2-0.5.0.jar torrssen2.jar
VOLUME [ "/root/data" ]
EXPOSE 8080
ENV BASE_URL http://localhost:8080
CMD [ "java", "-jar", "torrssen2.jar"]