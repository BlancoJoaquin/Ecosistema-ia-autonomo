#!/usr/bin/env bash
# Uso: ./enviar_casos.sh https://TU-N8N/webhook-test/nuevo-lead   (o /webhook/ en producción)
URL="${1:?Falta la URL del webhook}"
N=$(python3 -c "import json;print(len(json.load(open('casos_prueba.json'))))")
for i in $(seq 0 $((N-1))); do
  ID=$(python3 -c "import json;print(json.load(open('casos_prueba.json'))[$i]['id'])")
  BODY=$(python3 -c "import json;print(json.dumps(json.load(open('casos_prueba.json'))[$i]['body']))")
  echo "Enviando $ID"; curl -s -X POST "$URL" -H "Content-Type: application/json" -d "$BODY"; echo
  sleep 3
done
