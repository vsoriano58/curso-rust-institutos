#import "config.typ": *

= 🔖 Laboratorio
Como vamos a trabajar en la *Rust Playground*, para probar un programa podrás copiarlo del cuaderno y pegarlo en la parte izquierda de la ventana de la Playground. No obstante, si te has descargado el repositorio de los cuadernos también tienes allí los mismos códigos guardados en ficheros con el mismo nobre que se indica en el cuaderno. Puedes también copiar los códigos desde los ficheros y pegarlos en la playground.

== Sección 1: Despegue
A partir de esta sección empezaremos a programar y explicar distintos ejemplos para que consolides lo que has aprendido en teoría y te diviertas modificando y ejecutando los ejercicios que proponemos.

=== El programa hola mundo
El siguiente programa debe presentar en la pantalla el texto: *¡Hola, Mundo desde la Playground!*

- Lee los comentarios y ejecuta el programa pulsando el botón *[RUN]* o *[CONTROL]  + [ENTER]* en tu Playground.

- Sustitute el mensaje que se imprime por otro mensaje alternativo de tu elección y vuelve a ejecutar el programa.

Fichero: *hola_mundo.rs*

```rust
// Bienvenidos a vuestro primer programa en Rust.
// Las dos barras // sirven para escribir notas 
// que el ordenador ignora.

fn main() {
    // Todo programa en Rust empieza a ejecutarse dentro de estas llaves { }
    
    println!("¡Hola, Mundo desde la Playground!"); 
    
    // 💡 El punto y coma ';' al final indica que la orden ha terminado.
}
```

A simple vista parece poca cosa, pero aquí dentro se esconden las tres reglas sagradas de la estructura de Rust que debes memorizar:

1. *La Llave de Entrada* al programa, la función *fn main():*
La palabra *fn* significa *función* (un bloque de código que hace una tarea). La palabra *main* significa *principal* en inglés. En Rust, todo, absolutamente todo lo que quieras que tu ordenador ejecute, debe vivir dentro de la función principal. Es la puerta de acceso a la memoria. Más tarde veremos que pueden tambíen existir funciones que se escriben fuera de la función main, arriba o abajo de la misma.

2. *El Contenedor (Las llaves { }):* 
Las llaves actúan como las paredes de una habitación. La llave de apertura *{* marca dónde empieza a trabajar el ordenador y la llave de cierre *}* marca el final del camino. Si dejas una habitación sin una de sus paredes o las dos, el programa se romperá.

3. *El Emisor de Píxeles, println!(`“`texto`”`):* 
Esta orden (que se pronuncia print-line) toma el texto que escribas entre comillas y lo estampa en la pantalla negra de la derecha.

*Veamos algunos detalles importantes:*

*A) El punto y coma ; y los comentarios*

Si miras con atención el código anterior, notarás dos detalles cruciales: el punto y coma final y el uso de anotaciones.

- *El cierre de orden con “;”:*
Cada vez que le das una instrucción de acción al ordenador, debes terminar la línea con un punto y coma. Piensa en él como el punto final de una frase en un libro. Si lo omites, el ordenador se quedará esperando y no sabrá dónde termina una orden y dónde empieza la siguiente. Solo algunas líneas muy concretas en los programas no se finalizan con punto y coma. Obsérvalo en los listados para que no te pase desapercibido.

- *Los comentarios (`//`):* 
Si en cualquier parte de tu pantalla escribes dos barras seguidas `//`, todo lo que escribas a continuación en esa misma línea incluidas las dos barras se volverá de color gris. El ordenador ignorará por completo ese texto. 

Sirve para que tú, como programador, dejes notas explicativas para ti mismo o para tus compañeros.

*B) Las reglas del juego: ¿Qué pasa cuando rompemos el código?*

Programar consiste en experimentar, equivocarse y aprender a corregir. 

Si intentas ejecutar el siguiete  código en la Playground obtendrás errores que en el listado hemos señalado con dos comentarios que empiezan por una cruz roja  ❌ ¡peligro!:

```rust
fn main() {
    println!("Esto dará un fallo") // ❌ <--- error, no funcionará
    
    print_pantalla!("Hola"); // ❌ <--- error, no funcionará
}
```

❌ *Control de Daños, ¿en qué consiste?:*

Cuando un programa no funcione debido a un error en rojo del compilador, tu red de seguridad inmediata es comentar la línea que produce el error. El compilador te indicará el número de la línea. Añade `//` al principio de la instrucción que falla. Al hacerlo, la línea se volverá gris, el compilador la pasará de largo y te permitirá ejecutar el resto del programa (si es posible sin esa línea) para comprobar que lo demás está bien.

=== Qué hacer cuando obtenemos errores del compilador
En el apartado anterior aprendiste la teoría del "control de daños", y ahora vamos a ponerla en práctica. Si intentas pulsar *[RUN]* en la Playground con el código de abajo tal cual está, verás que la pantalla se tiñe de rojo. El compilador se ha negado a compilar el programa. 

Vamos a jugar a los detectives para entender qué está pasando aquí dentro analizando el programa:

Fichero: *destripando_main.rs*

```rust
fn main() {
    // En Rust, la orden para mostrar texto en pantalla lleva un signo de exclamación: println!()
    println!("Esto funciona perfectamente");

    // ¿Qué pasa si olvidamos el punto y coma al terminar la orden?
    println!("Esto dará un fallo")  // ❌ <--- error, no funcionará
    
    // ¿Qué pasa si escribimos mal el nombre de la función?
    print_pantalla!("Hola");        // ❌ <--- error, no funcionará
}
```
🕵️ *Experimento 1: El punto y coma fantasma*

Fíjate en la consola de errores de la Playground. El compilador se queja en la línea 6. Te dice algo como: *help: add `;` here* . Debes añadir un punto y coma donde te indica. Como no pusiste el punto y coma, Rust se ha desorientado y piensa que la orden se ha fusionado con lo que viene después. 

