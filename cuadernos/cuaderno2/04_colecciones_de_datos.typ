#import "config.typ": *

= 📦 Colecciones de Datos: Colecciones de datos: Arrays y Vectores
Hasta ahora, nuestras variables eran como cajas individuales donde guardábamos un solo dato: un número, un texto o un booleano. Pero en la vida real, los programas manejan listas de cosas: las puntuaciones de una partida, los nombres de los alumnos de clase o los artículos de un inventario.

Para gestionar estas listas, Rust nos ofrece dos herramientas fundamentales: los *Arrays* y los *Vectores*.

== 🥊 Semejanzas y Diferencias: ¿Quién es quién?
Antes de verlos en código, hagamos una comparativa rápida para saber en qué se parecen y en qué se diferencian:

- Semejanzas: Ambos son colecciones *homogéneas*. Esto significa que todos los elementos de la lista tienen que ser obligatoriamente del mismo tipo de dato (todo números enteros, todo textos, etc.). No puedes mezclarlos. Además, en ambos casos el primer elemento de la lista está en la *posición 0*.

- Diferencias: La diferencia clave está *en el tamaño durante el programa y en cómo se alojan en la memoria del ordenador*. 

 - Un Array tiene un *tamaño fijo* que se decide al escribir el código y nunca puede cambiar. Se guarda en el Stack (una zona de la memoria ultra rápida). 

 - Un Vector tiene un *tamaño dinámico*: puede crecer o encogerse mientras el programa se ejecuta. Se guarda en el Heap (una zona de memoria más flexible).

*¿Para qué sirve cada uno?*

- Usarás un *Array* cuando sepas de antemano el *número exacto de elementos* que va a tener y éste *nunca vaya a cambiar* (por ejemplo: los 7 días de la semana, las 4 estaciones o las coordenadas X e Y de un punto).

- Usarás un Vector cuando la *lista sea totalmente impredecible* (por ejemplo: los enemigos que aparecen en pantalla, los mensajes de un chat o la lista de la compra de un usuario).

= 🗂️ Arrays: Listas con tamaño grabado a fuego

== Creación y métodos más importantes

Para crear un array, encerramos los valores entre corchetes []. Rust nos permite declarar su tipo y su tamaño fijo con la sintaxis [tipo; tamaño]:

Veamos un par de ejemplos:

```rust
// Un array de 4 números flotantes f32
let temperaturas: [f32; 4] = [15.5, 22.1, 30.4, 18.2];

// Truco: Crear un array de 500 elementos todos cero
// Como hemos indicado nada, por defecto serán i32
let contador_ceros = [0; 500];

```
Los métodos y operaciones más importantes de un array son:
- Acceso por índice: temperaturas[0] nos da el primer elemento (15.5).
- Conocer su tamaño: El método .len() nos dice cuántos elementos tiene.
- Comprobar si está vacío: El método .is_empty() devuelve true o false.

Veamos un sencillo ejemplo:
```rust
fn main() {
    let temperaturas: [f32; 4] = [15.5, 22.1, 30.4, 18.2];
    println!("Primera temperatura: {}", temperaturas[0]);
    println!("Longitud del array temperaturas: {}", temperaturas.len());
    println!("¿Está vacío el array temperaturas?: {}", temperaturas.is_empty()); 
}
```
Ejecutando el programa en la Playground obtendrás el resultado:

```
Primera temperatura: 15.5
Longitud del array temperaturas: 4
¿Está vacío el array temperaturas?: false
```

== Propiedad (Ownership) en los Arrays

En Rust, los tipos de datos simples (como números enteros, decimales y booleanos) tienen el rasgo Copy. Esto significa que cuando creas un array de números, los datos se copian fácilmente. Si pasas el array a otra variable, ambas variables seguirán funcionando de forma independiente. El array original no se destruye ni se "mueve".

== 💻 Ejemplo Completo con Arrays

