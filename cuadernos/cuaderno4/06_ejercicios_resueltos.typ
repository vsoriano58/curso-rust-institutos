#import "config.typ": *

= Ejercicios resueltos
Aquí tienes 5 ejercicios prácticos resueltos, diseñados específicamente para el nivel de este Cuaderno 4 con explicaciones paso a paso para que asimiles la gestión de errores y el manejo de archivos.

 == Enunciados

=== Ejercicio 1: El Validador de Edades (Uso avanzado de Option`<T>`)
- *Enunciado*: Escribe una función llamada *obtener_edad_voto(edad: i32) -> Option`<i32>`* que reciba la edad de una persona. Si la edad es menor de 18 años o directamente imposible (negativa o mayor a 120), debe retornar None. Si es apta para votar (18 o más), debe retornar la edad envuelta en Some. En el main, simula el caso con varios valores y muestra un mensaje amigable.

=== Ejercicio 2: Conversión Segura de Temperatura (Uso de Result`<T, E>`)
- *Enunciado:* En física, el "Cero Absoluto" es la temperatura más baja posible (-273.15 °C). Crea una función *celsius_a_kelvin(celsius: f64) -> Result`<f64, String>`*. Si la temperatura introducida es inferior al cero absoluto, debe devolver un error explicativo. En caso contrario, debe sumar 273.15 y devolver el valor envuelto en el Ok.

=== Ejercicio 3: Copia de Seguridad de Archivos (Manejo del Sistema de Archivos y del operador ?)
- *Enunciado:* Desarrolla una función llamada *respaldar_archivo() -> std::io::Result`<()>`* que intente leer el contenido de un archivo llamado *notas.txt* y escribirlo íntegramente en un archivo nuevo llamado *notas_bak.txt.* Utiliza el operador *?* para propagar los errores de lectura y escritura.

=== Ejercicio 4: Calculadora Parser Robusta (Manejo de strings y entradas numéricas)
- *Enunciado:* Diseña un programa que reciba una cadena de texto que representa una suma simple (por ejemplo, "15+23"). El programa debe extraer ambos números, convertirlos a enteros (i32), sumarlos y mostrar el resultado. Si la cadena no tiene el formato correcto o no contiene números válidos, debe interceptar el error sin colapsar.

=== Ejercicio 5: Registro de Visitas con Fecha Simulada (Escritura persistente)
*Enunciado:* Crea un programa que pida al usuario su nombre por consola y lo guarde en un archivo llamado *visitas.txt*. Cada nombre debe guardarse en una línea nueva. El archivo no debe borrarse cada vez que se abre el programa; los nuevos nombres deben añadirse al final del documento (modo append).

== Soluciones

=== Ejercicio 1: El Validador de Edades (Uso avanzado de Option`<T>`)

*Código de la Solución*

```rust
fn obtener_edad_voto(edad: i32) -> Option<i32> {
    if edad >= 18 && edad <= 120 {
        Some(edad)
    } else {
        None
    }
}

fn main() {
    let casos_prueba = vec![16, 25, -5, 130];

    for edad in casos_prueba {
        match obtener_edad_voto(edad) {
            Some(e) => println!("Edad {} años: ¡Voto permitido!", e),
            None => println!("Edad {} años: Registro rechazado (Menor de edad o valor inválido).", edad),
        }
    }
}
```
*Explicación Didáctica*

- *El tipo Option como filtro:* El ejercicio demuestra cómo Option no solo sirve para la "ausencia" de datos, sino también para descartar activamente datos que no cumplen con las reglas de negocio (valores fuera de rango).

- *El uso de match:* Te obliga a cubrir ambas variantes (Some y None) del enumerado Option, garantizando que el programa nunca intente procesar un voto procedente de una edad inválida como -5.

=== Ejercicio 2: Conversión Segura de Temperatura (Uso de Result`<T, E>`)

*Código de la Solución*

```rust
fn celsius_a_kelvin(celsius: f64) -> Result<f64, String> {
    if celsius < -273.15 {
        Err(String::from("Error: La temperatura está por debajo del cero absoluto (–273.15 °C)."))
    } else {
        Ok(celsius + 273.15)
    }
}

fn main() {
    let temperaturas = vec![25.0, -300.0, 0.0];

    for t in temperaturas {
        match celsius_a_kelvin(t) {
            Ok(k) => println!("{:.2} °C equivalen a {:.2} K", t, k),
            Err(mensaje_error) => println!("{}", mensaje_error),
        }
    }
}
```

*Explicación Didáctica*

- *Diferencia con Option:* Aquí no usamos Option porque si algo falla, queremos explicar por qué ha fallado. La variante Err transporta un String con el motivo exacto del fallo físico.

- *Manejo explícito:* Al procesar el vector con un match, el programa maneja con gracia el valor -300.0 imprimiendo la advertencia en lugar de romperse.

=== Ejercicio 3: Copia de Seguridad de Archivos (Manejo del Sistema de Archivos y ?)

*Código de la Solución*

