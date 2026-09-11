#import "config.typ": *

= 🔖 Tipos de datos y operadores en Rust
En este tema hablaremos con más rigor sobre los tipos de datos en Rust e introduciremos los operadores en Rust. Un operador es un símbolo que atúa normalmente sobre dos valores de entrada y produce un valor de salida.

== Tipos de datos en Rust
Hasta ahora, hemos visto que nuestros programas manejan tres tipos de información: Números, Texto y Booleanos (sí/no). En el mundo real esto es un poco más complejo, pero no quisimos mostrártelo antes para no complicarte la vida. ¡Queríamos que empezaras a jugar con los programas lo antes posible!

Ya conoces algunos tipos como *i32* (enteros) o *f64* (decimales). Un entero i32 ocupa siempre en la memoria 32 bits y un decimal f64 ocupa siempre 64 bits. Veremos a continuación el concepto de bit. También has visto el texto en formato *&str*. Este último es una versión `recortada` de otro tipo llamado *String*. Ambos guardan texto, pero lo hacen de formas distintas y su tamaño en la memoria cambia según lo largo que sea el mensaje a diferencia de los anteriores que son de tamaño fijo.

Para entender por qué Rust es tan estricto con los tipos de datos, tenemos que hacer un viaje relámpago al interior de la memoria de tu ordenador.

=== 🔋¿Qué es un bit?

Un bit es la *célula más elemental* que existe en la informática. Imagínalo como un interruptor de la luz diminuto: solo puede estar encendido (1) o apagado (0).

Como un solo interruptor no sirve para guardar mucha información, los ordenadores agrupan estos bits en *paquetes* de 8, llamados *Bytes*. Una buena aproximación es imaginarse la memoria RAM de un ordenador como una sucesión de estos Bytes.

Así tendremos que:

- Un número de tipo *i32* se guarda en la memoria usando 4 bytes (32 bits en total).
- Un número de tipo *f64* se guarda en la memoria usando 8 bytes (64 bits en total).

=== 🗺️ La memoria del orenador y el sistema binario
El sistema binario (combinación de unos y ceros) puede representar cualquier cosa: números positivos, negativos, decimales y letras. Pero aquí está el gran secreto: la memoria del ordenador es ciega. Solo ve una fila gigantesca de unos y ceros y tenemos que decirle cómo está almacenada la información, con qué código. Cual es la sucesión de tipos de datos en esa fila. Cuando especificamos *i32* o *f64* le estamos proporcionando ese código.

Imagina que guardas un número f64. El ordenador mete en su memoria una secuencia de 64 interruptores encendidos y apagados. Para poder recuperar ese número más tarde, Rust necesita saber dos cosas obligatoriamente:

+ ¿En qué casilla de la memoria empieza el número?

+ ¿Qué tipo de dato es? (Es decir, qué "traductor" debe usar cuando lee el número).

Si intentaras leer esos 64 bits como si fuera un número entero i32, el ordenador solo leería la mitad del número (32 bits) y la traducción sería un desastre total. Es como si intentaras leer un libro en español usando las reglas de pronunciación del alemán: las letras son las mismas, ¡pero no entenderías nada!

Además, el ordenador usa trucos diferentes (códigos) para guardar números negativos o para convertir letras en números (asignando a cada letra un código numérico).

Por eso, los tipos de datos son las etiquetas que le dicen a Rust cómo traducir los unos y ceros de la memoria para que tu programa no se vuelva loco.

=== 🤖 Tipos de datos por defecto
*Números decimales*

En los ejemplos hemos utilizado instrucciones como esta:

```rust
let v = 50.5;
```

Aquí definimos la variable inmutable *v* (con *let*) como un valor decimal pero no indicamos el tipo de dato de v. En Rust existen dos tipos de datos digitales, f32 y f64. Si no indicamos el tipo en la signación de un valor decimal a una variable como en la anterior instrucción, el compilador toma por defecto *f64*. Por tanto v será del tipo f64.

Si queremos realmente que v sea de tipo f32 lo tenemos que indicar en la declaración y asignación. Por ejemplo:

```rust
let v:f32 = 50.5;
```
Aquí indicamos que v es de tipo f32.

Una forma alternativa de expresar lo mismo es:

```rust
let v = 50.5f32;
```

Aquí estamos diciendo que la constante 50.5 hay que tomarla como f32 por lo que *v* tendrá el mismo tipo f32. A esto se le llama inferencia de tipos, cuando el compilador adivina el tipo de la variable aún sin haber indicado el tipo en la misma variable.

*Números enteros*

Con los enteros i32 e i64 ocurre algo similar. El tipo por defecto es i32 pero también existe i64. Entonces:

