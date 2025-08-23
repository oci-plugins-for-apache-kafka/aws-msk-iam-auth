# Container images with the Amazon MSK Library for AWS Identity and Access Management

This repository contains set of container images with the Apache Kafka [Amazon MSK Library for AWS Identity and Access Management](https://github.com/aws/aws-msk-iam-auth) Apache Kafka® plugin.
These container images should allow you to use it with Strimzi 0.47 and newer using the Kubernetes Image Volumes.
You should also be able to use with other Apache Kafka® distributions running on Kubernetes.

## Example use with Strimzi

The following examples show how to mount the plugin into the Strimzi deployment.
For example through the `KafkaConnect` CR:

```yaml
kind: KafkaConnect
metadata:
  name: my-connect
spec:
  # ...
  authentication: # Use the AWS MSK IAM authentication
    type: custom
    sasl: true
    config:
      sasl.mechanism: AWS_MSK_IAM
      sasl.jaas.config: software.amazon.msk.auth.iam.IAMLoginModule required;
      sasl.client.callback.handler.class: software.amazon.msk.auth.iam.IAMClientCallbackHandler
  # ...
  template: # Add the AWS MSK IAM authentication plugin
    pod:
      volumes:
        - name: aws-msk-iam-auth
          image:
            reference: ghcr.io/kafka-oci-plugins/aws-msk-iam-auth:2.3.2
    connectContainer:
      volumeMounts:
        - name: aws-msk-iam-auth
          mountPath: /mnt/aws-msk-iam-auth
      env:
        - name: CLASSPATH
          value: "/mnt/aws-msk-iam-auth/*"
```

You can similarly use it also with Strimzi HTTP Bridge or with Kafka Mirror Maker 2.