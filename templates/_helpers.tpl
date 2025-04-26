{{/* Redis labels */}}
{{- define "redis.labels" -}}
app.kubernetes.io/component: redis
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/environment: {{ .Values.global.deployment.active }}
{{- end }}

{{/* Redis selector labels */}}
{{- define "redis.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/environment: {{ .Values.global.deployment.active }}
{{- end }}

{{/* PostgreSQL labels */}}
{{- define "postgresql.labels" -}}
app.kubernetes.io/component: postgresql
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/environment: {{ .Values.global.deployment.active }}
{{- end }}

{{/* PostgreSQL selector labels */}}
{{- define "postgresql.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/environment: {{ .Values.global.deployment.active }}
{{- end }}

{{/* Nextcloud labels */}}
{{- define "nextcloud.labels" -}}
app.kubernetes.io/component: nextcloud
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/environment: {{ .Values.global.deployment.active }}
{{- end }}

{{/* Nextcloud selector labels */}}
{{- define "nextcloud.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/environment: {{ .Values.global.deployment.active }}
{{- end }}

{{/* Environment namespace */}}
{{- define "environment.namespace" -}}
{{- if eq .Values.global.deployment.active "blue" -}}
{{- .Values.environments.blue.namespace -}}
{{- else -}}
{{- .Values.environments.green.namespace -}}
{{- end -}}
{{- end -}}