Imagina que queremos registrar las notas de los 3 trimestres de un alumno:

```rust
fn main() {
    // Creamos un array fijo de 3 elementos
    let notas_trimestre: [f32; 3] = [8.5, 9.0, 7.5];

    println!("Has cursado {} trimestres.", notas_trimestre.len());
    println!("La nota del segundo trimestre fue: {}", notas_trimestre[1]);
}

```

Si iIntentas acceder a notas_trimestre[4] hará que el compilador te lanzará un error porque sabe perfectamente que el array solo llega hasta el índice 2. ¡Seguridad ante todo!

= 🛍️ Vectores: La lista elástica

== Creación y métodos más importantes

Los vectores se representan como *Vec<T>* (donde la T significa el tipo de dato que guardará). La forma más común e intuitiva de crearlos es usando el "atajo" o macro *vec!*:

```rust
// Un vector mutable de textos dinámicos
let mut mochila = vec![String::from("Linterna"), String::from("Cuerda")];

```
Como los vectores pueden cambiar de tamaño, tienen métodos específicos muy potentes:

- .push(valor): Añade un elemento al final de la lista.
- .pop(): Quita el último elemento de la lista y te lo devuelve.
- .insert(índice, elemento): Mete un elemento en la posición exacta (índice) que tú quieras, desplazando los demás.
- .remove(índice): Borra el elemento de esa posición (índice).
- [posicion]: Te permite cotillear qué hay en una posición concreta. (Recuerda: ¡En informática siempre empezamos a contar desde la posición 0!)

== Propiedad (Ownership) en los Vectores

Aquí es donde Rust se pone serio. Un vector es dueño de los datos que contiene. Si tu vector guarda elementos complejos (como String), no puedes simplemente sacar un elemento asignándolo a otra variable, porque estarías intentando "mover" la propiedad de una parte interna del vector, y Rust no lo permite.

Para leer datos de un vector sin romper el programa, casi siempre utilizaremos referencias (&) (préstamos para mirar).

== 💻 Ejemplo Completo con Vectores

Vamos a simular el inventario de un jugador en un videojuego de rol (RPG):

```rust
fn main() {
    // 1. Inicializamos la mochila con dos ítems. Debe ser mutable (mut) para añadir cosas
    let mut inventario = vec![String::from("Poción de vida"), String::from("Escudo de madera")];

    // 2. El jugador encuentra un objeto y lo guarda
    inventario.push(String::from("Espada de hierro"));

    // 3. Queremos mirar qué hay en la primera posición. 
    // ¡Usamos "&" para pedirlo prestado! Si no ponemos "&", Rust dará error.
    let primer_objeto = &inventario[0];
    println!("El primer objeto de tu inventario es: {}", primer_objeto);

    // 4. El jugador usa el último objeto que recogió (la espada)
    let objeto_usado = inventario.pop(); 
    // .pop() saca el elemento del vector, reduciendo su tamaño a 2.
    println!("Has usado: {:?}", objeto_usado); 

    println!("Artículos restantes en la mochila: {:?}", inventario);
}

```

== Recorriendo el vector con bucles for
Ya sabes guardar datos en un vector y cómo extraer elementos sueltos. Pero el verdadero potencial de las colecciones aparece cuando quieres procesar toda la lista de golpe: aplicar un filtro, calcular una media o imprimir un listado de alumnos.

Para hacer esto de forma automática, sin escribir código fila por fila, usamos el bucle *for* combinado con un préstamo (*&*). Al poner el & antes del vector, le estamos diciendo a Rust: "Déjame mirar uno a uno los elementos de la lista, pero no destruyas el vector al terminar".

Mira qué limpio queda el código para pasar lista en clase:

