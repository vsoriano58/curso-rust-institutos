#import "config.typ": *

= Añadiendo Superpoderes: Métodos y Bloques `impl`
En el bloque anterior aprendimos a agrupar variables dentro de una estructura (struct). Sin embargo, hasta ahora, si queríamos modificar un personaje o calcular algo con sus datos, teníamos que programar funciones en el main, externas a la estructura.

En Rust, podemos asociar funciones y métodos o comportamientos *directamente* a nuestras estructuras. Para ello utilizamos el bloque de implementación: *`impl`*. La diferencia entre funciones asociadas y métodos la veremos más adelante pero señalemos ahora que un método es una función especial.

== ¿Qué es un bloque `impl`? Separando los datos del comportamiento
A diferencia de otros lenguajes de programación donde los datos y las funciones se mezclan dentro de una "Clase", *Rust prefiere mantenerlos separados pero conectados*. En la *`struct`* defines qué datos tiene el objeto, y en el *`impl`* defines qué sabe hacer dicho objeto.

```rust
// 1. El contenedor de datos (El plano)
struct NaveEspacial {
    nombre: String,
    escudo: u32,
    municion: u32,
}

// 2. El bloque de comportamiento (Los superpoderes)
impl NaveEspacial {
    // Aquí dentro programaremos todas las funciones
    // exclusivas de la NaveEspacial
}
```
Arriba podemos ver dos bloques de código. El bloque *struct* en el que se definen las propiedades de la estructura *NaveEspacial* y el bloque *impl* que todavía está vacio pero es donde programaremos *las funciones y los métodos* de la estructura *NaveEspacial*.

== El espejo de la estructura: Comprendiendo `self`, `&self` y `&mut self`
Para que una función dentro de un *impl* se considere un *método*, debe recibir como primer parámetro la palabra clave *self* o una de sus variantes como veremos luego. *self* representa el *objeto* o *instancia* de la estructura que está ejecutando el *método* o *acción*.

Hemos visto que las estructuras (struc) sirven para crear objetos del tipo de la estructura. Cada objeto creado se denomina *instancia* y el proceso de creación se denomina *instanciación*.

Una vez que tenemos creado un objeto o instancia de la estructura, podremos ejecutar sus métodos con el operador punto (*`.`*).

*Nota*. Supongamos que hemos creado un objeto o instancia denominado *halcon* de una estructura denominada *Pajaro* y que la estructura tiene un método denominado *volar()*. Bien, pues entonces podemos ejecutar el método *volar()* del objeto *halcon* mediante la expresión *halcon.volar()*. Aquí, la instancia u objeto es halcon y el método o acción es volar(). halcon es el *self* que veremos a continuación. En este apartado construiremos un escenario similar al descrito.

Los métodos operan sobre los datos del objeto (struct). Dependiendo de lo que queramos hacer con los datos, utilizaremos una de las tres siguientes variantes como primer parámetro en un método:

- *&self (Lectura):* Solo queremos leer los datos del objeto (por ejemplo, mostrar el estado en pantalla). Es la más común.

- *&mut self (Modificación):* Necesitamos alterar los datos internos del objeto (por ejemplo, cuando la nave recibe un disparo o gasta munición).

- *self (Consumo):* El método toma el control total del objeto (la propiedad) y lo destruye al terminar el método (se usa poco, por ejemplo, para transformar un objeto en otra cosa).

Veámoslo en acción con la nave:

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *impl_metodos.rs*

La explicación del programa está después del listado.

```rust
// 1. El contenedor de datos (El plano)
struct NaveEspacial {
    nombre: String,
    escudo: u32,
    municion: u32,
}

impl NaveEspacial {
  // Método de LECTURA (&self): No modifica nada, solo muestra información
  fn reportar_estado(&self) {
      println!("🛰️ [{}] Escudo al {}% | Munición: {} torpedos.", self.nombre, self.escudo, self.municion);
  }

  // Método de MODIFICACIÓN (&mut self): Altera las variables internas
  fn recibir_disparo(&mut self, daño: u32) {
      if daño >= self.escudo {
          self.escudo = 0;
          println!("💥 ¡AVISO! El escudo de la nave {} se ha destruido.", self.nombre);
      } else {
          self.escudo -= daño;
          println!("💥 ¡Impacto! El escudo absorbió el daño.");
      }
  }
}

fn main() {
  // Es obligatorio usar 'mut' para poder llamar a métodos que usen &mut self
  let mut mi_caza = NaveEspacial {
      nombre: String::from("Halcón Milenario"),
      escudo: 100,
      municion: 10,
  };

  mi_caza.reportar_estado(); // Llama al método de lectura
  mi_caza.recibir_disparo(40); // Llama al método de modificación
  mi_caza.reportar_estado(); // Volvemos a leer para comprobar los cambios
}
```

