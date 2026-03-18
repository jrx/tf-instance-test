{{ with secret "secret/data/myapp" }}{{ .Data.data.API_KEY }}{{ end }}