```rust
fn main() {
  let alumnos = vec![
      String::from("Lucía"), 
      String::from("Marcos"), 
      String::from("Sofía")
  ];

  println!("--- CONTROL DE ASISTENCIA ---");
  // "alumno" es una variable temporal que tomará el valor de cada elemento en cada vuelta
  for alumno in &alumnos {
      println!("👤 Presente: {}", alumno);
  }
  
  // Como usamos "&alumnos", la lista sigue existiendo aquí perfectamente
  println!("Total de alumnos registrados: {}", alumnos.len());
}
```
💡 *¿Y si queremos modificar los elementos del vector mientras lo recorremos?*

¡Fácil! Usamos un préstamo mutable tanto en el bucle como en el vector (&mut). Por ejemplo, si quisiéramos sumarle un punto de bonificación a una lista de notas por buen comportamiento:

```rust
fn main() {
  let mut notas = vec![4.5, 6.0, 8.5];

  // Usamos &mut para tener permiso de escritura en cada nota
  // Ahora nota es una referncia por haber utilizado &mut
  for nota in &mut notas {
  
  // El asterisco (*) sirve para entrar "dentro" de la referencia
  // y cambiar el valor
  *nota += 1.0; 
  }

  // Imprime: [5.5, 7.0, 9.5]
  println!("Notas con el punto extra: {:?}", notas);
}
```

==  📇 Proyecto Final: La Agenda de Contactos por Terminal
¡Ha llegado el momento de la verdad! Vamos a construir una aplicación real desde cero: una *Agenda de Contactos interactiva* que se ejecuta en la terminal de tu ordenador. El programa mostrará *un menú en bucle* que permitirá al usuario *añadir* nuevos amigos, *listar* los contactos guardados y *buscar* un teléfono rápidamente por el nombre.

Resumiendo: vamos a hacer un programa que controle el Sistema de Puntuaciones de un cierto Videojuego.

El programa se basa en determinadas funciones que reciben como argumento un *préstano de un vector*, en algunas ocasiones _inmutable_ *&* y en otras _mutable_ *&mut*. Cuando el argumento que recibe la función es un prestamo inmutable *&* solo queremos leer el valor de los elementos del vector que le pasamos a la función pero, si es mutable *&mut*, queremos modificar alguno o todos los elementos del vector.

En este proyecto del Cuaderno 2, juntaremos las piezas del puzle: Funciones, Vectores, Estructuras de control y manipulación de Strings.

*🛠️ El Diseño de la Aplicación*

Para que el código esté limpio y ordenado (como el de los programadores profesionales), organizaremos la información utilizando dos vectores:

- *lista_nombres*: Un vector de tipo Vec<String> para almacenar los *nombres de pila*. La notación Vec<String> indica que todos los elementos del vector son de tipo String. Podemos definir, si queremos, vectores de cualquier tipo. Por ejemplo Vec<i32> sería un vector cuyos elementos son enteros de 32 bits.

- *lista_telefonos*: Un vector de tipo Vec<String> para guardar sus números de teléfono. En este caso los números se guardarán como si fueran texto, es decir, no se podrá operar matemáticamente con ellos.

Nota: La posición 0 de ambos vectores corresponderá al primer contacto, la posición 1 al segundo, y así sucesivamente.

Antes de empezar a analizar el programa en su totalidad, vamos a comentar la parte del mismo que se encarga de pedir datos al usuario.

Para ello, vamos a crear ya el programa definitivo para este ejemplo y en plrimer lugar, ejecutaremos solamente un código reducido que pide al usuario que escriba algún dato y después de escribir y pulsar Return, el programa devuelve lo que ha escrito el usuario.

Abre un terminal integrado de Visual Studio Code en tu carpeta de proyectos de Rust y crea un nuevo proyecto con la orden:

```
cargo new agenda_contactos
```

Se creará el directorio *agenda_contactos* y dentro el fichero main.rs en el interior de la carpeta *src*.

Copia el siguiente programa, que es solo una demo de como un programa solicita datos al usuario y los muestra y, pegalo en el fichero main.rs del proyecto que acabas de crear.

