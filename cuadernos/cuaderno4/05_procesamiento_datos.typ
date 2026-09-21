#import "config.typ": *

= Procesamiento de Datos y Proyectos Prácticos
Hasta este punto del camino, hemos explorado los cimientos teóricos que hacen de Rust un lenguaje único: la rigurosidad de su sistema de tipos, las garantías inquebrantables de su modelo de propiedad (ownership) y la elegancia de su gestión de errores. Sin embargo, la verdadera potencia de estas herramientas no se aprecia en el aislamiento de los ejemplos de laboratorio, sino en el terreno de las aplicaciones del mundo real.

Este cuarto capítulo marca la transición definitiva de la teoría a la práctica. El ecosistema de Rust no solo destaca por su seguridad en memoria, sino también por su capacidad para procesar grandes volúmenes de información con un rendimiento predecible y una eficiencia implacable. A lo largo de las siguientes páginas, descubriremos cómo conectar las estructuras de datos nativas con el almacenamiento persistente, cómo leer y transformar flujos de información externos y cómo estructurar código modular que sea fácil de mantener a medida que crece.

Para consolidar estos conceptos, dejaremos de lado los fragmentos de código inconexos y nos enfocaremos en la construcción de proyectos prácticos orientados a resolver problemas reales. Utilizaremos Cargo no solo como un compilador, sino como un aliado estratégico para integrar dependencias del ecosistema y organizar nuestra arquitectura. Al finalizar este capítulo, habrás transformado las restricciones del compilador en tus mayores aliadas, adquiriendo la confianza necesaria para diseñar, estructurar y desplegar tus propias aplicaciones e infraestructuras en Rust.

== Parseo numérico
Para convertir *cadenas de texto* (String o &str) obtenidas del usuario (o de archivos) en números reales manipulables matemáticamente, se utiliza el método *.parse().* Como esta operación *puede fallar* (por ejemplo si el texto contiene letras), *siempre devuelve un Result*.

💻 Copia el siguiente código y ejecutalo en la Playground

Fichero: *parse.rs*

```rust
fn main() {
    let texto_numero = String::from("42");
    
    // El compilador infiere que queremos un i32 gracias
    // a la anotación de tipo
    let numero: Result<i32, _> = texto_numero.parse();
    
    match numero {
        Ok(n) => println!("El número {} multiplicado por 2 es: {}", n, n * 2),
        Err(_) => println!("No se pudo convertir la cadena a número."),
    }
}
```
Obtendrás el siguiente resultado:

"El número 42 multiplicado por 2 es: 84"

Lo que demuestra que la función *.parse()* ha convertido el String *texto_numero* en un número *i32*, ya que lo hemos podido multiplicar por 2 que es por defecto i32 (no hace falta escribir 2i32).

Analicemos la línea:

```rust
let numero: Result<i32, _> = texto_numero.parse();
```

Con *Result`<i32, _>`* le estás diciendo al compilador: sabemos que la función .parse() va a devolver un Result. Yo elijo el tipo del Ok (i32) y el compilador que averigue el tipo del Err investigando el contexto de la operación (equivalente a mirar los manuales). 

Se procede de esta forma porque si no, tendríamos que especificar nosotros el tipo del error y en este caso tendríamos que haber escrito:

```rust
// Código completo sin el guion bajo (más largo de escribir):
let numero: Result<i32, std::num::ParseIntError> = texto_numero.parse();
```
Tendríamos que saber, o si no averiguar, que el tipo de Err para nuestro caso es: *std::num::ParseIntError*. Tendríamos que mirar nosotros los manuales.

En el *match* se desempaqueta el *Ok* extrayendo *n* que es el *número* en i32 convertido a partir del String *texto_numero*. La parte de Err no nos interesa y le pasamos un guión bajo.

== Proyecto 1: El Gestor de Tareas Pendientes (To-Do-List). Grabar en disco
Este programa interactivo por consola te permitirá añadir tareas y guardarlas de forma persistente para que no se pierdan al cerrar la aplicación.

- Abre una terminal integrada de VS Code en la carpeta *proyectos-rust* (o en cualquier otra) y crea el proyecto de Rust *lista_tareas* con la orden:

```
cargo new lista_tareas
```

