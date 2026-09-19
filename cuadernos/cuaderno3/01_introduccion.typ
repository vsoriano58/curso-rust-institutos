#import "config.typ": *

= Introducción: De variables sueltas a objetos con sentido
Hasta este punto de tu aventura con *Rust*, has aprendido a manejar la información utilizando variables individuales. Si necesitabas almacenar la vida o salud de un jugador, creabas un *let salud = 100;*. Si querías su nombre, añadías un *let nombre = String::from(`"`Arturo`"`);*.

Este enfoque funciona perfectamente para programas pequeños o filtros digitales matemáticos aislados. Sin embargo, el software del mundo real no funciona con datos desconectados; funciona con *conceptos integrados*.

== El problema de los datos huérfanos
Imagina que estás diseñando el código de un videojuego multijugador. Cada jugador en el mapa necesita un nombre, una posición en el eje X, una posición en el eje Y y un estado de energía. Usando únicamente lo aprendido en los cuadernos anteriores, tu código inicial se vería más o menos así:

```rust
fn main() {
    // Datos del Jugador 1
    let j1_nombre = String::from("Falcon_Retro");
    let j1_pos_x = 10.5;
    let j1_pos_y = 20.0;
    let j1_energia = 100;

    // Datos del Jugador 2
    let j2_nombre = String::from("Rustaceo99");
    let j2_pos_x = -5.0;
    let j2_pos_y = 14.2;
    let j2_energia = 85;
    
    // Si tuviéramos 50 jugadores, ¡necesitaríamos 
    // 200 variables sueltas!
}
```
Para nuestra mente humana, *j1_nombre* y *j1_energia* están íntimamente relacionados: pertenecen al mismo jugador. Pero para el compilador de Rust, estas variables son completamente desconocidas entre si. Son solo datos flotando de forma independiente en la memoria de la computadora.

Esto acarrea tres problemas graves a medida que el proyecto crece:

+ *Fragilidad*: Si pasas la posición de un jugador a una función para calcular el movimiento, podrías equivocarte por accidente y pasar el eje X del Jugador 1 y el eje Y del Jugador 2. El compilador no protestará, porque ambos son números decimales, pero provocarás un bug (error) catastrófico en el juego.

+ *Falta de cohesión:* Las funciones que modifican al jugador (como recibir daño o teletransportarse) requieren que les pases una lista kilométrica de argumentos individuales en los parámetros de la función: todas las variables del jugador.

+ *Escalabilidad imposible:* Crear dinámicamente nuevos jugadores o eliminarlos cuando se desconecten de la partida se vuelve una tarea titánica si sus propiedades (variables) están dispersas.

== Pensar en "Objetos con Sentido"
Modelar el mundo real significa dejar de pensar en bytes, enteros o cadenas de texto aisladas, y empezar a pensar en *entidades completas*.

En lugar de ver cuatro variables huérfanas, queremos que nuestro código entienda el concepto unificado de un *Jugador*. Queremos empaquetar esos datos dispersos dentro de un contenedor único. De esta forma, si movemos (eliminamos) al jugador, movemos el paquete completo; si el jugador se cura, alteramos una propiedad interna de ese paquete.

En este cuaderno aprenderás a diseñar tus propios bloques de construcción para dotar a Rust de *tipos personalizados* que no existen en el lenguaje por defecto. Pasaremos de gestionar números y letras inconexos a modelar _*Inventarios, Héroes, Monstruos y Sistemas de Autenticación.*_

Damos la bienvenida a la programación estructurada. Es hora de levantar los planos de nuestro código. 

#pagebreak()
