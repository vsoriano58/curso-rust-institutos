#import "config.typ": *

= 🏭 Divide y Vencerás: Funciones Avanzadas (fn)
Hasta ahora, salvo en una breve alusión a las funciones en el Cuaderno 1, has escrito códigos donde las cosas pasaban una detrás de otra dentro de la función principal main(). Esto funciona para programas pequeños, pero si tu código crece, se vuelve un caos indescifrable.

Imagina que estás programando un videojuego: no metes el código de calcular la física (gravedad, rebotes, etc), pintar los gráficos y reproducir el sonido en una sola bolsa gigante. Lo separas en tareas especializadas. Esas tareas son las funciones.

== Entradas y Salidas: Parámetros y valores de retorno (→)
Una función se comporta como una máquina de una ábrica: le introduces una materia prima (*parámetros*), realiza un proceso interno, y te devuelve un producto terminado (valor *de retorno*).

En Rust, para que el compilador te proteja de errores, estás obligado a declarar de qué tipo es cada parámetro que entra y qué tipo de objeto va a salir.

Obsérvalo en el siguiente ejemplo:

```rust

fn calcular_edad(anio_actual: i32, anio_nacimiento: i32) -> i32 {
    let edad = anio_actual - anio_nacimiento;
    return edad; // Enviamos el resultado de vuelta a quien nos llamó
}

fn main() {
    let mi_edad = calcular_edad(2026, 2010); // Llamamos a la máquina
    println!("Tienes {} años. ¡Estás en la flor de la vida!", mi_edad);
}
```
La función anterior recibe dos parámetros de tipo i32: el año actual y el año de nacimiento, calcula la edad y la devuelve también como i32 mediante la sentencia return.

Veamos como se ejecuta el programa entero. Empieza en la primera línea del main().

El tipo de los parámetros y del valor de retorno se especifica en la cabecera de la función:

```rust
fn calcular_edad(anio_actual: i32, anio_nacimiento: i32) -> i32
```

La llamada a la función en el main:

```rust
let mi_edad = calcular_edad(2026, 2010); // Llamamos a la máquina
```
En esta línea declaramos la variable *mi_edad* con let (inmutable) y le asignamos el valor de retorno de la función *calcular_edad*, pasándole al  parámetro *anio_actual* de la función el *argumento* 2026 y al parámetro *anio_nacimiento* el *argumento* 2010. Esta distinción entre parámetros cuando son variables que figuran en le definición de la función y argumentos cuando son valores que precisamente se pasan a los parámetros, la volveremos a comentar más adelante.

Después de la línea anterior, la ejecución del programa pasa a la primera línea de la función, que hace la resta 2026 - 2010 = 16 y vuelve al main() asignando este valor a mi_edad.

A continuación el main() imprime la línea:

Tienes 16 años. ¡Estás en la flor de la vida!

Y el programa termina.

== La última línea sin punto y coma: Expresiones vs. Sentencias
Aquí viene uno de los "secretos" más curiosos de Rust y que más descoloca al principio. Rust es un lenguaje basado en expresiones. Esto significa que casi todo lo que se escribe en una línea  de código devuelve un valor. No obstante, podemos diferenciar entre sentencias y expresiones:

- Sentencia (Termina en *;*): Es una orden directa. "Haz esto". No devuelve nada.
 - Ejemplo: *let velocidad = 10;*

- Expresión (NO lleva *;* al final): Es un cálculo. "Esto vale tanto". Devuelve un valor automáticamente.
 - Ejemplo: *5 + 3*

La expresión anterior podemos utilizarla en un sentencia *let resultado = 5 + 3;* como se muestra a continuación:

```rust
fn main() {
    // El cálculo "5 + 3" es la expresión que devuelve el valor 8
    let resultado = 5 + 3; 

    println!("El resultado de la expresión es: {}", resultado);
}
```
En Rust, si la última línea de una función no tiene punto y coma, actúa como un return automático para devolver el valor. Mira cómo podemos simplificar la función anterior al "estilo Rust profesional" sin escribir explícitamente return en la línea final que devuelve el resultado:

```rust
fn calcular_edad_pro(anio_actual: i32, anio_nacimiento: i32) -> i32 {
  
  // ¡Sin ";" al final! Rust entiende que éste es el resultado a devolver.
  anio_actual - anio_nacimiento 
}
```
💡 Consejo: Si por error le pones un punto y coma a esa última línea, el compilador se quejará diciendo que la función devuelve "nada" () en lugar de un i32 tal como decimos en la cabecera de la función al definirla. ¡Prueba a quitar ese punto y coma y verás la magia!

#nota("Cuando una función no devuelve nada, el compilador lo indica mostrando que devuelve (). El paréntesis vacío equivale a nada.")

== Proyecto Intermedio: Modularizando la Calculadora Científica
¡Enhorabuena por llegar hasta aquí! En los apartados anteriores de este Cuaderno 2, has aprendido cómo Rust gestiona la estructura de tu código mediante *funciones*. Ahora es el momento de unir todas las piezas creando una *Calculadora Científica Modular*.

Nuestra calculadora permitirá realizar operaciones básicas (suma, resta) y algunas funciones más avanzadas muy utilizadas en ciencia e ingeniería: el cálculo de potencias y el factorial de un número.

Veremos además el significado de dos nuevas palabras de Rust: *mod* (que significa modulo) y *pub* (que significa publico). Esto nos va a permitir estructurar el programa en módulos o ficheros independientes; concretamente el módulo principal *main.rs* que utilizará el módulo *operaciones.rs* el cual contiene las funciones.

La definición de las funciones dentro de *operaciones.rs* va precedida de la palabra *pub* lo que permite (al ser públicas) que se puedan llamar desde el archivo *main.rs* (u otros archivos) como si las hubiéramos escrito dentro del archivo main.rs. 

