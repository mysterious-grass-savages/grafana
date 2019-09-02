{
    app: "grafana",
    port: 3000,
    host: "mysterious-grass-savages.github",
    namespace: "default",
    image: "grafana/grafana:6.3.5",
    url: "/grafana/",
    
    "volumeMounts": [
        {
            "mountPath": "/etc/grafana/grafana.ini",
            "name": "grafana-config",
            "subPath": "grafana.ini"
        },
        {
            "mountPath": "/etc/grafana/custom.ini",
            "name": "grafana-config2",
            "subPath": "custom.ini"   
        },
    ],
    "volumes": [
        {
            "name": "grafana-config",
            "configMap": {
                "name": "grafana-config"
            }
        }
    ],
}