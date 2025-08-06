{{- define "microservice.pod" }}
{{- if or .Values.imagePullSecrets .Values.imageCredentials }}
imagePullSecrets:
{{- end }}
{{- if .Values.imagePullSecrets }}
- name: {{ .Values.imagePullSecrets }}
{{- end }}
{{- if .Values.dnsPolicy }}
dnsPolicy: {{ .Values.dnsPolicy }}
{{- end }}
{{- with .Values.dnsConfig }}
dnsConfig:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if .Values.imageCredentials }}
- name: {{ include "microservice.name" . }}-docker-credentials
{{- end }}
{{- if .Values.serviceAccount }}
serviceAccountName: {{ .Values.serviceAccount }}
{{- end }}
{{- if .Values.podSecurityContext }}
securityContext:
  {{- toYaml .Values.podSecurityContext | nindent 2 }}
{{- end }}
automountServiceAccountToken: {{ .Values.automountServiceAccountToken }}
{{- if .Values.hostAliases }}
hostAliases:
{{- range .Values.hostAliases }}
- ip: {{ .ip }}
  hostnames:
  {{- range .hostnames }}
  - {{ . }}
  {{- end }}
{{- end }}
{{- end }}
hostNetwork: {{ .Values.hostNetwork }}
containers:
  - name: {{ .Chart.Name }}
{{- if .Values.securityContext }}
    securityContext:
      {{- toYaml .Values.securityContext | nindent 6 }}
{{- end }}
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    {{- if .Values.setCommand }}
    command: 
    - /bin/sh
    - -c
    {{- end }}
    {{- if .Values.args }}
    args: 
    - {{ .Values.args }}
    {{- end }}
    ports:
      {{- range .Values.services -}}
      {{- range $port:= .specs}}
      - name: {{ .name }}
        containerPort: {{ .targetPort | default .port}}
        protocol: {{ .protocol | default "TCP" }}
      {{- end }}
      {{- end }}
    {{- if (merge .Values.global.environment .Values.environment) }}
    env:
    {{- range $name, $value := merge .Values.global.environment .Values.environment }}
    - name: {{ $name | quote }}
      value: {{ $value | quote }}
    {{- end }}
    {{- end }}
    {{- if .Values.secretEnv.enabled }}
    envFrom: 
    {{- range $name := .Values.secretEnv.secretNames }}
    - secretRef:
        name: {{ $name | quote }}
    {{- end }}
    {{- end }}
    {{- if .Values.volumes.enabled }}
    volumeMounts:
      {{- range $conf := .Values.volumes.configMaps }}
      - mountPath: {{ $conf.mountPath }}
        name: {{ $conf.name }}-volume
      {{- if $conf.subPath }}
        subPath: {{ $conf.subPath }} 
      {{- end }}
      {{- end }}
      {{- range $sec := .Values.volumes.secrets }}
      - mountPath: {{ $sec.mountPath }}
        name: {{ $sec.name }}-volume
      {{- if $sec.subPath }}
        subPath: {{ $sec.subPath }} 
      {{- end }}
      {{- end }}
      {{- if .Values.volumes.pvc.enabled }}
      {{- if .Values.volumes.pvc.mountPath }}
      - mountPath: {{ .Values.volumes.pvc.mountPath }}
        name: {{ .Values.volumes.pvc.existingClaim | default .Values.volumes.pvc.name }}-volume
      {{- else }}
      {{- $vols := .Values.volumes }}
      {{- range $subpath := $vols.pvc.subPaths }}
      - mountPath: {{ $subpath.mountPath }}
        name: {{ $vols.pvc.existingClaim | default $vols.pvc.name }}-volume
        subPath:  {{ $subpath.subPath }}
      {{- end }}
      {{- end }}
      {{- end }}
    {{- end }}
{{- if .Values.resources }}
    resources:
      {{- toYaml .Values.resources | nindent 6 }}
{{- end }}
{{- if .Values.liveness.enabled }}
    livenessProbe:
      httpGet:
        path: {{ .Values.liveness.path }}
        port: {{ .Values.liveness.port }}
      initialDelaySeconds: {{ .Values.liveness.initialDelaySeconds }}
      periodSeconds: {{ .Values.liveness.periodSeconds }}
{{- end}}
{{- if .Values.readiness.enabled }}
    readinessProbe:
      httpGet:
        path: {{ .Values.readiness.path }}
        port: {{ .Values.readiness.port }}
      initialDelaySeconds: {{ .Values.readiness.initialDelaySeconds }}
      periodSeconds: {{ .Values.readiness.periodSeconds }}
      failureThreshold: {{ .Values.readiness.failureThreshold }}
{{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if .Values.volumes.enabled }}
volumes:
  {{- range $conf := .Values.volumes.configMaps }}
  - name: {{ $conf.name }}-volume
    configMap:
      name: {{ $conf.name }}
  {{- end }}
  {{- range $sec := .Values.volumes.secrets }}
  - name: {{ $sec.name }}-volume
    secret:
      secretName: {{ $sec.name }}
  {{- end }}
{{- if .Values.volumes.pvc.enabled }}
  - name: {{ .Values.volumes.pvc.existingClaim | default .Values.volumes.pvc.name }}-volume
    persistentVolumeClaim:
      claimName: {{ .Values.volumes.pvc.existingClaim | default .Values.volumes.pvc.name }}
{{- end }}
{{- end }}
{{- end }}