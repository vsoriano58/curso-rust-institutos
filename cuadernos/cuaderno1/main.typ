#import "config.typ": *

// ============================================================================
// 1. REGLAS ESTÉTICAS GLOBALES (Afectan a todo el libro)
// ============================================================================

// Diseño estético de las cajitas de código
#show raw.where(block: true): it => block(
  fill: rgb("#f4f5f7"), inset: 12pt, radius: 6pt,
  width: 100%, stroke: 0.5pt + rgb("#e1e4e8"), it
)

// REGLA NUEVA: Numeración automática de títulos (Capítulo 1, Subcapítulo 1.1, etc.)
#set heading(numbering: "1.1.")

#show heading.where(level: 1): it => block(below: 1.5em)[
  #set text(weight: "bold", fill: rgb("#1f2328"), size: 18pt)
  
  // Imprime el número automático (ej: 1.) y añade un espacio si el título está numerado
  #if it.numbering != none [
    #counter(heading).display(it.numbering) #h(0.3em)
  ]
  #it.body
  
  #v(0.2em)
  #line(length: 100%, stroke: 1.5pt + rgb("#007acc"))
]


// Tipografías
#set text(font: "Liberation Sans", size: 11pt, lang: "es")
#show raw: set text(font: "Liberation Mono", size: 10pt)

// CONFIGURACIÓN DE PÁGINA DEFINITIVA: 
// Oculta cabeceras y pies en la portada (folio 1) y en el índice (folio 2)
#set page(
  paper: "a4",
  margin: (x: 2.5cm, top: 3cm, bottom: 2.5cm),
  header: context {
    // here().page() mira el número de folio físico real en el PDF
    if here().page() > 2 [
      #align(right)[
        #text(size: 9pt, fill: luma(120), font: "Liberation Sans")[
          Cuaderno 1 de Rust (#edad_alumno) | Prototipo Editorial
        ]
      ]
    ]
  },
  footer: context {
    // El número de página aparecerá a partir del folio físico 3 (donde empieza el contenido)
    if here().page() > 2 [
      #align(center)[
        #text(size: 10pt, fill: luma(100), font: "Liberation Sans")[
          — #counter(page).display() —
        ]
      ]
    ]
  }
)

// =============================================
// CONFIGURACIÓN DE LOS ENLACES
// =============================================

// Los links del documento serán azules y subrayados
#show link: it => underline(text(fill: rgb("#007acc"))[#it])

// =============================================
// CONFIGURACIÓN para bloque ```text
// =============================================

// ===========================================================================
// 2. DISEÑO SEGURO DE LA PORTADA (Página física 1)
// ===========================================================================

#align(center)[
  #v(2cm)
  
  #text(size: 14pt, weight: "bold", tracking: 2pt, fill: rgb("#007acc"))[
    COLECCIÓN RUST PÍXEL A PÍXEL
  ]
  
  #v(1cm)
  
  #text(size: 28pt, weight: "bold", fill: rgb("#1f2328"))[
    Cuaderno 1 de Rust
  ]
  
  #v(0.5em)
  
  #text(size: 16pt, style: "italic", fill: luma(30%))[
    Descubriendo la programación y
  ]

  #text(size: 16pt, style: "italic", fill: luma(30%))[
    Filtros digitales
  ]

    #v(4em)

  #text(size: 16pt)[
    Recomendado a partir de los #edad_alumno años
  ]
  
  #v(1.5cm)
  #rect(width: 40%, height: 2pt, fill: rgb("#007acc"))
  
  #v(1fr)
  
  // Icono del cangrejo de Rust
  #rect(width: 80pt, height: 80pt, radius: 12pt, fill: rgb("#f4f5f7"), stroke: 1pt + rgb("#e1e4e8"))[
    #align(center + horizon)[#text(size: 48pt)[🦀]]
  ]
  
  #v(1.5fr)
  
  #text(size: 11pt, weight: "medium", fill: rgb("#1f2328"))[
    Prototipo Editorial
  ]
  
  #v(0.2cm)
  #text(size: 9pt, fill: luma(120))[
    Laboratorio de Código Instantáneo
  ]
  
  #v(1cm)
]

// Salto de página de la portada al índice
#pagebreak()

// ============================================================================
// 3. TABLA DE CONTENIDOS (Página física 2)
// ============================================================================
#set outline(title: "Índice General", indent: 1.5em)
#outline()

// Salto de página del índice al inicio del libro
#pagebreak()

// ============================================================================
// 4. INCLUSIÓN DE CONTENIDO (Página física 3 en adelante)
// ============================================================================

// Actualizamos el contador a 1 justo aquí, para que la Parte 1 empiece marcando la página 1
#counter(page).update(1)

#include "config.typ"
#include "01_introduccion.typ"
#include "02_que_es_un_programa.typ"
#include "03_conceptos_a_recordar.typ"
#include "04_laboratorio.typ"
#include "05_tipos_datos_y_operadores.typ"
#include "06_instalar_entorno_profesional.typ"
#include "07_tratamiento_de_imagenes.typ"