Ejecútalo con *cargo run* y cuando te pida que introduzcas una palabra, tecléala y termina pulsando *Return*. Observa la salida por la pantalla.

```rust
use std::io::{self, Write}; 

fn main() {
     // Pedimos al usuario que introduzca una palabra
    print!("Introduce cualquier palabra: ");

    // Fuerza a la terminal a mostrar el texto en pantalla
    io::stdout().flush().unwrap();

    // Creamos un String mutable vacío
    let mut algo = String::new();

    // Esperamos a que el usuario teclee Return
    // después de escribir y colocamos lo que haya escrito
    // en la variable algo
    io::stdin().read_line(&mut algo).unwrap();

    // Limpiamos la variable algo de espacios al inicio
    // y al final, y la convertimos en String. Antes era &str.
    let algo = algo.trim().to_string();
    
    // Imprimimos lo que ha escrito el usuario
    println!("✅ Has escrito: {}", algo);
}
```
No es nuestro objetivo averiguar qué hace cada palabrita del anterior programa sino entender lo que hace cada línea porque en el proyecto final que vamos a desarrollar aparcerán bloques muy parecidos a este que hemos analizado. Lo que nos interesa de verdad es todo lo relacionado con los vectores.

En el listado completo del programa que daremos al final, aparecen algunas funciones con un ecabezado similar pero no idéntico.

- Veamos la función *mostrar_contactos*

```rust
fn mostrar_contactos(nombres: &Vec<String>, telefonos: &Vec<String>) {
    println!("\n=== 👥 LISTA DE CONTACTOS DE LA AGENDA ===");
    
    if nombres.is_empty() {
        println!("⚠️ La agenda está completamente vacía.");
        return;
    }

    // Recorremos las posiciones usando un índice numérico desde 0 hasta el tamaño del vector
    for i in 0..nombres.len() {
        // Accedemos de forma segura a cada posición usando [i]
        println!("{}. 👤 Nombre: {} | 📞 Teléfono: {}", i + 1, nombres[i], telefonos[i]);
    }
    println!("==========================================");
}
```

Esta función tiene dos parámetros que son ambos prestamos de vectores de String. El primer parámetro se denomina *nombres* y el segundo *telefonos*. Cuando llamemos a la función desde el main le pasaremos un prestamo *&* del vector *agenda_nombres* en la primera posición y un prestamo *&* del vector *agenda_telefonos* en la segunda posición,ambos definidos al principio del *main* con las siguientes instrucciones:

```rust
let mut agenda_nombres: Vec<String> = Vec::new();
let mut agenda_telefonos: Vec<String> = Vec::new();
```
La llamada a la función en el main tiene la forma:

```rust
mostrar_contactos(&agenda_nombres, &agenda_telefonos);
```
Donde observamos lo que acabamos de comentar.

*¿Qué hace la función por dentro?*

- Si el vector de *nombres* está vació, entonces *nombres.is_empty()* devuelve un valor *true*. El if se cumple y por tanto el programa muestra un mensaje y termina con un *return*.

- Si el *if* no se cumple, pasamos a la instrucción *for*. Aquí tengamos en cuenta que *nombres.len()* nos da la cantidad de elementos que tiene el vector *nombres*. Es decir, si *nombres tiene 5 elementos* entonces *nombres.len() es igual a 5*.

-  En el bucle *for i in 0..nombres.len()*, la variable *i* empieza por valer 0 y en cada pasada del bucle aumenta en uno su valor hasta valer nombres.len() que en el caso anterior hemos supuesto que vale 5. Entonces la varuiable i va tomando los valores 0, 1, 2, 3, 4 porque el último de los valores, el 5, está excluido del rango. Si quisiéramos que el rango hubiese llegado hasta el 5 tendríamos que haber secrito *for i in 0..=nombres.len()*.

Para cada valor de i, se ejecutan todas las instrucciones que hay dentro del for. En este caso solo hay una.