```rust
let edad = 20;		  // edad es i32
let edad: i32 = 20;	// edad es i32. Especificación de tipo redundante
let edad = 20i64;	  // edad es i64
let edad:i64 = 20;	// edad es i64
```
Los tipos de datos numéricos que definiremos a continuación tienen tipos por defecto. 

=== 🧱 Las dos familias de tipos en Rust
Para organizar todos los tipos de datos, Rust los divide en dos grupos muy fáciles de entender: los *Escalares* y los *Compuestos*.

==== *Tipos Escalares (Un solo valor)*
Son los tipos de datos más sencillos. Representan *un único valor atómico* (no se pueden dividir en partes más pequeñas). Imagínalos como piezas individuales de Lego.
- *Enteros (Números sin decimales):* Sirven para contar cosas enteras (como vidas en un videojuego o años). Rust te permite elegir el tamaño exacto que ocuparán en memoria:
 - Con signo (pueden ser negativos o positivos): i8, i16, i32 (el favorito por defecto), i64, i128.
 - Sin signo (solo positivos o cero): u8 (ideal para colores en informática, de 0 a 255), u16, u32, u64, u128.
 - Según el ordenador: isize y usize (su tamaño depende de si el procesador es de 32 o 64 bits).

- *Flotantes (Números con decimales):* Para cuando necesitas precisión (como la salud de un jefe con 99.5% de vida o el precio de un juego).
 - f32 (precisión simple).
 - f64 (precisión doble, el que Rust usa por defecto).

- *Booleanos (Verdad o mentira):* Solo tienen dos estados posibles. ¡Como un interruptor!
 - *bool:* Sus únicos valores son true (verdadero) o false (falso). Es el motor de las decisiones en el código cuando se utiliza (if).

-*Caracteres (Una sola letra o símbolo):* Sirven para guardar una única letra, número suelto o... ¡incluso un emoji!

- *char:* Se escriben con comillas simples (por ejemplo: 'A', '7' o '🚀'). Ocupan 4 bytes porque usan Unicode, lo que les permite representar casi cualquier símbolo del mundo.

==== *Tipos Compuestos (Varios valores juntos)*
Son tipos que permiten agrupar múltiples valores dentro de una sola *caja* o *variable*. Nos podremos referir a esos multiples valores a través del nombre único de la variable.

- *Tuplas (Tuples):* Son como una mochila donde puedes meter cosas de diferentes tipos, pero con un tamaño fijo: una vez que creas la tupla, no puede crecer ni encoger.

 - Ejemplo: Puedes guardar el nombre de un jugador (&str), su puntuación (i32) y si está vivo (bool) en una sola variable: ("Halcón", 2500, true). Se caracterizan por utilizar un paréntesis en su declaración y los distintos valores separados por comas.

- *Arrays / Arreglos (Matrices fijas):* Son como un cartón de huevos. Guardan una lista de elementos, pero con dos reglas estrictas: todos tienen que ser del mismo tipo y el tamaño una vez creado el array es fijo (no puede cambiar).

 - Ejemplo: Las notas de 5 exámenes de un alumno: [10, 8, 9, 7, 9]. Se caracterizan por utilizar corchetes en su declaración con la lista de elementos separados por comas.

Piensa un poco en esto: Si tuvieras que guardar el inventario de Minecraft de un jugador, ¿qué tipo usarías para la cantidad de bloques de piedra? ¿Y para el nombre del pico?

=== 📄 Fichero: ejemplos_tipos.rs

💻 Copia este código en tu Playground

Fichero: *ejemplos_tipos.rs*

```rust
#![allow(warnings)] // <-- ¡Esta línea mágica:elimina todos los avisos amarillos en este fichero!

fn main() {
    // --- 1. TIPOS ESCALARES (Un solo valor) ---

    // Enteros: Rust adivina que es i32 por defecto
    let vidas = 3; 
    // Obligamos a que sea un u8 (solo de 0 a 255), ideal para ahorrar memoria
    let nivel: u8 = 10; 

    // Flotantes: Números con decimales
    let puntuacion = 95.5; // f64 por defecto
    let gravedad: f32 = 9.81; // Forzamos precisión simple

    // Booleanos: ¡Verdadero o Falso!
    let partida_terminada = false;
    let tiene_llave = true;

    // Caracteres: ¡Ojo! Van con comillas SIMPLES ''
    let inicial = 'H';
    let mi_emoji = '🚀'; // ¡Sí, Rust acepta emojis en los caracteres!


    // --- 2. TIPOS COMPUESTOS (Varios valores juntos) ---

    // Tupla: Un combo de datos de diferentes tipos (Nombre, Puntuación, ¿Está vivo?)
    let jugador: (&str, i32, bool) = ("Halcón", 2500, true);

    // Para sacar los datos de la tupla usamos un punto y su posición (empezando desde 0)
    let nombre_jugador = jugador.0;
    let puntos_jugador = jugador.1;

    // Array: Una lista fija de elementos que TIENEN que ser del mismo tipo
    // Guardamos las puntuaciones de las últimas 4 partidas
    let historial_puntos: [i32; 4] = [120, 98, 101, 63];

    // Para sacar un dato del array usamos corchetes [] y la posición (el primero es el 0)
    let primera_partida = historial_puntos[0]; 


    // --- ¡VAMOS A MOSTRARLO EN PANTALLA! ---
    println!("¡Bienvenido al juego, {}!", nombre_jugador);
    println!("Tu inicial es la {} y tienes {} vidas.", inicial, vidas);
    println!("En tu primera partida ganaste {} puntos y ahora tienes {}.", primera_partida, puntos_jugador);
    println!("¿Estás listo para despegar? {}", mi_emoji);
}
```

