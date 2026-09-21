#import "config.typ": *

= Interacción con el Sistema Operativo y Archivos
Lo que veremos en este tema es solo una pequeña introducción al tratamiento de archivos mediante Rust y a como puede interaccionar con el sistema operativo.

==  Leyendo archivos de texto
Nos limitaremos a la lectura de ficheros de texto.

Dado que no podemos trabajar con ficheros en la Playground, crearemos un proyecto de Rust con Cargo. Abre una terminal integrada de Visual Studio Code en la carpeta *proyectos-rust* anteriormente creada o en cualquier otra carpeta.

Ejecuta el siguiente comando para crear un proyecto:

```
cargo new sist_op_archivos
```
Despliega el directorio y crea el fichero *config.txt* al mismo nivel que el fichero *Cargo.toml*.

El fichero *config.txt* es el que vamos a leer desde nuestro programa y puedes poner, por ejemplo, las siguientes líneas:

*config.txt*

```
sdtv_mode=18
# 0 para NTSC
# 1 para la versión japonesa de NTSC
# 2 para PAL
# 3 para la versión brasileña de PAL
# 16 para NTSC progresivo
# 18 para PAL progresivo
```

💻 Copia el siguiente código y pégalo en el fichero *main.rs* del proyecto creado borrando previamente todo lo que hubiera en ese archivo.

Fichero: *main.rs*

```rust
use std::fs;

fn main() {
    let contenido = fs::read_to_string("config.txt");

    match contenido {
        Ok(datos) => println!("Contenido del archivo:\n{}", datos),
        Err(e) => println!("Error al leer el archivo: {}", e),
    }
}
```

Abre una terminal integrada de VS Code en la carpeta del proyecto y ejecuta el programa con la orden *cargo run*. Deberá mostrarte en la terminal el contenido del archivo *config.txt*.

*Explicación*:

La instrucción *use std::fs;* es necesaria para poder acceder a la función *read_to_string* que lee el fichero *config.txt*.

Como la operación de lecctura puede fallar si escribimos mal el nombre del fichero o si no existe, *read_to_string* devuelve un *Result* (está programada así en Rust) que es asignado a la variable *contenido*.

A continuación, el *match* desempaqueta *contenido* teniendo en cuenta las dos variantes del *Result* que puede contener. 

- Si contenido era *OK*, la variable *datos* contiene el fichero leido y se imprime con el println!. Podríamos poner a `datos` cualquier otro nombre siempre que utilicemos el mismo a la derecha.

- Si contenido era *Err*, la variable *e* contiene el error y se imprime con println! Podríamos poner a `e` cualquier otro nombre siempre que utilicemos el mismo a la derecha.

Tengamos en cuenta que en este ejemplo, nosotros no hemos escrito la función (read_to_string) que devuelve el Result, es una función de Rust y nosotros solo la utilizamos. En el tema anterior si que escribimos la función dividir:

```rust
fn dividir(dividendo: f64, divisor: f64) -> Result<f64, String> {...}
```

== Creación y escritura de datos en archivos
Para escribir datos, podemos crear un archivo nuevo o sobrescribir uno existente mediante std::fs::File y std::io::Write.

std::fs::File lo necesitamos para utilizar *File::create* y std::io::Write para utilizar *write_all* en archivo.write_all.

- Crea el proyecto de Rust *escribir_en_archivo* en la carpeta *proyectos-rust* igual que hemos hecho en el apartado anterior.

💻 Copia el siguiente código y pégalo en el fichero *main.rs* del proyecto creado borrando previamente todo lo que hubiera escrito en ese fichero.

Fichero: *main.rs*

```rust
use std::fs::File;
use std::io::Write;

fn main() {
    let mensaje = "LOG: El sistema se inició correctamente.";

    // 1. Intentamos crear/abrir el archivo
    match File::create("registro.log") {
        Ok(mut archivo) => {
            // 2. Si el archivo se creó con éxito, intentamos escribir los bytes
            match archivo.write_all(mensaje.as_bytes()) {
                Ok(_) => {
                    // Si todo salió bien
                    println!("Datos guardados exitosamente.");
                }
                Err(e) => {
                    // Si falló la escritura
                    println!("No se pudo escribir en el disco: {}", e);
                }
            }
        }
        Err(e) => {
            // Si falló la creación del archivo
            println!("No se pudo crear el archivo 'registro.log': {}", e);
        }
    }
}
```
Abre una terminal integrada de VS Code en la carpeta del proyecto y ejecuta el programa con la orden *cargo run*. Deberá crear el archivo *registro.log* al mismo nivel del archivo Cargo.toml.

*Explicación*

El contenido de la variable mensaje es lo que guardaremos en el fichero que crearemos.

La orden *File::create("registro.log")* tiene dos posibles resultados proporcionados por la función de Rust *create*: *Ok* o *Err* ya que la función puede tener éxito o fallar. Esto forma parte del ecosistema de Rust y se obtiene de la documentación ya que nosotros no hemos programado esta función.

El *File::create("registro.log")* contempla las dos opciones:

- Si el resultado es *Ok*, en el match desempaquetamos el Ok(mut *archivo*) y obtenemos el identificador mutable *archivo* con el que luego podremos crear y escribir en el fichero registro.log.

- Si el resultado es *Err* se desempaqueta también el *Err(e)* obteniendo el valor de *e* y se imprime el error de fallo en la creación del archivo.

Si el primer match se resolvió con OK intentamos escribir en el archivo para lo cual utilizamos un segundo match:

- match archivo.write_all(mensaje.as_bytes())

Aqui de nuevo tenemos las dos posibilidades. Si el *match* se resuelve en *Ok(`_`)*, con el guión bajo indicamos que no estamos interesados en desempaquetar ningún dato que pueda traer el Ok. Simplemente imprimimos el mensaje de que todo ha salido bien. Si se resuelve en *Err(e)* aquí si que desempaquetamos *Err*, obtenemos el valor de *e* y lo utilizamos en el mensaje de consola.

#nota("El programa anterior puede simplificarse utilizando una función que acepta el mensaje a guardar en el fichero y el operador ?")

El listado sería el siguiente:

```rust
use std::fs::File;
use std::io::Write;

fn guardar_registro(mensaje: &str) -> std::io::Result<()> {
    let mut archivo = File::create("registro.log")?;
    archivo.write_all(mensaje.as_bytes())?;
    Ok(())
}

fn main() {
    if let Err(e) = guardar_registro("LOG: El sistema se inició correctamente.") {
        println!("No se pudo escribir en el disco: {}", e);
    } else {
        println!("Datos guardados exitosamente.");
    }
}
```

*Explicación*

Al ejecutar la primera orden del main:

```rust
 if let Err(e) = guardar_registro("LOG: El sistema se inició correctamente.")
```
Si las dos líneas a las que aplicamos el operador ?

```rust
let mut archivo = File::create("registro.log")?;
    archivo.write_all(mensaje.as_bytes())?;
```
Se ejecutan sin problemas, se crea el fichero con el mensaje especificado y se ejecuta el else del main.

Si alguna de las dos funciones (*create* o *write_all*) se resuelve en *Err*, el error se propaga a quien la llamó, que es el main. En el main desempaquetamos con *if let Err(e)* el error imprimimos un mensaje por la consola.



#pagebreak()