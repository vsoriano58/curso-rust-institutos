#import "config.typ": *

= Introducción al Bloque Práctico: Rust en el Mundo Real

¡Bienvenido al último paso de tu viaje con Rust! En los cuadernos anteriores has aprendido a controlar la memoria mediante el sistema de propiedad (*ownership*), a estructurar tus datos con elegancia y a gestionar errores como un profesional de la ingeniería de software. Has estado trabajando en un entorno controlado, asegurándote de que los cimientos de tu conocimiento sean indestructibles. 

Sin embargo, la teoría sin práctica es letra muerta. Este cuaderno final no está aquí para enseñarte más reglas sintácticas, sino para *aplicar todo lo aprendido en tres proyectos reales* que interactúan con el mundo exterior. Pasaremos de ejecutar líneas en la terminal a construir aplicaciones palpables. A continuación, te explicamos por qué hemos elegido estos tres pilares para cerrar tu formación:

== El Servidor Web: Rust como el motor de la Internet moderna
Cuando navegas por internet, das por hecho que las páginas web responden al instante. Detrás de esa magia hay servidores que procesan miles de peticiones por segundo. Tradicionalmente, esto se hacía con lenguajes que consumían mucha memoria o que eran propensos a fallos de seguridad. 

En este bloque aprenderás a construir un servidor web desde cero. Verás cómo el estricto control de tipos de Rust y su velocidad nativa lo convierten en la tecnología favorita de empresas como Discord o Cloudflare para sostener la infraestructura del mundo digital. Entenderás cómo hacer para recibir datos de un usuario, procesarlos y devolver una respuesta en microsegundos de forma totalmente segura.

== Concurrencia y Asincronía: Exprimir el hardware al 100%
Ya lo adelantamos en el cuaderno anterior: los procesadores actuales no son significativamente más rápidos que los de hace unos años, simplemente tienen más núcleos. Un programa síncrono tradicional es como tener un Ferrari y usarlo solo para ir a comprar el pan a 20 km/h; estás desperdiciando el potencial del silicio.

En este apartado romperemos las barreras del tiempo y el orden secuencial. Aprenderás a coordinar tareas para que tu programa haga "muchas cosas a la vez". Verás la diferencia exacta entre *concurrencia* (repartir tareas pesadas entre los núcleos de la CPU) y *asincronía* (aprovechar los tiempos muertos en los que el ordenador espera datos de la red o del disco duro). Y lo mejor de todo: descubrirás por qué la comunidad llama a Rust el rey de la *"Fearless Concurrency"* (Concurrencia sin miedo), ya que su compilador te impedirá cometer los típicos errores de memoria que vuelven locos a los programadores en otros lenguajes.

== Tu primer Videojuego interactivo: ¿Por qué usamos Macroquad?
Un videojuego es la prueba de fuego definitiva para cualquier lenguaje de programación. ¿Por qué? Porque un juego no puede permitirse "frenar" para limpiar la basura de la memoria; necesita renderizar gráficos, calcular físicas y leer el teclado del jugador exactamente *60 veces por segundo* (60 FPS) sin un solo frenazo.

Para lograr esto de forma divertida y didáctica, utilizaremos *Macroquad*. Es una librería de Rust (*crate*) espectacular porque elimina toda la complejidad matemática de bajo nivel de las tarjetas gráficas (OpenGL/Vulkan) y te ofrece una interfaz limpia y directa. Te permite dibujar pantallas, mover personajes y detectar colisiones escribiendo pocas líneas de código. Macroquad nos permite centrarnos en la lógica pura del juego utilizando el rendimiento bruto y la seguridad que Rust ya nos da de serie.

#align(center)[
  #block(fill: rgb("faf5ff"), inset: 12pt, radius: 4pt, stroke: 0.5pt + rgb("e9d5ff"))[
    *El objetivo de este cuaderno:* \
    Demostrarte que Rust no es solo un lenguaje académico para evitar errores de memoria. Es una herramienta ultrapotente diseñada para construir el software del futuro: rápido, eficiente, concurrente y, por qué no, también divertido. ¡Empecemos!
  ]
]


#pagebreak()