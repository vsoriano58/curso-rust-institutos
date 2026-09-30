#import "config.typ": *

= 🔖 A los mandos de la Playground
A continuación se describen las distintas partes y funciones de la *Rust Playground* en donde editarás y ejecutarás los programas de *Rust*.

== El panel de control
Imagínate que la `Playground de Rust` es como el salpicadero de una nave espacial o el menú de configuración de tu videojuego favorito: está diseñado para que tengas todo lo necesario a la vista y al alcance de un clic. Cuando entres en la web, verás que la pantalla está dividida principalmente en dos grandes zonas y una barra de herramientas superior.

Accede ahora a la Playground: #link("https://play.rust-lang.org/?version=stable&mode=debug&edition=2024")[Rust Playground oficial]

*1. El lienzo de escritura (La parte izquierda):*
Es tu zona de creación. Es una gran caja blanca (o gris oscura, según el modo que elijas) que funciona como un editor de textos. Todo el código fuente que escribas, modifiques o copies se queda ahí. Verás que las líneas están numeradas a la izquierda (1, 2, 3...); esto es súper útil para saber exactamente en qué línea estás trabajando y para encontrar los errores cuando te los muestre el compilador juanto al número de línea que contiene el error.

*2. La pantalla de resultados o Consola (La parte derecha / inferior):*
Es donde el ordenador te responde. Cuando la Playground termine de procesar tu receta de código, la consola se encenderá de color gris oscuro para mostrarte las respuestas del programa (lo que llamamos la salida estándar o Standard Output) o, si te has equivocado, los mensajes de error con las pistas del compilador.

*3. Los botones de mando (La barra superior):*
En la parte de arriba tienes los botones que activan los *superpoderes* de Rust. Aunque hay varias opciones, para ser un piloto experto solo necesitas dominar estos tres botones clave:

- El botón *[RUN]* (Ejecutar): Es el botón de acción principal. Se visualiza cuando tienes una función main() en el panel izquierdo. Al pulsarlo, le ordenas a los servidores de Rust que cojan tu código fuente de la izquierda, lo compilen en milisegundos a unos y ceros y te muestren el resultado de ejecutar inmediatamente el programa*en el panel de la derecha. Truco de programador: Puedes pulsar las teclas *Ctrl + Enter* en tu teclado para ejecutar la acción equivalente a pulsar el botón *[RUN]* sin usar el ratón.

- El botón *[TOOLS]  > Rustfmt* (Poner el código bonito): Escribiendo rápido es normal que el código se vea desordenado. Al pulsar sobre *Rustfmt* desplegando el botón *[TOOLS]*, la herramienta utiliza un asistente llamado `Rustfmt` que reordena y limpia visualmente tu código de forma automática. ¡Magia! Tu código se verá limpio, profesional y elegante al instante. Acostúmbrate a pulsarlo a menudo; un buen programador es siempre ordenado.

- El botón *[TOOLS] > Clippy* (Tu inspector de estilo): *Clippy* es un pequeño asistente virtual que analiza tu programa en busca de mejoras. No busca faltas de ortografía (de eso se encarga el compilador), sino que revisa si hay formas más inteligentes, modernas o eficientes de escribir lo mismo. Si pulsas Clippy desplegando el botón *[TOOLS]*, te dará sugerencias en color amarillo para que tu código sea "perfecto al estilo Rust".

== El botón mágico: [SHARE]
A diferencia de cuando trabajas con un procesador de textos como `LibreOffice`, donde tienes que ir a `Archivo ➡️ Guardar` y generar un fichero en tu disco duro, en la Playground no existen las carpetas. Si cierras la pestaña del navegador sin hacer nada, ¡tu código desaparecerá para siempre!

Para evitar que pierdas tus trabajos o tus juegos, Rust incluye en la barra superior un botón mágico llamado *[SHARE]* (Compartir).

Cuando tu programa funcione correctamente (o si te has encallado y necesitas ayuda), haz clic sobre el botón *[SHARE]*. Al instante, la Playground hará dos cosas de forma invisible en sus servidores:

+ Guardará una "fotografía" exacta de todo el código que tienes escrito en tu pantalla izquierda.