Vamos a copiar las lineas que describen el error tal cual las entrega el compilador:

#figure(
  image("img1.png", width: 100%),
  caption: [
    _Error:_ expected `;`, found `print_pantalla`
  ],
) <fig1>

- *Misión:* Aplica el control de daños. Añade dos barras `//` al principio de la línea 6 para que se vuelva gris. Vuelve a pulsar [RUN]. El compilador seguirá marcandote el error de la linea 9.

🕵️‍♂️ *Experimento 2: El idioma inventado*

Al comentar la línea 6, el compilador por fin puede avanzar... ¡pero vuelve a protestar! Ahora el error se desplaza a la línea 9. El compilador te dice `error: cannot find macro print_pantalla in this scope`. Rust es muy estricto con las palabras sagradas; si inventas una orden que no existe en su diccionario (como print_pantalla! en lugar de println!), la máquina se detiene porque no sabe qué instrucciones enviar a la pantalla.

- *Misión:* Corrige la línea 9 cambiando print_pantalla! por println!. Quita también las barras `//` de la línea 6 y ponle el punto y coma ; que le faltaba al final de la línea. ¡Vuelve a compilar y disfruta de tu pantalla en verde!

=== Tipos e inferencia
Vamos a trabajar con el código del fichero que indicamos un poco más abajo.

- La instrucción: *let edad: i32 = 14;* significa que declaramos la variable edad como entera de 32 bits y la inicializamos con el entero 14.

- La instrucción *let nombre: &str = `"`Halcón68`"`;* significa que declaramos la variable `nombre` como texto y la inicializamos con la cadena de texto `"Halcón68"` sin las comillas.

Fichero: *tipos_e_inferencia.rs*

```rust
fn main() {
    // 1. Declaración Explícita (Le decimos a Rust exactamente qué tipo es)
    // i32 significa: Número Entero de 32 bits (números sin decimales)
    let edad: i32 = 14; 
    
    // &str significa: Cadena de texto (letras entre comillas)
    let nombre: &str = "Halcón68"; 

    println!("Alumno: {}, Edad: {} años", nombre, edad);

    // Intentar guardar un texto en una caja reservada para números:
    let puntos: i32 = "diez";   // ❌ <--- error, no funcionará

    // 2. La Magia de la Inferencia (Rust es listo y adivina el tipo)
    let nivel = 1;  // Rust sabe automáticamente que es un número entero (i32)
    let lenguaje = "Rust";   // Rust sabe automáticamente que es texto (&str)
    
    println!("Estudias el nivel {} de {}", nivel, lenguaje);
}
```

🖥️ Copia y pega el programa anterior en la Playground. Ejecuta el programa pulsando sobre el botón *[RUN]*.  Se producirá el siguiente error en la playground:

```
--> src/main.rs:12:23
   |
12 |     let puntos: i32 = "diez";   // ❌ <--- error, no funcionará
   |                 ---   ^^^^^^ expected `i32`, found `&str`
   |                 |
   |                 expected due to this

```

Efectivamente. Declaraste la variable *puntos* como entera de 32 bits, *let puntos: i32 = "diez";*  pero le asignaste el texto “diez”. Rust es muy estricto con los tipos. Si declaras una variable de un tipo, en el ejemplo *i32*, luego no puedes asignar a esa variable un valor de otro tipo, por ejemplo de tipo *Texto* como ocurre en el programa. Por eso el compilador generó el error.

Comenta esa línea con dos `//` barras al principio y vuelve a ejecutar con [RUN] para obtener los resultados esperados. Debes ver la línea así: ( `//` let puntos: i32 = `"`diez`"`; ).

En la programación, guardar información es como organizar una mudanza: necesitas cajas de cartón. Rust es increíblemente ordenado y exige saber qué tipo de objeto va dentro de cada caja para que nada se rompa por el camino.

Ejecuta nuevamente este código en tu Playground para ver cómo gestiona Rust sus "cajas" (a las que llamamos *variables*).

A continuación te proponemos *repetir de nuevo los pasos anteriores* para que interiorices bien este proceso de detección y comprensión de errores y tengas alguna herramienta para poder (cuando sea posible) anular el error y que el programa siga ejecutándose hacia abajo en el código.

🕵️ *Experimento 1: El conflicto de las cajas*

Si pulsas *[RUN]* tal como estaba el código al principio, la Playground se detendrá en la línea *let puntos: i32 = `"`diez`"`;* donde intentamos crear los puntos. El compilador te lanzará un error cristalino al principio con letras blancas en fondo rojo: *mismatched types (tipos que no coinciden).*

Le has dicho a Rust: Voy a crear una caja para números enteros *i32* pero luego has intentado meter dentro la palabra *diez* escrita con letras *&str*. Rust se niega en redondo a mezclar churras con merinas para evitar que el programa falle en el futuro.

- *Misión:* Aplica el control de daños. Comenta la línea que falla añadiendo `//` al principio para que se vuelva gris. Vuelve a pulsar *[RUN]*.

🧠 Los dos conceptos sagrados de este código:

+ *Las etiquetas de las cajas (let):* En Rust, cada vez que quieres crear una variable nueva, tienes que usar la palabra mágica let. Piensa en ella como la orden de "fabricar una caja nueva en la memoria".

+ *La Magia de la Inferencia:* Fíjate en las variables *nivel* y *lenguaje*. ¡No les hemos puesto los dos puntos : ni el tipo de datos! Rust tiene un cerebro digital tan potente que lee el valor de la derecha, ve un 1 y deduce él solo: "Vale, esto es un número entero, no hace falta que el programador me lo especifique", prepararé una caja i32 para enteros. Luego en esta caja no puedes meter un texto.

+ A este superpoder de adivinar el tipo se le llama Inferencia de tipos y solo es posible cuando en una asignación con el operador *=*, el tipo de la parte derecha del igual es cococido y se le asigna a la parte izquierda del igual.

