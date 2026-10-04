{{- define "demo.labels" -}}
app.kubernetes.io/name: demo
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
{{- end }}
{{- define "demo.selector" -}}
app.kubernetes.io/name: demo
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- define "demo.podSpec" -}}
securityContext:
  runAsNonRoot: true
  seccompProfile: {type: RuntimeDefault}
containers:
  - name: demo
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    ports: [{name: http, containerPort: 8080}]
    env:
      {{- range $k, $v := .Values.env }}
      - name: {{ $k }}
        value: {{ $v | quote }}
      {{- end }}
    readinessProbe: {httpGet: {path: /readyz, port: http}}
    livenessProbe: {httpGet: {path: /healthz, port: http}}
    resources: {{- toYaml .Values.resources | nindent 6 }}
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities: {drop: [ALL]}
{{- end }}