+ Generará una dirección web (una *URL*) única y permanente para ti.

En cuanto pulses el botón, verás que aparecen cuatro opciones en la pantalla. La única que nos interesa es la primera, llamada *Permalink to the playground* (Enlace permanente). Al lado de ella verás un icono con dos rayitas horizontales: haz clic en él para copiar la dirección web automáticamente. Ahora puedes pegar (guardar) esa dirección donde quieras.

*¿Para qué sirve este enlace?*

- *Para guardar tu trabajo:* Puedes copiar ese enlace y pegarlo en un documento tuyo de notas o enviártelo por correo. Cada vez que hagas clic en ese enlace, la Playground se abrirá mostrando exactamente tu código tal y como lo dejaste.

- *Para entregar tus ejercicios:* Cuando el profesor te pida una tarea, no tendrás que enviarle pesados archivos por correo ni usar un pendrive. Simplemente tendrás que enviarle ese enlace. El profesor podrá abrir tu programa en su propio ordenador, pulsar [RUN], probar tu juego y ver en qué te has equivocado para ayudarte.

#nota("Si abres un enlace de SHARE antiguo, haces cambios en el código y quieres guardar la nueva versión, tendrás que volver a pulsar el botón [SHARE] para generar un enlace nuevo. El enlace viejo nunca se modifica; siempre se queda guardado como una foto fija en el tiempo.")

== Activando superpoderes: ¿Qué es un crate?
Imagínate que estás jugando a tu videojuego favorito y le instalas un mod o una expansión para tener superpoderes, coches nuevos o herramientas que el juego no traía de fábrica. En el mundo de la programación hacemos exactamente lo mismo.

El lenguaje Rust ya viene con un montón de herramientas básicas integradas (como la orden *println!* para escribir en pantalla). Pero si queremos hacer cosas más complejas o divertidas ---como generar números al azar para un juego, procesar imágenes o conectar nuestro programa a internet---, no tenemos que inventar la rueda desde cero. Podemos usar piezas de código que otros programadores del mundo ya han escrito, probado y regalado a la comunidad de Rust.

En el idioma de Rust, estas `piezas o paquetes de expansión` se llaman *crates* (que en inglés significa "cajas de madera de mercancías", como las que caen del cielo en los juegos de supervivencia).

Al usar la *Playground web*, tenemos una ventaja increíble: los 100 crates más importantes y famosos de la historia de Rust ya están preinstalados en los servidores. No tenemos que descargar nada a nuestro ordenador. Para activar uno de estos *superpoderes* en nuestro programa, solo tenemos que usar una palabra mágica al principio de todo nuestro código: la instrucción *use* seguida del nombre del crate.

*¡Vamos a probarlo! El generador de dados al azar*

Vamos a pedirle a la Playground que use un crate super famoso llamado *rand* (de la palabra random, que significa "aleatorio" o al azar en inglés). Queremos crear un programa que simule el `lanzamiento de un dado de 6 caras` cada vez que pulsemos el botón RUN.

💻 Copia este código en tu Playground (limpia lo que tenías antes) y pulsa [RUN]:

Fichero: *generador_aleatorio.rs*

```rust
// 1. Traemos el trait 'RngExt' para activar los métodos del generador
// Y traemos el módulo raíz 'rand' para llamar a la función rand::rng()
use rand::RngExt; 

fn main() {
    // 2. Le pedimos a Rust que prepare el generador de números aleatorios
    let mut generador = rand::rng();
    
    // 3. Lanzamos el dado: simulado con .random_range(1..7)
    let numero_dado = generador.random_range(1..7);
    
    println!("🎲 Has lanzado el dado y ha salido un: {}", numero_dado);
}
```

Si pulsas el botón *[RUN]* varias veces seguidas, verás que la consola de la derecha te responde con un número diferente en cada intento. ¡Acabas de crear tu primer motor de azar para un videojuego!

*¿Qué ha pasado aquí?*

#nota("no es importante que entiendas el código. Fíjate solo en lo fácil que ha sido añadir superpoderes a nuestro programa. Una sola línea. ")

