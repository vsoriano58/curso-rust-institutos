#import "config.typ": *

= Servidor web asíncrono multihilo con Tokio
El ejemplo que hemos elegido une de forma muy visual el mundo de la red, la asincronía y las tareas en segundo plano.

El código que proponemsa utiliza un *modelo asíncrono multihilo* (work-stealing) gracias al *runtime de Tokio*.

💻 Abre una terminal integrada de VS Code en el directorio *proyectos-rust* creado al principio o en cualquier otro y crea un proyecto Rust con la orden: *cargo new servidor_web_multihilo*.

- Sitúate en la carpeta del proyecto mediante *cd servidor_web_multihilo* desde la misma terminal integrada de VS Code.

- Accede al fichero *Cargo.toml* y edita su sección [dependencies] para que se vea como se muestra abajo:

```
[dependencies]
axum = "0.8.9"
tokio = { version = "1.52.3", features = ["full"] }
```

- Copia el siguiente código y pégalo en el fichero src/main.rs

Fichero: *src/main.rs*

```rust
use axum::{routing::get, Router};
use std::net::SocketAddr;
use std::time::Duration; // Para pausar el tiempo

#[tokio::main]
async fn main() {
    // 1. Definimos la ruta de nuestra web
    let app = Router::new().route("/", get(leer_sensor));

    // 2. Configuramos la dirección de red
    let direccion = SocketAddr::from(([0, 0, 0, 0], 3000));
    println!("--- Servidor del Sensor Activo ---");
    println!("Pruébalo en este ordenador abriendo: http://localhost:3000");

    // [NUEVO] Lanzamos la tarea cíclica de fondo (conteo 1 al 10)
    // Tokio se encarga de ejecutar esto de manera asíncrona en paralelo
    tokio::spawn(async {
        let mut contador = 1;
        loop {
            println!("Contador cíclico: {}", contador);
            contador += 1;
            if contador > 10 {
                contador = 1;
            }
            // Pausa asíncrona de 1 segundo sin bloquear el hilo
            tokio::time::sleep(Duration::from_secs(1)).await;
        }
    });

    // 3. Encendemos el servidor y lo dejamos escuchando
    // Nota: Esta línea bloquea el final de main, si no, el programa se cerraría
    let listener = tokio::net::TcpListener::bind(direccion).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

// Función asíncrona que simula leer un sensor
async fn leer_sensor() -> String {
    // Simulamos que el sensor tarda 2 segundos en responder
    tokio::time::sleep(Duration::from_secs(2)).await;
    
    let temperatura = 24.5; // Un valor simulado
    format!("Temperatura actual del sensor: {} °C", temperatura)
}
```
- Ejecuta el programa mediante la orden *cargo run*.

- Dar una explicación de lo que hace el programa desde que se accede a la url localhost:3000.
- Dar una explicación línea por línea

== Mecanismos clave que intervienen en el programa

*1. El motor del sistema: tokio y #[tokio::main]*

La macro *`#[tokio::main]`* transforma la función main en una función asíncrona y, tras bambalinas, levanta el runtime (entorno de ejecución) de *Tokio*.

Por defecto, Tokio configura un grupo de hilos nativos (Thread Pool) del sistema operativo igual al número de núcleos de la CPU.

El planificador (scheduler) se encarga de repartir las tareas de forma eficiente entre esos hilos. Si un hilo se queda sin trabajo, "roba" tareas de otros hilos (work-stealing) para maximizar el rendimiento.

*2. El servidor web de alto rendimiento: axum*

- *Router::new().route("/", get(leer_sensor))*: Axum aprovecha el ecosistema asíncrono para gestionar las peticiones HTTP. Cuando llega una solicitud a la raíz (/), Axum no bloquea un hilo esperando a que se procese; simplemente genera una tarea asíncrona (Future).

- Al usar *axum::serve*, el servidor se queda escuchando de forma no bloqueante. Puede recibir miles de conexiones simultáneas en un solo hilo del sistema porque la espera se gestiona a nivel de eventos de red (gracias a abstracciones como `mio` bajo el capó de Tokio).

*3. La creación del "hilo de fondo": tokio::spawn*

- Es vital aclarar que *tokio::spawn* no crea un hilo del sistema operativo. Lo que crea es una Green Thread (o *tarea asíncrona*).

- Las tareas asíncronas en Rust son increíblemente ligeras (pesan apenas unos bytes o kilobytes en memoria, a diferencia de los megabytes que requiere un hilo real del sistema).

- Tokio toma ese bloque *async { ... }* y lo pone en la cola del planificador. Este contador cíclico se ejecutará en paralelo con el servidor web, saltando de un hilo a otro del pool de Tokio según haga falta, de forma transparente para el desarrollador.


*4. La magia del no-bloqueo: tokio::time::sleep(...).await*

- En el bucle del contador usamos *tokio::time::sleep*, y en la función del sensor hacemos lo mismo. La palabra clave *.await* es el "punto de rendimiento" voluntario.

