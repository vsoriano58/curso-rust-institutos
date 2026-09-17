#import "config.typ": *

=  Estructuras de Datos (`struct`)
Imagina que estás programando un videojuego y quieres guardar la información de un jugador. Hasta ahora ---como ya hemos mencionado en la introducción---, usando lo aprendido en el Cuaderno 2 tendrías que crear variables sueltas:

#nota("En el apartado: 7.7. del Cuaderno 1, ''El struct Persona y los superpoderes automáticos'', mencionamos muy de pasada las estructuras (strct) como herramientas para organizar la información.")

```rust
let jugador_nombre = String::from("Falcon_Retro");
let jugador_salud = 100;
let jugador_nivel = 5;
```
Este enfoque tiene un problema grave: para el compilador de Rust, estas tres variables no tienen ninguna relación entre sí. Si tienes 50 jugadores en una partida, gestionar cientos de variables sueltas se volvería una pesadilla. Aquí es donde entran las *estructuras (`struct`)*, que nos permiten agrupar variables de diferentes tipos bajo un mismo nombre con sentido.

== El plano arquitectónico: Definición de Struct clásicas
Una estructura funciona exactamente como el plano de una casa. No es la casa en sí misma, sino el diseño que define qué elementos la compondrán.

Para definirla, usamos la palabra clave struct, seguida del nombre en mayúscula (_*CamelCase*_) y abrimos llaves. Dentro, definimos los campos indicando su nombre y su tipo de dato.

#nota("CamelCase se aplica a nombres compuestos. Por ejemplo, si el nombre de la estructura fueran dos palabras, como ''jugador lateral'', el nombre resultante de la estructura del jugador sería JugadorLateral. Se unen las palabras poniendo la inicial de cada una en mayúsculas.")

```rust
// Definimos el plano de lo que es un "Personaje" en nuestro código
struct Personaje {
    nombre: String,
    salud: u32,
    nivel: u16,
    es_activo: bool,
}
```
== Construyendo el objeto: Instanciación y acceso a campos
Una vez que tenemos el plano (struct), podemos "construir" personajes reales en memoria. A este proceso lo llamamos instanciación. Para leer los datos de un campo específico, utilizamos el operador punto (.).

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

```rust
// Definimos el plano de lo que es un "Personaje" en nuestro código
struct Personaje {
    nombre: String,
    salud: u32,
    nivel: u16,
    es_activo: bool,
}

fn main() {
    // Instanciamos (creamos) el personaje basándonos en el plano
    let héroe = Personaje {
        nombre: String::from("Aragorn"),
        salud: 100,
        nivel: 1,
        es_activo: true,
    };

    // Accedemos a sus datos individuales usando el punto
    println!("¡Bienvenido al mundo, {}!", héroe.nombre);
    println!("Tu salud inicial es de {} puntos y eres nivel {}.", héroe.salud, héroe.nivel);
}
```
==  La mutabilidad en bloque: Modificar datos en una estructura
¿Qué pasa si nuestro personaje recibe un golpe y su salud baja? En Rust, la mutabilidad afecta a toda la estructura por igual. No puedes hacer que solo un campo sea mutable; toda la instancia debe declararse con *mut*.

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

```rust
struct Personaje {
    nombre: String,
    salud: u32,
    nivel: u16,
    es_activo: bool,
}

fn main() {
    // Declaramos la instancia como mutable usando 'mut'
    let mut enemigo = Personaje {
        nombre: String::from("Orco Gruñón"),
        salud: 80,
        nivel: 2,
        es_activo: true,
    };

    println!("El {} bloquea el camino con {} de vida.", enemigo.nombre, enemigo.salud);

    // ¡El jugador ataca! Modificamos los campos internos
    enemigo.salud = 50; // El enemigo pierde 30 de salud
    enemigo.nivel = 3;  // El enemigo se enfurece y sube 1 de nivel

    println!("Tras el impacto, el {} tiene {} de vida y nivel {}.", enemigo.nombre, enemigo.salud, enemigo.nivel);
}
```
== 2.4. Estructuras alternativas: Tuple Structs y Unit Structs
A veces no necesitas ponerle nombre a cada campo porque su significado es evidente, o simplemente necesitas un tipo sin datos para representar un concepto. Rust nos da dos herramientas secundarias muy útiles:

+ *Tuple Structs:* Son estructuras que tienen tipo pero no nombres en sus campos. Ideales para coordenadas espaciales o colores.

+ *Unit Structs:* Estructuras completamente vacías. Son útiles cuando más adelante veamos _Traits_ (rasgos/interfaces) donde un tipo necesita demostrar un comportamiento pero no requiere almacenar datos.

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

```rust
// Una estructura de tupla para almacenar coordenadas 3D (X, Y, Z)
struct Posicion3D(f32, f32, f32);

// Una estructura unitaria para marcar un estado o evento
struct FinDelJuego;

fn main() {
  // Instanciamos la Tuple Struct
  let origen = Posicion3D(0.0, 15.2, -3.4);
  
  // Para acceder a sus campos, usamos índices numéricos como en las tuplas normales
  println!("El jugador está en la altura Y: {}", origen.1);
}
```

#pagebreak()