# Flexible Kubernetes Chart

A kubernetes chart that can be fully configured using `values.yaml`.

## Values.YAML Example with all supported options

```yaml
###
# Global Settings
###
id: nginx
environment: development

###
# Deployment Settings
###
deployments:
- # meta
  name: 'app'
  component: 'webserver'
  version: '1.15'
  # scaling
  replicaCount: 1
  # deployment strategy
  # - Recreate: All existing Pods are killed before new ones are created.
  # - RollingUpdate: The Deployment updates Pods in a rolling update fashion.
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  revisionHistoryLimit: 5
  # autoscaling
  autoscaling:
    enabled: false
  # pods
  containers:
  - # name
    name: app
    # image
    imageRepository: docker.io/nginx
    imageTag: '1.15-alpine'
    # ports
    ports:
    - protocol: TCP
      containerPort: 80
    # environment variables
    env:
    - name: SECRET_USERNAME
      valueFrom:
        secretKeyRef:
          name: test-secret
          key: username
    # resources
    resources:
      requests:
        memory: '64Mi'
        cpu: '250m'
      limits:
        memory: '128Mi'
        cpu: '500m'
    # graceful shutdown
    terminationGracePeriodSeconds: 15
    # Healthchecks
    # - checks, if the container is ready to serve requests
    readinessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 10
      periodSeconds: 2
    # - checks if the container is still healthy
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 2
      periodSeconds: 2
###
# Services
# 
###
services:
- # service name
  name: app
  # workload selector
  selector: app
  # ports
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

###
# Ingresses
###
ingresses:
- # name
  name: app
  # allow http traffic
  allowHttp: true
  # redirect http requests to https
  sslRedirect: false
  # rules
  rules:
  - host: nginx.philippheuer.me
    http:
      paths:
      - path: /
        backend:
          serviceName: nginx-app
          servicePort: 80

###
# Cronjobs
###
cronjobs:
- # name
  name: app
  # cronjob schedule
  schedule: "0 * * * *"
  # Allow parralel execution for this cronjob: Allow, Forbid
  concurrencyPolicy: Forbid
  # only run within x seconds of the scheduled time, otherwise skip the next execution
  startingDeadlineSeconds: 60
  # containers
  containers:
  - # name
    name: app
    # image
    imageRepository: docker.io/nginx
    imageTag: '1.15-alpine'
    # ports
    ports:
    - protocol: TCP
      containerPort: 80
    # resources
    resources:
      requests:
        memory: '64Mi'
        cpu: '250m'
      limits:
        memory: '128Mi'
        cpu: '500m'
    # graceful shutdown
    terminationGracePeriodSeconds: 15
```

## License

Released under the [MIT License](LICENSE).
