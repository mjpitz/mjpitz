{{/*
Render the storj sidecar container.
*/}}
{{- define "storj.container" -}}
{{- $defaultSecretName := include "storj.fullname" . | printf "%s-config" -}}
{{- $secretName := .Values.externalConfig.secretRef.name | default $defaultSecretName -}}
- name: storj
  securityContext:
    {{- toYaml .Values.securityContext | nindent 4 }}
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  args:
    - run
  env:
    - name: STORJ_MINIO_ACCESS_KEY
      valueFrom:
        secretKeyRef:
          name: {{ $secretName }}
          key: {{ .Values.externalConfig.secretRef.accessKeyName }}
    - name: STORJ_MINIO_SECRET_KEY
      valueFrom:
        secretKeyRef:
          name: {{ $secretName }}
          key: {{ .Values.externalConfig.secretRef.secretKeyName }}
    - name: STORJ_ACCESS
      valueFrom:
        secretKeyRef:
          name: {{ $secretName }}
          key: {{ .Values.externalConfig.secretRef.accessGrantName }}
  ports:
    - name: s3
      containerPort: 7777
      protocol: TCP
  resources:
    {{- toYaml .Values.resources | nindent 4 }}
{{- end -}}
