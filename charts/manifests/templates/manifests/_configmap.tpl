{{/*

Copyright © 2021 Bedag Informatik AG

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
{{- define "bedag-lib.manifest.configmap" -}}
  {{- if .context }}
    {{- $context := set (set (set .context "name" .name) "fullname" .fullname) "prefix" .prefix -}}
    {{- $configmap := mergeOverwrite (fromYaml (include "bedag-lib.values.configmap" $)).configmap (default dict .values) (default dict .overwrites) -}}
    {{- if (include "bedag-lib.utils.intern.noYamlError" $configmap) -}}
      {{- with $configmap -}}
        {{- if .enabled }}
kind: ConfigMap
          {{- if .apiVersion }}
apiVersion: {{ .apiVersion }}
          {{- else }}
apiVersion: v1
          {{- end }}
metadata:
  name:  {{ include "bedag-lib.utils.common.fullname" $context }}
  labels: {{- include "lib.utils.common.labels" (dict "labels" .labels "context" $context)| nindent 4 }}
          {{- with .namespace }}   
  namespace: {{ include "lib.utils.strings.template" (dict "value" . "context" $context) }}
          {{- end }}
          {{- with .annotations }}
  annotations:
            {{- range $anno, $val := . }}
              {{- $anno | nindent 4 }}: {{ include "lib.utils.strings.template" (dict "value" $val "context" $context) | quote }}
            {{- end }}
          {{- end }}
data:
          {{- if .data.content }}
            {{- if .data.plain }}
              {{- with .data.content }}
                {{ include "lib.utils.strings.template" (dict "value" . "context" $context) | nindent 2 }}
              {{- end }}  
            {{- else }}
              {{- include "bedag-lib.utils.configs.content" (dict "context" $context "config" .data) | nindent 2 }}
            {{- end -}}
          {{- end }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end -}}