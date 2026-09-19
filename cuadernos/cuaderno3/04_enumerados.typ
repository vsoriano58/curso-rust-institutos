#import "config.typ": *

= Enumerados (enum): La Joya de la Corona de Rust
Hasta ahora hemos aprendido a usar estructuras (`struct`) para modelar objetos fijos: una nave espacial siempre tiene un nombre, un escudo y munición. Pero, ¿qué pasa si queremos representar un concepto que puede manifestarse de diferentes formas mutuamente excluyentes?

Por ejemplo, la poción de un videojuego puede ser de _Salud, Magia o Fuerza_. Un usuario puede iniciar sesión mediante _Email, Teléfono o Google_. Para resolver esto con total seguridad en los tipos, Rust utiliza los enumerados (*`enum`*).

== Más allá de las listas fijas: Enumerados tradicionales vs. Datos asociados
En otros lenguajes de programación, un enumerado es simplemente una lista de etiquetas. En Rust, los enumerados son un "super-tipo" porque cada variante puede *almacenar sus propios datos con estructuras diferentes*.

Imagina el sistema de hechizos de un videojuego RPG:

#nota("Un juego RPG (Role-Playing Game) significa que es un juego de rol, donde controlas a un personaje o a un grupo mientras mejoran sus habilidades, suben de nivel y avanzan por una historia profunda")

```rust
// Un hechizo SOLO puede ser de una de las tres variantes
// que se definen en el enum Hechizo:
// Curacion: Variante tradicional (sin datos)
// BolaFuego: Variante con una estructura interna
// Teletransporte: Variante con una tupla interna (Coordenadas X, Y)
enum Hechizo {
    Curacion,                          
    BolaFuego { daño: u32, radio: f32 }, 
    Teletransporte(i32, i32),
```
Para instanciar una variante de un enumerado, utilizamos el nombre del enumerado seguido de los dos puntos dobles (::):

```rust
fn main() {
    // Creamos tres variables que son del mismo tipo "Hechizo"
    let hechizo_basico = Hechizo::Curacion;
    
    let hechizo_ataque = Hechizo::BolaFuego {
        daño: 50,
        radio: 4.5,
    };
    
    let escape_emergencia = Hechizo::Teletransporte(150, -80);
}
```
#nota("Las tres variables comparten el tipo Hechizo, pero cada una guarda la información exacta que necesita para funcionar.")

== El tipo Option`<T>`: La solución definitiva al peligro del valor "Nulo"
En la gran mayoría de lenguajes tradicionales (como Java, C++ o JavaScript) existe el concepto de valor *Nulo* (`null` o `nil`). ES el contenido de una variable que apunta al vacío (un lugar de la memoria en donde no existe información útil para el programa). Cuando intentas usar un valor nulo, provoca el error informático más famoso y temido del mundo: el *NullPointerException*, que hace que los programas se congelen y crasheen.

*En Rust no existe el valor Nulo*. ¡El creador del lenguaje lo eliminó por completo! En su lugar, Rust utiliza un enumerado nativo ultra inteligente llamado Option`<T>`.

Este enumerado viene integrado (incluido) en el lenguaje y está definido de la siguiente manera:

```rust
// T puede ser cualquier tipo
enum Option<T> {
    Some(T),      // Significa: "Aquí hay un valor válido de tipo T"
    None,         // Significa: "No hay ningún valor, está vacío"
}
```
Cuando una variable recibe un dato de tipo Option`<T>` ---Some(T) o None---, obliga al programador a gestionar explícitamente el caso en el que un dato no exista, haciendo imposible que el programa falle por sorpresa.

*Ejemplo de la vida real: El inventario de armas*

Imagina un personaje que puede o no equipar un arma en su mano derecha.

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *option_arma.rs*

```rust
struct Personaje {
    nombre: String,
    // El arma es opcional: puede tener un String con su nombre,
    // o no tener nada
    arma_equipada: Option<String>, 
}

fn main() {
    // Caso 1: Un guerrero armado
    let guerrero = Personaje {
        nombre: String::from("Conan"),
        arma_equipada: Option::Some(String::from("Espada Atlante")),
    };

    // Caso 2: Un monje que pelea con los puños libres
    let monje = Personaje {
        nombre: String::from("Shaolin"),
        arma_equipada: Option::None, // Expresamos la ausencia de datos con total seguridad
    };

    // Rust nos da métodos rápidos para comprobar el contenido de un Option:
    if guerrero.arma_equipada.is_some() {
        println!("⚔️ {} está listo para el combate.", guerrero.nombre);
    }

    if monje.arma_equipada.is_none() {
        println!("🧘 {} prefiere la diplomacia y sus puños.", monje.nombre);
    }
}
```
¿Cómo extraemos de forma segura el texto `"`Espada Atlante`"` que está atrapado dentro de Some sin romper el código? 

== La instrucción match

En el siguiente apartado nos detendremos para ver de forma detallada como utilizar la instrucción *match* para *desempaquetar* un *Option*, es decir, para averiguar lo que contiene, si es *Some* o es *None*. Ademas, en el caso de que Some avericguaremos que dato tiene dentro.

Sin embargo, en Rust, match es también una herramienta de control de flujo ultrapotente que funciona como un `"`if-else`"` tradicional con esteroides, y que además tiene la capacidad de "abrir" estructuras de datos como hemos comentado antes.

Aquí tienes una explicación resumida dividida en sus dos facetas principales:

- *Control de flujo general*: Funciona como un if/else extendido o un switch avanzado de otros lenguajes. Compara un valor con múltiples opciones (patrones) de forma exhaustiva y ejecuta el bloque de código de la primera opción que coincida.

- *Desempaquetado (Pattern Matching)*: Es el mecanismo nativo para extraer de forma segura el valor dentro de tipos complejos como Option (sacar el valor si es Some o manejar el caso si es None), obligándote por diseño a gestionar todos los escenarios posibles y evitando errores en tiempo de ejecución.

*Ejemplo de código*

Nos anticipamos un poco al siguiente tema con el objetivo de mostrar la capacidad de la instrucción *match* sin vincularla unicamente al desempaquetado de datos de tipo Option.

El siguiente listado presenta los dos casos de utilización de *match* que hemos comentado.

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *option_ejemplo.rs*

```rust
fn main() {
    // 1. Como control de flujo general
    let numero = 2;
    match numero {
        1 => println!("Es uno"),
        2 | 3 => println!("Es dos o tres"),
        _ => println!("Es cualquier otro número"), // Es como el "else" 
    }

    // 2. Para desempaquetar un Option
    let opcional = Some(1);
    match opcional {
        Some(dato) => println!("El valor interno es: {}", dato),
        None => println!("No hay ningún valor"),
    }
}
```

En el primer caso, como número es dos se imprime:

- `"`Es dos o tres`"`

En el segundo caso, la variable *dato* toma el valor del *argumento del Some* que en este caso es *1* e imprime:

- `"`El valor interno es: 1`"`

#nota("Hemos podido utilizar la expresión Some(1) sin definir nada antes porque el enumerado Option<T> con sus dos variantes Some(T) y None están definidas ya en el sistema por Rust")

En el siguiente tema seguimos hablando de match.





















#pagebreak()

