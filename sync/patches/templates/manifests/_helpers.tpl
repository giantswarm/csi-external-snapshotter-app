{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "labels.common" -}}
{{ include "labels.selector" . }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ include "chart" . | quote }}
application.giantswarm.io/team: {{ index .Chart.Annotations "application.giantswarm.io/team" | quote }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "labels.selector" -}}
app.kubernetes.io/name: {{ include "name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}

{{/*
Name of the one-shot hook that hands ownership of pre-existing CRDs to Helm.
*/}}
{{- define "crdAdopt" -}}
{{- printf "%s-%s" ( include "name" . ) "crd-adopt" | replace "+" "_" | trimSuffix "-" -}}
{{- end -}}

{{- define "crdAdoptAnnotations" -}}
"helm.sh/hook": "pre-install,pre-upgrade"
"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded,hook-failed"
{{- end -}}

{{/* Create a label which can be used to select any orphaned crd-adopt hook resources */}}
{{- define "crdAdoptSelector" -}}
{{- printf "%s" "crd-adopt-hook" -}}
{{- end -}}

{{/* Whether the CRD ownership migration hook should be rendered at all */}}
{{- define "crdAdoptEnabled" -}}
{{- and .Values.crds.install .Values.crds.adopt.enabled -}}
{{- end -}}
