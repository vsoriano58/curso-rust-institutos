#import "config.typ": *

= 🔖 Conceptos que necesitarás recordar
En este apartado vamos a incluir algunos conceptos sobre Rust de la máxima importancia. Evidentemente no están todos los que son pero si un pequeño conjunto que te resultará crucial para entender el resto del cuaderno y podrás volver aquí para revisarlos cada vez que lo necesites.

== La información que maneja un programa
Los programas informáticos se caracterizan por manejar información. Esta información pueden obtenerla de muchas formas, por ejemplo: puede estar incrustada en el mismo programa o, facilitada por el usuario a través del ratón o el teclado, mediante una conexión a una cámara web, mediante la lectura de un código de barras, mediante la lectura de ficheros que recibe desde Internet o desde otras vías; existen muchas otras formas mediante las cuales un programa puede recibir información. 

En base a las fuentes de información citadas anteriormente, podríamos clasificar la información que puede recibir ---y por tanto manejar--- un programa en muchas categorías pero, vamos a simplificar este proceso y a distinguir solamente tres categorías de información: 

- Numérica (representada por números enteros y decimales) 

- Texto (representado por una agrupación de letras o caracteres)

- Booleanos, que solo tienen dos valores (verdadero y falso)

Lo primero a reslatar es que mientras en matemáticas el conjunto de los números es infinito, en informática no lo es y tiene valores máximos y mínimos que pueden alcanzar. 

Un texto puede contener numerosos caracteres. Considérense los caracteres que contiene un libro cuyo contenido puede ser manejado íntegramente por un programa informático.

Sin embargo, el conjunto de los booleanos solo tiene dos valores, *true* (verdadero) y *false* (falso) pero, en informática son tan valiosos como los anteriores.

=== Tipos de datos reales
En el apartdo anterior hablamos de forma muy general de *números*, *textos* y *booleanos*. Sin embargo, para programar de verdad en Rust, debemos entender que el ordenador solo entiende de interruptores eléctricos (*unos* y *ceros*).

#nota("Más adelante en el tema, en el apartado 6.1.- Tipos de datos en Rust, desarrollaremos con mayor rigor el concepto que introducimos en este apartado. Lo hacemos así para que puedas entender los ejemplos de programas que vamos a estudiar en el siguiente tema sin adentrarnos todavía en una justificación teórica que es algo compleja y que dejamos para más tarde, cuando ya hayas utilizado estos conceptos desde la práctica con los ejemplos.")

Para que esos unos y ceros se conviertan en una *edad*, en tu *nombre* o en el *precio* de un videojuego, Rust necesita saber el *Tipo de Dato*. Un tipo de dato es, simplemente, la plantilla que le dice al ordenador cómo traducir esos unos y ceros de la memoria RAM para poder entenderlos.

Aunque existen muchos tipos, por ahora solo necesitas dominar de momento estos cuatro tipos sagrados:

- *Enteros (i32)*: Sirven para contar cosas completas que no se pueden partir. Tu edad, el año actual o el número de vidas de un personaje. Rust los llama *i32* (un entero de 32 bits). En la memoria ocupan por tanto un espacio de tamaño fijo.

- *Decimales (f64)*: Sirven para medir cosas precisas. El precio de una golosina (1.50), la distancia en millas (5.34) o la temperatura (23.6). Rust los llama *f64* (número en coma flotante de 64 bits). El ordenador los guarda usando una parte para el número y otra para saber dónde va el punto decimal. ¡Ojo! En programación usamos el punto ., nunca la coma , para los decimales.

- *Texto (&str y String)*: Son cadenas de letras, números y símbolos unidos, siempre encerrados entre comillas (como `"`Halcón68`"`). En la memoria, el ordenador los guarda como una lista de caracteres seguidos.

- *Booleanos (bool)*: Es el tipo más sencillo del mundo. Solo tiene dos valores posibles: *true* (verdadero) o *false* (falso). En la memoria ocupan el mínimo espacio posible: un único interruptor encendido o apagado. Sirven para tomar decisiones (¿el juego ha terminado?, ¿el usuario es mayor de edad?).

