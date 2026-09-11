#import "config.typ": *

= 🔖 Conceptos que necesitarás recordar
En este apartado vamos a incluir algunos conceptos sobre Rust de la máxima importancia. Evidentemente no están todos los que son pero si un pequeño conjunto que te resultará crucial para entender el resto del cuaderno y podrás volver aquí para revisarlos cada vez que lo necesites.

== La información que maneja un programa
Los programas informáticos se caracterizan por manejar información. Esta información pueden obtenerla de muchas formas, por ejemplo: puede estar incrustada en el mismo programa o, facilitada por el usuario a través del ratón o el teclado, mediante una conexión a una cámara web, mediante la lectura de un código de barras, mediante la lectura de ficheros que recibe desde Internet o desde otras vías; existen muchas otras formas mediante las cuales un programa puede recibir información. 

En base a las fuentes de información citadas anteriormente, podríamos clasificar la información que puede recibir y por tanto manejar un programa en muchas categorías pero, vamos a simplificar este proceso y a distinguir solamente tres categorías de información: 

- Numérica (representada por números enteros y decimales) 
- Texto (representado por una agrupación de letras o caracteres)
- Booleanos, que solo tienen dos valores (verdadero y falso)

Lo primero a reslatar es que mientras en matemáticas el conjunto de los números es infinito, veremos luego que en informática no lo es y tiene valores máximos y mínimos que pueden alcanzar. 

Un texto puede contener numerosos caracteres. Considérense los caracteres que contiene un libro cuyo contenido puede ser manejado íntegramente por un programa informático.

Sin embargo, el conjunto de los booleanos solo tiene dos valores, *true* (verdadero) y *false* (falso) pero, en informática son tan valiosos como los anteriores.

=== Tipos de datos reales
En el apartdo anterior hablamos de forma muy general de *números*, *textos* y *booleanos*. Sin embargo, para programar de verdad en Rust, debemos entender que el ordenador solo entiende de interruptores eléctricos (*unos* y *ceros*).

*Nota*: Más adelante en el tema, en el apartado _5.1.- Tipos de datos en Rust_ desarrollaremos con mayor rigor el concepto que introducimos en este apartado. Lo hacemos así para que puedas entender los ejemplos de programas que vamos a estudiar sin adentrarnos todavía en una justificación teórica que es algo compleja y que dejamos para más tarde, cuando ya hayas utilizado estos conceptos desde la práctica con los ejemplos.

Para que esos unos y ceros se conviertan en una *edad*, en tu *nombre* o en el *precio* de un videojuego, Rust necesita saber el `Tipo de Dato`. Un tipo de dato es, simplemente, la plantilla que le dice al ordenador cómo traducir esos unos y ceros de la memoria RAM.

Aunque existen muchos tipos, por ahora solo necesitas dominar de momento estos cuatro tipos sagrados:

- *Enteros (i32)*: Sirven para contar cosas completas que no se pueden partir. Tu edad, el año actual o el número de vidas de un personaje. Rust los llama *i32* (un entero de 32 bits). En la memoria ocupan un espacio de tamaño fijo.

- *Decimales (f64)*: Sirven para medir cosas precisas. El precio de una golosina (1.50), la distancia en millas (5.34) o la temperatura (23.6). Rust los llama *f64* (número en coma flotante flotante de 64 bits). El ordenador los guarda usando una parte para el número y otra para saber dónde va el punto decimal. ¡Ojo! En programación usamos el punto ., nunca la coma , para los decimales.

- *Texto (&str y String)*: Son cadenas de letras, números y símbolos unidos, siempre encerrados entre comillas (como "Halcón68"). En la memoria, el ordenador los guarda como una lista de caracteres seguidos.

- *Booleanos (bool)*: Es el tipo más sencillo del mundo. Solo tiene dos valores posibles: *true* (verdadero) o *false* (falso). En la memoria ocupan el mínimo espacio posible: un único interruptor encendido o apagado. Sirven para tomar decisiones (¿el juego ha terminado?, ¿el usuario es mayor de edad?).

