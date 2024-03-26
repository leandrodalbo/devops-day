# Commands Used

## create/start/stop a cluster on top of Docker

```bash
$ minikube start --cpus 2 --memory 4g --driver docker --profile catalog
$ minikube stop --profile catalog
$ minikube start --profile catalog
```

## setup the context

```bash
$ kubectl config get-contexts
$ kubectl config current-context
$ kubectl config use-context catalog
```

## list all nodes

```bash
$ kubectl get nodes
```

## create postgres pod

```bash
$ kubectl apply -f postgres.yml
$ kubectl get pod
```

# create deployments

```bash
$ kubectl apply -f config-service/deployment.yml
$ kubectl apply -f catalog-service/deployment.yml
$ kubectl get deployments
```

# create services

```bash
$ kubectl apply -f config-service/service.yml
$ kubectl apply -f catalog-service/service.yml
$ kubectl get services
```

# expose app

```bash
$ kubectl port-forward service/catalog-service 8080:80
$ curl http://127.0.0.1:8080/welcome
```