Para i=0 se ejecutará:

```rust
println!("{}. 👤 Nombre: {} | 📞 Teléfono: {}", 0 + 1, nombres[0], telefonos[0]);
```
Para i=1 se ejecutará:

```rust
println!("{}. 👤 Nombre: {} | 📞 Teléfono: {}", 1 + 1, nombres[1], telefonos[1]);
```

Si hemos supuesto que tenemos 5 valores en el vector, el último prinln! sería:

```rust
println!("{}. 👤 Nombre: {} | 📞 Teléfono: {}", 4 + 1, nombres[4], telefonos[4]);
```
El resultado sería un listado con los nombres y telefonos de los contactos.

- Analicemos ahora la función *añadir_contacto*

```rust
fn añadir_contacto(nombres: &mut Vec<String>, telefonos: &mut Vec<String>) {
    println!("\n--- 🆕 Añadir Nuevo Contacto ---");
    
    // Pedimos el nombre y lo colocamos en la variable "nombre"
    print!("Introduce el nombre: ");
    io::stdout().flush().unwrap(); 
    let mut nombre = String::new();
    io::stdin().read_line(&mut nombre).unwrap();
    let nombre = nombre.trim().to_string();

    // Pedimos el teléfonoy lo colocamos en la variable "telefono"
    print!("Introduce el teléfono: ");
    io::stdout().flush().unwrap();
    let mut telefono = String::new();
    io::stdin().read_line(&mut telefono).unwrap();
    let telefono = telefono.trim().to_string();

    // Guardamos los datos en sus respectivos vectores
    // Las datos se añaden a los que ya hayan
    nombres.push(nombre);
    telefonos.push(telefono);
    
    println!("✅ ¡Contacto guardado con éxito!");
}
```
De esta forma actualizamos los dos vectores "nombres "y "telefonos" con los nuevos valores que hemos introducido por teclado.

- Analicemos ahora la función *buscar_contacto*

```rust
fn buscar_contacto(nombres: &Vec<String>, telefonos: &Vec<String>) {

  // Indicamos que vamos a buscar por nombre
  println!("\n--- 🔍 Buscar por Nombre ---");

  // Pedimos el nombre del contacto a buscar
  // y lo guardamos en la variable "busqueda"
  print!("¿A quién estás buscando?: ");
  io::stdout().flush().unwrap();
  let mut busqueda = String::new();
  io::stdin().read_line(&mut busqueda).unwrap();
  let busqueda = busqueda.trim().to_string();

  // Definimos inicialmente la variable encontrado a "false"
  let mut encontrado = false;

  // Buscamos en el vector de nombres
  for i in 0..nombres.len() {
      // Comparamos para cada i el nombres guardado en el vector
      // con el que ha tecleado "busqueda" el usuario
      // pasamos ambos a mayúscula con .to_lowercase() para
      // que no influyan mayúscula y minúsculas.

      // Si lo encontramos imprimimos y salimos con "break"
      if nombres[i].to_lowercase() == busqueda.to_lowercase() {
          println!("🎉 ¡Encontrado! El teléfono de {} es: 📞 {}", nombres[i], telefonos[i]);
          encontrado = true;
          break; // Salimos del bucle porque ya lo hemos encontrado
      }
  }

  // Si no lo hemos encontrado imprimimos este mensaje
  if !encontrado {
      println!("❌ Lo siento, '{}' no figura en tu lista de contactos.", busqueda);
  }
}
```

Nos queda solo analizar la función main que es por donde empieza el programa a ejecutarse.

- Analicemos la funcion *main*

