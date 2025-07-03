{{- with secret "gcp/static-account/my-key-account/key" -}}
{{ base64Decode .Data.private_key_data }}
{{- end -}}