No obstante, aquí tienes una explicación por si te pica el gusanillo.

La primera línea, use *rand::RngExt;*, es la llave que necesitamos para trabajar con el crate *rand* que utilizamos para generar números aleatorios. Este ejemplo no forma parte de lo que es la teoría de este cuaderno. Lo hemos puesto aquí simplemente para que veas como se consiguen poderes del exterior para nuestro programa. 

Evidentemente no es suficiente con conseguir los poderes sino que luego hay que saber utilizarlos como se muestra para este caso en las líneas *let mut generador = rand::rng();* y *let numero_dado = generador.random_range(1..7);*.

Si borráramos la línea *use rand::RngExt;* el compilador se volvería loco y nos daría un error en rojo diciendo que no entiende qué significa eso de *.random_range(1..7)*. Gracias a los *crates* y a la *Playground*, tu capacidad para crear programas divertidos se vuelve infinita con solo una línea de código. Obviamente, repetimos, los crates están documentados y tenemos que aprender a utilizar los que queramos incluir en nuestro programa.

== Lanzar el dado sin utilizar crates
El ejemplo que hemos hecho en el apartado anterior sirvió para transmitir el concepto de crate y para que veas cómo se utilizan. Solo al final del cuaderno volveremos a utilizar otro crate e indicaremos cómo hacerlo.

Simular mediante un programa el lanzamiento de un dado puede hacerse también sin utilizar ningún crate externo, solo con las instrucciones que incorpora Rust como podemos ver en el siguiente programa. 

💻 Copialo, pegalo en la playground y ejecútalo.

Fichero: *lanzar_dado.rs*

```rust
fn main() {
    // Genera un número aleatorio entre 1 y 6 directamente (el 7 no se incluye)
    let numero_dado = rand::random_range(1..7);
    
    println!("🎲 Has lanzado el dado y ha salido un: {}", numero_dado);
}
```

== Aprendiendo a leer el "idioma" del compilador
*Guía visual* para no asustarse con los mensajes en rojo (errores) y amarillo (consejos de estilo); aprendiendo a buscar la línea exacta donde está el fallo.

Cuando pulsas el botón de *RUN*, la Playground *compila* primero el programa y a continuación, `si no han habido errores de compilación`, lo *ejecuta*.

El compilador no es un enemigo que juzga tu código; es un asistente automatizado con un detector de errores ultra-sensible. Cuando tu código no compila o muestra avisos, no significa que hayas "roto" la computadora. Simplemente significa que el compilador ha encontrado algo que no entiende o que podría hacerse mejor.

Aprender a leer su "idioma" te ahorrará horas de frustración.

🚨 *La regla de oro: Errores vs. Advertencias (Warnings)*
Lo primero que debes aprender a distinguir es la gravedad del mensaje. Los compiladores modernos utilizan un código de colores estándar:

#table(
  // Definimos 4 columnas con anchos proporcionales para que el texto largo no se amontone
  columns: (1fr, 1.5fr, 3fr, 2.5fr),
  align: (col, row) => if row == 0 { center + horizon } else { left + top },
  stroke: 0.5pt + luma(150), // Líneas grises finas similares a la imagen

  // --- ENCABEZADO ---
  [*Color*], [*Tipo de Mensaje*], [*¿Qué significa?*], [*¿Detiene la ejecución?*],

  // --- FILA 1 ---
  [*Rojo*], 
  [Error de Compilación], 
  [El código tiene un fallo sintáctico o lógico grave. El compilador no entiende qué quieres hacer.], 
  [SÍ. No se generará el programa ejecutable hasta que lo arregles.],

  // --- FILA 2 ---
  [*Amarillo*], 
  [Advertencia (Warning)], 
  [El código es válido y se puede ejecutar, pero es un consejo de estilo o has realizado una práctica peligrosa (ej. una variable que creaste pero nunca usas).], 
  [NO. El programa funcionará, pero ignorarlo puede traer "bugs (errores)" ocultos.]
)

🔍 *Tu plan de acción ante un error (mensaje en rojo)*

Cuando te enfrentes a una lista enorme de errores, sigue este protocolo para mantener la calma:

- *Paso 1: Ve siempre al primer error*. Un solo punto y coma olvidado al principio del archivo puede desencadenar 50 errores falsos en las líneas siguientes porque el compilador se desorienta. Arregla el primero de la lista y vuelve a compilar.

- *Paso 2: Copia y pega buscando ayuda*. Si no entiendes la descripción del error, no adivines. Copia el texto explicativo (ejemplo: `error: y1_r0 holds a non-trivially copyable type`) y búscalo en Google o StackOverflow. Alguien ya se equivocó en eso mismo antes que tú. Y siempre puedes preguntar a alguna *IA* por el error. Indícale que estás utilizando Rust, copia el primer error y mándalo al chat.

== Tu copiloto digital: Cómo preguntar a la IA
El compilador de Rust (*rustc*) es famoso por ser uno de los más descriptivos y serviciales del mundo. Sin embargo, cuando estás empezando, sus explicaciones detalladas pueden resultar abrumadoras. Es en ese momento cuando una `Inteligencia Artificial` (*IA*) puede convertirse en tu mejor tutor personal, siempre y cuando sepas cómo comunicarte con ella.

El objetivo no es que la IA te dé el código ya resuelto para copiar y pegar, sino usarla como un puente para entender qué te está pidiendo el compilador.

📋 *El método correcto: Copiar desde la Rust Playground.*

Cuando tu código falla en la Rust Playground, la terminal inferior te mostrará el error estructurado. Para pedir ayuda de forma eficiente, debes proporcionar a la IA el *contexto completo*.

Sigue estos pasos para preparar tu consulta:

- Copia el código completo de tu programa en la ventana de edición.

- Copia el mensaje de error íntegro de la consola inferior (incluyendo los bloques que dicen help: o note:, ya que Rust suele incluir ahí la solución exacta).

- Pega finalmente los contenidos anteriores en la ventana de chat con la IA como parte final de tu prompt (consulta, pregunta).

🦾 *Fórmulas de Prompts: Cómo pedir explicaciones (y no solo respuestas).*

Si le dices a la IA "Arréglame este código", te devolverá un bloque para copiar que funcionará, pero no habrás aprendido nada y volverás a cometer el mismo error cinco minutos después.

Para obligar a la IA a actuar como un profesor y no como un generador de código automático, utiliza estas plantillas de instrucciones (prompts):

- *Para entender el concepto:*

"Estoy aprendiendo Rust en la Playground. Mi código da este error de compilación. No me des el código corregido aún. Explícame en un lenguaje sencillo qué regla de Rust estoy rompiendo y qué significa este error."

- *Para buscar pistas:*

"Este es mi código y este es el error de Rust. Dame una pista o una guía paso a paso de qué debo modificar en mi lógica, pero no me escribas las líneas de código finales."

- *Para corregir y contrastar (Auto-evaluación):*

“No logro solucionar este error en Rust. Por favor, muéstrame el código corregido y explica detalladamente qué cambiaste línea por línea respecto a mi versión original."

== 🛑 Las 3 reglas para no volverte dependiente de la IA
Para que tu aprendizaje en Rust sea sólido, grábate estas tres reglas cuando uses herramientas de IA:

- *Regla 1: Lee primero la sugerencia de Rust*. Antes de saltar a la IA, lee la sección help: que te da la Playground. El 80% de las veces, Rust te dice exactamente qué carácter añadir o qué función cambiar. Entrenar tu ojo para leer al compilador es tu superpoder como programador.

- *Regla 2: Prohibido el "Copiar y Pegar" a ciegas.* 
Si la IA te da una línea corregida, no la pegues sin más. Tecléala tú mismo en la Playground. El acto físico de teclear el código ayuda a tu cerebro a fijar la sintaxis (especialmente con los estrictos operadores de Rust como `&`, `*` o `mut`).

- *Regla 3: El validador final es la Playground, no la IA*. 
Las IA a veces inventan métodos o sintaxis que no existen en Rust (alucinaciones). Si la IA te dice una cosa y la Rust Playground te sigue dando rojo, la Playground siempre tiene la razón. `Trust the compiler`.

#pagebreak()