```rust
fn main() {
  // Creamos las bases de datos (vectores) de la 
  // agenda (vacías al iniciar)
  let mut agenda_nombres: Vec<String> = Vec::new();
  let mut agenda_telefonos: Vec<String> = Vec::new();

  println!("=========================================");
  println!("  📱 ¡BIENVENIDO A TU AGENDA EN RUST!   ");
  println!("=========================================");

  // Iniciamos un bucle "loop" infinito. Solo terminará cuando el usuario elija salir.
  loop {
      // Si el usuario no pulsa ninguna tecla, el programa
      // imprime en cada pasada del bucle las líneas println! de
      // abajo y da la sensación de que nada sucede. Sin embargo,
      // como veremos abajo el programa esta esperando a que
      // el usuario pulse un texto seguido de la tecla Return


      println!("\n🎯 ¿Qué deseas hacer hoy?");
      println!("1. Ver todos los contactos");
      println!("2. Añadir un contacto");
      println!("3. Buscar un contacto");
      println!("4. 🚪 Salir de la aplicación");
      print!("👉 Selecciona una opción (1-4): ");
      
      // Hace que se pinte inmediatamente en pantalla lo que teclea
      // el usuario
      io::stdout().flush().unwrap();

      // Leemos la opción del usuario por teclado y
      // la asignamos a la variable "opción"
      let mut opcion = String::new();
      io::stdin().read_line(&mut opcion).unwrap();
      let opcion = opcion.trim();

      // Estructura match (como un if gigante)
      // Selecciona la función que es va a jecutar
      // Segun la tecla pulsada por el usuario
      // Si pulsa "1" se ejecutará:
      //    mostrar_contactos(&agenda_nombres, &agenda_telefonos)

      // Y asi sucesivamente. Las pulsaciones correctas son:
      //   1, 2, 3 y 4 seguidas de Return.

      // Cualquier otra pulsación se recoge con el guión bajo _ 
      // y se imprime que no es una opción valida.
      match opcion {
        "1" => mostrar_contactos(&agenda_nombres, &agenda_telefonos),
        "2" => añadir_contacto(&mut agenda_nombres, &mut agenda_telefonos),
        "3" => buscar_contacto(&agenda_nombres, &agenda_telefonos),
        "4" => {
            println!("\n👋 ¡Gracias por usar la agenda en Rust! Cerrando sistema...");
            break; // Rompe el bucle loop y el programa termina
        }
        _ => println!("⚠️ Opción no válida. Por favor, introduce un número del 1 al 4."),
      }
  }
}
```
📇 *Listado completo: Proyecto La Agenda de Contactos por Terminal*

Una vez que hemos explicado todos los entresijos de este programa, llega el momento de presentar de presentar el listado completo del mismo, para que lo puedas pasar al fichero main.rs del proyecto *agenda_contactos* que creamos al principio.

