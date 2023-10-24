
    module "amazon_msk_cluster_abc_socket" {
      source                      = "app.terraform.io/abc-Inc/modules/abc//aws/queues/amazon_msk"
      version                     = "1.0.5"
      microservice_name           = var.microservice_name
      env                         = var.env
      team                        = var.team
      kafka_client_subnets        = var.kafka_client_subnets
      broker_ebs_volume_size      = var.broker_ebs_volume_size
      broker_instance_type        = var.broker_instance_type
      kafka_version               = var.kafka_version
      number_of_broker_nodes      = var.number_of_broker_nodes
      kafka_enhanced_monitoring   = var.kafka_enhanced_monitoring
      kafka_logs_retention_period = var.kafka_logs_retention_period
      security_group_id           = aws_security_group.kafka_sg.id
      public_access               = var.kafka_public_access
      scram_user                  = var.scram_user
      scram_password              = var.scram_password
    } 

The module enables both IAM and SCRAM authentication. A user is created and the credentials stored in secrets manager. The user has to be given permissions to perform various actions on the cluster eg create topics.

First we set up kafka cli on a linux server to be able to run command on the cluster. Next we authenticate to the cluster via IAM as per the instructions given [here](https://docs.aws.amazon.com/msk/latest/developerguide/create-topic.html) in order to give the SCRAM user that was created permissions to the cluster.

Steps to install kafka cli on linux.

 - Install Java JDK version 11

>     yum -y install java-11

 - Download and install Kafka

>     wget https://archive.apache.org/dist/kafka/2.8.1/kafka_2.12-2.8.1.tgz
>     tar -xzf kafka_2.12-2.8.1.tgz

    
 - Download **aws-msk-iam-auth-1.1.1-all.jar** into the kafka libs directory on your PC

>     cd kafka_2.12-2.8.1/libs
>     wget https://github.com/aws/aws-msk-iam-auth/releases/download/v1.1.1/aws-msk-iam-auth-1.1.1-all.jar

 - Setup the $PATH environment variables for easy access to the Kafka binaries 

> echo 'export PATH=$PATH:~/kafka_2.12-2.8.1/bin' >> ~/.bashrc source
> ~/.bashrc

 - The iam.config file is as below

```
security.protocol=SASL_SSL
sasl.mechanism=AWS_MSK_IAM
sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
```

 - You can create and list topics to test the setup is working. Ensure AWS credentials have been set up.

```
kafka-topics --command-config iam.config --bootstrap-server broker-url:9198 --create --topic first_topic --partitions 1
Created topic first_topic.
```

```
kafka-topics --command-config playground.config --bootstrap-server broker-url:9198 --list
__amazon_msk_canary
__consumer_offsets
first_topic
```

Run the command below to create an ACL that will grant a SCRAM user named tom admin permissions.

    kafka-acls --bootstrap-server broker-url:9198 --command-config iam.config --add --allow-principal User:tom --operation All --topic '*' --group '*'
    
Test whether the SCRAM user that was created is able to run commands on the kafka cluster.

The scram.config file has the contents below.

    security.protocol=SASL_SSL
    sasl.mechanism=SCRAM-SHA-512
    ssl.truststore.location=/tmp/kafka.client.truststore.jks
    sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="tom" password="TE2g9SjvffvffdVaPHkRNen";

First, use the following command to copy the JDK key store file from your JVM `cacerts` folder into the `kafka.client.truststore.jks` file. Replace `JDKFolder` with the name of the JDK folder on your instance.

    cp /usr/lib/jvm/**JDKFolder**/jre/lib/security/cacerts /tmp/kafka.client.truststore.jks

If the JDK folder is **java-11-amazon-corretto.x86_64**, then the command will be

    cp /usr/lib/jvm/java-11-amazon-corretto.x86_64/lib/security/cacerts /tmp/kafka.client.truststore.jks

Then run the test command.

    kafka-topics --command-config scram.config --bootstrap-server broker-url:9196 --create --topic first_topic --partitions 1