=== Mis primeras funciones
Vamos a poner en práctica la teoría del "divide y vencerás". En este experimento, a continuación de esta explicación teórica, vamos a crear tres funciones propias fuera del main y vamos a darle órdenes personalizadas al ordenador. Es decir, le diremos al main que ejecute esas funciones

#nota("Las funciones se escriben fuera del main y pueden estar tanto arriba como abajo del main.")

En primer lugar vamos a describir desde `un punto de vista más teórico` tres conceptos clave:

+ * Qué es una función* 
+ * Qué son los parámetros -y sus tipos ascoiados- de una función* 
+ * Que son los argumentos pasados a los parámetros de una función*

Vamos a hacer el razonamiento sobre un pequeño programa de ejemplo que explicaremos prácticamente línea a línea: Es el siguiente:

```rust
fn sumar_numeros(a: i32, b: i32) {
    let resultado = a + b;
    println!("La suma de {} + {} es: {}", a, b, resultado);
}
fn main() {
    sumar_numeros(3, 4); // Pasamos los ingredientes correctos
}
```
#nota("La función sumar_numeros acepta dos numeros a y b, calcula la suma, la coloca en la variable resultado y finalmente imprime a, b y resultado en los huecos {}.")

Lo primero que debemos observar es que la función, denominada *sumar_numeros*, se define fuera de la función *main* mediante este código:

```rust
fn sumar_numeros(a: i32, b: i32) {
    let resultado = a + b;
    println!("La suma de {} + {} es: {}", a, b, resultado);
}
```

La primera línea utiliza *fn* para definir el nombre de la función: *sumar_numeros*, sus dos parámetros: *a* y *b* y los tipos de esos parámetros que son enteros *i32*.

La potencia de las funciones se observa cuando se llaman desde la funcion *main* o desde cualquier otra función. En el ejemplo, nosotros llamamos a la funcion *sumar_numeros* en la única línea que tiene nuestra función *main*:

```rust
sumar_numeros(3, 4);
```

¿Qué pasa cuando se ejecuta la línea de arriba? Vayamos por partes:

+ El programa *abandona la ejecución del main* en esa misma línea y *ejecuta* la funcion *sumar_numeros*.

+ Para ello, copia en el parámetro *a* de la función el argumento *3* que le pasamos en la línea anterior (la llamada a la función) y en el parámetro *b* el argumento *4*.

+ A continuación ejecuta las dos líneas del cuerpo de la función pero tomando *a = 3* y *b = 4*. Primero realiza la suma y luego imprime por pantalla.

+ Finalmente, el programa abandona la función *sumar_numeros* y regresa a la linea siguiente desde la que salto, es decir, a la linea siguiente de *sumar_numeros(3, 4);* en la función main y sigue hasta que la función main termine. En realidad, nosotros ya no tenemos nada en el main después de sumar_numeros(3, 4); luego cuando el programa regresa al main despues de haber ejecutado la función sumar_numeros, inmediatamente termina.

+ Es posible que una función no tenga parámetros como la función *saludar_alumno* del siguiente ejemplo, en cuyo caso, tampoco se le pasan argumentos al llamarla.

Como vemos, el programa realiza un viaje de ida y vuelta a la función y realiza una tarea (en este casos sumar dos números e imprimir el resultado) sin que el código para realizar la suma esté escrito dentro de la función main, está en el cuerpo de la función sumar_numeros.

Al definir la función hemos definido los parametros a y b como números enteros (a: i32, b: i32) y luego le hemos pasado argumentos enteros al llamar la función con *sumar_numeros(3, 4);*, hemos pasado a = 3 y b = 4 y por eso funciona. Si hiciéramos la llamada *sumar_numeros(3.5, 4);* el programa se rompería y nos arrojaría un error. El argumento *a* no puede ser decimal.

Veamos un ejemplo un poco más completo en acción.

💻 Copia este código en tu Playground:

Fichero: *mis_primeras_funciones.rs*

```rust
// 1. Fabricamos nuestra primera función propia
// Esta función no necesita parámetros, solo ejecuta una acción visual
fn saludar_alumno() {
    println!("👋 ¡Hola, Alumno de Rust!");
    println!("🚀 Bienvenido a tu zona de entrenamiento.");
}

// 2. Fabricamos una función que hace un cálculo matemático
// Le pedimos que nos multiplique un número por 2
fn duplicar_numero(numero: i32) {
    let resultado = numero * 2;
    println!("🔢 El doble de {} es: {}", numero, resultado);
}
// 3. Una función con DOS ingredientes para sumar
fn sumar_numeros(a: i32, b: i32) {
    let resultado = a + b;
    println!("➕ La suma de {} + {} es: {}", a, b, resultado);
}

fn main() {
    println!("🏁 El programa principal (main) se ha iniciado.\n");

    // 💡 LLAMADA A LAS FUNCIONES: Aquí despertamos a nuestras recetas
    saludar_alumno(); // El ordenador salta al código de la función
    
    println!("\n--- Haciendo cálculos en el laboratorio ---");
    
    duplicar_numero(10); // Le pasamos el número 10 como ingrediente
    duplicar_numero(50); // Reutilizamos la misma función con otro dato
    
    println!("\n🔚 El programa principal va a terminar.");
    sumar_numeros(3, 4); // Pasamos los ingredientes correctos
    
        // ❌ Error provocado para el laboratorio:
        // sumar_numeros(3.2, 4); 
}
```

⚙️  *Experimento 1: El salto del ordenador*

Si pulsas *[RUN]*, verás que el texto de salida en la pantalla aparece perfectamente ordenado. El ordenador *entra en el main*, imprime la bandera de salida, y al leer *saludar_alumno();* detiene lo que está haciendo, "viaja" arriba a donde empieza la función, ejecuta los dos saludos y vuelve a *main* para seguir con la siguiente línea. La función saludar_alumno() no tiene parámetros por lo tanto, no recibe argumentos en la llamada.

