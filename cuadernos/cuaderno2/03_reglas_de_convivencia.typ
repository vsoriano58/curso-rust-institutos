#import "config.typ": *

= 🤝 Las Reglas de Convivencia: Introducción Intuitiva al Ownership
Llegamos al núcleo de lo que hace a Rust un lenguaje único en el mundo: el Ownership (Propiedad).

Para entenderlo, imagina que cuando tu programa quiere guardar el valor de una variable, primero debe pedirle al sistema operativo un "hueco" o reserva de memoria RAM donde quepa ese valor.

El problema es que, muchas veces, unas líneas más abajo en el código dejamos de usar esa variable, pero la reserva de memoria sigue activa. Si esto ocurre dentro de una función que se repite miles de veces, el programa irá acumulando memoria ocupada e inútil hasta que el ordenador se sature y falle. Este es el famoso _Memory Leak_ (fuga de memoria), y es solo uno de los muchos dolores de cabeza que existen.

¿Cómo se soluciona esto? Liberando la memoria cuando ya no se usa. Cada lenguaje lo hace a su manera:

- *Java, Python o C`#`*: Tienen un Recolector de Basura (Garbage Collector). Es un vigilante en segundo plano que limpia la memoria de forma automática, pero a costa de ralentizar el programa.

- *C o C++*: Todo depende de la destreza del programador, que debe escribir a mano cuándo liberar la memoria. Un solo olvido provoca fallos graves de seguridad o cierres inesperados.

- *Rust*: ¡Toma un camino revolucionario! No tiene un recolector que vuelva lento el programa, pero tampoco deja la responsabilidad en manos del programador. En Rust, *el propio compilador añade el código de limpieza de forma automática*, asegurándose de que la memoria se libere exactamente en el momento adecuado.

El compilador de Rust aplica las tres reglas que mencionamos a continuación para controlar las reservas y liberaciones de memoria:

+ Cada valor en Rust tiene un dueño (owner).
+ Solo puede haber un dueño a la vez.
+ Cuando el dueño sale del ámbito (scope), el valor se destruye.

En los tres puntos anteriores, un dueño es una variable que maneja el valor de una variable en memoria.

Para comprender el significado de ámbito (scope) veamos el siguiente ejemplo:

```rust
fn main() {
    let nombre = "Diego";

    {
        let color = "rojo";
        println!("{color}" );
    } // <-- Final del ámbito de la variable color
    
    println!("{nombre}");
}   // <-- Final del ámbito de la variable nombre

```
Como vemos en el listado, el ámbito de una variable termina en la llave de cierre del bloque en la que está definida.

== ¿Quién es el dueño del dato? La regla del propietario único
En Rust:

Cada dato en memoria tiene una variable que es su dueño (owner).

Solo puede haber un dueño a la vez.

Cuando la variable queda fuera de ámbito porque el programa ha llegado hasta el final de su ámbito, el dato que representa la variable se destruye automáticamente para no ocupar espacio en la memoria del ordenador.
== El peligro de la copia vs. el movimiento (Move)
En este apartado vamos a ver *como cambia el propietario de un dato* cuando hacemos una asignación de una variable a otra. Esto ocurre cuando se trata de datos complejos como textos dinámicos. Veremos como ejempo el caso de un String (Texto).

Existen al menos dos formas de definir un string:

```rust
let mi_string1 = "Hola Mundo".to_string();
let mi_string2 = String::from("Hola Mundo");

```
Las dos variables definidas son de tipo *String* y representan la misma cadena de texto en ambos casos: *Hola Mundo*. 

Veamos en el siguiente ejemplo como el dato, el String *Spiderman: Año Uno* cambia de dueño al hacer una asignación de variables.

Con la terminal abierta en tu carpeta de proyectos de Rust, haz clic derecho sobre la carpeta y *crea una terminal integrada de Visual Studio Code*. Crea un proyecto de Cargo con el comando *cargo new nombre_proyecto*, sustituye el código del *main.rs* por el siguiente listado y ejecuta el programa mediante *cargo run*.