== 📢 El altavoz de tu código: Salida estándar con println!()
Un programa que calcula cosas en silencio dentro del ordenador pero no te las muestra es un programa inútil. Necesitamos un *altavoz* para comunicarnos con el usuario humano, y en Rust ese altavoz es la orden _*println!()*_.

La palabra viene del inglés Print Line (imprimir línea). Su funcionamiento parece sencillo, pero esconde dos herramientas de diseño avanzadas que verás constantemente en el laboratorio:

===  Los "Anclajes" u "Ojos de buey" {}
Cuando quieres mostrar texto combinado con variables, no puedes tirarlo todo junto. Rust utiliza los corchetes *{}* como marcadores de posición o *huecos para rellenar*. Piensa en ellos como un gancho donde vas a colgar tus datos en orden. Por ejemplo:

```rust
println!("Hola {}, tienes {} años.", nombre, edad);
```
Rust leerá esa línea y la imprimirá en la pantalla colocando el valor de `nombre` en el primer {} y el valor de `edad` en el segundo {}. Si cambias el orden de las variables al final, la frase cambiará por completo.

===  El limitador de decimales {:.N}
A los ordenadores se les da tan bien la precisión matemática que, si calculas una división o una conversión de kilómetros a millas, a veces te arrojan resultados como 8.59432210943. ¡Eso en una pantalla queda feísimo!

Para solucionarlo, Rust te permite tunear el marcador {} añadiendo instrucciones dentro. La más utilizada es *{:.2}*.

- Los dos puntos : en el interior significan: "Atención, voy a darte una instrucción de formato".

- El punto y el número dos .2 significan: "Corta el número decimal y muestra solo dos dígitos después del punto".

- Se puede generalizar a N decimales donde N puede valer 2, 3, 4,… {:.N}.

Ejemplo:

Si el *resultado* real es 5.14367, la siguiente línea,

```rust
println!("Distancia: {:.3} km", resultado); 
```
mostraría: `Distancia: 5.143 km`

==  El proceso de compilación de un programa
Un poco más adelante te explicaremos de forma más detallada el funcionamiento de la *Playground de Rust*. Es básicamente una aplicación web que te permite escribir en el lado izquierdo tu programa Rust y, si no tienes errores, cuando le das al botón *[RUN]* ves en la parte derecha el resultado de ejecutar el programa. Si cometes errores en la escritura de tu programa la Playground no generará ningún resultado. Te marcará los mensajes de error en rojo y te dará normalmente pistas para subsanarlos. Es posible que no sigas las recomendaciones de lo que Rust considera un estilo perfecto.  En tal caso te entregará mensajes en color amarillo para avisarte pero también ejecutará el programa entregándote los resultados.

Vamos a utilizar por primera vez la Playground.

1. Pulsa sobre el enlace: #link("https://play.rust-lang.org/?version=stable&mode=debug&edition=2024")[Rust Playground oficial]

En general, el programa que nosotros escribimos se denomina programa fuente. Por ejemplo, el primero será simplemente imprimir un saludo por la pantalla. 

2. Copia el texto que tienes abajo y pégalo en la parte izquierda de la ventana de la Playground, borrando primero el contenido previo en caso de existir.

```rust
fn main() {
    println!("¡Bienvenido al curso de Rust!");
}
```

#nota("para borrar...")

- Click con el botón derecho del ratón sobre el panel izquierdo de la pantalla > Seleccionar todo
- Pulsa la Tecla Supr

3. Pulsa con el ratón sobre el botón *[RUN]*

Verás aparecer en la parte derecha el siguiente texto:

```
Standard Error
    Compiling playground v0.0.1 (/playground)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.52s
    Running `target/debug/playground`
Standard Output
¡Bienvenido al curso de Rust!
```
El resultado de tu programa es solamente la última línea:

`¡Bienvenido al curso de Rust!`

