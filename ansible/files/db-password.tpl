{{ with secret "secret/data/myapp" }}{{ .Data.data.DB_PASSWORD }}{{ end }}
