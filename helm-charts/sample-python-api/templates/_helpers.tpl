{{/*
common labels
*/}}
{{- define "common.labels" -}}
app.kubernetes.io/name: {{ .Values.service_name | default "test"}}
app.kubernetes.io/instance: {{ .Values.common_labels.instance | default "test" }}
app.kubernetes.io/version: {{ .Chart.Version }}
app.kubernetes.io/part-of: {{ .Values.common_labels.part_of | default .Chart.Name }}
app.kubernetes.io/component: {{ .Values.common_labels.component | default .Chart.Type }}
app.kubernetes.io/managed-by: {{ .Values.common_labels.managed_by | default "helm" }}
{{- end -}}
{{/*
selector labels
*/}}
{{- define "selector.labels" -}}
app.kubernetes.io/app: {{.Values.service_name | default "test"}}
{{- end -}}
{{/*
Repo Url
*/}}
{{- define "full.image_name" -}}
{{- $repo := .Values.image.image }}
{{- if .Values.image.tag -}}
{{- $repo }}:{{ .Values.image.tag }}
{{- else -}}
{{- $repo }}
{{- end -}}
{{- end -}}