== 📢 El altavoz de tu código: Salida estándar con println!()
Un programa que calcula cosas en silencio dentro del ordenador pero no te las muestra es un programa inútil. Necesitamos un *altavoz* para comunicarnos con el usuario humano, y en Rust ese altavoz es la orden _*println!()*_.

La palabra viene del inglés Print Line (imprimir línea). Su funcionamiento parece sencillo, pero esconde dos herramientas de diseño avanzadas que verás constantemente en el laboratorio:

===  Los "Anclajes" u "Ojos de buey" {}
Cuando quieres mostrar texto combinado con variables, no puedes tirarlo todo junto. Rust utiliza las llaves *{}* como marcadores de posición o *huecos para rellenar*. Piensa en ellos como un gancho donde vas a colgar tus datos en orden. Por ejemplo:

```rust
println!("Hola {}, tienes {} años.", nombre, edad);
```
Rust leerá esa línea y la imprimirá en la pantalla colocando el valor de `nombre` en el primer {} y el valor de `edad` en el segundo {}. Si cambias el orden de las variables al final, la frase cambiará por completo.

Por ejemplo, si nombre vale `"`Juan`"` y edad vale 25, la orden anterior imprimiría por pantalla:

```
Hola Juan, tienes 25 años.
```

===  El limitador de decimales {:.N}
A los ordenadores se les da tan bien la precisión matemática que, si calculas una división o una conversión de kilómetros a millas, a veces te arrojan resultados como 8.59432210943. ¡Eso en una pantalla queda feísimo!

Para solucionarlo, Rust te permite tunear el marcador {} añadiendo instrucciones dentro. Una de las más utilizadas es *{:.2}*.

- Los dos puntos : en el interior significan: "Atención, voy a darte una instrucción de formato".

- El punto y el número dos .2 significan: "Corta el número decimal y muestra solo dos dígitos después del punto".

- Se puede generalizar a N decimales {:.N}, donde N puede valer 2, 3, 4, etc.

Ejemplo:

Si *resultado* vale 5.14367, la siguiente línea,

```rust
println!("Distancia: {:.3} km", resultado); 
```
mostraría:

 `Distancia: 5.143 km`

==  El proceso de compilación de un programa
Un poco más adelante te explicaremos de forma más detallada el funcionamiento de la *Playground de Rust*. Es básicamente una aplicación web que te permite escribir en el lado izquierdo tu programa Rust y, si no tienes errores, cuando le das al botón *[RUN]* ves en la parte derecha el resultado de ejecutar el programa. 

Si cometes errores en la escritura de tu programa la Playground no generará ningún resultado. Te marcará los mensajes de error en rojo y te dará normalmente pistas para subsanarlos. Es posible que no sigas las recomendaciones de lo que Rust considera un estilo perfecto. En tal caso te entregará mensajes en color amarillo para avisarte pero en este caso si que ejecutará el programa entregándote los resultados.

Vamos a utilizar por primera vez la Playground.

1. Pulsa sobre el enlace: #link("https://play.rust-lang.org/?version=stable&mode=debug&edition=2024")[Rust Playground oficial]

En general, el programa que nosotros escribimos se denomina programa fuente. El primero será simplemente imprimir un saludo por la pantalla. 

2. Copia el texto que tienes abajo y pégalo en la parte izquierda de la ventana de la *Playground*, borrando primero el contenido previo en caso de existir.

```rust
fn main() {
    println!("¡Bienvenido al curso de Rust!");
}
```

#nota("para borrar en la Playground, sigue los dos pasos que vienen a continuación")

- Click con el botón derecho del ratón sobre el panel izquierdo de la pantalla y elige *Seleccionar todo* en el menú contextual.

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

Si estuviéramos trabajando en un entorno de programación más complejo que la *Playground*, seguramente el código que hemos copiado y pegado se encontraría en un fichero llamado `main.rs`. *rs* es la extensión que utilizan los ficheros de Rust. Sin embargo, al trabajar con la Playground se simplifica este proceso y desaparece el concepto de fichero `main.rs`. 

Nosotros trabajaremos sencillamente con el concepto de programa, identificado con el texto que escribimos en la parte izquierda de la Playground.