💻 Copia el siguiente código y pégalo en el fichero *main.rs* del proyecto creado, borrando previamente todo lo que hubiera escrito en ese fichero.

Fichero: *main.rs*

```rust
use std::fs::{OpenOptions, read_to_string};
use std::io::{self, Write};

const ARCHIVO_TAREAS: &str = "tareas.txt";

fn mostrar_tareas() {
    println!("\n--- MIS TAREAS PENDIENTES ---");
    match read_to_string(ARCHIVO_TAREAS) {
        Ok(contenido) => {
            if contenido.trim().is_empty() {
                println!("No tienes tareas pendientes.");
            } else {
                println!("{}", contenido);
            }
        }
        Err(_) => println!("No se encontró archivo previo. ¡Añade tu primera tarea!"),
    }
}

fn agregar_tarea(tarea: &str) -> io::Result<()> {
    // Abrimos el archivo en modo "añadir" (append) o lo creamos si no existe
    let mut archivo = OpenOptions::new()
        .write(true)
        .append(true)
        .create(true)
        .open(ARCHIVO_TAREAS)?;
    
    writeln!(archivo, "- {}", tarea)?;
    Ok(())
}

fn main() {
    loop {
        mostrar_tareas();
        println!("\nOpciones: [1] Añadir tarea  [2] Salir");
        print!("Selecciona una opción: ");
        io::stdout().flush().unwrap();

        let mut opcion = String::new();
        io::stdin().read_line(&mut opcion).unwrap();

        match opcion.trim() {
            "1" => {
                print!("Escribe la nueva tarea: ");
                io::stdout().flush().unwrap();
                let mut nueva_tarea = String::new();
                io::stdin().read_line(&mut nueva_tarea).unwrap();
                
                if let Err(e) = agregar_tarea(nueva_tarea.trim()) {
                    println!("Error al guardar la tarea: {}", e);
                }
            }
            "2" => {
                println!("¡Hasta luego!");
                break;
            }
            _ => println!("Opción no válida."),
        }
    }
}
```
#nota("Empezamos ahora un proceso destinado a que entiendas la mayor parte posible del programa. En la carpeta 'src' del proyecto, junto al archivo main.rs hay otro archivo con el nombre 'listado_comentado.rs' que contiene el mismo programa anterior pero comentado prácticamente línea por línea. Puedes apoyarte también en este archivo para la comprensión del programa.")

*Ejecuta el programa*

Antes de empezar a investigar cómo funciona el programa, vamos a ver qué es lo que hace.

Abre una terminal integrada en la carpeta del proyecto (*lista_tareas*) y ejecuta la orden *cargo run*. Debe aparecer en pantalla el siguiente mensaje:

```
--- MIS TAREAS PENDIENTES ---
No se encontró archivo previo. ¡Añade tu primera tarea!

Opciones: [1] Añadir tarea  [2] Salir
Selecciona una opción: 
```
- Pulsa 1 y a continuación Enter para seleccionar la opción [1]

El programa contesta con:

```
--- MIS TAREAS PENDIENTES ---
No se encontró archivo previo. ¡Añade tu primera tarea!

Opciones: [1] Añadir tarea  [2] Salir
Selecciona una opción: 1
Escribe la nueva tarea: 
```
Primero lista las tareas que tienes grabadas en un fichero (Todavía no tienes tareas ni fichero) y te pide *Escribe la nueva tarea*: 

Puedes escribir cualquier cosa, como por ejemplo "Estudiar el Cuaderno 1 de Rust" y pulsas Enter. En ese momento se creará el fichero *tareas.txt* en el mismo nivel que Cargo.toml y se guardará la tarea en el fichero. 

Podrás seguir añadiendo tareas a través del menú o salir del programa. Cada vez que añadas una tarea el programa te listará todas las tareas que tienes guardadas y te presentará el menú de añadir tarea o salir.

Bien, una vez sabemos qué hace el programa vamos a ver cómo lo hace. Algunas cosas no las podremos explicar en detalle porque se apoyan en conceptos que no hemos explicado todavía. No obstante, en el archivo *listado_comentado.rs* están comentadas prácticamente todas las líneas.

*Empezamos*

*1) Las sentencias use*:

```rust
use std::fs::{OpenOptions, read_to_string};
use std::io::{self, Write};
```
Son necesarias para poder utilizar nombres de funciones del ecosistema Rust que aparecen en el listado. 