```rust
use std::io::{self, Write}; // Necesario para poder leer lo que el usuario escribe en el teclado

// --- FUNCIÓN 1: MOSTRAR TODOS LOS CONTACTOS ---
// Recibe préstamos de lectura (&) de los vectores porque solo queremos mirar los datos
fn mostrar_contactos(nombres: &Vec<String>, telefonos: &Vec<String>) {
    println!("\n=== 👥 LISTA DE CONTACTOS DE LA AGENDA ===");
    
    if nombres.is_empty() {
        println!("⚠️ La agenda está completamente vacía.");
        return;
    }

    // Recorremos las posiciones usando un índice numérico desde 0 hasta el tamaño del vector
    for i in 0..nombres.len() {
        // Accedemos de forma segura a cada posición usando [i]
        println!("{}. 👤 Nombre: {} | 📞 Teléfono: {}", i + 1, nombres[i], telefonos[i]);
    }
    println!("==========================================");
}

// --- FUNCIÓN 2: AÑADIR UN NUEVO CONTACTO ---
// ¡Ojo! Recibe préstamos MUTABLES (&mut) porque vamos a alterar los vectores originales (.push)
fn añadir_contacto(nombres: &mut Vec<String>, telefonos: &mut Vec<String>) {
    println!("\n--- 🆕 Añadir Nuevo Contacto ---");
    
    // Pedimos el nombre
    print!("Introduce el nombre: ");
    io::stdout().flush().unwrap(); // Fuerza a la terminal a mostrar el texto en pantalla inmediatamente
    let mut nombre = String::new();
    io::stdin().read_line(&mut nombre).unwrap();
    let nombre = nombre.trim().to_string(); // .trim() elimina el "Enter" invisible del teclado

    // Pedimos el teléfono
    print!("Introduce el teléfono: ");
    io::stdout().flush().unwrap();
    let mut telefono = String::new();
    io::stdin().read_line(&mut telefono).unwrap();
    let telefono = telefono.trim().to_string();

    // Guardamos los datos en sus respectivos cajones
    nombres.push(nombre);
    telefonos.push(telefono);
    
    println!("✅ ¡Contacto guardado con éxito!");
}

// --- FUNCIÓN 3: BUSCAR UN CONTACTO ---
fn buscar_contacto(nombres: &Vec<String>, telefonos: &Vec<String>) {
    println!("\n--- 🔍 Buscar por Nombre ---");
    print!("¿A quién estás buscando?: ");
    io::stdout().flush().unwrap();
    let mut busqueda = String::new();
    io::stdin().read_line(&mut busqueda).unwrap();
    let busqueda = busqueda.trim().to_string();

    let mut encontrado = false;

    // Buscamos en el vector de nombres
    for i in 0..nombres.len() {
        // Comparamos el nombre guardado con la búsqueda del usuario (sin importar mayúsculas)
        if nombres[i].to_lowercase() == busqueda.to_lowercase() {
            println!("🎉 ¡Encontrado! El teléfono de {} es: 📞 {}", nombres[i], telefonos[i]);
            encontrado = true;
            break; // Salimos del bucle porque ya lo hemos encontrado
        }
    }

    if !encontrado {
        println!("❌ Lo siento, '{}' no figura en tu lista de contactos.", busqueda);
    }
}

// --- FUNCIÓN PRINCIPAL: EL MENU INTERACTIVO ---
fn main() {
  // Creamos las bases de datos de la agenda (vacías al iniciar)
  let mut agenda_nombres: Vec<String> = Vec::new();
  let mut agenda_telefonos: Vec<String> = Vec::new();

  println!("=========================================");
  println!("  📱 ¡BIENVENIDO A TU AGENDA EN RUST!   ");
  println!("=========================================");

  // Iniciamos un bucle loop infinito. Solo terminará cuando el usuario elija salir.
  loop {
    println!("\n🎯 ¿Qué deseas hacer hoy?");
    println!("1. Ver todos los contactos");
    println!("2. Añadir un contacto");
    println!("3. Buscar un contacto");
    println!("4. 🚪 Salir de la aplicación");
    print!("👉 Selecciona una opción (1-4): ");
    io::stdout().flush().unwrap();

    // Leemos la opción del usuario por teclado
    let mut opcion = String::new();
    io::stdin().read_line(&mut opcion).unwrap();
    let opcion = opcion.trim();

    // Estructura match (como un if gigante) para decidir qué función ejecutar
    match opcion {
        "1" => mostrar_contactos(&agenda_nombres, &agenda_telefonos),
        "2" => añadir_contacto(&mut agenda_nombres, &mut agenda_telefonos),
        "3" => buscar_contacto(&agenda_nombres, &agenda_telefonos),
        "4" => {
            println!("\n👋 ¡Gracias por usar la agenda en Rust! Cerrando sistema...");
            break; // Rompe el bucle loop y el programa termina
        }
        _ => println!("⚠️ Opción no válida. Por favor, introduce un número del 1 al 4."),
    }
  }

  // Instrucción para pruebas
  println!("Imprimimos desde última línea: {:?}", agenda_nombres)
}
```
🧠 *Conclusiones sobre la forma de trabajar de Rust?*

Fíjate en las llamadas a las funciones dentro del match en el main:

#pagebreak()