4. Explicación

Si estuviéramos trabajando en un entorno de programación más complejo que la *Playground*, seguramente el código que hemos copiado y pegado se encontraría en un fichero llamado `main.rs`. *rs* es la extensión que utilizan los ficheros de Rust. Sin embargo, al trabajar con la Playground se simplifica este proceso y desaparece el concepto de fichero main.rs. 

Nosotros trabajaremos sencillamente con el concepto de programa, identificado con el texto que escribimos en la parte izquierda Playground.

Dentro de nuestro programa, en la instrucción `fn main()`, la palabra `fn` sirve para definir una función (ya veremos qué es esto) y la instrucción  `println!("¡Bienvenido al curso de Rust!");` imprime el mensaje *¡Bienvenido al curso de Rust!* (sin las comillas) por la pantalla.

Este *programa* fuente está escrito en un lenguaje (`Rust`) que el ser humano puede entender. Sin embargo, el ordenador solo entiende de unos y ceros. Para que el ordenador pueda entender y procesar el programa, existe un proceso denominado compilación que convierte el programa fuente  en otro equivalente que solo contiene unos y ceros  y que el ordenador es capaz de entender.

Podemos llamar a este fichero *ejecutable* aunque no sea totalmente exacto en todos los casos.

Podríamos resumirlo en una frase diciendo que `compilar un programa fuente lo convierte en un programa ejecutable`. Esta traducción la realiza un programa denominado *compilador* y es el que genera los mensajes de error cuando nos equivocamos al escribir el programa fuente. El programa ejecutable, como su nombre indica, puede ser ejecutado por nuestro sistema operativo, el sistema bajo el cual se ha compilado, de una forma prácticamente idéntica en Linux, MacOS o Windows. 

El programa fuente, el que entiende el humano, es idéntico en las tres plataformas anteriores pero al compilar, cada plataforma genera un código ejecutable que solo ella es capaz de entender.

Como nosotros utilizaremos la *Rust Playground* desde la Web, da igual el sistema operativo desde el que accedamos a esta aplicación web: no se van a generar ficheros compilados que nosotros podamos ver y todos estaremos en las mismas condiciones. Por supuesto, podremos intercambiar entre nosotros los programas fuente como el que acabamos de ver, independientemente de la plataforma desde la que los hayamos creado y en la que vayamos a ejecutarlos.

==  Qué es una variable en programación
Reconocemos que es un poco aventurado explicar qué es una variable en programación sin apenas haber escrito código. Sin embargo, partimos de la base de que ya has utilizado variables al resolver problemas en matemáticas o física. Ese concepto, aunque no es exactamente igual en informática, es un punto de partida perfecto.

En clase de física, por ejemplo, decimos:

- v = 50.5 (Velocidad en Km/h)
- t = 2 (Tiempo en horas)
- e = Espacio recorrido (en Km)

Para calcular el espacio, aplicas la fórmula:

$ e = v * t = 50.5 * 2 = 101 K m $

En física usas esas letras para guardar números. En informática hacemos lo mismo, pero con una gran diferencia: el ordenador necesita guardar esos valores dentro de su memoria RAM y necesita saber qué tipo de información va a meter dentro.

Imagína que la memoria del ordenador es un almacén gigante lleno de `cajas de cristal` para almacenar `variables`. Para usar una caja, necesitas hacer dos cosas:

+ Ponerle una etiqueta con un nombre (para encontrarla rápido)
+ Decirle al ordenador qué tipo de objeto vas a guardar dentro (un número entero, un número con decimales, un texto...), porque cada tipo de dato necesita una caja de tamaño diferente.

Mira cómo escribiríamos este mismo problema de física en `Rust`. Copia este código en tu Playground y pulsa *[RUN]*:

```rust
fn main() {
    let v = 50.5;
    let t = 2.0;
    let e = v * t;
    println!("Espacio recorrido = {} Km", e);
}
```
Con *fn* definimos la función *main()* que es el punto de entrada al programa, por donde empieza a ejecutarse. Lo que hay entre las llaves {} es el código de la función main(), lo que se ejecutará al pulsar [RUN].

- *¿Qué significa let?* Es la palabra que usamos en `Rust` para `fabricar` una `caja nueva` en la memoria. *let v = 50.5;* significa: "Créame una caja llamada v y guarda dentro el número decimal 50.5".

- *¿Por qué es genial Rust?* Te habrás fijado en que no le hemos dicho a Rust qué tipo de caja queríamos. Rust es un lenguaje inteligentísimo: ve que ponemos un 50.5 (con un punto decimal) y él solo deduce: "¡Ah! Esto es un número decimal, usaré una caja para decimales". Esto se llama inferencia de tipos. No siempre puede proceder así.

- *¿Qué pasa si nos equivocamos de caja?* Imagina que vas al Traductor de Google, escribes una frase en español pero le dices al programa que está en alemán para que la traduzca al inglés. La traducción será un desastre absoluto. Con el ordenador pasa igual: si intenta leer un texto como si fuera un número, o viceversa, se volverá loco. Por eso Rust es tan estricto con los tipos de datos.

Veremos más adelante que no siempre Rust infiere los tipos de datos a utilizar, e incluso a veces, queremos elegir nosotros que utilice un tipo de datos concreto. En este caso se lo tendremos que indicar de una forma explícita y coherente

=== Variables inmutables
Por defecto, en Rust, todas las cajas que creas con la palabra *let* son cajas fuertes de cristal. Puedes ver lo que hay dentro, puedes usar su valor para hacer operaciones (como multiplicar v x t), pero está completamente prohibido cambiar lo que hay dentro una vez que lo has guardado. Se llaman variables *inmutables*.

Si después de escribir *let t = 2.0;* intentas poner en la línea de abajo *t = 3.0;* para decir que ha pasado una hora más, `el compilador de Rust detendrá el programa, se enfadará y te mostrará un error en letras rojas.` Rust hace esto para protegerte: si una variable no debería cambiar, se asegura de que nadie la modifique por error.

=== Variables mutables
¿Pero qué pasa si estamos programando un videojuego y queremos guardar la puntuación del jugador? La puntuación empieza en 0, pero cambiará cada vez que elimine a un enemigo. `¡Necesitamos una caja que nos permita cambiar su contenido!.`

En Rust, para que una caja sea *modificable*, tenemos que añadir la palabra mágica *mut* (de mutable).

Mira este ejemplo:

```rust
fn main() {
    let mut puntuacion = 0; // Creamos la caja mutable y empieza en 0
    println!("Puntuación inicial: {}", puntuacion);

    puntuacion = 10; // ¡Ahora sí nos deja cambiar el valor de la caja!
    println!("¡Has ganado puntos!: {}", puntuacion);
}
```

#nota("Todo lo que hay a la derecha de las dos barras // hasta el final de la línea es un comentario y el programa lo ignora.")

Al añadir la palabra *mut*, le estás diciendo a Rust: "Ojo, el contenido de esta caja va a estar cambiando a lo largo del programa, prepárate".

=== Comentarios de línea
Aunque ya lo hemos mencionado antes en una nota, las anotaciónes con dos barras inclinadas como `// Creamos la caja mutable y empieza en 0` que podemos ver en el programa anteriort, se llaman comentarios. El ordenador ignorará esa línea desde las dos barras inclinadas incluidas hasta el final de línea. Más adelante describimos otra forma más de añadir comentarios.

== Divide y vencerás: ¿Qué es una función (fn)?
Imagina que estás cocinando siguiendo una receta gigante. En lugar de escribir paso a paso cómo se hace una masa de pizza cada vez que la necesitas, en tu libro de cocina tienes una nota que dice: "Hacer la masa de pizza (ver página 20)".

