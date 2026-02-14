{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nifi-registry.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nifi-registry.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nifi-registry.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nifi-registry.labels" -}}
helm.sh/chart: {{ include "nifi-registry.chart" . }}
{{ include "nifi-registry.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nifi-registry.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nifi-registry.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nifi-registry.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "nifi-registry.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Git config secret name.
*/}}
{{- define "flowProvider.git.config.secretName" -}}
{{- printf "%s-git-config" (include "nifi-registry.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
LDAP configmap name.
*/}}
{{- define "nifi-registry.ldap.configMapName" -}}
{{- required "ldap.configMapName is required (external ConfigMap with authorizers.xml, identity-providers.xml, nifi-registry.properties)" .Values.ldap.configMapName -}}
{{- end }}

{{/*
TLS secret name issued by cert-manager.
*/}}
{{- define "nifi-registry.tls.secretName" -}}
{{- default (printf "%s-tls" (include "nifi-registry.fullname" .)) .Values.certManager.secretName -}}
{{- end }}