```rust
fn main() {

    // El dueño del dato es comic_original
    let comic_original = String::from("Spiderman: Año Uno");
    
    // El dato SE MUEVE de dueño
    // El dueño del dato es ahora "otro_comic"
    let otro_comic = comic_original; 

    // Aquí la variable comic_original ya no existe
    
    // ERROR COMPILADOR: Intentas leer algo que ya no existe
    // println!("Voy a releer mi cómic: {}", comic_original); 
    
    println!("Mi amigo está leyendo: {}", comic_prestado); // Esto sí funciona
}
```
En el código anterior, al acer la asignación *let otro_comic = comic_original;*, el dueño del dato *Spiderman: Año Uno* se mueve de *comic_original* (que era su dueño original) a *otro_comic* que es su nuevo y único dueño.

Además, la variable *comic_original* se destruye y deja de existir.

Hemos dicho que esto solo ocurre cuando se trata de datos complejos como textos dinámicos, y hemos puesto como ejemplo un String para que puedas comprobarlo. Descomenta el último println! e intenta compilar.

Sin embargo, esto no ocurre cuando se trata de los tipos básicos mencionados en el Cuaderno 1. Veamos un ejemplo:

```rust
fn main() {
  let a = 10;
  let mut b = a;
  
  println!("{a}");  // 10
  println!("{b}");  // 10
  
  b = 16;
  println!("{a}");  // 10
  println!("{b}");  // 16
}   
```
Como no hemos especificado el tipo de las variables a y b, el compilador las tomará por defecto como *i32*, un tipo básico.

La variable *b* la hemos hecho mutable *let mut b* para poder cambiar su valor después de su primera asignación y comprobar que evoluciona por si sola independiente de *a*.

La asignación *let mut b = a;* no consume en este caso la variable *a*, que no se destruy,e ya que como podemos comprobar la utilizamos posteriormente imprimiéndola en la instrucción *println!(`"`{a}`"`);*. 

Esto ocurre, como hemos mencionado, parque las variables *a* y *b* son de *tipo básico*, concretamente *i32*. Con los *String* ya vimos también que las asignaciones funcioan de manera diferente,

== Compartir es vivir: Referencias (&) y "Préstamos" (Borrowing)
Como ir perdiendo la propiedad de tus variables cada vez que las asignas a otra variable es un dolor de cabeza, Rust inventó las Referencias (&). En lugar de regalar el cómic y perder la propiedad, lo dejas prestado para que lo lean.

El símbolo *&* delante de una variable significa: "Te dejo mirar este dato, te lo presto, pero sigue siendo mío".

En el siguiente ejemplo, la función *mostrar_info_comic* admite un parámetro denominado *comic* del tipo *&String*. Es por tanto un préstamo de un tipo String. El cuerpo de la función imprime el argumento que se le pase al parámetro *comic*.

```rust
// Esta función solo "mira" el texto, para imprimirlo.
// No se adueña de él. Usa &String
fn mostrar_info_comic(comic: &String) {
    println!("Examinando el ejemplar: {}", comic);
}

fn main() {
    let mi_comic = String::from("Batman: El caballero oscuro");
    
    // Pasamos el cómic con un "&" delante. ¡Es un préstamo!
    mostrar_info_comic(&mi_comic); 
    
    // ¡Buenas noticias! Como solo lo prestamos para mirar, seguimos siendo los dueños.
    println!("Lo guardo en mi estantería: {}", mi_comic); 
}
```
Cuando la llamamos en el *main* con *mostrar_info_comic(&mi_comic);*, le pasamos un préstamo de *mi_comic* a la función para que lo pueda imprir pero como no le hemos pasado la variable completa *mi_comic*, sino solamente un préstamo; la variable *mi_comic* sigue activa después de la llamada a la función; no se ha consumido y podemos imprimirla. 

== Préstamos mutables (&mut): Solo puede quedar uno
Ya hemos visto que con *&* podemos prestar un dato para que otros lo lean. Pero, ¿qué pasa si queremos prestar algo para que lo modifiquen? Imagina que le dejas tu cuaderno a un compañero para que corrija un ejercicio. Necesitas hacer un préstamo mutable, y en Rust esto se escribe con *&mut*.

Para evitar que el código se vuelva un caos y dos partes del programa
intenten escribir a la vez sobre el mismo dato, Rust impone una regla de oro muy estricta: *mientras un dato esté prestado para modificarse (&mut), nadie más puede mirarlo ni modificarlo a la vez*. 

Solo puede haber un préstamo mutable activo.

Mira este ejemplo de cómo funciona un taller de pintura de coches:

