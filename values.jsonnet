local grafana_vars = import 'grafana-vars.libsonnet';
local portType(type = "ClusterIP") = type;

{
    "deployment.json": {
        environments: [
            {
                volumeMounts: env,

            }
            for env in grafana_vars.volumeMounts
    ], 
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "name": grafana_vars["app"] + "-deployment",
            "labels": {
                "app": grafana_vars["app"]
            }
        },
        "spec": {
            "replicas": 1,
            "selector": {
                "matchLabels": {
                    "app": grafana_vars["app"]
                }
            },
            "template": {
                "metadata": {
                    "labels": {
                        "app": grafana_vars["app"]
                    }
                },
                "spec": {
                    "containers": [
                        {
                            "name": grafana_vars["app"],
                            "image": grafana_vars["image"],
                            "ports": [
                                {
                                    "containerPort": grafana_vars.port
                                }
                            ],
                            
                            [if 'volumeMounts' in grafana_vars && std.length(grafana_vars.volumeMounts) > 0 then "volumeMounts"]: [ item
                                for item in grafana_vars.volumeMounts
                            ],
                        }
                    ],
                    [if 'volumes' in grafana_vars && std.length(grafana_vars.volumes) > 0 then "volumes"]: [ item
                            for item in grafana_vars.volumes
                    ]
                }
            }
        }
    },
    "service.json": {
        apiVersion: "v1",
        kind: "Service",
        metadata: {
            name: grafana_vars["app"] + "-service"
        },
        spec: {
            selector: {
                app: grafana_vars["app"]
            },
            ports: [
                {
                    protocol: "TCP",
                    port: grafana_vars["port"],
                    targetPort: grafana_vars["port"]
                },
            ],
            type: portType(),
        },
    },

    "ingress.json": {
        "apiVersion": "extensions/v1beta1",
        "kind": "Ingress",
        "metadata": {
            "name": grafana_vars["app"] + "-ingress",
            "namespace": grafana_vars["namespace"] ,
        },
        "spec": {
            "rules": [
                {
                    "host": grafana_vars["host"],
                    "http": {
                        "paths": [
                            {
                                "path": grafana_vars.url,
                                "backend": {
                                    "serviceName": grafana_vars["app"] + "-service",
                                    "servicePort": grafana_vars["port"] 
                                }
                            }
                        ]
                    }
                }
            ]
        }
    },
}