En programación, esa receta independiente se llama *Función.* Una función es un bloque de código aislado que `tiene un nombre`, `hace una tarea muy concreta` y `se puede reutilizar todas las veces que quieras en tu programa y en otros programas.`

Hasta ahora has visto la función mágica *fn main()*. Esa es la función "jefa" de Rust, el punto de partida donde el ordenador empieza a ejecutar el programa. Pero los programadores profesionales nunca meten miles de líneas de código dentro de main. En su lugar, dividen el programa en trocitos pequeños, *funciones*, por tres razones sagradas:

- *Ahorrar trabajo*: Si tienes que calcular el IVA de un producto diez veces, no escribes la fórmula matemática diez veces. Creas la función `calcular_iva` y la llamas cuando la necesites.

- *Evitar errores*: Si la fórmula del IVA cambia en el futuro, solo tienes que corregirla en un único sitio de tu programa (dentro de su función), no en las diez partes del programa que la utilizas.

- *Hacer el código legible*: Es mucho más fácil leer un programa que dice `abrir_puerta();` y `encender_luces();` que ver cincuenta líneas de programa que realizan estas dos acciones.

== A los mandos de la Playground
A continuación se describen las distintas partes y funciones de la *Rust Playground* en donde editarás y ejecutarás los programas de *Rust*.

=== El panel de control
Imagínate que la `Playground de Rust` es como el salpicadero de una nave espacial o el menú de configuración de tu videojuego favorito: está diseñado para que tengas todo lo necesario a la vista y al alcance de un clic. Cuando entres en la web, verás que la pantalla está dividida principalmente en dos grandes zonas y una barra de herramientas superior.

Accede ahora a la Playground: #link("https://play.rust-lang.org/?version=stable&mode=debug&edition=2024")[Rust Playground oficial]

*1. El lienzo de escritura (La parte izquierda):*
Es tu zona de creación. Es una gran caja blanca (o gris oscura, según el modo que elijas) que funciona como un editor de textos. Todo el código fuente que escribas, modifiques o copies se queda ahí. Verás que las líneas están numeradas a la izquierda (1, 2, 3...); esto es súper útil para saber exactamente en qué línea estás trabajando y para encontrar los errores cuando te los muestre el compilador juanto al número de línea que contiene el error.

*2. La pantalla de resultados o Consola (La parte derecha / inferior):*
Es donde el ordenador te responde. Cuando la Playground termine de procesar tu receta de código, la consola se encenderá de color gris oscuro para mostrarte las respuestas del programa (lo que llamamos la salida estándar o Standard Output) o, si te has equivocado, los mensajes de error con las pistas del compilador.

*3. Los botones de mando (La barra superior):*
En la parte de arriba tienes los botones que activan los *superpoderes* de Rust. Aunque hay varias opciones, para ser un piloto experto solo necesitas dominar estos tres botones clave:

- El botón *[RUN]* (Ejecutar): Es el botón de acción principal. Se visualiza cuando tienes una función main() en el panel izquierdo. Al pulsarlo, le ordenas a los servidores de Rust que cojan tu código fuente de la izquierda, lo compilen en milisegundos a unos y ceros y te muestren el resultado de ejecutar el programa inmediatamente en el panel de la derecha. Truco de programador: Puedes pulsar las teclas *Ctrl + Enter* en tu teclado para ejecutar la acción equivalente a pulsar el botón [RUN] sin usar el ratón.

- El botón *[TOOLS]  > Rustfmt* (Poner el código bonito): Escribiendo rápido es normal que unas líneas queden más hacia dentro que otras, que olvides dar espacios después de los signos o que el código se vea desordenado. Al pulsar sobre *Rustfmt* desplegando el botón *[TOOLS]*, la herramienta utiliza un asistente llamado `Rustfmt` que reordena y limpia visualmente tu código de forma automática. ¡Magia! Tu código se verá limpio, profesional y elegante al instante. Acostúmbrate a pulsarlo a menudo; un buen programador es siempre ordenado.