```rust
// Esta función recibe un coche modifcable usando &mut String
fn pintar_coche(coche: &mut String) {
    coche.push_str(" con alerón y pintura metalizada"); // Modificamos el texto original
}

fn main() {
    // 1. El coche original TIENE que ser mutable (mut) para poder cambiarlo
    let mut mi_coche = String::from("Seat Ibiza Blanco");
    
    // 2. Lo prestamos al taller usando &mut
    pintar_coche(&mut mi_coche);
    
    // 3. El coche original ha cambiado permanentemente en la memoria
    println!("Resultado del taller: {}", mi_coche); 
    // Imprime: Resultado del taller: Seat Ibiza Blanco con alerón y pintura metalizada
}
```

Ejecútalo en la Playground de Rust.

- La línea *coche.push_str(`"` con alerón y pintura metalizada`"`);* añade al final del contenido de la variable *coche*, que tiene que ser de tipo *String*, el texto *con alerón y pintura metalizada*.

- En la línea *pintar_coche(&mut mi_coche);* le pasamos a la función *pintar_coche* el préstamo mutable *&mut mi_coche* para que la función, en su interiror, pueda modificar la variable *mi_coche* como vemos al imprimirla inmediatamente después.

Como a la función le hemos pasado un préstamo, en este caso mutable, la variable mi_coche no se consume (no se destruye) en el préstamo a la función. La función modifica la variable y podemos imprimirla después, luego sigue activa.

🚨 Un error muy común al empezar: Si intentas crear dos referencias mutables de la misma variable al mismo tiempo, el compilador te detendrá con un mensaje de error claro: *cannot borrow as mutable more than once at a time*. ¡Rust cuida que nadie rompa la memoria de tu ordenador!

Lo podemos comprobar escribiendo de una forma ligeramente distinta el programa anterior al que definimos dos referencias mutables a mi_coche.

Ejecuta el programa en la Playground para obtener el error.

```rust
// Esta función recibe un coche modifcable usando &mut String
fn pintar_coche(coche: &mut String) {
    coche.push_str(" con alerón y pintura metalizada"); // Modificamos el texto original
}

fn main() {
    // 1. El coche original TIENE que ser mutable (mut) para poder cambiarlo
    let mut mi_coche = String::from("Seat Ibiza Blanco");
    
    // 2. Definimos dos referncias muables a mi_coche
    let referencia_mut_1 = &mut mi_coche;
    let referencia_mut_2 = &mut mi_coche;   //  ❌ ERROR:
    
    // 2. Lo prestamos al taller usando referencia_mut_1
    pintar_coche(referencia_mut_1);
    
    // 3. El coche original ha cambiado permanentemente en la memoria
    println!("Resultado del taller: {}", mi_coche); 
    // Imprime: Resultado del taller: Seat Ibiza Blanco con alerón y pintura metalizada
}
```
Comenta la línea *let referencia_mut_2 = &mut mi_coche;* con dos barras `//` al principio y vuelve a ejecutar el programa. El error ha desaparecido.

== Consumo (destrucción) de una variable cuando se pasa como parámtero 

En los dos casos anteriores en los que que hemos pasado referencias de una variable a una función, en el primer caso mutable y en el segundo inmutable, hemos comprobado que la variable original sigue estando activa y podemos imprimirla después de la llamada a la función.

Vamos a ver a continuación con un ejemplo que si pasamos la variable original (no una referencia) a la función, después de la llamada a la función la variable original se ha consumido (se ha destruido, ya no es accesible.)

Ejecuta el siguiente programa en la Playground de Rust:

```rust
// Esta función recibe un coche modifcable de tipo String
// Lo indica en su parámetro: mut coche: String
fn pintar_coche(mut coche: String) {
  coche.push_str(" con alerón y pintura metalizada"); //Modificamos el texto original
}

fn main() {
  let mut mi_coche = String::from("Seat Ibiza Blanco");

  pintar_coche(mi_coche);
  println!("Resultado del taller: {}", mi_coche); //  ❌ ERROR:
    
  println!("Final del programa")
    
}
```
Al pulsar el botón de [RUN] obtendrás un mensaje del compilador porque después de pasar mi_coche a pintar_coche, operación en la cuel se consume la variable mi_coche, le pasamos luego otra vez la variable mi_coche que ya no existe a la función println.

Comenta la línea con dos barras al principio:

```rust
// println!("Resultado del taller: {}", mi_coche); 
```

Vuelve a ejecutar el programa y comprueba que funciona.

#pagebreak()