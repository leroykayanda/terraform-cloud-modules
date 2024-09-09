FROM amazonlinux
RUN yum -y install java-11 wget tar gzip awscli -y
WORKDIR /home

# Download your version of Kafka
RUN wget https://archive.apache.org/dist/kafka/3.5.1/kafka_2.13-3.5.1.tgz -O kafka.tgz && \
    tar -xzf kafka.tgz

# Set up the Kafka CLI 
RUN cd kafka_2.13-3.5.1/libs && \
    wget https://github.com/aws/aws-msk-iam-auth/releases/download/v1.1.1/aws-msk-iam-auth-1.1.1-all.jar && \
    touch ~/.bashrc && \
    echo 'export PATH=$PATH:/home/kafka_2.13-3.5.1/bin' >> ~/.bashrc && \
    source ~/.bashrc

COPY <<EOF /home/iam.config
security.protocol=SASL_SSL
sasl.mechanism=AWS_MSK_IAM
sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
EOF

COPY <<EOF /home/scram.config
security.protocol=SASL_SSL
sasl.mechanism=SCRAM-SHA-512
ssl.truststore.location=/tmp/kafka.client.truststore.jks
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="foo" password="bar";
EOF

RUN cp /usr/lib/jvm/java-11-amazon-corretto/lib/security/cacerts /tmp/kafka.client.truststore.jks