- *Misión:* Intenta duplicar la línea *saludar_alumno();* en el main para que aparezca dos veces seguidas. Vuelve a pulsar [RUN]. Verás cómo el saludo se repite en pantalla sin necesidad de que hayas tenido que volver a teclear los dos println! originales. ¡Has ahorrado código!

🧠 *Los "ingredientes" de una función*

Fíjate en la función *duplicar_numero(numero: i32)*. Lo que hay dentro de sus paréntesis (numero: i32 ) es su ingrediente (en programación lo llamamos parámetro). Le estamos diciendo a Rust: "Para que esta función realice su trabajo, necesita que le den un número (argumento) entero (i32)". Al llamarla desde el main con *duplicar_numero(10);*, la función atrapa el 10 (el argumento) y lo asigna al parámetro a, lo multiplica por 2 y nos muestra el resultado en la pantalla de forma limpia.

⚙️  *Experimento 2: El diccionario de la programación y el guardián de la puerta*

Si miras la última función añadida, *fn sumar_numeros(a: i32, b: i32)*, descubrirás cómo hablan los programadores profesionales. Es un lenguaje técnico muy sencillo de entender:

- Los *parámetros* (a: i32, b: i32): Son las variables que escribimos en la definición de la función. Son los "moldes" o los "huecos reservados". Le dicen a Rust: "Para poder sumar, necesito que me prepares dos huecos para números enteros".

- Los *argumentos* (3 y 4): Son los valores reales y vivos que le pasamos a la función cuando la llamamos dentro del main(). El 3 se mete en el hueco de la a y el 4 en el de la b.

🛑 *Rompiendo el guardián de Rust (Prueba de laboratorio)*

Quita las dos barras `//` de la última línea (sumar_numeros(3.2, 4);) y pulsa *[RUN]*.

- *El resultado:* La Playground se volverá a teñir de rojo con un error de *mismatched types*. El compilador te dirá que esperaba un entero i32 pero le has enviado un decimal flotante (un decimal, a todos los efectos).

- *La lección:* En Rust, las funciones tienen un guardián ultra-estricto en la puerta. Si la receta pide un número entero sin partir (i32), no puedes intentar colarle un decimal con tropiezos (3.2). Rust prefiere romper el programa antes de permitir que una función cocine con los ingredientes equivocados.

- *Corrección:* Vuelve a poner las barras `//` para dejar el laboratorio funcionando en verde.

Lo mismo ocurriría si la funcion espera un valor booleano (false o true) en uno de sus parámetros y le pasamos un entero i32.

== Sección 2: Cajas y permisos
Para poder manejar información, el programa debe acceder a los lugares de la memoria en donde está almacenada. Vamos a hacer un simil entre variables del ordenador que almacenan la información y cajas que contienen información con persmisos para que esa información *solo pueda ser vista* (leida) o por contra, para que *pueda ser vista y modificada* (reescrita).

=== La palabra `let` para variables inmutables
En otros lenguajes de programación, cuando creas una caja (variable) puedes cambiar lo que hay dentro siempre que quieras. En Rust, las cosas son diferentes. Rust es un lenguaje diseñado para ser ultra-seguro, y para evitar accidentes aplica una regla muy estricta: *todas las cajas nacen cerradas con llave*. Cuando creas una variable con *let*, por ejemplo en el código de abajo con *let puntuacion = 10;* posteriormente en el programa ya no podrás cambiar el valor de la variable puntuación. Veremos que hay otra forma de proceder en la que si se puede cambiar el valor de las variables después de haberles asignado el primer valor.

💻 Ejecuta este código en tu Playground y mira qué pasa cuando intentas romper esa regla:

Fichero: *cajas.rs*

```rust
fn main() {
    // En Rust, cuando creamos una variable (una caja) es como cerrarla con un candado.
    let puntuacion = 10;
    println!("Tu puntuación inicial es: {}", puntuacion);

    // Intentamos cambiar el valor de la caja cerrada:
    puntuacion = 20; // ❌ <--- error, no funcionará

    // El ordenador no te dejará ejecutar el programa porque por defecto las variables 
    // son "inmutables" (no se pueden cambiar) para evitar accidentes.
}
```

⚙️ *Experimento 1: El candado de Rust*

Al pulsar *[RUN]*, la Playground se detendrá en seco en la línea donde intentas cambiar la puntuación a 20. El compilador te mostrará un *mensaje de error* que dice algo como: cannot assign twice to immutable variable (*no se puede asignar dos veces a una variable inmutable*).

Para Rust, la palabra *Inmutable* significa "prohibido tocar tras su fabricación". Si tú creas con *let* una caja con un 10 dentro, ese valor se queda congelado para siempre.

- *Misión:* Aplica el control de daños que ya conoces. Añade las dos barras `//` al principio de la línea que da error (puntuacion = 20;). Vuelve a pulsar *[RUN]* para comprobar que el programa compila en verde y muestra el mensaje inicial en la pantalla.

💡 *¿Por qué hace esto Rust?*

Imagina que estás programando un videojuego gigante y creas una variable para la velocidad máxima del personaje. Si cualquier parte del código pudiera cambiar esa variable por accidente, el juego podría volverse loco. Al poner un candado por defecto (*let*) a esta variable, Rust se asegura de que `nadie cambie datos importantes sin tu permiso explícito`.

=== Las palabras `let mut` para variables mutables
¿Y qué pasa si realmente necesitamos cambiar el valor de una caja? Por ejemplo, las vidas de un jugador, la puntuación o el nivel actual. Para esos casos, Rust nos da una llave especial: la palabra mágica *mut* (abreviatura de mutable, que significa "capaz de cambiar").

💻 Copia este código en tu Playground y observa cómo cambia el comportamiento del compilador.

Fichero: *mutacion.rs*