Las siguientes explicaciones están encaminadas a que entiendas el programa anterior. Ejecuta el programa y compara los resultados obtenidos con los que puedes deducir tu mismo de las explicaciones. Si no llegas a conprender el 100% del programa no es problemático pero si haces un esfuerzo te será útil.

🎨 *Rust empieza a contar desde 0*

En todos los tipos de datos compuestos donde bajo el nombre único de una variable se agrupan varios valores, se utiliza siempre un *indice* que empieza por cero para el primer valor y luego se va aumentando de uno en uno. La forma de utilizar ese índice es diferente en las tuplas *nombre_variable.0*, *nombre_variable.1*, etc. y en los vectores  *nombre_variable[0]*, *nombre_variable[1]*, etc. 

Lo podemos ver en los siguientes ejemplos:

*En la tupla*

```rust
let jugador: (&str, i32, bool) = ("Halcón", 2500, true);
// Para sacar los datos de la tupla usamos un punto y su posición (empezando desde 0)
let nombre_jugador = jugador.0;
let puntos_jugador = jugador.1;
let esta_vivo = jugador.2;
```

*En el vector*

```rust
let historial_puntos: [i32; 4] = [120, 98, 101, 63];
// Para sacar un dato del array usamos corchetes [] y la posición (el primero es el 0)
let primera_partida = historial_puntos[0]; 
let segunda_partida = historial_puntos[1]; 
// etc.
```

🎨 *Comillas simples o dobles*

Las comillas importan: Las letras sueltas (*char*) llevan comillas simples ('A'), mientras que los textos de más de una letra (*&str o String*) llevan comillas dobles ("Halcón"). Si mezclas las comillas, ¡el compilador te echará una bronca de campeonato!

== Los motores del cambio: Operadores en Rust
Imagina que las variables son cajas donde guardas cosas (como tus monedas, tu nivel o tu inventario). Los operadores son las herramientas matemáticas y lógicas que te permiten hacer cosas con esas cajas: sumar puntos, comparar quién ha ganado o comprobar si tienes la llave correcta para abrir una puerta.

En Rust tenemos tres familias principales de operadores que vas a usar todo el tiempo.

=== 🧮 Operadores Matemáticos (Los de toda la vida)
Sirven para hacer cálculos. Funcionan exactamente igual que en tu clase de matemáticas, con un par de símbolos especiales que usa el ordenador.

#table(
  columns: (1.6fr, 3.5fr, 3.5fr, 3.8fr),
  align: (col, row) => (
    if row == 0 { left }
    else if col == 3 { left }
    else { left }
  ),
  stroke: 0.5pt + luma(120),
  
  // Encabezados de la tabla
  [*Operador*], [*Operación*], [*Ejemplo en Rust*], [*Resultado*],

  // Fila 1: Suma
  [+], [Suma], [`let total = 5 + 3;`], [8],

  // Fila 2: Resta
  [-], [Resta], [`let vidas = 10 - 2;`], [8],

  // Fila 3: Multiplicación
  [\*], [Multiplicación], [`let doble = 4 * 2;`], [8],

  // Fila 4: División
  [\/], [División], [`let mitad = 16 / 2;`], [8],

  // Fila 5: Módulo
  [%], [Módulo (El resto de la división)], [`let resto = 9 % 2;`], [1 (9 entre 2 da 4, y sobra 1)],
)

- ⚠️ *La regla de oro de Rust:* Rust es superestricto. No puedes mezclar tipos de números en las operaciones. Si intentas sumar un entero (i32) con un decimal (i64), el compilador se enfadará y detendrá el programa. ¡Tienen que ser del mismo tipo!

=== ⚖️ Operadores de Comparación (Los jueces)
Sirven para comparar dos cosas. El resultado de estas operaciones siempre es un booleano (true o false). Son los que usarás para que tu código tome decisiones (por ejemplo: "Si las vidas son iguales a 0, entonces _Game Over_").