*2) Definimos la constante*:

```rust
const ARCHIVO_TAREAS: &str = "tareas.txt";
```
Las constantes se definen con la palabra *const* y un nombre en mayúsculas. Son similares a las variables pero su valor no puede cambiar durante la ejecución del programa. Son visibles desde cualquier punto del programa, por eso se llaman globales y existen desde el instante en que se ejecuta el programa hasta que termina.

Son prácticas porque si utilizamos una constante en muchos sitios en el interior del programa, podemos cambiar ese valor en todos los sitios a la vez modificando la línea de arriba de su definición y cambiando allí el valor.

*3) La función mostrar_tareas(){...*

Su funcionamiento está basado en la línea:

```rust
 match read_to_string(ARCHIVO_TAREAS) {...
```
El match desempaqueta las dos variantes de Result que puede devolver *read_to_string(ARCHIVO_TAREAS)*:
1. Con Ok(contenido) => instrucciones...
 - read_to_string ha tenido éxito leyendo ARCHIVO_TAREAS y la variable contenido contiene precisamente el contenido del archivo.
 - contenido.trim().is_empty quita los espacios que pueda tener el texto al principio y al final y comprueba si está vacio.
 - finalmente imprime un mensaje entre dos opciones mediante un if-else

2. Con Err(`_`) ignora el valor del error e imprime un mensaje personalizado

*4) La función agregar_tarea(tarea: &str) -> io::Result<()> {...*
- Añade una nueva línea de texto al final de nuestro archivo.
- Retorna un 'io::Result<()>' permitiendo propagar errores de I/O mediante el operador '?'.
- Está comentada linea por línea en el archivo listado_comentado.rs.

*5) El método main*
- Crea primero que nada un bucle loop
-  En el interior del bucle, llama al empezar a la función mostrar_tareas()y a continuación pide al usuario que elija una opción introduciendo un 1 o un 2. La elección del usuario se coloca en la variable *opcion*.
- Con *match opcion.trim()* desempaqueta el valor de opcion después de quitarle los posibles espacios que tenga al principio y al final.
- Si el valor de opcion es *1*, pide al usuario que escriba el nombre de la nueva tarea y lo coloca en la variable nueva_tarea.
- Con la instrucción if let Err(e) a verigua si en *agregar_tarea(nueva_tarea.trim())* se ha producido un error. Si es así lo imprime y sale. Si nu hubo error, la nueva_tarea se ha agredado al fichero *tareas.txt*.
- Si el valor de la opción es *2* sale del programa.
- Con el guión bajo *`_`* se recoge cualquier otro valor de opcion y se presenta el mensaje de opcion no válida.
- Ver *listado_comentado.rs* para comentarios más detallados.

== Proyecto 2: Herramienta CLI para automatización del sistema
Este programa interactúa directamente con los argumentos proporcionados por la terminal del sistema operativo utilizando *std::env::args*. Sirve para simular una herramienta administrativa que automatiza tareas cotidianas como por ejemplo crear o borrar un fichero.

*Creación del proyecto*

- Abre una terminal integrada de VS Code en la carpeta *proyectos-rust* (o en cualquier otra) y crea el proyecto de Rust *herramientas_cli* con la orden:

```
cargo new herramientas_cli
```

💻 Copia el siguiente código y pégalo en el fichero *main.rs* del proyecto creado, borrando previamente todo lo que hubiera escrito en ese fichero.

Fichero: *main.rs*

