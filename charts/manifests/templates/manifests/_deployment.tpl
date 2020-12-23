{{/*

Copyright © 2020 Oliver Baehler

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/}}
{{- define "bedag-lib.manifest.deployment.values" -}}
  {{- include "lib.utils.template" (dict "value" (include "bedag-lib.mergedValues" (dict "type" "deployment" "root" .)) "context" .context) -}}
{{- end }}

{{- define "bedag-lib.manifest.deployment" -}}
  {{- if .context -}}
    {{- $context := .context -}}
    {{- $deployment := (fromYaml (include "bedag-lib.manifest.deployment.values" .)) -}}
kind: Deployment
    {{- if $deployment.apiVersion }}
apiVersion: {{ $deployment.apiVersion }}
    {{- else }}
apiVersion: apps/v1
    {{- end }}
metadata:
  name: {{ include "bedag-lib.fullname" . }}
  labels: {{- include "lib.utils.labels" (dict "labels" $deployment.labels "context" $context)| nindent 4 }}
spec:
    {{- with $deployment.strategy }}
  strategy: {{ toYaml . |  nindent 4 }}
    {{- end }}
  replicas: {{ default "1" $deployment.replicaCount }}
  selector:
    matchLabels: {{- include "lib.utils.template" (dict "value" (default (include "lib.utils.selectorLabels" $context) $deployment.selectorLabels) "context" $context) | nindent 6 }}
  serviceName: {{ default (include "bedag-lib.fullname" $context) $deployment.serviceName }}
  template: {{- include "bedag-lib.template.pod" (dict "pod" $deployment "context" $context) | nindent 4 }}
  {{- end }}
{{- end -}}