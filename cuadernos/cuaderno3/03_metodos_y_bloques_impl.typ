#import "config.typ": *

= Añadiendo Superpoderes: Métodos y Bloques `impl`
En el bloque anterior aprendimos a agrupar variables dentro de una estructura (struct). Sin embargo, hasta ahora, si queríamos modificar un personaje o calcular algo con sus datos, teníamos que programar funciones externas en el main.

En Rust, podemos asociar funciones y comportamientos *directamente* a nuestras estructuras. Para ello utilizamos el bloque de implementación: *`impl`*.

== ¿Qué es un bloque `impl`? Separando los datos del comportamiento
A diferencia de otros lenguajes de programación donde los datos y las funciones se mezclan dentro de una "Clase", *Rust prefiere mantenerlos separados pero conectados*. En la *`struct`* defines qué datos tiene el objeto, y en el *`impl`* defines qué sabe hacer.

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
== El espejo de la estructura: Comprendiendo `self`, `&self` y `&mut self`
Para que una función dentro de un *impl* se considere un *método*, debe recibir como primer parámetro una palabra clave especial: *self*. self representa a la instancia exacta de la estructura que está ejecutando la acción.

#nota("Un método es una función que pertenece a una estructura y se aplica mediante un punto. Por ejemplo, si tenemos un objeto denominado halcon de una estructura denominada Pajaro y, esa estructura tiene un método denominado volar(), entonces podemos aplicar el método al objeto mediante la expresión 'halcon.volar()'. Aquí, la instancia es halcon y el método es volar(). halcon es self. Veremos a continuación cómo construimos un escenario similar a este.")

Los métodos operan sobre los datos del objeto struct. Dependiendo de lo que queramos hacer con los datos, utilizaremos tres variantes como primer parámetro en un método:

- *&self (Lectura):* Solo queremos leer los datos del objeto (por ejemplo, mostrar el estado en pantalla). Es la más común.

- *&mut self (Modificación):* Necesitamos alterar los datos internos del objeto (por ejemplo, cuando la nave recibe un disparo o gasta munición).

- *self (Consumo):* Toma el control total del objeto y lo destruye al terminar el método (se usa poco, por ejemplo, para transformar un objeto en otra cosa).

Veámoslo en acción con la nave:

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

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

En primer lugar definimos nuestra estructura (struct) con tres campos:

```rust
struct NaveEspacial {
    nombre: String,
    escudo: u32,
    municion: u32,
}
```
Los objetos que creemos con esta estructura van a tener unos métodos que tendremos que definir dentro el bloque:

```rust
impl NaveEspacial {
  // Definición de los métodos de la estructura
}
``` 
Coloquemos a continuación el mismo bloque pero ya con los métodos definidos:

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

Supongamos que hemos creado un *objeto_nave_esp* de tipo NaveEspacial. Luego veremos como se crea en el main.

La forma en que el objeto que hemos creado ejecuta los métodos anteriores es la siguiente:

1) objeto_nave_esp.reportar_estado()

Como vemos en la cabecera del método *fn reportar_estado(&self)*, recibe como primer y único parámetro un *prestamo* (o referencia) del *objeto mismo &self*. self representa el objeto que está llamando al método con el punto. Esto permite al método acceder a las propiedades del objeto en el interior del método, como *self.propiedad* (ejemplo self.nombre). Al haber recibido un prestamo &self, cuando el método termina de hacer su trabajo el objeto sigue activo, no se destruye.

2) fn recibir_disparo(&mut self, daño: u32)

Aquí la situación es analoga al caso anterior salvo que el método recibe dos parametros. El primer parámetro es *&mut self* y al igual que antes, el metodo podrá acceder a las propiedades del objeto mediante *self.propiedad* pero además de poder leerlas, la palabra *mut* en *&mut self* le permite tambien modificarlas.

El segundo argumento *daño* opera igual que en una función normal. Se utiliza en el interior del método.

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
  // Constructor: No recibe self, porque su trabajo es CREAR el objeto desde cero
  fn new(nombre_nave: &str) -> NaveEspacial {
      NaveEspacial {
          nombre: String::from(nombre_nave),
          escudo: 100,      // Todas las naves empiezan con escudo a tope
          municion: 50,     // Y munición cargada por defecto
      }
  }
}

fn main() {
  // Para llamar a una función asociada usamos los cuatro puntos (::)
  let nueva_nave = NaveEspacial::new("X-Wing");
  nueva_nave.reportar_estado();
}
```
El siguiente objeto:

```rust
 NaveEspacial {
    nombre: String::from(nombre_nave),
    escudo: 100,      // Todas las naves empiezan con escudo a tope
    municion: 50,     // Y munición cargada por defecto
}
```
es la expresión que devuelve la función *new*, ya que está en su última línea y no lleva punto y coma al final.

== 🎮 Proyecto Práctico I: El simulador de inventario de una tienda de videojuegos


#pagebreak()