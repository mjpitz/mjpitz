local string = { type: "string" };
local boolean = { type: "boolean" };
local integer = { type: "integer" };
local number = { type: "number" };

local list(items) = { type: "array", items: items };
local object(properties) = { type: "object", properties: properties };

local env = {
    anyOf: [
        { "type": "null" },
        object({}),
        list(object({
            name: string,
            value: string,
        })),
    ],
};

local containerPort = object({
    name: string,
    containerPort: integer,
    protocol: string,
});

local probe = object({
    exec: object({}),
    grpc: object({}),
    httpGet: object({}),
    tcpSocket: object({}),
});

local servicePort = object({
    name: string,
    port: integer,
    targetPort: string,
    protocol: string,
});

local utilization = {
    anyOf: [
        { "type": "null" },
        integer,
    ],
};

{
    "$schema": "https://json-schema.org/draft-07/schema#",
    title: "Values",
    type:  "object",
    properties: {
        nameOverride: string,
        fullnameOverride: string,
        image: object({
            repository: string,
            tag: string,
            pullPolicy: string,
        }),
        imagePullSecrets: list(
            object({
                registry: string,
                username: string,
                password: string,
            }),
        ),
        serviceAccount: object({
            create: boolean,
            annotations: object({}),
            name: string,
        }),
        hooks: list(
            object({
                name: string,
                triggers: list(string),
                weight: integer,
                resourcePolicy: string,
                deletionPolicy: list(string),
                securityContext: object({}),
                image: object({
                    repository: string,
                    tag: string,
                    pullPolicy: string,
                }),
                env: env,
                envFrom: list(object({})),
                command: list(string),
                args: list(string),
                resources: object({}),
            }),
        ),
        deployment: object({
            replicaCount: integer,
            autoscaling: object({
                enabled: boolean,
                minReplicas: integer,
                maxReplicas: integer,
                targetCPUUtilizationPercentage: utilization,
                targetMemoryUtilizationPercentage: utilization,
                metrics: list(object({})),
            }),
            annotations: object({}),
            imagePullSecrets: list(object({
                name: string,
            })),
            volumes: list(object({})),
            application: object({
                securityContext: object({}),
                env: env,
                envFrom: list(object({})),
                volumeMounts: list(object({})),
                command: list(string),
                args: list(string),
                port: list(containerPort),
                checks: object({
                    startup: probe,
                    liveness: probe,
                    readiness: probe,
                }),
                resources: object({}),
            }),
            sidecars: list(object({
                name: string,
                securityContext: object({}),
                image: object({
                    repository: string,
                    tag: string,
                    pullPolicy: string,
                }),
                env: env,
                envFrom: list(object({})),
                volumeMounts: list(object({})),
                command: list(string),
                args: list(string),
                port: list(containerPort),
                checks: object({
                    startup: probe,
                    liveness: probe,
                    readiness: probe,
                }),
                resources: object({}),
            })),
            tasks: list(object({
                name: string,
                schedule: string,
                suspend: boolean,
                securityContext: object({}),
                image: object({
                    repository: string,
                    tag: string,
                    pullPolicy: string,
                }),
                env: env,
                envFrom: list(object({})),
                volumeMounts: list(object({})),
                command: list(string),
                args: list(string),
                resources: object({}),
            })),
            nodeSelector: object({}),
            tolerations: list(object({
                effect: string,
                key: string,
                operator: string,
                tolerationSeconds: integer,
                value: string,
            })),
            affinity: object({
                nodeAffinity: object({}),
                podAffinity: object({}),
                podAntiAffinity: object({}),
            }),
        }),
        networking: object({
            service: object({
                annotations: object({}),
                type: string,
                clusterIP: string,
                ports: list(servicePort),
            }),
            ingress: object({
                enabled: boolean,
                className: string,
                annotations: object({}),
                portName: string,
                hosts: list(object({
                    host: string,
                    paths: list(object({
                        path: string,
                        pathType: string,
                        portName: string,
                    })),
                })),
                tls: list(object({
                    secretName: string,
                    hosts: list(string),
                })),
            }),
        }),
        metrics: object({
            enabled: boolean,
            endpoints: list(object({
                portName: string,
                podMonitor: object({
                    authorization: object({}),
                    basicAuth: object({}),
                    bearerTokenSecret: object({}),
                    enableHttp2: boolean,
                    filterRunning: boolean,
                    followRedirects: boolean,
                    honorLabels: boolean,
                    honorTimestamps: boolean,
                    interval: string,
                    metricRelabelings: list(object({})),
                    oauth2: object({}),
                    params: object({}),
                    path: string,
                    port: string,
                    proxyUrl: string,
                    relabelings: list(object({})),
                    scheme: string,
                    scrapeTimeout: string,
                    tlsConfig: object({}),
                }),
            })),
        }),
    },
}
