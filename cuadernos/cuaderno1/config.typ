// ==========================================
// 1. DEFINICIÓN DE VARIABLES (ESTILO CONSTANTES)
// ==========================================
// Definimos estos datos arriba del todo.
// Los podremos utilizar desde todos los ficheros que hagan
// #include "config.typ"

#let edad_alumno = "16 años"
#let curso_academico = "2026/2027"
#let autor_proyecto = "Halcón68"

// ==========================================
// 2. CREACIÓN DE FUNCIONES PERSONALIZADAS
// ==========================================
// En lugar de escribir todo el código del bloque "Ojo" cada vez, 
// creamos nuestra propia etiqueta personalizada llamada "#advertencia"

#let advertencia(texto) = block(
  fill: rgb("#fff9e6"),
  stroke: (left: 4pt + rgb("#f59e0b")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  *⚠️ ¡Ojo!* \ #texto
]

// Creamos otra para notas informativas rápidas
#let nota(texto) = block(
  fill: rgb("#eff6ff"),
  stroke: (left: 4pt + rgb("#3b82f6")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  *#text(fill: rgb("#3b82f6"))[\u{1F6C8}] Nota:* #texto
]

#let aviso(texto) = block(
  fill: rgb("#fff9e6"), stroke: (left: 4pt + rgb("#f59e0b")),
  inset: 12pt, radius: (right: 4pt), width: 100%,
)[*⚠️ Aviso:* #texto]

#let error_comun(texto) = block(
  fill: rgb("#fef2f2"), stroke: (left: 4pt + rgb("#ef4444")),
  inset: 12pt, radius: (right: 4pt), width: 100%,
)[*❌ Control de Daños:* \ #texto]