```rust
fn main() {
    // Al añadir la palabra 'mut', le ponemos una etiqueta de "permitido cambiar" a la caja.
    let mut vidas = 3;
    println!("Empiezas la partida con {} vidas.", vidas);

    // Como la caja tiene el permiso 'mut', ahora sí podemos modificar su contenido:
    vidas = 2; 
    println!("¡Te ha tocado un enemigo! Ahora te quedan {} vidas.", vidas);

    // ⚠️ ¡Cuidado! Puedes cambiar el valor, pero NO el tipo de dato que guarda la caja:
    vidas = "cero"; // ❌ <--- error, no funcionará

    // Explicación: La caja 'vidas' se creó para guardar números enteros. 
    // No puedes meter texto dentro de una caja de números.
}
```

⚙️ *Experimento 1: La mutación exitosa y el límite de Rust*

Si pulsas [RUN], verás que la Playground se tiñe de rojo al llegar a la línea donde pone *vidas = `"`cero`"`;*. El compilador te lanzará otra vez el error de mismatched types (tipos que no coinciden). Intentaste colocar el texto `"`cero`"`en la variable *vidas* que por inferencia de tipos es de tipo *i32*. La inferencia se produjo en la línea *let mut vidas = 3;*.

- *Misión:* Aplica tu técnica de control de daños. Comenta la línea donde intentas meter la palabra "cero" en la variable *vidas* escribiendo `//` al principio. Vuelve a pulsar *[RUN]* para ver el programa funcionar de principio a fin de forma impecable.

Ahora el programa consigue ejecutar las dos primeras órdenes de texto sin problemas. ¡Hemos logrado cambiar las vidas de *3* a *2* gracias a *let mut*!

🧠 *La lección clave: Permiso para cambiar, no para transformarse*

Este experimento nos enseña una de las reglas más importantes de Rust:

- *mut* te da permiso para cambiar el contenido de la caja (el número 3 por el número 2)

- mut *NO* te da permiso para cambiar la naturaleza de la caja. Si la caja nació para guardar números enteros, morirá guardando números enteros. No puedes transformarla de repente en una caja de texto.

=== Prácticas sobre permisos en el laboratorio
Para terminar esta sección, vamos a simular el motor de un videojuego real. Aquí vas a ver cómo un programador decide, antes de empezar, qué cajas deben llevar candado y cuáles deben quedarse abiertas con *mut*. Además, nos enfrentaremos a un error muy común: los despistes al teclear.

💻 Copia este código en tu Playground y prepárate para resolver el misterio.

Fichero: *operaciones_laboratorio.rs*

```rust
fn main() {
    // Datos fijos del juego (no necesitan cambiar, van sin 'mut')
    let nombre_jugador = "Halcón68";
    let puntos_por_enemigo = 150;

    // Datos dinámicos del juego (van a cambiar, necesitan 'mut')
    let mut puntuacion_total = 0;
    let mut nivel_actual = 1;

    println!("--- ESTADÍSTICAS DE {} ---", nombre_jugador);
    println!("Nivel: {} | Puntos: {}", nivel_actual, puntuacion_total);

    // El jugador derrota a un enemigo: aumentamos la puntuación

    // ⬇️  ❌ --- error, no funcionará
    puntuacion_total = puntuacion_total + points_por_enemigo;
    // (Nota: ¡Ojo con el inglés! La variable se llama 'puntos_por_enemigo')

    // Corrección del error (sustituye la línea erronea de arriba por esta):
    // puntuacion_total = puntuacion_total + puntos_por_enemigo;
    nivel_actual = 2;

    println!("--- ¡ENEMIGO DERROTADO! ---");
    println!("Nivel: {} | Puntos Totales: {}", nivel_actual, puntuacion_total);
}
```

⚙️ *Experimento 1: El error de traducción*

Si pulsas [RUN], la Playground se detendrá en la línea inferior al comentario con un cruz en rojo. El compilador te dirá: *cannot find value points_por_enemigo in this scope* (no se encuentra el valor en este ámbito).

*¿Qué ha pasado?* La variable mutable *puntuacion_total* está bien escrita, pero al hacer la suma hemos escrito *points_por_enemigo* (en inglés) en lugar de *puntos_por_enemigo* (en español). Para el ordenador, cambiar una sola letra es como hablarle en un idioma totalmente diferente.

- *Misión* (Arreglar en lugar de comentar): Esta vez no vamos a usar el control de daños de ocultar la línea con `//`. Vamos a arreglarla de verdad. Cambia la palabra *points_por_enemigo* por *puntos_por_enemigo*. Vuelve a pulsar *[RUN]* y observa cómo el juego calcula la puntuación y te sube de nivel con éxito.

🧠 *La lección de diseño: ¿Cuándo usar mut?*

Fíjate en la estrategia que hemos usado: *nombre_jugador* y *puntos_por_enemigo* no cambian durante la partida. Se quedan *sin mut*. Son seguros y eficientes. *puntuacion_total* y *nivel_actual* se están recalculando constantemente. Necesitan *mut* obligatoriamente.

A partir de ahora, cada vez que crees una variable, hazte la pregunta mágica: ¿Este dato va a cambiar a lo largo del programa? Si la respuesta es no, no le pongas mut.

== Sección 3: Tomar decisiones en el código (if, else if, else)
Para que un programa sea inteligente y dinámico, debe ser capaz de tomar decisiones basadas en diferentes condiciones. Aquí es donde entran en juego las estructuras condicionales *if*, *else if* y *else*. Estas herramientas nos permiten evaluar si una condición es verdadera o falsa y, a partir de ahí, decidir qué bloques de código se deben ejecutar y cuáles se deben ignorar.

Es importante destacar que estas estructuras son completamente modulares y adaptables a tus necesidades:

- El *if* es el único elemento obligatorio para abrir un bloque condicional.

- El *else if* no es obligatorio, y puedes usar tantos como necesites para evaluar múltiples condiciones alternativas.

- El *else* tampoco es obligatorio; sirve únicamente como un "salvavidas" final para ejecutar código cuando ninguna de las condiciones anteriores se ha cumplido.