```rust
use std::fs;

fn respaldar_archivo() -> Result<(), std::io::Error> {
    // 1. Intentamos leer el archivo origen
    let contenido = fs::read_to_string("notas.txtr")?;

    // 2. Intentamos escribir en el archivo destino
    fs::write("notas_bak.txt", contenido)?;

    // 3. Si todo va bien, devolvemos la unidad que no es más
    // que una tupla vacía envuelta en Ok
    Ok(())
}

fn main() {
    // Para probar el código, primero creamos un notas.txt simulado
    let _ = fs::write("notas.txt", "Contenido importante de clase.");

    match respaldar_archivo() {
        Ok(_) => println!("¡Copia de seguridad realizada con éxito!"),
        Err(e) => println!("Error crítico durante el respaldo: {}", e),
    }
}
```

*Explicación Didáctica*

*El poder de ?*: El operador *?* limpia el código. Sin *?*, necesitaríamos dos bloques *match* anidados (uno para leer y otro para escribir en el fichero), lo que haría el código muy farragoso. Con el operador *?* y el tipo adecuado en el Result *std::io::Error*, cualquiera de los dos errores que se produzcan se propagan al main y se tratan allí con un solo match.

*El tipo de retorno ():* El "tipo unidad" () dentro de Result<(), Error>, se utiliza para indicar que todo ha ido bien y no porque se necesite devolver un valor matemático.

=== Ejercicio 4: Calculadora Parser Robusta (Manejo de strings y entradas numéricas)

*Código de la Solución*

```rust
fn sumar_cadena(operacion: &str) -> Result<i32, String> {
    // Dividimos la cadena usando el carácter '+' como separador
    let partes: Vec<&str> = operacion.split('+').collect();

    if partes.len() != 2 {
        return Err(String::from("Formato inválido. Debe ser: número+número"));
    }

    // Intentamos parsear ambos operandos eliminando espacios en blanco adicionales
    let num1: i32 = partes[0].trim().parse()
        .map_err(|_| String::from("El primer operando no es un número válido."))?;
        
    let num2: i32 = partes[1].trim().parse()
        .map_err(|_| String::from("El segundo operando no es un número válido."))?;

    Ok(num1 + num2)
}

fn main() {
    let pruebas = vec!["15+23", " 8 + 12 ", "10+tres", "45-5"];

    for p in pruebas {
        match sumar_cadena(p) {
            Ok(resultado) => println!("Operación '{}' = {}", p, resultado),
            Err(e) => println!("Error en '{}': {}", p, e),
        }
    }
}
```

*Explicación Didáctica*

- *Robustez en Parsing:* El uso de .trim() enseña a los alumnos a limpiar los datos de entrada de los usuarios (quitando espacios no deseados).

- *El método .map_err() (Opcional/Avanzado):* Permite transformar el error técnico que da .parse() (un ParseIntError) en un mensaje de texto personalizado y entendible por cualquier usuario antes de usar el operador ?.

Aclaramos esto último.

La función .parse() intenta convertir el texto en un número i32. Esto devuelve un Result: 
- Si tiene éxito: Devuelve Ok(número).
- Si falla: Devuelve Err(ParseIntError) (por ejemplo, si el texto era `"`hola`"` en lugar de `"`23`"` o similar).
- ParseIntError es lo que hemos llamado antes un error técnico.

Al aplicar .map_err(...)

```rust
let num1: i32 = partes[0].trim().parse()
  .map_err(|_| String::from("El primer operando no es un número válido."))?;
```

El error técnico es sustituido por el String que vemos a la derecha y si el operador ? actúa porque el Result dio error, lo que se transmite al main es el String, no el error técnico.

=== Ejercicio 5: Registro de Visitas con Fecha Simulada (Escritura persistente)

*Código de la Solución*

```rust
use std::fs::OpenOptions;
use std::io::{self, Write};

fn registrar_usuario(nombre: &str) -> io::Result<()> {
    // Abrimos el archivo permitiendo la escritura y forzando el añadido al final (append)
    let mut archivo = OpenOptions::new()
        .write(true)
        .append(true)
        .create(true) // Si no existe, lo crea automáticamente
        .open("visitas.txt")?;

    // Escribimos el nombre seguido de un salto de línea
    writeln!(archivo, "Usuario: {}", nombre)?;
    Ok(())
}

fn main() {
    println!("Por favor, introduce tu nombre de estudiante:");
    
    let mut entrada = String::new();
    io::stdin().read_line(&mut entrada).expect("Error al leer de la consola");
    let nombre_limpio = entrada.trim();

    if nombre_limpio.is_empty() {
        println!("No has introducido ningún nombre.");
        return;
    }

    match registrar_usuario(nombre_limpio) {
        Ok(_) => println!("¡Tu visita ha sido registrada en 'visitas.txt'!"),
        Err(e) => println!("No se pudo acceder al registro: {}", e),
    }
}
```

*Explicación Didáctica*

- *Diferencia* entre *File::create* y *OpenOptions*: Es crucial entender que *File::create* "machaca" (sobrescribe) el archivo desde cero. Para logs, agendas o bases de datos orientadas a registros, se necesita usar *OpenOptions* con la propiedad *.append(true)*.

- Hemos usado el patrón constructor (Builder Pattern) de OpenOptions para configurar el acceso al archivo:

 - .write(true) -> Habilita permisos de escritura.
 - .append(true) -> Posiciona el puntero al final del archivo para no sobrescribir lo existente.
 - .create(true) -> Si el archivo 'visitas.txt' no existe, el sistema operativo lo creará automáticamente.

- *Interactividad básica:* Conecta los conceptos del sistema de archivos con la entrada estándar (stdin) que ya conocen de los cuadernos anteriores.



#pagebreak()