#table(
  columns: (1.2fr, 4.5fr, 1.5fr, 1.8fr),
  align: left,
  stroke: 0.5pt + luma(120),
  
  // Encabezados de la tabla
  [*Operador*], [*Significado*], [*Ejemplo*], [*Qué responde \ Rust?*],

  // Fila 1
  [`==`], [¿Es exactamente igual? (¡Ojo, doble signo igual!)], [`5 == 5`], [`true`],

  // Fila 2
  [`!=`], [¿Es diferente?], [`5 != 3`], [`true`],

  // Fila 3
  [`>`], [¿Es mayor que?], [`4 > 7`], [`false`],

  // Fila 4
  [`<`], [¿Es menor que?], [`3 < 8`], [`true`],

  // Fila 5
  [`>=`], [¿Es mayor o igual que?], [`5 >= 5`], [`true`],

  // Fila 6
  [`<=`], [¿Es menor o igual que?], [`10 <= 2`], [`false`],
)

💡 *Truco mental:* No confundas *=* con *==*. Un solo = sirve para guardar algo en una caja (let x = 5;). El doble == sirve para preguntar si dos cajas tienen lo mismo.

=== 🧠 Operadores Lógicos (Los detectives)
Sirven para combinar varias preguntas a la vez. Imagina que para entrar a una mazmorra necesitas: tener el nivel 10 Y tener la llave dorada. ¡Aquí entran en juego los operadores lógicos!

- *&& (Operador Y / AND):* Da true solo si todas las condiciones son verdaderas.
 - let entrar = (nivel >= 10) && tiene_llave; (Si una de las dos es falsa, no entras).

- *|| (Operador O / OR):* Da true si al menos una de las condiciones es verdadera. (El signo | se obtiene con la tecla *Alt Gr + 1* en la mayoría de teclados).
 - let jugar = (tengo_consola) || (tengo_pc); (Con que tengas uno de los dos, ya puedes jugar).

- *! (Operador NO / NOT):* Invierte el resultado. Lo que era true lo vuelve false, y viceversa. Es el botón de "llevar la contraria".
 - let vivo = true;
 - let fantasma = !vivo; (fantasma pasará a valer false).

💻 Un minireto

¿Qué valor crees que guardará la variable resultado_final en este código?

```rust
let puntos = 100;
let tiene_bonus = true;
let resultado_final = (puntos > 50) && (tiene_bonus == true);
```

=== 🎮 Ejercicio propuesto: Misión "Acceso a la Mazmorra del Dragón"
¡Ha llegado el momento de poner a prueba tus nuevos superpoderes con los operadores! Imagina que estás programando las reglas de un juego de rol. El jugador quiere abrir la puerta de una mazmorra secreta, pero el juego solo le dejará pasar si cumple unos requisitos muy estrictos.

📝 *El Reto*

Tienes que escribir un programa en tu Playground que calcule la puntuación final de un jugador y decida si puede entrar a la mazmorra.

Las reglas del juego son:

- La *Puntuación Total*: Se calcula sumando los *puntos_base* más los *puntos_extra* multiplicados por *2*.

- La *Condición de Entrada*: Para entrar, el jugador necesita tener una *puntuacion_total mayor o igual a 80* Y poseer el objeto mágico (*tiene_llave*).

Si todavía no has llegado a una solución...

💻 Copia este código en tu Playground, comprende las operaciones y la lógica y ejecútalo. Cambia algunos valores y condiciones a tu gusto y observa los resultados al ejecutarlo

📄 Fichero: *operadores_reto.rs*

```rust
#![allow(warnings)] // Evitamos los avisos amarillos para concentrarnos

fn main() {
    // --- DATOS DEL JUGADOR (Puedes cambiar estos valores para hacer pruebas) ---
    let puntos_base = 40;
    let puntos_extra = 25;
    let tiene_llave = true;

    // --- 1. OPERACIÓN MATEMÁTICA ---
    // Multiplica los puntos_extra por 2 y súmaselos a los puntos_base
    let puntuacion_total = puntos_base + (puntos_extra * 2);

    // --- 2. OPERADOR DE COMPARACIÓN Y LÓGICO ---
    // Comprueba si la puntuación es mayor o igual a 80 Y ADEMÁS tiene la llave
    let puede_entrar = (puntuacion_total >= 80) && (tiene_llave == true);

    // --- 3. EL VEREDICTO DEL ORDENADOR ---
    println!("--- ESTADO DE LA MISIÓN ---");
    println!("Puntuación final conseguida: {} puntos.", puntuacion_total);
    println!("¿Tiene el objeto mágico?: {}", tiene_llave);
    println!("¿Se abre la puerta de la mazmorra?: {}", puede_entrar);
}
```
#pagebreak()