*Explicación del programa*

En primer lugar definimos nuestra estructura con tres campos.

El bloque *struct*

```rust
struct NaveEspacial {
    nombre: String,
    escudo: u32,
    municion: u32,
}
```
Los objetos que creemos con esta estructura tendrán los métodos definidos en el bloque impl.

El bloque *impl*

```rust
impl NaveEspacial {
  // Método de LECTURA (&self): No modifica nada, solo muestra información
  fn reportar_estado(&self) {
      println!("🛰️ [{}] Escudo al {}% | Munición: {} torpedos.", self.nombre, self.escudo, self.municion);
  }

  // Método de MODIFICACIÓN (&mut self): Altera las variables internas
  fn recibir_disparo(&mut self, daño: u32) {
      if daño >= self.escudo {
          self.escudo = 0;
          println!("💥 ¡AVISO! El escudo de la nave {} se ha destruido.", self.nombre);
      } else {
          self.escudo -= daño;
          println!("💥 ¡Impacto! El escudo absorbió el daño.");
      }
  }
}
```
Como podemos ver hemos definido dos métodos, cuyas cabeceras son:

- fn reportar_estado(&self)

- fn recibir_disparo(&mut self, daño: u32)

Observa que en la función main se crea el objeto mutable *mi_caza* con la instrucción:

```rust
let mut mi_caza = NaveEspacial {
      nombre: String::from("Halcón Milenario"),
      escudo: 100,
      municion: 10,
  };
```

La forma en que el objeto que hemos creado ejecuta los métodos anteriores es la siguiente (ver en el main):

1) mi_caza.reportar_estado()

Como vemos en la cabecera del método *fn reportar_estado(&self)*, recibe como primer y único parámetro un *prestamo* (o referencia) *&self*. *self* representa el objeto que está llamando al método con el punto, es decir, *mi_caza*. Esto permite al método acceder a las propiedades del objeto en el interior del método con *self.propiedad* (ejemplo self.nombre). Al haber recibido un prestamo &self, cuando el método termina de hacer su trabajo el objeto sigue activo, no se destruye.

2) mi_caza.recibir_disparo(40)

Aquí la situación es analoga al caso anterior salvo que el método recibe dos parametros. El primer parámetro es *&mut self* y al igual que antes, el metodo podrá acceder a las propiedades del objeto mediante *self.propiedad* pero además de poder leerlas, la palabra *mut* en *&mut self* le permite tambien modificarlas.

El segundo argumento *daño* opera igual que en una función normal. Se utiliza en el interior del método.

#nota("Cuando se llaman los métodos de un struct con el operador punto, el primer parámetro ya sea &self, &mut self o self no es necesario colcarlo.")

*El método main*
En la función main se realiza toda la acción.

Se crea el objeto *mi_caza* de la estructura *NaveEspacial* y se *ejecutan sus métodos*.

```rust
fn main() {
  // Es obligatorio usar 'mut' para poder llamar a métodos que usen &mut self
  let mut mi_caza = NaveEspacial {
      nombre: String::from("Halcón Milenario"),
      escudo: 100,
      municion: 10,
  };

  mi_caza.reportar_estado(); // Llama al método de lectura
  mi_caza.recibir_disparo(40); // Llama al método de modificación
  mi_caza.reportar_estado(); // Volvemos a leer para comprobar los cambios
}
```
== Funciones asociadas: Constructores personalizados (`new`)
A veces queremos meter una función dentro de un `impl` que *no reciba self*. A esto se le llama *función asociada*. Como no tiene self, no actúa sobre un objeto ya creado, sino que suele usarse para *fabricar uno nuevo*. En Rust, la convención *para el constructor de un objeto es llamarlo `new`*.