- El botón *[TOOLS] > Clippy* (Tu inspector de estilo): *Clippy* es un pequeño asistente virtual que analiza tu programa en busca de mejoras. No busca faltas de ortografía (de eso se encarga el compilador), sino que revisa si hay formas más inteligentes, modernas o eficientes de escribir lo mismo. Si pulsas Clippy desplegando el botón *[TOOLS]*, te dará sugerencias en color amarillo para que tu código sea "perfecto al estilo Rust".

=== El botón mágico: [SHARE]
A diferencia de cuando trabajas con un procesador de textos como `LibreOffice`, donde tienes que ir a `Archivo ➡️ Guardar` y generar un fichero en tu disco duro, en la Playground no existen las carpetas. Si cierras la pestaña del navegador sin hacer nada, ¡tu código desaparecerá para siempre!

Para evitar que pierdas tus trabajos o tus juegos, Rust incluye en la barra superior un botón mágico llamado *[SHARE]* (Compartir).

Cuando tu programa funcione correctamente (o si te has encallado y necesitas ayuda), haz clic sobre el botón *[SHARE]*. Al instante, la Playground hará dos cosas de forma invisible en sus servidores:

+ Guardará una "fotografía" exacta de todo el código que tienes escrito en tu pantalla izquierda.

+ Generará una dirección web (una *URL*) única y permanente para ti.

En cuanto pulses el botón, verás que aparecen cuatro opciones en la pantalla. La única que nos interesa es la primera, llamada *Permalink to the playground* (Enlace permanente). Al lado de ella verás un icono con dos rayitas horizontales: haz clic en él para copiar la dirección web automáticamente. Ahora puedes pegar (guardar) esa dirección donde quieras.

*¿Para qué sirve este enlace?*

- *Para guardar tu trabajo:* Puedes copiar ese enlace y pegarlo en un documento tuyo de notas o enviártelo por correo. Cada vez que hagas clic en ese enlace, la Playground se abrirá mostrando exactamente tu código tal y como lo dejaste.

- *Para entregar tus ejercicios:* Cuando el profesor te pida una tarea, no tendrás que enviarle pesados archivos por correo ni usar un pendrive. Simplemente tendrás que enviarle ese enlace. El profesor podrá abrir tu programa en su propio ordenador, pulsar [RUN], probar tu juego y ver en qué te has equivocado para ayudarte.

_¡Nota importante!_ Si abres un enlace de SHARE antiguo, haces cambios en el código y quieres guardar la nueva versión, tendrás que volver a pulsar el botón [SHARE] para generar un enlace nuevo. El enlace viejo nunca se modifica; siempre se queda guardado como una foto fija en el tiempo.

=== Activando superpoderes: ¿Qué es un crate?
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
// Y traemos el módulo raíz 'rand' para llamar a la función .rng()
use rand::RngExt; 