```rust
use std::env;
use std::fs;

fn main() {
    // Captura los argumentos de la línea de comandos
    // (ej: cargo run -- limpiar archivo.txt)
    let argumentos: Vec<String> = env::args().collect();

    // Imprimimos el vector argumentos para ver lo que contiene
    println!("{:?}", argumentos);

    if argumentos.len() < 3 {
        println!("Uso incorrecto del programa.");
        println!("Ejemplo: cargo run -- <accion> <nombre_archivo>");
        println!("Acciones disponibles: eliminar, crear");
        return;
    }

    let accion = &argumentos[1];
    let nombre_archivo = &argumentos[2];

    match accion.as_str() {
        "crear" => {
            match fs::File::create(nombre_archivo) {
                Ok(_) => println!("Automatización: Archivo '{}' creado con éxito.", nombre_archivo),
                Err(e) => println!("Error al crear el archivo: {}", e),
            }
        }
        "eliminar" => {
            match fs::remove_file(nombre_archivo) {
                Ok(_) => println!("Automatización: Archivo '{}' eliminado de forma segura.", nombre_archivo),
                Err(e) => println!("Error al eliminar el archivo: {}", e),
            }
        }
        _ => println!("Acción desconocida. Prueba con 'crear' o 'eliminar'."),
    }
}
```
#nota("Empezamos ahora un proceso destinado a que entiendas la mayor parte posible del programa. En la carpeta 'src' del proyecto, junto al archivo main.rs hay otro archivo con el nombre 'listado_comentado.rs' que contiene el mismo programa anterior pero comentado prácticamente línea por línea. Puedes apoyarte también en este archivo para la comprensión del programa.")

*Ejecuta el programa*

Al igual que en el proyecto anterior, antes de empezar a investigar cómo funciona el programa, vamos a ver qué es lo que hace.

Abre una terminal integrada en la carpeta del proyecto (*herramientas_cli*) y en lugar de ejeutar la orden `cargo run.` como hacemos siempre, ejecuta la siguiente orden:

*cargo run -- crear ejemplo.txt*

Al pulsar return el programa crea el fichero ejemplo.txt al mismo nivel del fichero Cargo.toml.

Ahora podemos ejecutar la orden:

*cargo run -- eliminar ejemplo.txt*

Y borraremos el fichero creado anteriormente. Por tanto, a través de comandos de texto entregados a nuestro programa, estamos ejecutando órdenes sobre nuestro directorio de ficheros como podríamos hacer directamente desde el sistema operaticvo.

*Explicación*

1) La línea:

```rust
let argumentos: Vec<String> = env::args().collect();
```
Captura las distintos parámetros entregados a la orden cargo run. La primera orden que hemos ejecutado ha sido: *cargo run -- crear ejemplo.txt* y al imprimir el vector *argumentos* obtenemos:

[`"`target/debug/herramientas_cli`"`, `"`crear`"`, `"`ejemplo.txt`"`] (compruébalo en tu terminal)

Por tanto, las variables que nos interesan son:

- *let accion = &argumentos[1];*
- *let nombre_archivo = &argumentos[2];*

2) A continuación tenemos un match externo que crea dos ramas de ejecución de flujo según el valor de la variable accion. Una para el valor *crear* y otra para *eliminar*.

- En la opción *crear*, otro match interno desempaqueta el Result que entrega la funcion *create* e imprime sendos mensajes según el resultado.

- En la opción *eliminar* se procede analogamente con el resultado de la función *remove_file*.

== Atrapar varios tipos de errores en un único Result
Vamos a explicar por qué a veces una función devuelve u Result de la forma:

Result`<f64, Box<dyn Error>>` 

Es un concepto avanzado y si se quiere, se puede admitir que el motivo es porque la función puede devolver errores de distintos tipos y con el Result`<T, U>` que hemos utilizado hasta ahora, el error puede ser de un tipo *U* cualquiera pero no de distintos tipos a la vez.

Si quieres seguir con la explicación, lo primero en observar es que el principal beneficio que obtenemos es la *composición de errores con el operador ?.* 

Si tienes una función que lee un archivo (puede producir el error *std::io::Error*) y si luego parsea un número (puede producir el error *std::num::ParseIntError*), no puedes devolver ambos tipos directamente en el Result`<T, U>`. Con *U* solo podemos representar un tipo de error pero no dos. Al usar `Box<dyn std::error::Error>`, Rust convierte automáticamente ambos errores al mismo tipo común.

*Ejemplo de código*

```rust
use std::fs::File;
use std::io::Read;
use std::error::Error;

// Usamos Box<dyn Error> para poder devolver cualquier tipo de error
fn leer_numero_de_archivo() -> Result<i32, Box<dyn Error>> {
    let mut archivo = File::open("numero.txt")?; // Puede lanzar std::io::Error
    let mut contenido = String::new();
    
    archivo.read_to_string(&mut contenido)?; // Puede lanzar std::io::Error
    
    let numero: i32 = contenido.trim().parse()?; // Puede lanzar ParseIntError
    
    Ok(numero)
}
```

