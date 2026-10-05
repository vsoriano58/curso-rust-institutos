=  Asincronia: async / await en Rust

En Rust, el modelo asíncromo permite ejecutar tareas sin bloquear el hilo principal de ejecución, logrando una eficiencia masiva. 

El fundamento es sencillo. Cuando una tarea que declaradmos asíncrona, por ejemplo la descarga de un fichero o la entrada de datos por parte del usuario, tiene que esperar bien a que termine la descarga o a que el usuario termine con la entrada de datos, se pausa la tarea y el hilo sigue trabajando en su tarea principal o en otra tarea asíncrona que esté lista. Esta comutación entre tareas es muy rápiada y con muy poco costo de memoria para el sistema comparada con la conmutación entre hilos del sistema operativo.

Rust proporciona la sintaxis y las herramientas básicas pero para programar la asincronía necesitas una libreria externa o `runtime` como *tokio* o *async-std*.

*Qué es un futuro?*

Un Future (futuro) es un valor que representa una operación que aún no ha terminado, pero que promete completarse en algún momento.

*Cómo se utiliza async / await*

La sintaxis `async` y `await` son palabras clave que transforman bloques de código normales en estructuras que devuelven futuros y permiten pausar la ejecución sin bloquear el hilo que las ejecuta.

- *async:* Transforma un bloque de código o una función para que devuelva un objeto que implementa Future.

- *await:* Pausa la ejecución de la función actual marcada con async hasta que el futuro esté listo, permitiendo que el hilo ejecute otras tareas mientras tanto.

== Ejemplo práctico con tokio

- Abre una terminal integrada de VS Code en la carpeta *proyectos-rust* (o en cualquier otra) y crea el proyecto de Rust *tokio_ejemplo_asin* con la orden:

```
cargo new tokio_ejemplo_asin
```
Edita la sección [dependencies] del fichero Cargo.toml como se muestra a continuación:

```
[dependencies]
tokio = { version = "1", features = ["full"] }
```

💻 Copia el siguiente código y pégalo en el fichero *main.rs* del proyecto creado, borrando previamente todo lo que hubiera escrito en ese fichero.

Proyecto: *tokio_ejemplo_asin*

*src/main.rs*

```rust
use std::time::Duration;
use tokio::time::sleep;

// 1. Definimos una función asíncrona usando 'async'
async fn descargar_archivo(id: u32) -> String {
    println!("Iniciando descarga del archivo {}...", id);
    
    // Simulamos una espera de red de 2 segundos sin bloquear el hilo
    sleep(Duration::from_secs(2)).await; 
    
    format!("Contenido del archivo {}", id)
}

// 2. La función principal también debe ser asíncrona y gestionada
// por un runtime. En este caso hemos elegido 'tokio'
#[tokio::main]
async fn main() {
    println!("Iniciando el gestor de descargas.");

    // Creamos dos futuros (no se ejecutan todavía)
    let descarga1 = descargar_archivo(1);
    let descarga2 = descargar_archivo(2);

    // Con tokio::join! ejecutamos ambos futuros en paralelo de forma asíncrona
    // El programa tardará ~2 segundos en total, no 4.
    let (resultado1, resultado2) = tokio::join!(descarga1, descarga2);

    println!("Resultado 1: {}", resultado1);
    println!("Resultado 2: {}", resultado2);
    println!("¡Todas las descargas finalizadas!");
}
```
La salida del programa debe ser la siguiente:

```
Iniciando el gestor de descargas.
Iniciando descarga del archivo 1...
Iniciando descarga del archivo 2...
Resultado 1: Contenido del archivo 1
Resultado 2: Contenido del archivo 2
¡Todas las descargas finalizadas!
```

== Ventajas frente a la concurrencia con Hilos del Sistema Operativo (OS Threads)

Rust permite usar hilos nativos mediante std::thread, pero el modelo async/await ofrece ventajas críticas en escenarios de alta carga (como servidores web y aplicaciones de red o de E/S):

