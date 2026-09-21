#import "config.typ": *

= Introducción
¡Bienvenido al Cuaderno 4 de tu camino de aprendizaje en Rust! Hasta este momento, en los tres volúmenes anteriores has aprendido a comunicarte con el compilador, a estructurar datos en la memoria y a modelar el mundo real mediante objetos y colecciones. Sin embargo, todos tus programas anteriores asumían un entorno "perfecto": el usuario siempre introducía el dato correcto, los archivos siempre existían y los recursos nunca fallaban.

En el mundo del software profesional, el entorno ideal no existe. Los discos duros se llenan, las redes se caen, los archivos se corrompen y los usuarios cometen errores constantemente al introducir datos. Un programador amateur escribe código que funciona cuando todo va bien; un desarrollador profesional escribe software robusto que sabe qué hacer cuando todo o casi todo va mal.

== Qué vas a aprender en este volumen?
Este cuaderno está diseñado para transformar tu forma de programar mediante tres pilares fundamentales:

- *Gestión Defensiva de Errores*: Descubrirás por qué Rust no utiliza el peligroso concepto de "valor nulo" (null) y aprenderás a usar las herramientas *Option`<T>`*y *Result`<T, E>`* para anticiparte y desactivar los fallos antes de que ocurran.

- *Persistencia en el Mundo Real*: Aprenderás a conectar tus programas con el sistema operativo. Tu código dejará de ser efímero: aprenderás a leer y escribir archivos de texto plano para guardar información de forma permanente en el disco.

- *El Ecosistema Cargo*: Romperás los límites del lenguaje estándar introduciéndote en *Crates.io*, el almacén comunitario de Rust, aprendiendo a integrar librerías externas de forma automática para procesar datos complejos como archivos *.csv*.

Al terminar este cuaderno, habrás desarrollado tres proyectos clave (un gestor de tareas persistente, una herramienta de automatización para la terminal y un analizador estadístico). Estarás completamente preparado para enfrentarte al desarrollo de aplicaciones reales y conectadas. ¡Empecemos!

== 🧩 Paréntesis Didáctico: Entendiendo los Tipos Genéricos (`<T>`, `<E>`)
Al adentrarnos en las herramientas que describe este cuaderno, verás que aparecen expresiones extrañas como *Option`<T>`* o *Result`<T, E>`*. Option y Result son dos enumerados definidos en Rust y que estudiaremos luego, pero ¿qué significan esas letras mayúsculas entre símbolos de mayor y menor que? Se llaman *Tipos Genéricos*, y son una de las herramientas más potentes para ahorrar código.

=== El problema: Repetir código para cada tipo de dato
Imagina que queremos programar una función muy simple que sume dos números. Si no existieran los genéricos, nos veríamos obligados a escribir una función diferente para cada tipo de número que usemos en Rust:

```rust
// Tendríamos que escribir esto...
fn sumar_i32(a: i32, b: i32) -> i32 { a + b }
fn sumar_f32(a: f32, b: f32) -> f32 { a + b }
fn sumar_u64(a: u64, b: u64) -> u64 { a + b }
// ¡Qué pérdida de tiempo y qué código tan repetitivo!
```
=== La solución: Las plantillas genéricas (`<T>`)
Para evitar esto, Rust nos permite crear una única función genérica que sustituye a todas las anteriores. Usamos la letra T como un comodín (piensa en T como "Tipo de dato cualquiera"). Es como crear una plantilla o un molde:

```rust
// Usamos <T> para decirle a Rust:
// Esta función acepta un tipo T cualquiera
fn sumar<T>(a: T, b: T) -> T {
    a + b
}
```
_Nota académica_: Al usar la función en tu código, por ejemplo, *sumar(5i64, 10i64)*, Rust automáticamente "sustituye" en su mente todas las *T* que hay en la definición de la función genérica sumar por *i64*. Si le pasas dos sumandos f32, las sustituye por f32. ¡Una sola función genérica sirve para todos los tipos de números del mundo siempre y cuando admitan la operación suma entre ellos! No podremos con la función anterior sumar dos String.

=== Funciones con más de un genérico (`<T, E>`)
El comodín no tiene por qué ser una sola letra. Un programa puede necesitar manejar dos o más tipos de datos que no tienen nada que ver entre sí dentro de la misma estructura. En esos casos, añadimos más letras separadas por comas (por convención se usan T, U, E, etc.):

```rust
// Una función que recibe un dato de Tipo 'T' y otro
// de Tipo 'U' totalmente diferentes
fn mostrar_par<T, U>(identificador: T, valor: U) {
    // ...
}
```

La teoría sobre datos genéricos la estudiaremos más adelante pero por ahora debe quedar claro que cuando veamos letras mayúsculas en la definición de estructuras, enumerados o funciones significan un tipo de dato cualquiera, genérico.

=== Cómo se aplica esto a los enumerados Option y Result que veremos luego?
Ahora ya estás preparado para entender las herramientas de Rust. Cuando veas: 

- Option`<T>`: Significa que es una caja que puede contener un dato T (¡el que tú quieras!: un entero, un texto String, o una estructura personalizada).

- Result`<T, E>`: Significa que es una estructura que, si todo va bien, devuelve un dato exitoso de tipo *T*, y si falla, devuelve un error de tipo *E* (de Error).

Los genéricos son simplemente eso: comodines que toman su valor real en el mismo instante en el que tú decides utilizarlos en tu programa.

Estos dos enumerados están definidos por Rust y por tanto en nuestros programas podremos utilizarlos directamente sin definirlos. Son enumerados genéricos predefinidos.

Ciertamente es un concepto bastante abstracto pero cuando lo veas aplicado en algunos ejemplos lo normalizarás rápidamente.



#pagebreak()