=== Tomar decisiones en base a preguntas en el código

A continuación analizamos un ejemplo.

💻 Copia este código en tu Playground y lee la explicación del código

Fichero: *tomar_decisiones.rs*

```rust
fn main() {
    // Definimos una variable de ejemplo
    let puntuacion = 85;

    // 1. Un "if" en solitario (completamente válido)
    if puntuacion >= 50 {
        println!("¡Has aprobado el examen!");
    }

    // 2. Una estructura completa con "else if" y "else"
    if puntuacion >= 90 {
        println!("Excelente: Tienes una A.");
    } else if puntuacion >= 80 {
        println!("Muy bien: Tienes una B.");
    } else if puntuacion >= 70 {
        println!("Bien: Tienes una C.");
    } else {
        println!("Necesitas mejorar tu nota.");
    }
}
```

💡*Explicación del código:*

- *Sintaxis limpia:* A diferencia de otros lenguajes, en Rust las condiciones del *if* y *else if* no llevan paréntesis (es decir, escribimos *if puntuacion >= 50* en lugar de *if (puntuacion >= 50)*). Sin embargo, las llaves *{}* son siempre obligatorias, incluso si el bloque de código solo tiene una línea como en los casos anteriores.

- *Evaluación booleana estricta:* La condición que evalúa el *if* debe ser estrictamente un valor booleano (*true* o *false*). Rust no permite "valores de verdad" implícitos (por ejemplo, no puedes usar un número entero directamente como condición).

- *El flujo del programa:* En la primera parte, el programa comprueba si *puntuacion es mayor o igual a 50*. Como 85 lo es, imprimirá el mensaje *¡Has aprobado el examen!*. En la segunda parte, irá evaluando en orden las condiciones de arriba a abajo. Al llegar a *else if puntuacion >= 80*, la condición se cumple (*true*), por lo que imprimirá *Muy bien: Tienes una B.* e ignorará el resto de opciones (else if >= 70 y else).

== Sección 4: El bucle for con rangos
Imagina que le pides a un ordenador que pinte una línea de 100 píxeles en la pantalla. No vas a escribir la instrucción de pintar un píxel 100 veces, ¿verdad? Para evitar esa repetición absurda existen los bucles.

En Rust, la herramienta más potente y limpia para repetir una tarea un número exacto de veces es el bucle for combinado con rangos:

```rust
for x in 0..N {
    // El código que quieres repetir se escribe aquí
}
```
*¿Cómo funciona exactamente?*

- *0..N (El Rango):* Es una máquina de generar números consecutivos. Empieza en el primer número (0) y genera el siguiente en cada vuelta del bucle. El operador .. es exclusivo, lo que significa que llegará hasta el número anterior a N. Por ejemplo, 0..5 generará los números 0, 1, 2, 3 y 4 (un total de 5 vueltas).

- *x (La Variable de Control):* Es una variable temporal que "atrapa" el número que toca en cada vuelta. En la primera vuelta x vale 0, en la segunda vale 1, y así sucesivamente.

- *in:* Es la palabra clave que le dice al bucle de dónde tiene que sacar los valores (en este caso, de nuestro rango).

*¿Para qué sirven en el mundo real?*
+ *Contar y repetir*: Hacer que una acción se ejecute exactamente N veces.

+ *Recorrer colecciones por su posición*: Si tienes una *lista* de datos (como un array), puedes usar *x* como el índice (la posición) para examinar o modificar lo que hay dentro de *lista[x]*.

+ *Movernos por coordenadas (Imágenes y Mapas)*: Como los píxeles de una imagen se organizan en filas y columnas numeradas (desde el píxel 0 hasta el ancho de la imagen), usamos estos bucles para decirle al programa: "Ve al píxel x, procesa su color, y pasa al siguiente".

*Ejemplo unidimensional: lectura de un array*

🖥️  Copia el siguiente programa y pégalo en la Playgroud.

Fichero: *for_en_array.rs*

```rust
fn main() {
    let numeros = [2, 4, 34, 98];

    // numeros.len() es 4, así que el rango va de 0 a 3
    for i in 0..numeros.len() {
        println!("Índice: {}, Valor: {}", i, numeros[i]);
    }
}
```

- El array *numeros* definido tiene cuatro elementos, por tanto *numeros.len()* es igual a 4. Es la longitud del array.

- El rango 0..numeros.len() genera los números 0, 1, 2, 3

- En el bucle for, la i empezará por tomar el valor 0 en la primera vuelta, 1 en la segunda vuelta, 2 en la tercera vuelta y 3 en la cuarta vuelta.

Por tanto, al ejecutar este programa obtendremos:

```
Índice: 0, Valor: 2
Índice: 1, Valor: 4
Índice: 2, Valor: 34
Índice: 3, Valor: 98
```

Pulsa el botón *[RUN]* de tu Playground y comprueba el resultado.

#nota("Para interpretar los resultados sustituye el valor de i en cada pasada del bucle.")

*Ejemplo bidimensional: lectura de una matriz*

🖥️  Copia el siguiente programa y pégalo en la Playgroud.

Fichero: *for_en_matriz.rs*

```rust
fn main() {
    // Matriz de 2 filas (alto) y 3 columnas (ancho)
    let matriz = [
        [2, 9, 32],
        [65, 90,4]
    ];

    let alto = 2;
    let ancho = 3;

    // Bucle externo para recorrer las filas (2)
    for fila in 0..alto {
        // Bucle interno para recorrer las columnas (3)
        for columna in 0..ancho {
            print!("{} ", matriz[fila][columna]);
        }
        println!(); // Salto de línea al terminar cada fila
    }
}
```

Es similar al ejercicio anterior pero ahora tenemos un bucle externo que recorre las filas (fila toma los valores 0 y 1) y un bucle interno que para cada fila, recorre las columnas (columna toma los valores 0, 1 y 2).

De esta forma se recorren y se leen los seis elementos de la matriz.

