= 📇 Proyecto Final: La Agenda de Contactos por Terminal

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

Fíjate en las llamadas a las funciones dentro del *match* en la función *main*:

- Para mostrar o buscar un contacto, enviamos como parámetro a la función correspondiente un préstamo *&agenda_nombres*. Le prestamos la agenda a la función para que *pueda leerla pero no podrá modificarla*. 

- Para añadir un contacto, enviamos como parámetro a la función correspondiente un prestamo mutable *&mut agenda_nombres*. Le prestamos la agenda a la función y le *damos permiso para que pueda de escribir* contactos nuevos.

- Como en ambos pasamos un prestamo a la función, no la variable original *agenda_nombres*, esta no se consume en las llamadas a las funciones y sigue activa al final del main. Para demostrarlo, introduce algún contacto mediante la opción "2" y luego elige la opción "4" que *sale del bucle loop mediante un break y cae en la función main*, ejecutando la línea *println!("Imprimimos desde última línea: {:?}", agenda_nombres)* demostrando así que accede a la variable *agenda_nombres*.

- Si intentáramos añadir un contacto a la agenda utilizando la función correspondiente, mientras otra función la está leyendo en un segundo plano, ¡el compilador de Rust haría saltar las alarmas y daría un error para proteger la memoria!. Para ejecutar tareas en segundo plano hay que utilizar *threads*, que los veremos bastante más adelante.