fn main() {
    // 2. Le pedimos a Rust que prepare el generador de números aleatorios
    let mut generador = rand::rng();
    
    // 3. Lanzamos el dado: simulado con .random_range(1..7)
    let numero_dado = generador.random_range(1..7);
    
    println!("🎲 Has lanzado el dado y ha salido un: {}", numero_dado);
}
```

Si pulsas el botón [RUN] varias veces seguidas, verás que la consola de la derecha te responde con un número diferente en cada intento. ¡Acabas de crear tu primer motor de azar para un videojuego!

*¿Qué ha pasado aquí?*

#nota("no es importante que entiendas el código. Fíjate solo en lo fácil que ha sido añadir superpoderes a nuestro programa. Una sola línea. ")

No obstante, aquí tienes una explicación por si te pica el gusanillo.

La primera línea, use *rand::RngExt;*, es la llave que necesitamos para trabajar con el crate *rand* que utilizamos para generar números aleatorios. Este ejemplo no forma parte de lo que es la teoría de este cuaderno. Lo hemos puesto aquí simplemente para que veas como se consiguen poderes del exterior para nuestro programa. 

Evidentemente no es suficiente con conseguir los poderes sino que luego hay que saber utilizarlos como se muestra para este caso en las líneas *let mut generador = rand::rng();* y *let numero_dado = generador.random_range(1..7);*.

Si borráramos la línea *use rand::RngExt;* el compilador se volvería loco y nos daría un error en rojo diciendo que no entiende qué significa eso de *.random_range(1..7)*. Gracias a los crates y a la Playground, tu capacidad para crear programas divertidos se vuelve infinita con solo una línea de código. Obviamente, repetimos, los crates están documentados y tenemos que aprender a utilizar los que queramos incluir en nuestro programa.

=== Lanzar el dado sin utilizar crates
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

=== Aprendiendo a leer el "idioma" del compilador
*Guía visual* para no asustarse con los mensajes en rojo (errores) y amarillo (consejos de estilo); aprendiendo a buscar la línea exacta donde está el fallo.

Cuando pulsas el botón de RUN, la Playground *compila* primero el programa y a continuación, `si no han habido errores de compilación`, lo *ejecuta*.

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

🔍 Tu plan de acción ante la pantalla roja

Cuando te enfrentes a una lista enorme de errores, sigue este protocolo para mantener la calma:

- *Paso 1: Ve siempre al primer error*. Un solo punto y coma olvidado al principio del archivo puede desencadenar 50 errores falsos en las líneas siguientes porque el compilador se desorienta. Arregla el primero de la lista y vuelve a compilar.

- *Paso 2: Copia y pega en reversa*. Si no entiendes la descripción del error, no adivines. Copia el texto explicativo (ejemplo: `error: y1_r0 holds a non-trivially copyable type`) y búscalo en Google o StackOverflow. Alguien ya se equivocó en eso mismo antes que tú. Y siempre puedes preguntar a alguna IA por el error. Indícale que estás utilizando Rust, copia el primer error mándalo al chat.

=== Tu copiloto digital: Cómo preguntar a la IA
El compilador de Rust (*rustc*) es famoso por ser uno de los más descriptivos y serviciales del mundo. Sin embargo, cuando estás empezando, sus explicaciones detalladas pueden resultar abrumadoras. Es en ese momento cuando una `Inteligencia Artificial` (*IA*) puede convertirse en tu mejor tutor personal, siempre y cuando sepas cómo comunicarte con ella.

El objetivo no es que la IA te dé el código ya resuelto para copiar y pegar, sino usarla como un puente para entender qué te está pidiendo el compilador.

📋 *El método correcto: Copiar desde la Rust Playground.*

Cuando tu código falla en la Rust Playground, la terminal inferior te mostrará el error estructurado. Para pedir ayuda de forma eficiente, debes proporcionar a la IA el *contexto completo*.

Sigue estos pasos para preparar tu consulta:

- Copia el código completo de tu ventana de edición
- Copia el mensaje de error íntegro de la consola inferior (incluyendo los bloques que dicen help: o note:, ya que Rust suele incluir ahí la solución exacta)

🦾 *Fórmulas de Prompts: Cómo pedir explicaciones (y no solo respuestas).*

Si le dices a la IA "Arréglame este código", te devolverá un bloque para copiar que funcionará, pero no habrás aprendido nada y volverás a cometer el mismo error cinco minutos después.

Para obligar a la IA a actuar como un profesor y no como un generador de código automático, utiliza estas plantillas de instrucciones (prompts):

- *Para entender el concepto:*

"Estoy aprendiendo Rust en la Playground. Mi código da este error de compilación. No me des el código corregido aún. Explícame en un lenguaje sencillo qué regla de Rust estoy rompiendo y qué significa este error."

- *Para buscar pistas:*

"Este es mi código y este es el error de Rust. Dame una pista o una guía paso a paso de qué debo modificar en mi lógica, pero no me escribas las líneas de código finales."

- *Para corregir y contrastar (Auto-evaluación):*

“No logro solucionar este error en Rust. Por favor, muéstrame el código corregido y explica detalladamente qué cambiaste línea por línea respecto a mi versión original."

=== 🛑 Las 3 reglas para no volverte dependiente de la IA
Para que tu aprendizaje en Rust sea sólido, grábate estas tres reglas cuando uses herramientas de IA:

- *Regla 1: Lee primero la sugerencia de Rust*. Antes de saltar a la IA, lee la sección help: que te da la Playground. El 80% de las veces, Rust te dice exactamente qué carácter añadir o qué función cambiar. Entrenar tu ojo para leer al compilador es tu superpoder como programador.

- *Regla 2: Prohibido el "Copiar y Pegar" a ciegas.* 
Si la IA te da una línea corregida, no la pegues sin más. Tecléala tú mismo en la Playground. El acto físico de teclear el código ayuda a tu cerebro a fijar la sintaxis (especialmente con los estrictos operadores de Rust como `&`, `*` o `mut`).

- *Regla 3: El validador final es la Playground, no la IA*. 
Las IA a veces inventan métodos o sintaxis que no existen en Rust (alucinaciones). Si la IA te dice una cosa y la Rust Playground te sigue dando rojo, la Playground siempre tiene la razón. `Trust the compiler`.

== Las notas que el ordenador ignora: Los comentarios
Cuando escribimos una receta de cocina, a veces añadimos notas al margen como "cuidado, no dejar quemar" o "el horno debe estar muy caliente". En programación hacemos exactamente lo mismo utilizando los *comentarios*.

Un comentario es un fragmento de texto que escribimos dentro de nuestro programa para explicarnos a nosotros mismos (o a un compañero) qué hace el código. Lo maravilloso de los comentarios es que *el compilador los ignora* por completo. Al traducir nuestro programa a unos y ceros, el compilador hace como si esas líneas no existieran.

En Rust, para escribir un comentario de una sola línea solo tenemos que poner dos barras inclinadas `//`. Todo lo que escribas a la derecha de esas dos barras se volverá de un color diferente en la pantalla y el ordenador no lo ejecutará.

