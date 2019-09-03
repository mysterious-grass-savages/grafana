local serviceDeployment = import "service-deployment-ingress.jsonnet.TEMPLATE";

serviceDeployment + {
    serviceName:: "grafana",
    dockerImage:: "grafana/grafana:6.3.5",
    servicePort:: 3000,
    url:: "/grafana/",

    volumeMounts:: [
        {
            "mountPath": "/etc/grafana/grafana.ini",
            "name": "grafana-config",
            "subPath": "grafana.ini"
        },
    ],
    env:: [
        {
            "name": "DEMO_GREETING",
            "value": "Hello from the environment"
        },
        {
            "name": "DEMO_FAREWELL",
            "value": "Such a sweet sorrow"
        }
    ],
    volumes:: [
        {
            "name": "grafana-config",
            "configMap": {
                "name": "grafana-config"
            }
        }
    ],
}