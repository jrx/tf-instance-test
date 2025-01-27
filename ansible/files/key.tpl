{{ with pkiCert "pki_int/issue/team-a" "common_name=foo.test.example.com" "ttl=5m" }}
{{ .Data.Key }}
{{ end }}