```rust
fn main() {
    // Esto es un comentario. El ordenador no lo leerá.
    println!("¡Hola!"); // Aquí imprimimos el saludo.
}
```

También podemos escribir comentarios de varias líneas rodeándolos ente los caracteres `/* y */` como se muestra a continuación:

```rust
fn main() {
    /*Esto es un comentario de varias líneas. 
    El compilador no lo leerá y actuará
    como si no estuviera.*/
    println!("¡Hola!"); // Aquí imprimimos el saludo.
}
```

== Cuando los planes fallan: Errores de escritura vs. Errores de lógica
Para no frustrarte cuando programes, debes saber que existen dos formas muy diferentes de equivocarse en programación. Los programadores se enfrentan a ellas a diario:

+ *Errores de Compilación (Fallas de escritura):* 

Ocurren cuando escribes algo mal en el lenguaje Rust (por ejemplo, olvidar un punto y coma ;, cerrar mal un paréntesis o escribir printlin en vez de println!). El compilador, que es un árbitro implacable, se dará cuenta inmediatamente, detendrá el proceso y te mostrará letras rojas en la Playground. El programa ni siquiera llega a compilarse. Es el equivalente a intentar leer una frase con palabras inventadas que no existen en el diccionario.

+ *Errores de Lógica (El programa "funciona", pero hace lo que quiere):* 

Estos son los más tramposos. Ocurren cuando tu código está perfectamente escrito (no hay faltas de ortografía en Rust), el compilador lo traduce sin protestar a unos y ceros, le das a RUN... pero el resultado no es el que tú esperabas. Por ejemplo, si querías crear un programa que sumara dos números y por error pusiste el signo de restar `-`. Para el ordenador el programa es perfecto, pero para tu objetivo es un fracaso. Aquí el error no es de la máquina, ¡es de nuestra lógica!

#pagebreak()