Dentro de nuestro programa, en la instrucción *fn main()*, la palabra *fn* sirve para definir una función (ya veremos qué es esto) y la instrucción  *println!(`"`¡Bienvenido al curso de Rust!`"`);* imprime el mensaje *¡Bienvenido al curso de Rust!* (sin las comillas) por la pantalla.

Este *programa* fuente está escrito en un lenguaje *Rust* que el ser humano puede entender. Sin embargo, el ordenador solo entiende de unos y ceros. Para que el ordenador pueda entender y procesar el programa, existe un proceso denominado compilación que convierte el programa fuente  en otro equivalente que solo contiene unos y ceros  y que el ordenador es capaz de entender.

Podemos llamar a este fichero *ejecutable* aunque no sea totalmente exacto en todos los casos.

Podríamos resumirlo en una frase diciendo que "compilar un programa fuente lo convierte en un programa ejecutable". Esta traducción la realiza un programa denominado *compilador* y es el que genera los mensajes de error cuando nos equivocamos al escribir el programa fuente. El programa ejecutable, como su nombre indica, puede ser ejecutado por nuestro sistema operativo, el sistema bajo el cual se ha compilado, de una forma prácticamente idéntica en Linux, MacOS o Windows. 

El programa fuente, el que entiende el humano, es idéntico en las tres plataformas anteriores pero al compilar, cada plataforma genera un código ejecutable que solo ella es capaz de entender.

Como nosotros utilizaremos la *Rust Playground* desde la Web, da igual el sistema operativo desde el que accedamos a esta aplicación web: no se van a generar ficheros compilados que nosotros podamos ver y todos estaremos en las mismas condiciones. Por supuesto, podremos intercambiar entre nosotros los programas fuente como el que acabamos de ver, independientemente de la plataforma desde la que los hayamos creado y en la que vayamos a ejecutarlos.

==  Qué es una variable en programación
Reconocemos que es un poco aventurado explicar qué es una variable en programación sin apenas haber escrito código. Sin embargo, partimos de la base de que ya has utilizado variables al resolver problemas en matemáticas o física. Ese concepto, aunque no es exactamente igual en informática, es un punto de partida perfecto.

En clase de física, por ejemplo, decimos:

- v = 50.5 (Velocidad en Km/h)

- t = 2 (Tiempo en horas)

- e: Espacio recorrido (en Km)

Para calcular el espacio, aplicas la fórmula:

$ e = v * t = 50.5 * 2 = 101 K m $

En física usas esas letras para guardar números. En informática hacemos lo mismo, pero con una gran diferencia: el ordenador necesita guardar esos valores dentro de su memoria RAM y necesita saber qué tipo de información va a meter dentro.

Imagína que la memoria del ordenador es un almacén gigante lleno de *cajas de cristal* para almacenar *variables*. Para usar una caja, necesitas hacer dos cosas:

+ Ponerle una etiqueta con un nombre (para encontrarla rápido)

+ Decirle al ordenador qué tipo de objeto vas a guardar dentro (un número entero, un número con decimales, un texto...), porque cada tipo de dato necesita una caja de tamaño diferente.

Mira cómo escribiríamos el problema de física anterior en `Rust`. 

Copia este código en tu Playground y pulsa *[RUN]*:

```rust
fn main() {
    let v = 50.5;
    let t = 2.0;
    let e = v * t;
    println!("Espacio recorrido = {} Km", e);
}
```
Con *fn* definimos la función *main()* que es el punto de entrada al programa, por donde empieza a ejecutarse. Lo que hay entre las llaves *{}* es el código de la función main(), lo que se ejecutará al pulsar *[RUN]*.

- *¿Qué significa let?* Es la palabra que usamos en *Rust* para *fabricar* una *caja nueva* en la memoria. *let v = 50.5;* significa: "Créame una caja llamada *v* y guarda dentro el número decimal *50.5*".

- *¿Por qué es genial Rust?* Te habrás fijado en que no le hemos dicho a Rust qué tipo de caja queríamos. Rust es un lenguaje inteligentísimo: ve que ponemos un 50.5 (con un punto decimal) y él solo deduce: "¡Ah! Esto es un número decimal, usaré una caja para decimales". Esto se llama inferencia de tipos. No siempre puede proceder así. A veces el programador debe indicar el tipo de dato que va a meter en la caja.

