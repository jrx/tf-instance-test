{{ with secret "secret/test" }} 
username: {{ .Data.data.username }} 
username: {{ .Data.data.password }} 
{{ end }}