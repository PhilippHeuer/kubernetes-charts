# Cronjob

This chart allows you to deploy cronjob in your kubernetes cluster.

## Example

```yaml
###
# Global Settings
###
id: systemName
environment: development

###
# Cronjobs
###
cronjobs:
- name: app
  version: '1.0'
  # cronjob schedule
  schedule: '0 * * * *'
  # Allow parralel execution for this cronjob: Allow, Forbid
  concurrencyPolicy: Forbid
  # only run within x seconds of the scheduled time, otherwise skip the next execution
  startingDeadlineSeconds: 15
  # specify how many completed and failed jobs should be kept in the kubernetes job history
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 3
  # containers
  containers:
  - name: app
    # image
    imageRepository: docker.io/hello-world
    imageTag: 'latest'
    # ports
    ports: []
    # environment variables
    env: []
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
  # restart policy
  restartPolicy: Never
```