#table(
  columns: (1.2fr, 2fr, 2fr),
  stroke: (x, y) => if y > 0 { (top: 0.5pt + rgb("3a3a42")) } else { none },
  fill: none,
  inset: 10pt,
  align: horizon + left,

  // --- CABECERA ---
  [*Característica*],
  [*Hilos del Sistema Operativo \ ( #text(fill: rgb("a5a5b0"))[`std::thread`] )*],
  [*Asincronía ( #text(fill: rgb("a5a5b0"))[`async/await`] )*],

  // --- FILA 1 ---
  [*Modelo*],
  [Concurrencia preventiva (el OS gestiona el tiempo).],
  [Concurrencia cooperativa (las tareas ceden el control).],

  // --- FILA 2 ---
  [*Consumo de \ Memoria*],
  [#strong("Alto.") Cada hilo reserva un gran bloque de memoria para su propia pila (_stack_), usualmente de 1 a 2 MB.],
  [#strong("Muy Bajo.") Las tareas asíncronas no tienen pilas propias; se guardan en el _heap_ ocupando solo unos pocos bytes o kilobytes.],

  // --- FILA 3 ---
  [*Cambio de \ Contexto*],
  [#strong("Costoso.") Cambiar de un hilo a otro requiere que la CPU intervenga y modifique registros del sistema.],
  [#strong("Muy rápido.") El cambio ocurre dentro del propio _runtime_ en el espacio de usuario, casi gratis a nivel de CPU.],

  // --- FILA 4 ---
  [*Escalabilidad*],
  [Limitada a unos pocos miles de hilos antes de que el sistema se sature.],
  [Permite manejar #strong("millones") de tareas simultáneas en una sola máquina.]
)

En resumen: ¿Cuándo usar cada uno?

- Usa Hilos del OS si tus tareas requieren un uso intensivo de la CPU (matemáticas pesadas, procesamiento de imágenes o criptografía).

- Usa Asincronía si tus tareas pasan la mayor parte del tiempo esperando (E/S), como servidores web, peticiones API, bases de datos o lecturas de archivos masivos.

== El Rol del Runtime (Ej. Tokio o el de Macroquad)
Dado que la biblioteca estándar de Rust no incluye un planificador asíncrono para mantener los binarios lo más pequeños posibles, necesitas un Runtime externo (como Tokio para servidores o el interno de Macroquad para juegos como veremos luego).

*Que funciones desempeña el runtime?*

- El Runtime mantiene una cola de Futures.
- Llama a poll() en el Future para preguntar su estado.
- Si el Future devuelve Poll::Pending, el Runtime lo registra en el sistema operativo (usando herramientas eficientes como epoll en Linux o IOCP en Windows) para que el hardware le avise cuando haya actividad en la tarjeta de red o el disco.
- Mientras tanto, ese hilo del Runtime pasa a procesar otro Future de la cola.
- Cuando el S.O. avisa que los datos llegaron, el Runtime despierta al Future correspondiente mediante un componente llamado Waker y vuelve a llamar a poll(), avanzando al siguiente estado. 

== ¿Por qué llamamos a Macroquad Runtime interno?

Llamamos a *Macroquad* "runtime interno" porque el propio motor del juego incluye e implementa su propio *planificador asíncrono* dentro de su código base, sin obligarte a depender de herramientas externas como *Tokio* o *async-std*.

En el siguiente apartado utilizaremos Macroquad para programar un juego.

En Rust, la biblioteca estándar provee la sintaxis (async, await) y el trait base (Future), pero no incluye el motor que hace rodar esos futuros. Alguien tiene que encargarse de llamar a poll() y gestionar la cola de tareas.

Macroquad necesita controlar de forma milimétrica el tiempo y los fotogramas del juego. Por ello, en lugar de usar un runtime de propósito general (como Tokio, que está diseñado para servidores web y bases de datos), implementa su propio *bucle de control asíncrono* optimizado para gráficos:

+ Gestión del bucle gráfico: El macro-bucle de Macroquad toma tu función *`async fn main()`* y ejecuta su código frame a frame.

+ Control del .await: Cuando tu código llega a *next_frame().await*, el planificador interno de Macroquad sabe exactamente que debe pausar tu función main, cederle el control a la tarjeta gráfica para que dibuje la pantalla y, justo en el siguiente fotograma, volver a despertar tu función para continuar con la lógica.

En resumen, se le llama "interno" porque viene dentro de la propia caja de Macroquad, permitiendo que los juegos en Rust funcionen de forma asíncrona con una configuración cero para el programador.

En el siguiente apartado comenzamos a trabajar con Macroquad así que esto ha sido un avance para poderlo comparar con la opción `tokio` utilizada en el ejemplo anterior.


#pagebreak()

