# Ecosistema de Automatización IA: Clasificación de Leads con Aprobación Humana

Sistema end-to-end que recibe consultas de clientes, las clasifica con Claude usando contexto de Airtable, redacta una respuesta personalizada y **espera la aprobación de una persona en Slack** antes de enviar el email por Gmail.

## Stack
| Capa | Tecnología |
|---|---|
| Orquestador | n8n |
| Base de datos / memoria | Airtable (Leads, Empresas, Log de Errores) |
| Procesamiento IA | Anthropic Claude (tool use con salida JSON estructurada) |
| Validación humana + alertas | Slack (Send and Wait) |
| Salida al cliente | Gmail |

## Flujo en una línea
`Webhook -> Normalizar -> Validar datos -> Anti-duplicado -> Upsert Empresa -> Crear Lead -> Claude -> Parseo -> Airtable (Procesado por IA) -> Slack (HITL) -> Gmail -> Airtable (Enviado) -> Confirmación en hilo`

## Contenido del repositorio
| Ruta | Descripción |
|---|---|
| [`docs/arquitectura.pdf`](docs/arquitectura.pdf) | Diagrama de arquitectura, modelo de datos y matriz de errores |
| [`flow/flujo-leads.json`](flow/flujo-leads.json) | Flujo n8n exportado (sin credenciales) |
| [`prompts/prompt_clasificacion.md`](prompts/prompt_clasificacion.md) | Prompt, schema y decisiones de diseño |
| [`airtable/`](airtable/) | Estructura de la base y CSV de encabezados |
| [`tests/`](tests/) | Casos de prueba, script de envío y plan de test de estrés |
| [`screenshots/`](screenshots/) | Capturas de evidencia (ver `LEEME.md`) |
| [`docs/guia_configuracion.md`](docs/guia_configuracion.md) | Instalación paso a paso |
| [`docs/guion_video_demo.md`](docs/guion_video_demo.md) | Guion del video de 3 minutos |

## Enlaces obligatorios
- Base de datos Airtable (solo lectura): https://airtable.com/appnarTnPFgVG0clv/shrhuFfCuBAid0Ul4
- Video demo (3 min): **https://youtu.be/p4vDlWcKnEI**

## Cumplimiento de requisitos
| Requisito | Dónde se cumple |
|---|---|
| 4+ tecnologías | n8n, Airtable, Claude, Slack, Gmail |
| Flujo sin intervención manual hasta el punto crítico | Webhook -> IA -> Slack |
| Rutas de error | Datos faltantes, duplicados, reintentos y salida de error en IA, validación de parseo, Error Trigger global, Log de Errores |
| Human-in-the-loop | `Slack - Solicitar Aprobación (HITL)` + `IF - Aprobado?` antes de `Gmail - Enviar Respuesta al Cliente` |
| Nodos con nombres claros, variables dinámicas, sin hardcodeo | Prefijo por tecnología; parámetros en `Set - Config y Parámetros`; credenciales de n8n |
| Campos de estado y relaciones | `Estado` en Leads; relaciones Empresas-Leads y Leads-Log de Errores |
| Trigger específico | Webhook POST (sin polling) |
| Max Tokens limitado | `max_tokens` = 700 en el nodo de configuración |
| Thread ID | `Slack Thread TS` y `Gmail Thread ID` guardados en Airtable |
| Test de estrés (5+ ejecuciones) | `tests/plan_de_pruebas.md` (8 casos incluyendo camino infeliz) |

## Check de seguridad
- Filtro anti-bucle: sí (búsqueda por Email y trigger único por webhook).
- Tipos de datos correctos: número vs número (`puntaje` vs `umbral_puntaje`) y booleano en la aprobación.
- Prompt dinámico: sí, con variables de n8n y datos de Airtable.
- Sin secretos en el repositorio: el JSON usa credenciales de n8n y marcadores `REEMPLAZAR`.

## Probar rápido
```bash
bash tests/enviar_casos.sh https://TU-N8N/webhook-test/nuevo-lead
```
