# Flexible Chart

Allows you to create a Deployment, Service, Ingress and Cronjobs based on the `values.yml` configuration.
This ensures that all deployments follow the same conventions.

## Example

```yaml
###
# Global Settings
###
id: nginx
environment: development

###
# ConfigMaps
###
configmaps:
- name: 'main'
  version: '1'
  data:
    game.properties: |
      enemies=aliens
      lives=3
      enemies.cheat=true
      enemies.cheat.level=noGoodRotten
      secret.code.passphrase=UUDDLRLRBABAS
      secret.code.allowed=true
      secret.code.lives=30

###
# Deployment Settings
###
deployments:
- name: 'app'
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
    minReplicas: 1
    maxReplicas: 3
    cpuUtilization: 50
  # restartPolicy
  restartPolicy: 'Always'
  # containers
  containers:
  # container definition
  - name: app
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
      value: 'TOP_SECRET'
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
    # volumeMounts
    volumeMounts:
    - mountPath: /redis-master
      name: config
  # volumes
  volumes:
  - name: config
    configMap:
      name: main
      items:
      - key: game.properties
        path: redis.conf

###
# Services
###
services:
- name: app
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
- name: app
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
          serviceSelector: app
          servicePort: 80

###
# Storage
###
storage:
- name: main
  storageClassName: "slow"
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi

###
# Cronjobs
###
cronjobs: []
```
