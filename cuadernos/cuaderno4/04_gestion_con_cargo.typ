#import "config.typ": *

=  Gestión con Cargo y el Ecosistema de Rust
Cargo es el gestor de paquetes, compilador y sistema de construcción de Rust. La construcción de un programa es algo similar a la unión de varias piezas (programas) para formar un único programa principal.

Entonces podemos definir a Cargo como la herramienta "todo en uno" que acompaña al lenguaje para facilitar la vida del desarrollador, encargándose de automatizar prácticamente todas las tareas relacionadas con la gestión de un proyecto.

== *¿Cuáles son las funciones principales de Cargo?*

Cargo centraliza todo el flujo de trabajo de un programador de Rust a través de cuatro pilares básicos:

- *Gestión de dependencias*: Descarga, actualiza y compila automáticamente las librerías externas (llamadas crates) que tu proyecto necesita desde el registro oficial *crates.io*.

- *Sistema de construcción*: Compila tu código fuente con un solo comando, configurando de forma transparente los parámetros optimizados para desarrollo o para producción.

- *Orquestador de pruebas*: Busca y ejecuta de forma nativa todas las pruebas unitarias y de integración que hayas escrito para verificar que tu código funcione bien. Nosotros no escribimos pruebas unitarias.

- *Generador de proyectos*: Crea la estructura de carpetas inicial estándar y genera los archivos de configuración necesarios para empezar un programa desde cero.

== Los comandos esenciales de Cargo

En el día a día, casi nunca interactúas con el compilador puro (rustc), sino que utilizas Cargo a través de la terminal mediante estos comandos:

- *cargo new* mi_proyecto: Crea una carpeta con un proyecto nuevo listo para programar.

- *cargo build*: Compila el proyecto y genera el archivo ejecutable.

- *cargo run*: Compila el código (si ha habido cambios) y lo ejecuta inmediatamente.

- *cargo check*: Revisa rápidamente el código en busca de errores de compilación sin perder tiempo en generar el archivo ejecutable (ideal mientras estás programando).

- *cargo test*: Ejecuta todos los tests de tu aplicación.

Cuando creamos un proyecto con la orden cargo new mi_proyecto se genera un directorio para el proyecto con dos ficheros que vamos a comentar a continuación.

== Cargo.toml (El manifiesto del desarrollador)
El archivo Cargo.toml (escrito con la primera letra en mayúscula y extensión .toml) es un fichero generado automáticamente por Cargo. No está pensado para ser manipulado manualmente aunque se puede hacer.

En este archivo tú especificas:

- *Metadatos*: El nombre de tu programa, la versión actual, el autor y la edición de Rust que usas.

- *Tus intenciones*: Qué librerías externas (crates) quieres usar y qué versiones estás dispuesto a aceptar.

*Ejemplo típico de un Cargo.toml*:

```
[package]
name = "mi_proyecto"
version = "0.1.0"
edition = "2024"

[dependencies]
# Aquí se añaden las librerías del ecosistema
csv = "1.3"
serde = "1.0"  
```
== Cargo.lock (El registro exacto del sistema)
El archivo *Cargo.lock* (completamente autogenerado por Cargo) es el que garantiza que tu código se compile exactamente igual en cualquier ordenador del mundo. 

Tú no debes editar este archivo a mano. Cargo lo gestiona solo.

Guarda las versiones exactas (por ejemplo, 1.0.199 en lugar de solo 1.0).

Si otra persona descarga tu proyecto un año después, Cargo.lock asegura que use exactamente las mismas versiones que usaste tú, evitando que una actualización rota en una librería externa rompa tu programa de repente.

== ¿Qué son las crates y Crates.io?
En Rust, los paquetes de código o librerías se llaman crates. La comunidad publica miles de soluciones de código abierto en la web oficial *crates.io*. En lugar de reinventar la rueda (por ejemplo, programar nuestro propio lector de ficheros CSV "tipo hoja de cálculo" o generador de gráficos), añadimos la línea correspondiente en [dependencies] y Cargo se encarga de descargar el crate indicado, verificarlo y compilarlo de forma totalmente transparente.


#pagebreak()