*Resultado de ejecutar el programa *

```
2 9 32 
65 90 4 
```
== Sección 5: Bucles infinitos loop y while: repetir tareas sin cansarse
En esta sección veremos cómo podemos repetir un conjunto de instrucciones vinculado al cumplimiento o no de una condición.

=== El bucle loop
A los ordenadores se les da fatal improvisar, pero son los reyes absolutos de la repetición. No se cansan, no se aburren y no cometen errores por falta de atención. En Rust, cuando queremos que el ordenador repita un bloque de código, usamos los *bucles* (loops). El primero y más directo se llama, literalmente, *loop*.

💻 Copia este código en tu Playground y prepárate para usar el botón de emergencia

Fichero: *bucle_loop.rs*

```rust
fn main() {
    let mut contador = 0;

    println!("¡Iniciando el motor de repetición!");

    // La palabra 'loop' abre un bucle infinito. 
    // Lo que esté dentro del loop se repetirá de principio a fin
    // para siempre...
    loop {
        contador = contador + 1;
        println!("Vuelta número: {}", contador);

        // ❌ Si dejamos el código así, la Playground se colgará.
        // Necesitamos una condición de salida (un freno de mano).
        // Es el contador de la línea de abajo.
        if contador == 5 {
            break;      // 💡 ¡La palabra 'break' rompe el bucle, nos saca de aquí
                        // y nos lleva a la siguiente instrucción después del loop
        }
    }

    println!("¡Bucle terminado con éxito! El contador final es: {}", contador);
}
```

⚙️ Experimento 1: El freno de mano (break)

Si pulsas *[RUN]*, verás que el programa cuenta del 1 al 5 a la velocidad del rayo y se detiene limpiamente. La palabra clave break (que en inglés significa romper o frenar) es nuestra válvula de escape.

- *Misión (Simular un desastre controlado):* Vamos a ver qué pasa si saboteamos el freno de mano. Aplica el control de daños al revés: añade dos barras `//` al principio de la línea que tiene el break;. Vuelve a pulsar *[RUN]*.

- *¿Qué pasa?* Verás que los números empiezan a subir sin parar en la pantalla. ¡El programa ha entrado en un bucle infinito! Pulsa la pestaña *[Close]* en la parte superior derecha de la Playground para rescatar al ordenador.

- *Corrección:* Quita las barras `//` para devolver el break; a su sitio y que el programa vuelva a ser seguro.

🧠 *La lección clave: Las tres piezas del bucle loop*

Para que un bucle loop no se vuelva infinito, siempre necesitas tres cosas:

+ Una variable mutable fuera del bucle (*let mut contador = 0;*) para llevar la cuenta.

+ Una actualización dentro del bucle (*contador = contador + 1;*) para que las cosas avancen.

+ Un interruptor de apagado (*if ... break;*) para saber cuándo hemos terminado el trabajo.

=== El Bucle while
El bucle loop que vimos antes es muy potente, pero tener que escribir un *if* y un *break* dentro del bucle cada vez, puede ser un poco pesado. Por suerte, Rust tiene un hermano más inteligente llamado *while* (que en inglés significa "mientras").

El bucle *while* funciona mediante una condición: repite el código en su interior mientras esa condición ---que se evalúa en cada pasada del bucle---  sea verdad. En el momento en que deja de serlo, el bucle se frena solo automáticamente y el programa sigue en la siguiente instrucción al while.

💻 Copia este código en tu Playground para ver cómo funciona un medidor de batería que se va descargando

Fichero: *bucle_while.rs*

```rust
fn main() {
    // Empezamos con la batería al 100%
    let mut bateria = 100;

    println!("📱 Teléfono encendido. Batería al {}%", bateria);

    // MIENTRAS la batería sea mayor que cero, el teléfono sigue funcionando:
    while bateria > 0 {
        // En cada vuelta del bucle, el teléfono gasta un 25% de energía
        bateria = bateria - 25;
        
        println!("Usa una aplicación... Batería restante: {}%", bateria);
    }

    // ❌ Error oculto en tu cuaderno:
    // ¿Qué pasaría si dentro del bucle olvidamos restar energía?
    // (Ejemplo: // bateria = bateria - 25;)

    println!("🪫 ¡Batería agotada! El teléfono se ha apagado.");
}
```

⚙️ *Experimento 1: La descarga controlada*

Si pulsas *[RUN]*, verás cómo el programa va calculando la bajada de batería limpiamente (100% -> 75% -> 50% -> 25% -> 0%) y, al llegar a cero, la condición bateria > 0 deja de cumplirse. Rust lo detecta, sale del bucle y te muestra el mensaje final de "🪫 ¡Batería agotada! El teléfono se ha apagado.". ¡Todo automático!

⚙️ *Experimento 2: El tiempo congelado*

Vamos a provocar un fallo de lógica muy común entre programadores novatos.

- *Misión:* Comenta la línea donde restamos la energía añadiendo dos barras al principio: `// bateria = bateria - 25;`. Vuelve a pulsar *[RUN]*.

- *¿Qué ocurre?* Como la batería nunca baja de 100, la condición bateria > 0 siempre es verdadera. El programa se queda atrapado en un bucle infinito mostrando el mismo mensaje en bucle. Pulsa sobre la pestaña *[Close]* en la parte superior derecha de la Playground para rescatar al ordenador.

- *Corrección:* Borra las barras `//` para que el teléfono vuelva a gastar energía de forma normal.

🧠 *La diferencia fundamental entre loop y while*

- Usa loop cuando no sepas de antemano cuántas vueltas vas a dar y necesites comprobar cosas complejas dentro.

- Usa while cuando tengas una condición matemática clara y directa (como un contador o un porcentaje) para controlar la duración del bucle.

== Sección 5: Proyectos clave
Llegados a este punto, ya no eres un mero espectador; tienes en tu caja de herramientas los pilares de la programación en Rust: variables, inmutabilidad, tipos de datos, decisiones y bucles. Es hora de unir todas las piezas en proyectos reales.