```rust
impl NaveEspacial {
  // Constructor: No recibe self, porque su trabajo es CREAR el
  // objeto desde cero
  fn new(nombre_nave: &str) -> NaveEspacial {
      NaveEspacial {
          nombre: String::from(nombre_nave),
          escudo: 100,  // Todas las naves empiezan con escudo a tope
          municion: 50, // Y munición cargada por defecto
      }
  }
}

fn main() {
  // Para llamar a una función asociada usamos los cuatro puntos (::)
  let nueva_nave = NaveEspacial::new("X-Wing");
  nueva_nave.reportar_estado();
}
```
El constructor *new* que hemos definido crea un objeto de tipo *NaveEspacial* con los valores indicados para sus propiedades. Siempre que se invoque este constructor creará el mismo objeto que vemos abajo.

```rust
 NaveEspacial {
    nombre: String::from(nombre_nave),
    escudo: 100,      // Todas las naves empiezan con escudo a tope
    municion: 50,     // Y munición cargada por defecto
}
```
Este objeto es lo que devuelve la función *new*, ya que está en su última línea y no lleva punto y coma al final.

== 🎮 Proyecto Práctico I: El simulador de inventario de una tienda de videojuegos
Para cerrar este bloque, vamos a unificar las *`structs`*, los vectores (*`Vec`*) que aprendimos en el Cuaderno 2, y los bloques *`impl`* con constructores y métodos. Crearemos el motor de gestión para una tienda de videojuegos.

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *tienda_videojuegos.rs*

```rust
// Definimos la estructura de un Videojuego individual
struct Videojuego {
    titulo: String,
    precio: f64,
    stock: u32,
}

impl Videojuego {
    // Constructor de un juego
    fn new(titulo: &str, precio: f64, stock: u32) -> Videojuego {
        Videojuego {
            titulo: String::from(titulo),
            precio,
            stock,
        }
    }
}

// Definimos la estructura de la Tienda, que albergará una 
// lista de videojuegos
struct Tienda {
    nombre: String,
    inventario: Vec<Videojuego>, // Usamos un vector dinámico de estructuras
}

impl Tienda {
    // Constructor de la tienda
    fn new(nombre: &str) -> Tienda {
        Tienda {
            nombre: String::from(nombre),
            inventario: Vec::new(), // Empezamos con el inventario vacío
        }
    }

    // Método para añadir un videojuego al inventario
    fn agregar_juego(&mut self, juego: Videojuego) {
        println!("📦 Añadiendo al almacén: {}", juego.titulo);
        self.inventario.push(juego);
    }

    // Método de lectura para listar todos los productos en stock
    fn mostrar_inventario(&self) {
        println!("\n--- 🛒 INVENTARIO DE: {} ---", self.nombre.to_uppercase());
        for juego in &self.inventario {
            println!("• {} | Precio: {:.2}€ | Unidades: {}", juego.titulo, juego.precio, juego.stock);
        }
        println!("--------------------------------------\n");
    }

    // Método mutable para simular una venta
    fn vender_juego(&mut self, titulo_juego: &str) {
        let mut encontrado = false;

        for juego in &mut self.inventario {
            if juego.titulo == titulo_juego {
                encontrado = true;
                if juego.stock > 0 {
                    juego.stock -= 1;
                    println!("✅ ¡Venta realizada con éxito! Disfruta de: {}", juego.titulo);
                } else {
                    println!("❌ Lo sentimos, no queda stock de: {}", juego.titulo);
                }
                break; // Salimos del bucle al encontrar el juego
            }
        }

        if !encontrado {
            println!("🔍 El juego '{}' no se encuentra en nuestro catálogo.", titulo_juego);
        }
    }
}

fn main() {
    // 1. Inauguramos nuestra tienda
    let mut mi_tienda = Tienda::new("Pixel & Bits");

    // 2. Creamos y añadimos stock de productos
    let juego1 = Videojuego::new("Rust: Survival Evolved", 39.99, 3);
    let juego2 = Videojuego::new("Cyberpunk 2077", 59.99, 1);
    
    mi_tienda.agregar_juego(juego1);
    mi_tienda.agregar_juego(juego2);

    // 3. Mostramos el estado inicial
    mi_tienda.mostrar_inventario();

    // 4. Simulamos compras por parte de los clientes
    mi_tienda.vender_juego("Cyberpunk 2077"); // Quedará con stock 0
    mi_tienda.vender_juego("Cyberpunk 2077"); // Debería dar error de falta de stock
    mi_tienda.vender_juego("Minecraft");      // No existe en la tienda

    // 5. Comprobamos cómo ha quedado el inventario final
    mi_tienda.mostrar_inventario();
}
```
```
*La salida del programa*
📦 Añadiendo al almacén: Rust: Survival Evolved
📦 Añadiendo al almacén: Cyberpunk 2077

--- 🛒 INVENTARIO DE: PIXEL & BITS ---
• Rust: Survival Evolved | Precio: 39.99€ | Unidades: 3
• Cyberpunk 2077 | Precio: 59.99€ | Unidades: 1
--------------------------------------

✅ ¡Venta realizada con éxito! Disfruta de: Cyberpunk 2077
❌ Lo sentimos, no queda stock de: Cyberpunk 2077
🔍 El juego 'Minecraft' no se encuentra en nuestro catálogo.

--- 🛒 INVENTARIO DE: PIXEL & BITS ---
• Rust: Survival Evolved | Precio: 39.99€ | Unidades: 3
• Cyberpunk 2077 | Precio: 59.99€ | Unidades: 0
--------------------------------------
```