- *¿Qué pasa si nos equivocamos de caja?* Imagina que vas al Traductor de Google, escribes una frase en español pero le dices al programa que está en alemán y que la traduzca al inglés. La traducción será un desastre absoluto. Con el ordenador pasa igual: si intenta leer un texto como si fuera un número, o viceversa, se volverá loco. Por eso Rust es tan estricto con los tipos de datos.

Veremos más adelante que no siempre Rust infiere los tipos de datos a utilizar, e incluso a veces, queremos elegir nosotros que utilice un tipo de datos concreto. En este caso se lo tendremos que indicar de una forma explícita y coherente

=== Variables inmutables
Por defecto, en Rust, todas las cajas que creas con la palabra *let* son cajas fuertes de cristal. Puedes ver lo que hay dentro, puedes usar su valor para hacer operaciones (como multiplicar v x t), pero está completamente prohibido cambiar lo que hay dentro una vez que lo has guardado. Se llaman variables *inmutables*.

Si después de escribir *let t = 2.0;* intentas poner en la línea de abajo *t = 3.0;* para decir que ha pasado una hora más, "el compilador de Rust detendrá el programa, se enfadará y te mostrará un error en letras rojas". Rust hace esto para protegerte: si una variable no debería cambiar, se asegura de que nadie la modifique por error.

=== Variables mutables
¿Pero qué pasa si estamos programando un videojuego y queremos guardar la puntuación del jugador? La puntuación empieza en 0, pero cambiará cada vez que elimine a un enemigo. "¡Necesitamos una caja que nos permita cambiar su contenido!".

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

#nota("Todo lo que hay a la derecha de las dos barras // (incluidas) hasta el final de la línea es un comentario y el programa lo ignora.")

Al añadir la palabra *mut*, le estás diciendo a Rust: "Ojo, el contenido de esta caja va a estar cambiando a lo largo del programa, prepárate".

== Las notas que el ordenador ignora: Los comentarios
Cuando escribimos una receta de cocina, a veces añadimos notas al margen como "cuidado, no dejar quemar" o "el horno debe estar muy caliente". En programación hacemos exactamente lo mismo utilizando los *comentarios*.

Un comentario es un fragmento de texto que escribimos dentro de nuestro programa para explicarnos a nosotros mismos (o a un compañero) qué hace el código. Lo maravilloso de los comentarios es que *el compilador los ignora* por completo. Al traducir nuestro programa a unos y ceros, el compilador hace como si esas líneas no existieran.

En Rust, para escribir un comentario de una sola línea solo tenemos que poner dos barras inclinadas `//`. Todo lo que escribas a la derecha de esas dos barras, incluyendo las dos barras, se volverá de un color diferente en la pantalla y el ordenador no lo ejecutará.

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

== Divide y vencerás: ¿Qué es una función (fn)?
Imagina que estás cocinando siguiendo una receta gigante. En lugar de escribir paso a paso cómo se hace una masa de pizza cada vez que la necesitas, en tu libro de cocina tienes una nota que dice: "Hacer la masa de pizza (ver página 20)".

En programación, esa receta independiente se llama *Función.* Una función es un bloque de código aislado que `tiene un nombre`, `hace una tarea muy concreta` y `se puede reutilizar todas las veces que quieras en tu programa y en otros programas.`

Hasta ahora has visto la función mágica *fn main()*. Esa es la función "jefa" de Rust, el punto de partida donde el ordenador empieza a ejecutar el programa. Pero los programadores profesionales nunca meten miles de líneas de código dentro de main. En su lugar, dividen el programa en trocitos pequeños, *funciones*, por tres razones sagradas:

- *Ahorrar trabajo*: Si tienes que calcular el IVA de un producto diez veces, no escribes la fórmula matemática diez veces. Creas la función `calcular_iva` y la llamas cuando la necesites.

- *Evitar errores*: Si la fórmula del IVA cambia en el futuro, solo tienes que corregirla en un único sitio de tu programa (dentro de su función), no en las diez partes del programa que la utilizas.

- *Hacer el código legible*: Es mucho más fácil leer un programa que dice `abrir_puerta();` y `encender_luces();` que ver cincuenta líneas de programa que realizan estas dos acciones.



#pagebreak()