- Cuando el programa llega a esa línea, la tarea le dice al planificador de Tokio: "Voy a estar libre 1 o 2 segundos. Retírame de la CPU y aprovecha este hilo para atender peticiones web o avanzar con otra tarea".

- Una vez cumplido el tiempo, Tokio despierta la tarea y la vuelve a poner en la cola para continuar justo donde se quedó. Si usaras *std::thread::sleep*, congelarías el hilo entero del sistema operativo, impidiendo que otras tareas avancen.

=== ¿Cómo reparte Tokio las tareas entre los hilos? (El Planificador)
El planificador de Tokio de tipo Work-Stealing (Robo de Trabajo) funciona como un director de orquesta ultraeficiente. Imagina un procesador con 4 núcleos (Hilo 1 al Hilo 4).Cuando arrancas el servidor, Tokio asigna una cola local de tareas a cada hilo del sistema operativo. El reparto visual se comporta así:

```
[ HILO 1 del Sistema ] ──> [ Cola Local ] ──> 📋 Tarea: Servidor Axum (Escuchando)
 [ HILO 2 del Sistema ] ──> [ Cola Local ] ──> 📋 Tarea: Contador Cíclico (tokio::spawn)
 [ HILO 3 del Sistema ] ──> [ Cola Local ] ──> (Vacía - Buscando trabajo)
 [ HILO 4 del Sistema ] ──> [ Cola Local ] ──> (Vacía - Buscando trabajo)
```

*
El flujo de ejecución paso a paso:*

1. Lanzamiento: Al ejecutar tokio::spawn, el Contador Cíclico se envía al planificador. Este lo coloca en la cola de uno de los hilos libres (por ejemplo, el Hilo 2).

2. Petición Web: Cuando un usuario entra a http://localhost:3000, el Servidor Axum (en el Hilo 1) recibe la conexión y genera una nueva tarea: 📋 Tarea: leer_sensor().

3. El Punto .await (Cooperación): En cuanto la tarea leer_sensor() llega a su tokio::time::sleep(...).await, libera el Hilo 1. La tarea se pausa en segundo plano esperando el temporizador, dejando el Hilo 1 completamente vacío y listo para recibir a otro usuario.

4. Robo de Trabajo (Work-Stealing): Si el Hilo 3 o el Hilo 4 se quedan sin tareas en su cola local, no se duermen. Miran las colas de los Hilos 1 y 2 y "roban" de forma segura cualquier tarea que esté lista para ejecutarse (como el contador cíclico cuando despierta de su segundo de pausa).

=== Diferencia de Consumo de Memoria: std::thread vs tokio::spawn
Para entender por qué la asincronía escala tan bien, debemos comparar qué le cuesta al ordenador crear un hilo real frente a una tarea asíncrona.