*Explicación del programa*

Vamos a escribir una especie de resumen del programa.

1) Tenemos dos estructuras en nuestro programa: *Videojuego* y *Tienda*.

- La estructura Videojuego tiene solo un constructor new en su bloque impl:
 - fn new(titulo: &str, precio: f64, stock: u32) -> Videojuego 
- La estructura Tienda tiene un constructor new y tres métodos:
 - fn new(nombre: &str) -> Tienda 
 - fn agregar_juego(&mut self, juego: Videojuego)
 - fn mostrar_inventario(&self) {
 - fn vender_juego(&mut self, titulo_juego: &str)

Veamos el constructor new de la estructura Videojuego. Su código es el siguiente:

```rust
fn new(titulo: &str, precio: f64, stock: u32) -> Videojuego {
        Videojuego {
            titulo: String::from(titulo),
            precio,
            stock,
        }
    }
```

Teóricamente lo tendríamos que haber escrito así:

```rust
fn new(titulo: &str, precio: f64, stock: u32) -> Videojuego {
        Videojuego {
            titulo: String::from(titulo),
            precio: precio,
            stock: stock,
        }
    }
```
Pero como los parámetros *precio* y *stock* se llaman igual que las propiedades correspondientes del Videojuego, es suficiente con escribirlo una sola vez como hacemos arriba.

Utilización de los métodos en el main.

*Creación de un videojuego*.
- El constructor a utilizar:
  - fn new(titulo: &str, precio: f64, stock: u32) -> Videojuego 
- La instrucción en el main:
  - let juego1 = Videojuego::new("Rust: Survival Evolved", 39.99, 3);

*Creación de la tienda*:
- El constructor a utilizar:
 - fn new(nombre: &str) -> Tienda
- La instrucción en el main:
 - let mut mi_tienda = Tienda::new(`"`Pixel & Bits`"`);

*Agregar un juego a la tienda:*
- El método a utilizar:
 - fn agregar_juego(&mut self, juego: Videojuego)
- La instrucción en el main:
 - mi_tienda.agregar_juego(juego1);

*Mostrar inventario de la tienda*
- El método a utilizar:
 - fn mostrar_inventario(&self) 
- La instrucción en el main:
 - mi_tienda.mostrar_inventario();

*Vender un juego*
- El método a utilizar:
 - fn vender_juego(&mut self, titulo_juego: &str)
- La instrucción en el main:
 - mi_tienda.vender_juego(`"`Cyberpunk 2077`"`);

Te queda un importante trabajo inspeccionando el interior de los métodos y observando:

- Como devuelven los constructores *new* los respectivos objetos.
- Como se utiliza el *operador punto* para acceder a las propiedades de un ojeto, por ejemplo *juego.titulo*.
- Diferenciar entre métodos que solo leen las propiedades del objeto y reciben como argumento *&self* de los que también pueden modificar el objeto recibiendo *&mut self*.



#pagebreak()
