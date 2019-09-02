local app = "grafana";
local port = 3000;
local servicePortType = "ClusterIP";
local host = "mysterious-grass-savages.github";
local namespace = "default";

{

    "deployment.json": {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "name": "grafana-deployment",
            "labels": {
                "app": "grafana"
            }
        },
        "spec": {
            "replicas": 1,
            "selector": {
                "matchLabels": {
                    "app": app
                }
            },
            "template": {
                "metadata": {
                    "labels": {
                        "app": app
                    }
                },
                "spec": {
                    "containers": [
                        {
                            "name": app,
                            "image": "grafana/grafana:6.3.5",
                            "ports": [
                                {
                                    "containerPort": port
                                }
                            ],
                            "volumeMounts": [
                                {
                                    "name": "grafana-config",
                                    "mountPath": "/etc/grafana/grafana.ini",
                                    "subPath": "grafana.ini"
                                }
                            ]
                        }
                    ],
                    "volumes": [
                        {
                            "name": "grafana-config",
                            "configMap": {
                                "name": "grafana-config"
                            }
                        }
                    ]
                }
            }
        }
    },
    "service.json": {
        apiVersion: "v1",
        kind: "Service",
        metadata: {
            name: app + "-service"
        },
        spec: {
            selector: {
                app: app
            },
            ports: [
                {
                    protocol: "TCP",
                    port: port,
                    targetPort: port
                },
            ],
            type: servicePortType,
        },
    },

    "ingress.json": {
        "apiVersion": "extensions/v1beta1",
        "kind": "Ingress",
        "metadata": {
            "name": app + "-ingress",
            "namespace": namespace,
        },
        "spec": {
            "rules": [
                {
                    "host": host,
                    "http": {
                        "paths": [
                            {
                                "path": "/" + app + "/",
                                "backend": {
                                    "serviceName": app + "-service",
                                    "servicePort": port
                                }
                            }
                        ]
                    }
                }
            ]
        }
    },
}