Analicemos la siguiente tabla:

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (x, y) => if y == 0 { (bottom: 1pt + gray) } else { (bottom: 0.5pt + gray.lighten(50%)) },
  inset: 10pt,
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
  
  // Encabezado de la tabla
  table.header(
    [*Característica*], 
    [*Hilo Nativo ( \#raw("std::thread") )*], 
    [*Tarea de Tokio ( \#raw("tokio::spawn") )*]
  ),

  // Fila 1: Nivel
  [*Nivel*],
  [Administrado por el *Sistema Operativo*.],
  [Administrado por el *Runtime de Tokio* (en espacio de usuario).],

  // Fila 2: Tamaño en Memoria
  [*Tamaño en Memoria*],
  [*¡De 1 a 2 Megabytes (MB)!* (Reserva fija para la pila/stack).],
  [*Unos pocos Kilobytes (KB)* o incluso Bytes (dinámico según variables).],

  // Fila 3: Límite Práctico
  [*Límite Práctico*],
  [Unos pocos miles (el sistema se colapsa).],
  [*Millones* de tareas simultáneas sin despeinarse.],

  // Fila 4: Cambio de Contexto
  [*Cambio de Contexto*],
  [*Costoso.* Involucra al kernel de la CPU para salvar registros de hardware.],
  [*Barato.* Es un simple cambio de puntero y llamada a una función ( `poll` ).]
)

Cuando creas un hilo nativo con *std::thread*, el sistema operativo es precavido y le asigna un "colchón" de memoria enorme (normalmente 2 MB en Linux) por si la función realiza muchas llamadas internas. Si intentas abrir 50.000 hilos nativos, tu servidor consumirá unos 100 GB de RAM solo en existir, lo que tumbará la máquina.

En cambio, *tokio::spawn* no pide memoria fija al sistema operativo. En Rust, un bloque asíncrono se compila como una Máquina de Estados (una estructura de datos interna). Solo ocupa el espacio estrictamente necesario para guardar las variables que están activas durante el .await.

- La tarea del contador cíclico solo guarda un entero (contador). ¡Ocupa prácticamente nada en memoria! Puedes levantar 1.000.000 de contadores asíncronos y el servidor apenas consumirá unas pocas decenas de Megabytes.

Hemos preparado dos retos finales para animar a arremangarte y modificar el programa anterior.

=== 🏆 Reto Final A: El Panel de Control del Operador
¡Ha llegado el momento de poner a prueba tus nuevos superpoderes asíncronos!
Actualmente, nuestro servidor web lee un sensor simulado estático y, por otro lado, un contador cíclico imprime números en la consola de forma independiente. Tu misión, si decides aceptarla, es unirlos.

🎯 *El Objetivo*

Modifica el código para que el contador cíclico actúe como un "generador de telemetría" que actualiza el valor del sensor en tiempo real. Cuando el usuario visite http://localhost:3000, el servidor web debe responder mostrando el último valor que ha calculado el contador de fondo.

💡 Pistas para resolverlo:

Para lograr que la tarea de fondo (tokio::spawn) y la función del servidor web (leer_sensor) compartan datos de forma segura en un entorno multihilo, necesitarás usar las herramientas de sincronización que nos da Rust:

1. El Estado Compartido (Arc + Mutex o RwLock): No puedes usar variables globales normales porque Rust te protegerá de carreras de datos (data races). Envuelve el contador en un Arc::new(Mutex::new(0)) para poder compartirlo de forma segura entre hilos.

2. Pasar el Estado a Axum: Axum permite pasar datos a las rutas usando .with_state(). Investiga cómo recibir ese estado en la función leer_sensor usando el extractor State.

3. ¡Cuidado con los Mutex del sistema! Recuerda que estás en un entorno asíncrono. Si usas un Mutex tradicional de la librería estándar (std::sync::Mutex) y lo bloqueas a través de un .await, podrías congelar el planificador de Tokio. Utiliza el Mutex asíncrono de Tokio: tokio::sync::Mutex.

*El Resultado Esperado*

Al abrir tu navegador y refrescar la página varias veces, verás cómo la temperatura cambia dinámicamente según el segundo exacto en el que hagas la petición:

- Intento 1: Temperatura actual del sensor: 24.1 °C
- Intento 2 (un segundo después): Temperatura actual del sensor: 24.2 °C

=== 🏆 Reto Final B: El Sistema de Alertas Inteligente
Ahora que entiendes cómo Tokio reparte el trabajo y cómo Axum atiende a tus usuarios, es hora de poner a prueba tus habilidades. Vamos a transformar nuestro servidor estático en un sistema de monitoreo en tiempo real.

🎯 *El Objetivo*

Modifica el código actual del cuaderno para cumplir con las siguientes directrices:

1. La Variable Compartida: Crea una variable global (o compartida de forma segura) que almacene la temperatura actual del sensor.

2. El Hilo de Fondo Actualiza: En lugar de solo imprimir del 1 al 10, haz que la tarea de fondo (tokio::spawn) simule la lectura del sensor generando una temperatura aleatoria cada 2 segundos y actualice la variable compartida.

3. El Servidor Responde al Instante: Modifica la función leer_sensor de Axum para que, cuando el usuario entre a http://localhost:3000, ya no espere 2 segundos de forma fija, sino que responda inmediatamente mostrando el último valor que haya calculado la tarea de fondo

💡 *Pistas para resolverlo*

- El problema de compartir en hilos: Como Tokio puede mover tus tareas entre diferentes hilos del sistema operativo, no puedes usar una variable común y corriente. Rust te obligará a protegerla.

- Tus herramientas aliadas: Necesitarás combinar un puntero inteligente de pertenencia compartida (std::sync::Arc) con un cerrojo de exclusión mutua asíncrono (tokio::sync::Mutex) para poder leer y escribir la temperatura de forma segura entre la tarea del contador y la ruta de Axum.

- Para los datos aleatorios: Puedes usar la funcionalidad de tiempo de Rust para *inventar un número* o añadir la dependencia *rand* en tu Cargo.toml.

📝 *Pista de código (Estructura base)*

Por si te atascas te dejamos esta pequeña plantilla de cómo se inicializa el estado compartido en Axum:

```rust
// Ejemplo de cómo compartir el estado en Axum usando Arc y Mutex
use std::sync::Arc;
use tokio::sync::Mutex;
use axum::{Extension, Router, routing::get};

// 1. Creamos un tipo para nuestro estado
type EstadoCompartido = Arc<Mutex<f32>>;

#[tokio::main]
async fn main() {
    // 2. Inicializamos la temperatura en 25.0 grados
    let temperatura_compartida: EstadoCompartido = Arc::new(Mutex::new(25.0));

    // 3. Pasamos el estado a Axum usando "Extension"
    let app = Router::new()
        .route("/", get(leer_sensor))
        .layer(Extension(temperatura_compartida.clone()));
        
    // ... El resto de tu código de Tokio ...
}
```





#pagebreak()