==  Proyecto 3: Analizador Estadístico de archivos .`csv`
Este último proyecto te introducirá en el uso del ecosistema real de Rust. Utilizaremos la crate externa *csv* (que previamente añadirás al fichero *Cargo.toml* del proyecto). El programa procesará el archivo de datos numéricos *datos.csv* estructurado en una columna e imprimirá el promedio estadístico de los mismos.

El fichero de datos es el que se muestra a continuación:

*datos.csv*

```
calificacion
15
18
12
20
```

*Creación del proyecto*

- Abre una terminal integrada de VS Code en la carpeta *proyectos-rust* (o en cualquier otra) y crea el proyecto de Rust *datos_csv* con la orden:

```
cargo new datos_csv
```

- Edita el fichero Cargo.toml de forma que la sección [dependencies] quede como se muestra abajo:

[package]
name = "datos_csv"
version = "0.1.0"
edition = "2024"

[dependencies]
csv = "1.3"

- Crea un fichero *datos.csv* con el contenido que se muestra al principio y colócalo en el mimo nivel que Cargo.toml.

💻 Copia el siguiente código y pégalo en el fichero *main.rs* del proyecto creado, borrando previamente todo lo que hubiera escrito en ese fichero.

Fichero: *main.rs*

```rust
// Nota: Requiere la dependencia 'csv = "1.3"' en Cargo.toml
use std::error::Error;
use std::fs::File;

fn calcular_promedio_csv() -> Result<f64, Box<dyn Error>> {
    // Abrimos el archivo de datos
    let archivo = File::open("datos.csv")?;
    
    // Inicializamos el lector de la librería externa 'csv'
    let mut lector = csv::Reader::from_reader(archivo);
    
    let mut suma = 0.0;
    let mut total_elementos = 0;

    // Iteramos por cada registro/fila del archivo de manera segura
    for resultado in lector.records() {
        let registro = resultado?;
        // Tomamos el primer valor de la fila (columna 0)
        if let Some(valor_texto) = registro.get(0) {
            let valor: f64 = valor_texto.trim().parse()?;
            suma += valor;
            total_elementos += 1;
        }
    }

    if total_elementos == 0 {
        return Ok(0.0);
    }

    Ok(suma / total_elementos as f64)
}

fn main() {
    match calcular_promedio_csv() {
        Ok(promedio) => println!("--- ANALIZADOR ESTADÍSTICO ---\nEl promedio del archivo es: {:.2}", promedio),
        Err(e) => println!("Error procesando el archivo CSV: {}", e),
    }
}
```

*Ejecuta el programa*

Abre una terminal integrada en la carpeta de proyecto y ejecuta lo orden cargo run. Deberás obtener lo siguiente en la terminal:

```
--- ANALIZADOR ESTADÍSTICO ---
El promedio del archivo es: 16.25
```

*Explicación*

La función;

- *calcular_promedio_csv() -> Result`<f64, Box<dyn Error>>`*

 - Ya hemos explicado en el apartado anterior la utilización de `Box<dyn Error>` en el Result.

Las líneas:

 - let archivo = File::open(`"`datos.csv`"`)?;
 - let mut lector = csv::Reader::from_reader(archivo);

 Construyen la variable *lector* que representa el fichero *datos.csv*.
    
Al entrar en el bucle for hay que tener en cuenta que por defecto, la función *csv::Reader::from_reader(archivo)* asume que la primera fila de cualquier archivo CSV es siempre una cabecera (texto con los nombres de las columnas). Por tanto la instrucción:

*for resultado in lector.records()*

lector.records(), que representa las filas del fichero datos.csv, empieza por el primer dato numérico (15) saltándose el texto *calificacion*.

La instrucción:

*if let Some(valor_texto) = registro.get(0) {...*

Asume que *registro.get(0)* va a proporcionar la variante Some de un Option y desempaqueta el valor en la variable *valor_texto*. Luego fuerza una conversión de esta variable a f64.

La instrucción:

*let valor: f64 = valor_texto.trim().parse()?;*

LLeva el operador ? al final porque si en la línea anterior, por equivocación, registro.get(0) fuera un texto en lugar de un número, el operador ? sería el encargado de lanzar el error hacia el main.

#pagebreak()