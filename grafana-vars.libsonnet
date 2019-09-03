{
    app: "grafana",
    port: 3000,
    namespace: "default",
    image: "grafana/grafana:6.3.5",
    url: "/grafana/",
    
    "volumeMounts": [
        {
            "mountPath": "/etc/grafana/grafana.ini",
            "name": "grafana-config",
            "subPath": "grafana.ini"
        }
    ],
    "volumes": [
        {
            "name": "grafana-config",
            "configMap": {
                "name": "grafana-config"
            }
        }
    ],
    "env": [
        {
            "name": "DEMO_GREETING",
            "value": "Hello from the environment"
        },
        {
            "name": "DEMO_FAREWELL",
            "value": "Such a sweet sorrow"
        }
    ]

}