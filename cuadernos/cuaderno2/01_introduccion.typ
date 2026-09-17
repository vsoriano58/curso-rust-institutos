#import "config.typ": *

= 🔖 Introducción y Objetivos del Cuaderno
¡Te damos la bienvenida al segundo volumen de *Cuadernos de Rust!* Si en el primer cuaderno diste tus primeros pasos escribiendo líneas de código secuenciales y entendiendo la sintaxis básica, ha llegado el momento de dar el salto hacia la madurez como programador en Rust.

En este cuaderno vamos a dejar atrás los programas sencillos de un solo bloque para aprender a diseñar software de verdad: organizado, eficiente y seguro. Para lograrlo, dividiremos nuestro código en funciones avanzadas y construiremos herramientas más complejas, como una calculadora científica modular.

Sin embargo, el verdadero plato fuerte de este volumen es el superpoder que hace único a Rust: el Ownership (Sistema de Propiedad). A través de analogías del mundo real y sin tecnicismos innecesarios, entenderás por qué Rust prescinde de un *recolector de basura* para ser rápido y no permite que cometas errores graves de memoria. Aprenderás las reglas de convivencia del código: quién es el "dueño" de un dato, cuándo se "mueve" y cómo se "presta" de forma segura.

Finalmente, descubriremos cómo almacenar grandes volúmenes de información utilizando *Arrays* y *Vectores*; entenderemos cómo se organiza la memoria de tu ordenador y desmitificaremos el trabajo con textos mediante el control total de los Strings. ¡Prepárate, porque al terminar este cuaderno habrás programado tu propia Agenda de Contactos funcional por terminal!

== Objetivos del Cuaderno
Al finalizar este cuaderno, serás capaz de:

- 🏭 Dominar las funciones avanzadas: Diseñar código modular y limpio, comprendiendo la diferencia crítica en Rust entre una expresión y una sentencia (el misterio del punto y coma).

- 🤝 Pensar en términos de Ownership: Asimilar de forma intuitiva las reglas de propiedad, movimientos (moves) y préstamos (borrowing) mutables e inmutables para escribir código seguro por defecto.

- 📦 Manipular colecciones de datos con soltura: Elegir con criterio cuándo utilizar un Array estático grabado a fuego o un Vector elástico que crece y se contrae dinámicamente según las necesidades de tu programa.

- 🗺️ Visualizar la memoria: Comprender el mapa mental de qué pasa dentro de tu ordenador cuando ejecutas un programa y cómo Rust gestiona los recursos de forma automática.

- 🔤 Dominar el laberinto de los Strings: Trabajar sin miedo con textos estáticos (&str) y dinámicos (String), sabiendo cómo concatenarlos, convertirlos y manipularlos.

- 📇 Construir aplicaciones reales: Integrar todos los conceptos del cuaderno para dar vida a proyectos prácticos, desde el sistema de puntuación de un videojuego hasta una base de datos local de contactos.

#pagebreak()