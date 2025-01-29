{{- with pkiCert "pki_int/issue/team-a" "common_name=foo.test.example.com" "ttl=45d" -}}
{{- .Cert -}}
{{- .Key -}}
{{- .Cert | writeToFile "/opt/vault/vault-agent-certificate.pem" "vault" "vault" "0644" -}}
{{- .Key | writeToFile "/opt/vault/vault-agent-private-key.pem" "vault" "vault" "0600" -}}
{{- end -}}
{{- with secret "pki_int/issuer/default" -}}
{{- .Data.certificate -}}
{{- .Data.certificate | writeToFile "/opt/vault/vault-agent-certificate.pem" "vault" "vault" "0644" "append" -}}
{{- end -}}