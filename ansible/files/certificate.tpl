{{- with pkiCert "pki/issue/team-a" "common_name=foo.tenant-1.example.com" "ttl=5m" -}}
{{- .Key -}}
{{- .Cert -}}
{{- .CAChain -}}
{{- .Key | writeToFile "/opt/vault/vault-agent-private-key.pem" "nginx" "vault" "0755" -}}
{{- .Cert | writeToFile "/opt/vault/vault-agent-certificate.pem" "nginx" "vault" "0755" -}}
{{- range .CAChain -}}
{{- . -}}
{{- . | writeToFile "/opt/vault/vault-agent-certificate.pem" "nginx" "vault" "0755" "append" -}}
{{- end -}}
{{- end -}}