=== Conversor de unidades interactivo
¿Cuántas veces has tenido que buscar en *Google* cuántos kilómetros son tantas millas, o a cuántos grados *Celsius* equivale una temperatura en *Fahrenheit*? En este proyecto vamos a programar nuestro propio conversor automático.

💻 Copia este código en tu Playground

Fichero: *conversor_de_unidades.rs*

```rust
fn main() {
    // === CONFIGURACIÓN DEL USUARIO (Cambia estos valores para probar) ===
    let millas_a_convertir = 5.0;    // Usa números con punto decimal (f64)
    let celsius_a_convertir = 25.0;
    // ===================================================================

    println!("⚙️  INICIANDO CONVERSOR DE UNIDADES INTERACTIVO ⚙️\n");

    // 1. Conversión de Distancia (Millas a Kilómetros)
    // Regla matemática: 1 milla = 1.60934 kilómetros
    let factor_millas = 1.60934;
    let kilometros_resultantes = millas_a_convertir * factor_millas;
    
    println!("📍 [DISTANCIA]: {} millas equivalen a {:.2} kilómetros.", 
             millas_a_convertir, kilometros_resultantes);

    // 2. Conversión de Temperatura (Celsius a Fahrenheit)
    // Regla matemática: F = (C * 9/5) + 32
    let fahrenheit_resultantes = (celsius_a_convertir * 9.0 / 5.0) + 32.0;
    
    println!("🌡️  [TEMPERATURA]: {}°C equivalen a {:.1}°F.", 
             celsius_a_convertir, fahrenheit_resultantes);

    // ❌ Error de laboratorio provocado:
    // ¿Qué pasaría si intentas sumar un número entero a uno decimal?
    // Descomenta la línea de abajo quitando las barras para ver el enfado de Rust:
    // let error_calculo = millas_a_convertir + 10; 
}
```

⚙️ *Experimento 1: Rompiendo las matemáticas de Rust*

Si pulsas *[RUN]*, el programa calculará perfectamente las conversiones y te mostrará los resultados limpios en la pantalla derecha gracias a un truco visual: *{:.2}* le dice a Rust que solo muestre dos decimales para que no se llene la pantalla con demasiados números.

Ahora, hagamos una prueba de fuego con la seguridad de Rust. Quita las dos barras `//` de la última línea (let error_calculo = ...) y pulsa *[RUN]*.

- *El resultado:* Rust se detendrá con un error de tipo. No te permite sumar *millas_a_convertir* (que es un número decimal, f64) con el número *10* (que es un número entero, i32).

- *La solución:* Rust te obliga a ser ultra-preciso. Si quieres sumar diez a *millas_a_convertir*, tendrías que escribir *10.0*. Vuelve a colocar las barras `//` para dejar el laboratorio limpio

🎮 ¡Te toca jugar!

Modifica los valores de las líneas 3 y 4. Pon las millas que recorres para ir al colegio o la temperatura actual de tu habitación. Pulsa *[RUN]* y observa cómo tu código se adapta al instante a tus nuevos datos.

=== Geneador de historias aleatorias (tipo Mad Libs)
¿Has jugado alguna vez a *Mad Libs*? Es ese juego divertidísimo en el que le pides a un amigo que te diga un nombre, un verbo, un adjetivo y un lugar sin saber la historia, y al rellenar los huecos queda un relato completamente absurdo y desternillante.

En este último proyecto del laboratorio, vamos a construir un Generador de Historias Locas. Tu ordenador se encargará de fusionar las palabras que tú elijas dentro de un texto fijo.

💻 Copia este código en tu Playground

Fichero: *generador_historias_aleatorias.rs*

```rust
fn main() {
    // === CONFIGURACIÓN DE TU HISTORIA (¡Cambia estas palabras!) ===
    let protagonista = "Un robot con sombrero";
    let lugar = "la cocina de la abuela";
    let objeto = "una cuchara de madera";
    let accion = "bailar la macarena";
    let año = 2085; // Un número entero
    // =============================================================

    println!("📖 GENERADOR DE HISTORIAS MÁGICAS ACTIVADO 📖\n");

    // Rust se encarga de tejer la historia usando los marcadores {}
    println!("Corría el año {}, cuando ocurrió algo inaudito.", año);
    println!("El valiente {} se encontraba en medio de {}.", protagonista, lugar);
    
    println!("De repente, sacó {} de su mochila y, sin pensarlo dos veces,", objeto);
    println!("¡se puso a {} frente a todos los presentes!", accion);

    println!("\n🎭 Fin de la aventura. ¡Vuelve a cambiar las variables para otra historia!");
}
```

#nota("Cuando se imprime la secuencia de caracteres \\n con la instrución println!, equivale a hacer un salto de línea y retorno de carro.")

⚙️ *Experimento 1: El tejedor de palabras*

Si pulsas *[RUN]*, verás cómo Rust recoge ordenadamente el texto de cada una de tus variables y lo encaja exactamente en el orden en que has colocado los marcadores *{}* dentro de los println!.

*Fíjate en un detalle:* hemos mezclado variables de texto (*&str*) con una variable de *número entero* (año). A diferencia de las matemáticas (donde vimos que no se pueden mezclar tipos), a la hora de imprimir en pantalla, Rust es muy amable y te permite colocar cualquier tipo de dato dentro de las llaves {} porque sabe convertirlo todo a texto visual.

🎮 *¡Hazlo tuyo!*

Cambia por completo las palabras de las líneas 3 a 7. Inventa el protagonista más raro que se te ocurra (un pingüino astronauta, tu profesor de matemáticas, un zombi vegetariano...), un lugar extraño y una acción ridícula. Modifica también el año. Vuelve a pulsar *[RUN]* y observa cómo tu programa genera una historia completamente nueva en un abrir y cerrar de ojos.

#pagebreak()