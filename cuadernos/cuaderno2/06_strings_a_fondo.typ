#import "config.typ": *

= El laberinto de las palabras: Strings a Fondo

En este tema hablaremos de los *strings* que representan *texto* y distinguiremos entre strings de tipo *&str*, que una vez creados no pueden cambiar y, strings de tipo *String*, que pueden ser modificados después de ser creados.

Si vienes de programar en lenguajes como Python, JavaScript o Java, las palabras y los textos eran simples: creabas una variable *texto = `"`Hola`"`* y te olvidabas de problemas. Pero en Rust, cuando intentas hacer operaciones sencillas con palabras, de repente el compilador te empieza a hablar de dos cosas llamadas *String* y *&str*.

¿Por qué Rust nos complica la vida con dos tipos de texto diferentes? La respuesta es, una vez más, el rendimiento y la seguridad de la memoria. Rust quiere que tu programa sea tan rápido como un videojuego de última generación, y para conseguirlo necesita tratar los textos fijos de una manera y los textos dinámicos (variables) de otra.

== El texto que no cambia (&str) vs. El texto dinámico (String)

Para entender la diferencia de un vistazo, vamos a usar una metáfora:

*&str* (también llamado String Slice o Texto prestado): Imagina un letrero tallado en piedra. El *&str* es un texto estático, fijo, que se graba directamente dentro del propio archivo ejecutable de tu programa. Como está "tallado en piedra", ocupa un espacio fijo, no puede crecer, ni encogerse, ni modificarse mientras el programa se ejecuta. Es increíblemente rápido de leer.

*String* (También llamado Texto dinámico o En propiedad): Imagina un bloc de notas de anillas. *String* es una estructura de datos que se guarda en la memoria dinámica (Heap) de tu ordenador. Puedes arrancar páginas, escribir palabras nuevas al final, borrar letras o cambiar su tamaño en cualquier momento. Al ser dinámico, requiere un poquito más de trabajo para el ordenador, pero te da total libertad para su uso.

Mira la diferencia en el código:

```rust
fn main() {
  // 1. Esto es un &str. Un texto fijo "tallado" en el código.
  let mensaje_fijo: &str = "¡Bienvenido al nivel 2!";
  
  // Si intentas hacer: 
  // mensaje_fijo.push_str(" Crack"); -> ¡ERROR! No se puede alterar la piedra.

  // 2. Esto es un String mutable (mut). 
  // Un bloc de notas dinámico en el que podemos escribir.
  let mut nombre_usuario: String = String::from("Gamer");
  
  // ¡Aquí sí tenemos libertad! Podemos modificarlo y añadirle "Pro_99"
  nombre_usuario.push_str("Pro_99"); 
  
  println!("Saludo: {}, {}", mensaje_fijo, nombre_usuario); 
  // Imprime: ¡Bienvenido al nivel 2!, GamerPro_99
}
```
== Conversiones y trucos útiles: .to_string(), .push_str() y concatenación

En el día a día con Rust, te vas a encontrar constantemente con que una función te pide un *String* pero tú tienes un *&str*, o viceversa. Aprender a pasar de un formato a otro es como aprender los cambios de marcha de un coche.

Aquí tienes el "manual de supervivencia" para trabajar con textos:

- *A) Pasar de Letrero de Piedra (&str) a Bloc de Notas (String)*

Si tienes un texto fijo y necesitas transformarlo en un texto mutable que pueda cambiar, usas *.to_string()* o *String::from()*:

```rust
fn main() {
    let texto_piedra: &str = "Hola";
    let texto_dinamico: String = texto_piedra.to_string(); // ¡Convertido!
    // o bien:
    let texto_dinamico2: String = String::from(texto_piedra);

    println!("{texto_dinamico}");   // Hola
    println!("{texto_dinamico}");   // Hola
}

```
Evidentemente, en el caso anterior texto_dinamico y texto_dinamico2 son iguales. En ambos casos el compilador puede inferir el tipo de la variable y podemos escribir:

```rust
let texto_dinamico = texto_piedra.to_string(); // ¡Convertido!
let texto_dinamico2 = String::from(texto_piedra);
```
- *B) Pasar de Bloc de Notas (String) a Letrero de Piedra (&str)*

¡Esto es gratis! Como un *String* es el dueño de todo el texto, si solo quieres prestar una parte o su totalidad para que alguien lo lea como un *&str*, basta con ponerle el símbolo de préstamo (&) delante:

```rust
let bloc_notas: String = String::from("Contenido importante");

// Rust lo convierte automáticamente a &str
let prestamo_lectura: &str = &bloc_notas;
```

- *C) Modificar un String sobre la marcha*

Para añadir letras a un bloc de notas mutable, tienes dos herramientas clave:
 + *push()*: Añade un único carácter (va entre comillas simples, ej: 'a').
 + *push_str()*: Añade una frase o palabra completa (va entre comillas dobles, ej: "hola").

*Ejemplo:*

```rust
fn main() {
  // Para que un String sea mutable tenemos que declararlo con mut
  let mut palabra = String::from("Ruste");
  palabra.pop();                // Quita la 'e' final -> "Rust"
  palabra.push('a');            // Añade un carácter -> "Rusta"
  palabra.push_str("ceos");     // Añade un string slice (&str) -> "Rustaceos"
  
  println!("{}", palabra);      // Rustaceos
}
```

- *D) El truco de la macro format!*

Intentar sumar varios textos en Rust usando el símbolo + puede volverse muy caótico por culpa de las reglas de propiedad (Ownership). La forma más elegante, limpia y profesional de combinar textos y variables en un nuevo String es usar la macro *format!*. Funciona exactamente igual que println!, pero en lugar de lanzar el texto por el altavoz de la pantalla, lo empaqueta y lo guarda en una variable.

```rust
fn main() {
  let clase = "4º ESO";
  let alumnos = 28;
  
  // format! une todo de forma segura y nos devuelve un String perfecto
  let informe: String = format!("Grupo: {} | Total alumnos: {}", clase, alumnos);
  
  println!("{}", informe);  // Grupo: 4º ESO | Total alumnos: 28
}
```

#pagebreak()