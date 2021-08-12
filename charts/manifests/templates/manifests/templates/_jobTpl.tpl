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
{{- define "bedag-lib.template.job" -}}
  {{- $values := mergeOverwrite (fromYaml (include "bedag-lib.values.template.job" $)) $.job -}}
  {{- if and $values (include "bedag-lib.utils.intern.noYamlError" $values) . (include "bedag-lib.utils.intern.noYamlError" $) -}}
    {{- with $values -}} 
metadata:
  name: {{ include "bedag-lib.utils.common.fullname" $ }}
  labels: {{- include "lib.utils.common.labels" (dict "labels" .jobLabels "context" $) | nindent 4 }}
      {{- with .jobNamespace }}   
  namespace: {{ include "lib.utils.strings.template" (dict "value" . "context" $) }}
      {{- end }}
      {{- with .jobAnnotations }}
  annotations:
        {{- range $anno, $val := . }}
          {{- $anno | nindent 4 }}: {{ include "lib.utils.strings.template" (dict "value" $val "context" $) | quote }}
        {{- end }}
      {{- end }}
spec:
      {{- with .jobFields }}
        {{- toYaml . | nindent 2 }}
      {{- end }}
      {{- with .activeDeadlineSeconds }}
  activeDeadlineSeconds: {{ . }}
      {{- end }}
      {{- with .backoffLimit }}
  backoffLimit: {{ . }}
      {{- end }}
      {{- with .completions }}
  completions: {{ . }}
      {{- end }}
      {{- with .ttlSecondsAfterFinished }}
  ttlSecondsAfterFinished: {{ . }}
      {{- end }}
      {{- with .jobSelector }}
  selector: {{ toYaml . | nindent 4 }}
      {{- end }}
  template: {{- include "bedag-lib.template.pod" (set $ "pod" .) | nindent 4 }}
    {{- end }}
  {{- else }}
    {{- fail "Template requires '.pod' and '.context' as arguments" }}
  {{- end }}
{{- end }}