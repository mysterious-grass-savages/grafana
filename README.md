## What is this?

Sample grafana project to run on Kubernetes. Grafana is hosted under a suburl.

## How do I get this going?

Pre-requisites to running this is
1. JSONNET - https://github.com/google/jsonnet
1. Minikube - https://kubernetes.io/docs/setup/learning-environment/minikube/
1. Ingress addon for minikube - https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/
1. Adding hostname - `mysterious-grass-savages.github` to your /etc/hosts to enable ingress routing - https://medium.com/@Oskarr3/setting-up-ingress-on-minikube-6ae825e98f82. Example `echo "$(minikube ip) mysterious-grass-savages.github" | sudo tee -a /etc/hosts`
1. Run `jsonnet grafana-deployment.jsonnet > values.yml`
1. Run `kubectl apply -f grafana-configmap.yaml values.yaml`
1. Head to http://mysterious-grass-savages.github/grafana/

To access Grafana - http://mysterious-grass-savages.github/grafana