Por defecto, es decir, sino calificamos las funciones con *pub*, Rust las define como privadas y entonces no pueden llamarse desde fuera del archivo en donde están escritas.

A su vez, para poder utilizar las *funciones* del modulo *operaciones.rs* desde el módulo *main.rs*, debemos incluir en este último archivo la instruccion *mod operaciones;* para que main.rs reconozca este archivo.

=== Creación del proyecto: mi_calculadora
En el Cuaderno 1 apartado 6 "🔖 Subiendo de nivel: Instalación de un Entorno de Desarrollo Profesional" se explica de forma detallada *cómo instalar Rust de forma profesional en tu ordenador y cómo crear un proyecto.*

Revisa esa parte del Cuaderno 1 si lo necesitas y crea el proyecto: *mi_calculadora*. Añade al directorio *src* el fichero *operaciones.rs*.

+ *La Estructura del Proyecto*

Para este proyecto, nuestro programa se dividirá en dos partes fundamentales: 

- *main.rs*: El motor principal que interactúa con el usuario. 

- *operaciones.rs*: El módulo (o caja de herramientas) que albergará las funciones matemáticas complejas.

Nuestra carpeta del proyecto en Cargo debe lucir exactamente así:

```
mi_calculadora/
├── Cargo.toml
└── src/
    ├── main.rs
    └── operaciones.rs

```

*2. El Código del Proyecto*

Archivo: *src/operaciones.rs*

Este archivo no tiene una función main. Es una "biblioteca" matemática. Fíjate bien en la palabra clave *pub* (público), imprescindible para que otros archivos puedan usar estas funciones:

#nota("Si la última línea de una función NO TERMINA en punto y coma ; es una expresión y el resultado de evaluar dicha expresión es devuelto automáticamente por la función sin necesidad de utilizar return. El valor se devuelve a la variable que se utiliza cada vez que se llama la función.")

```rust
// src/operaciones.rs

// Devuelve la suma de dos números flotantes
pub fn sumar(a: f64, b: f64) -> f64 {
    a + b // Expresión: devuelve el resultado directamente
}

/// Devuelve la resta de dos números flotantes
pub fn restar(a: f64, b: f64) -> f64 {
    a - b
}

/// Calcula la potencia de una base elevada a un exponente entero.
pub fn calcular_potencia(base: f64, exponente: i32) -> f64 {
    base.powi(exponente)
}

/// Calcula el factorial de un número entero de forma iterativa.
pub fn calcular_factorial(n: u64) -> u64 {
    let mut resultado = 1;
    for i in 1..=n {
        resultado *= i;
    }
    resultado
}
```

La expresión *for i in 1..=n* es un bucle que se repite *n* veces. La primera vez i vale 1, la segunda vez i vale 2 y la enésima vez i vale n.

#nota("Este tipo de bucles está explicado en el Cuaderno 1, aparatdo '4.4 El bucle for con rangos'. Si quieres refrescar la mamoria prueba simplemente a calcular_factorial(4) que debe darte 4x3x2x1 = 24")

*Archivo: src/main.rs*

Aquí es donde el programa cobra vida. Usamos *mod operaciones;* para indicarle a Rust que incluya en el *main.rs* las herramientas que acabamos de crear en *operaciones.rs*.

```rust
// src/main.rs

// 1. Declaramos el módulo externo para que Rust sepa que existe
mod operaciones;

// 2. Traemos las funciones al entorno actual para usarlas
use operaciones::{sumar, restar, calcular_potencia, calcular_factorial};

fn main() {
    println!("=== CALCULADORA CIENTÍFICA MODULAR ===");

    // Ejemplo 1: Probando la suma (f64 + f64)
    let a = 2.0;
    let b = 3.0;
    let suma = sumar(a, b);
    println!("La suma de {} y {} es {}", a, b, suma);

    // Ejemplo 2: Probando la resta (f64 - f64)
    let c = 20.0;
    let d = 5.0;
    let resta = restar(c, d);
    println!("La resta de {} menos {} es {}", c, d, resta);

    // Ejemplo 3: Probando la potencia (f64 elevado a i32)
    let base = 2.5;
    let exp = 3;
    let potencia = calcular_potencia(base, exp);
    println!("La potencia de {} elevado a {} es: {}", base, exp, potencia);

    // Ejemplo 4: Probando el factorial (u64)
    let numero = 5;
    let factorial = calcular_factorial(numero);
    println!("El factorial de {}! es: {}", numero, factorial);
}
```
*3. Explicación del Ejemplo (Paso a Paso)*

Para entender por qué este código funciona tan bien, analicemos sus tres pilares clave:

- *El Sistema de Módulos (mod y pub)*: Por defecto, todo en Rust es privado (está oculto). Si en operaciones.rs hubiéramos escrito fn calcular_factorial sin el *pub* delante, main.rs no podría ver la función y el compilador daría un error. Al añadir pub, le damos permiso a otros archivos para usarla.

- *El Método powi*: Rust es extremadamente estricto con los tipos de datos. En lugar de un método genérico para calcular potencias, usamos .powi(), que significa "_Power Integer_" (potencia entera). Permite elevar de forma súper eficiente un número con decimales (f64) a un exponente entero (i32).

- *Mutabilidad Controlada y Rangos Especiales*: En la función del factorial, declaramos *let mut resultado = 1;*. Como en Rust las variables son inmutables por defecto para evitar despistes, la palabra clave *mut* le avisa al compilador de que ese valor sí va a cambiar dentro del bucle. Además, el bucle usa el operador *1..=n* (rango inclusivo), lo que asegura que el propio número n se incluya en la multiplicación.
#pagebreak()