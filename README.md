# quitquitquit

Docker image to ease the use of K8S jobs within an istio mesh.

This image is intended to be placed in initContainer of a pod in a job/cronjob.

## Why?

Currently, istio is a bit complicated to use
in `strict mode` for jobs and cronjobs.

The job remains in `NotReady` even after the job is executed.

```console
NAME                             READY   STATUS      RESTARTS   AGE
demo-4cbb2                       1/2     NotReady    0          12s
```

The solution is to make a POST request to proxy-agent.

This small image allows the use of istio in jobs using containers without curl
or wget.

See: [istio/issues/6324](https://github.com/istio/istio/issues/6324)

## xh

`xh` is a alternative to curl written in rust and
does not require any dependencies.

See: [ducaale/xh](https://github.com/ducaale/xh)

## Example

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  creationTimestamp: null
  name: my-cronjob
spec:
  jobTemplate:
    metadata:
      creationTimestamp: null
      name: my-cronjob
    spec:
      template:
        metadata:
          creationTimestamp: null
        spec:
          volumes:
            - name: shared
              emptyDir: {}
          initContainers:
            - name: init-shared
              image: docker.io/upciti/quitquitquit:latest
              command: ["cp", "-r", "/shared/", "/volume/"]
              volumeMounts:
                - name: shared
                  mountPath: "/volume"
          containers:
            - image: image_without_curl:latest
              name: job
              command:
                - /volume/shared/entrypoint.sh", "ls -la /"]
              volumeMounts:
                - name: shared
                  mountPath: "/volume"
          restartPolicy: OnFailure
  schedule: 0 * * * *
status: {}
```
