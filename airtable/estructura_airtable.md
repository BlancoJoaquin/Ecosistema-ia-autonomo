# Estructura de Airtable ("Cerebro" del sistema)

Base sugerida: **Leads IA**. Tres tablas con relaciones. Los CSV de `/airtable` tienen los encabezados para importar y luego ajustar tipos de campo.

## Tabla `Empresas`
| Campo | Tipo |
|---|---|
| Nombre | Texto (campo principal, valor único: lo usa el Upsert) |
| Sector | Texto |
| Tamaño | Single select: Micro, Pequeña, Mediana, Grande |
| Leads | Link a `Leads` (se crea sola al vincular desde Leads) |
| Cantidad de Leads | Rollup/Count de `Leads` |

## Tabla `Leads`
| Campo | Tipo | Notas |
|---|---|---|
| Nombre | Texto | |
| Email | Email | Clave anti-duplicado |
| Teléfono | Texto | Formato internacional +54... |
| Empresa | Link a `Empresas` | Relación 1-N |
| Mensaje | Texto largo | |
| **Estado** | Single select | `Pendiente`, `Procesado por IA`, `Aprobado por Humano`, `Rechazado`, `Enviado`, `Descartado`, `Error` |
| Categoría IA | Single select | `VIP`, `Estandar`, `Descartar` |
| Puntaje | Número (entero) | 0-100 |
| Resumen IA | Texto largo | |
| Motivo IA | Texto largo | |
| Borrador Respuesta | Texto largo | |
| Slack Thread TS | Texto | Para responder en el hilo |
| Gmail Thread ID | Texto | Para mantener la conversación |
| Fecha Ingreso | Created time | |
| Errores | Link a `Log de Errores` | |

## Tabla `Log de Errores`
| Campo | Tipo |
|---|---|
| ID | Autonumber (principal) |
| Tipo | Single select: `Dato faltante`, `Duplicado`, `Fallo API IA`, `Error global` |
| Nodo | Texto |
| Mensaje | Texto largo |
| Payload | Texto largo |
| Reintentado | Checkbox |
| Lead | Link a `Leads` |
| Fecha | Created time |

## Vistas recomendadas
- `Leads` agrupada por Estado (Kanban) para la captura de pantalla.
- `Leads` filtrada: Estado = `Procesado por IA` (pendientes de aprobación).
- `Log de Errores` ordenada por Fecha descendente.

## Token y permisos
Personal Access Token con scopes `data.records:read`, `data.records:write`, `schema.bases:read`, limitado a esta base.

## Link de solo lectura
Share view -> "Create a shared view link" (modo lectura) en la vista Kanban de Leads, y también en Log de Errores. Pegá el link en el README.
