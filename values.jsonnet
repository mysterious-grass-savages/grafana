//Conventions - https://github.com/databricks/jsonnet-style-guide

local grafana_vars = import 'grafana-vars.libsonnet';
local portType(type = "ClusterIP") = type;

// Top level arguement to set environment - DEV, SIT, UAT, PROD
// @param env Name of environment the template has been generated for
function(env = "dev") {
    env: env,
}

{
    //-- DEPLOYMENT --
    "deployment.json": {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "name": grafana_vars["app"] + "-deployment",
            "labels": {
                "app": grafana_vars["app"],
                "environment": env,
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
                            
                            [if std.objectHas(grafana_vars, 'volumeMounts') && std.length(grafana_vars.volumeMounts) > 0 then "volumeMounts"]: [ item
                                for item in grafana_vars.volumeMounts
                            ],
                            [if std.objectHas(grafana_vars, 'env') && std.length(grafana_vars.volumeMounts) > 0 then "env"]: [ item
                                for item in grafana_vars.env
                            ],
                        }
                    ],
                    [if std.objectHas(grafana_vars, 'volumes') && std.length(grafana_vars.volumes) > 0 then "volumes"]: [ item
                            for item in grafana_vars.volumes
                    ]
                }
            }
        }
    },
    //-- SERVICE --
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

    //-- INGRESS --
    "ingress.json": {
        local hostPrefix = if (env == "PROD") then "foo.github" else "mysterious-grass-savages.github",
        "apiVersion": "extensions/v1beta1",
        "kind": "Ingress",
        "metadata": {
            "name": grafana_vars["app"] + "-ingress",
            "namespace": grafana_vars["namespace"] ,
        },
        "spec": {
            "rules": [
                {
                    "host": hostPrefix,
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