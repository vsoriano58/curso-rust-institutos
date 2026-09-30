#import "config.typ": *

= Concurrencia Segura y Asincronía en Rust
Todos los programas que hemos diseñado en los cuadernos anteriores comparten una característica fundamental: son estrictamente síncronos y no aplican concurrencia. Esto se traduce en que, al ejecutarse, consumen un único hilo del microprocesador. Sin embargo, la informática actual ha cambiado. La gran mayoría de los procesadores modernos disponen de varios núcleos de hardware, y los sistemas operativos son capaces de gestionar miles de hilos de software de forma simultánea. Para aprovechar este potencial, los lenguajes modernos incorporan recursos que permiten a los programas exprimir cada núcleo de la CPU.

*Algunas definiciones*

+ *Sobre el concepto de monohilo (Síncrono):* Un programa síncrono tradicional se ejecuta en un único hilo de software procesando las instrucciones en orden secuencial. El sistema operativo asigna ese hilo a un solo núcleo de la CPU a la vez. Si ese núcleo está al 100% de su capacidad o se queda esperando a que el disco duro lea un archivo, todo tu programa se congela por completo en ese instante.

+ *Hilos de Software vs. Núcleos de Hardware:* Los sistemas operativos son tan avanzados que pueden gestionar miles de hilos de software al mismo tiempo, incluso si el microprocesador solo tiene, por ejemplo, 8 núcleos físicos de hardware. El sistema operativo va rotando esos hilos en los núcleos tan rápido (en microsegundos) que nos da la ilusión de que todo se ejecuta a la vez. Rust te da el control total para crear estos hilos de software de forma 100% segura.

+ *Concurrencia vs. Asincronía:* La concurrencia (hilos) divide el trabajo pesado entre los núcleos de la CPU. La asincronía (tareas/Futures) optimiza los tiempos muertos de espera (red, discos) para que un solo hilo pueda hacer otras cosas mientras espera, logrando hacer "más cosas al mismo tiempo" pero con una filosofía y un coste radicalmente distintos.

En el ecosistema de Rust, la concurrencia y la asincronía son las dos herramientas clave para hacer más de una cosa al mismo tiempo; aunque, como descubriremos a continuación, operan bajo filosofías, costes y mecanismos de ejecución completamente diferentes.


== La relación entre Concurrencia y Asincronía en Rust
Para entender cómo se relacionan, primero debemos diferenciar sus conceptos:

- *Concurrencia (Basada en Hilos / Threads):* Está orientada a la CPU. El sistema operativo levanta hilos nativos (*std::thread*). Cada hilo tiene su propia pila de memoria (stack) asignada por el sistema (normalmente unos 2 MB). Si tienes 4 tareas pesadas de cálculo matemático, creas 4 hilos distribuidos en los núcleos de tu procesador. Su coste de conmutación (cambiar de un hilo a otro) es gestionado por el hardware/S.O. y es relativamente alto.

- *Asincronía (Basada en Tareas / Futures):*
Está orientada a operaciones de Entrada/Salida (I/O), como esperar una respuesta de red (HTTP), una consulta a la base de datos o la lectura de un archivo. En lugar de bloquear un hilo entero del sistema operativo mientras esperas los bytes, el hilo "suelta" la tarea y se dedica a procesar otra y por tanto permanece activo.

*La conexión entre Concurrencia y Asincronía: Múltiples tareas sobre pocos hilos*

La asincronía en Rust es un modelo de concurrencia cooperativa. Te permite ejecutar miles o millones de tareas simultáneas (comportamiento concurrente) utilizando un número mínimo de hilos del sistema operativo (a menudo, tantos hilos como núcleos tenga tu CPU).

#table(
  columns: (auto, 1fr, 1fr),
  fill: none,
  stroke: (x, y) => if y == 0 { (bottom: 1.5pt + black) } else { (bottom: 0.5pt + gray.lighten(50%)) },
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
  
  // Cabecera de la tabla
  table.header(
    [*Característica*],
    [*Concurrencia Clásica \ (`std::thread`)*],
    [*Asincronía \ (`async/await`)*],
  ),

  // Filas de contenido
  [*Enfoque principal*], [Tareas intensivas de CPU (Cálculo).], [Tareas intensivas de I/O (Red, Discos).],
  [*Coste de memoria*], [Alto (Megabytes por hilo del S.O.).], [Prácticamente cero (Bytes por tarea).],
  [*Gestor*], [El Sistema Operativo (Planificador).], [Un _Runtime_ en espacio de usuario (ej. Tokio).],
  [*Bloqueo*], [Bloquea el hilo por completo.], [Pausa la tarea, el hilo sigue libre.],
)

La tabla anterior merece algunos comentarios avanzados que posiblemente no necesitarás para entender el código de los programas que vienen a continuación pero reafirmarás las bases que estas aprendiendo.

1. *Coste de memoria: ¿Por qué vemos en la tabla MB por hilo vs. Bytes por tarea? ¿No depende de la tarea a realizar?*
Sí depende de la tarea, pero la diferencia radical está en el peaje de entrada que te cobra el sistema operativo por el simple hecho de existir.

- *Concurrencia Clásica (std::thread):* Cuando le pides al sistema operativo que cree un hilo nativo, este tiene que reservarle obligatoriamente un bloque de memoria fijo llamado Stack (Pila). En la mayoría de sistemas operativos (como Linux o Windows), este tamaño por defecto suele ser de 2 Megabytes. Da igual si tu hilo solo va a sumar 2 + 2 (que ocupa unos pocos bytes); el sistema operativo ya le ha amputado 2 MB a la memoria RAM de tu ordenador solo para gestionar ese hilo. Si intentas crear 10.000 hilos a la vez, tu servidor colapsará porque necesitará unos 20 GB de RAM solo en "peajes de existencia".

- *Asincronía (async/await):* Las "tareas" asíncronas no son hilos del sistema operativo; son gestionadas por Rust como pequeñas estructuras de datos (máquinas de estados, como vimos antes). El peaje de entrada aquí es de unos pocos Bytes o Kilobytes (el espacio justo para guardar las variables locales de esa función asíncrona). Si la tarea necesita calcular algo muy grande en el Heap, gastará más, pero si la tarea es pequeña, ocupa casi nada. Por eso un solo hilo de ejecución asíncrono puede gestionar 100.000 tareas web simultáneas en una Raspberry Pi sin despeinarse.

2. *¿Qué significa `"`en espacio de usuario`"`?*

Un sistema operativo moderno divide la memoria del ordenador en dos zonas de seguridad totalmente aisladas:

- *Espacio de Núcleo (Kernel Space):* Es la zona VIP y ultra-protegida donde vive el corazón del Sistema Operativo. Solo el Kernel puede hablar directamente con la tarjeta de red, el disco duro o el procesador. Crear o destruir un hilo (std::thread) requiere que tu programa llame al Kernel, lo cual es lento porque exige un cambio de contexto de seguridad en la CPU.

- *Espacio de Usuario (User Space):* Es la zona donde se ejecutan tus programas normales (como tu navegador, tu juego o tu servidor de Rust).

 - Decir que el Runtime (como Tokio) gestiona la asincronía en "espacio de usuario" significa que es tu propio programa en Rust el que decide qué tarea va primero y cuál va después, mediante código normal y corriente de Rust. No tiene que pedirle permiso al Kernel del sistema operativo cada vez que cambia de una tarea a otra, lo que hace que cambiar entre miles de tareas asíncronas sea ridículamente rápido y eficiente.

==  ¿Cómo funciona async / await en Rust?

A diferencia de JavaScript o `C#`, donde la asincronía viene integrada con un motor interno y recolección de basura, en Rust la asincronía es de coste cero (Zero-Cost Abstraction) y no incluye un planificador por defecto.

El funcionamiento se basa en tres pilares: El Trait Future, Las Máquinas de Estados (async) y El Ejecutor (Runtime).

=== ¿Qué es un Trait?
Un Trait (que significa *rasgo o característica* en inglés) es simplemente una lista de tareas o habilidades que un tipo de datos promete saber hacer. En otros lenguajes de programación se le conoce como una Interfaz.

Decimos que un tipo de datos implementa un trait cuando posee todas las habilidades que componen el trait. El trait se implementa mediante código.

Veamos un ejemplo muy sencillo. Definimos el trait *Hablador* con un solo método, *hacer_sonido(&self)*. Los traits pueden contener cualquier número de métodos. Cuando se definen los métodos en el trait solo se pone su cabecera. Los tipos que implementen el trait tienen que dar código a esos metodos cuya cabecera heredan del trait.

En el ejemplo, los struct *Perro* y *Pato* implementan (con la sentencia *impl*) el trait *Hablador* y dan código al método *hacer_sonido*. Podemos ver en el main como se instancian los objetos perro y pato y llaman al método hacer_sonido de cada objeto.

```rust
/* 
    --- Este es el contrato ---
    Cualquier tipo (de dato) que sea un "Hablador" 
    debe saber hacer_sonido
*/

// Definimos el trait Hablador
trait Hablador {
    fn hacer_sonido(&self);
}

struct Perro {
    nombre: String,
}

struct Pato {
    nombre: String,
}

// El Perro firma el contrato "Hablador"
impl Hablador for Perro {
    fn hacer_sonido(&self) {
        println!("¡Guau! Soy el perro {}", self.nombre);
    }
}

// El Pato firma el contrato "Hablador"
impl Hablador for Pato {
    fn hacer_sonido(&self) {
        println!("¡Cuaic! Soy el pato {}", self.nombre);
    }
}

fn main() {
    let perro = Perro {
        nombre: String::from("Jerry"),
    };
    
    let pato = Pato {
        nombre: String::from("Lucas"),
    };

    perro.hacer_sonido();
    pato.hacer_sonido();
}
```

Gracias a este mecanismo, podemos crear funciones que no necesitan saber si tratan con un perro o con un pato; solo necesitan saber que el objeto que reciben cumple con el contrato de *saber hablar*.

De la misma forma, el *Trait Future* del que hablaremos después es simplemente un contrato que dice: "No me importa qué tipo de tarea asíncrona seas (red, disco, base de datos), si firmas este contrato, te obligas a ti mismo a tener una función llamada *poll* para que pueda preguntarte si ya has terminado".

===  A. El Trait Future (El modelo de "Tirar" o Poll)
En la mayoría de lenguajes, cuando lanzas una función asíncrona, esta empieza a ejecutarse inmediatamente en segundo plano (modelo Push). En Rust no.

Una función async devuelve un objeto que implementa el trait Future. Un Future es una estructura perezosa (lazy): no hace absolutamente nada hasta que alguien se lo pide. Su diseño simplificado es el siguiente:

```rust
pub trait Future {
    type Output;
    // El runtime llama a 'poll' para ver si el valor ya está listo
    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output>;
}
```
El Runtime llama al método poll(). Este responde Poll::Pending (si sigue esperando el archivo o la red) o Poll::Ready(valor) (si ya terminó).

=== B. Qué hace async por dentro: La Máquina de Estados
Cuando marcas una función o bloque con la palabra clave async, el compilador de Rust transforma mágicamente tu código secuencial en una estructura de datos que actúa como una máquina de estados.

Cada vez que pones un .await, el compilador genera un punto de interrupción en esa máquina de estados.

```rust
// 1. Código escrito por el programador:
async fn procesar_pedido() -> String {
    let id = descargar_id().await; // Punto de pausa 1
    let resultado = verificar_pago(id).await; // Punto de pausa 2
    resultado
}
```
Por detrás, el compilador traduce ese código en un enum similar a esto:

```rust
// 2. Lo que genera el compilador (simplificado):
enum ProcesarPedidoFuture {
    Inicio,
    EsperandoDescargarId(DescargarIdFuture),
    EsperandoVerificarPago(VerificarPagoFuture),
    Completado,
}
```
Cuando la ejecución topa con un .await, el estado de la función se guarda en memoria (en el stack de la tarea, no del hilo) y la función retorna el control inmediatamente.

=== C. El Rol del Runtime (Ej. Tokio o el de Macroquad)
Dado que la biblioteca estándar de Rust no incluye un planificador asíncrono para mantener los binarios lo más pequeños posibles, necesitas un Runtime externo (como Tokio para servidores o el interno de Macroquad para juegos).

- El Runtime mantiene una cola de Futures.
- Llama a poll() en el Future.
- Si el Future devuelve Poll::Pending, el Runtime lo registra en el sistema operativo (usando herramientas eficientes como epoll en Linux o IOCP en Windows) para que el hardware le avise cuando haya actividad en la tarjeta de red o el disco.
- Mientras tanto, ese hilo del Runtime pasa a procesar otro Future de la cola.
- Cuando el S.O. avisa que los datos llegaron, el Runtime despierta al Future correspondiente mediante un componente llamado Waker y vuelve a llamar a poll(), avanzando al siguiente estado. 

-------------------------------------------

[ESTO LO PONGO AQUÍ PARA NO PERDERLO PERO ES UNA CONSULTA A LA IA] 

Yo: ¿Por qué llamas a Macroquad Runtime interno?

Llamamos a Macroquad "runtime interno" porque el propio motor del juego incluye e implementa su propio planificador asíncrono dentro de su código base, sin obligarte a depender de herramientas externas como Tokio o async-std.

En Rust, la biblioteca estándar provee la sintaxis (async, await) y la interfaz base (Future), pero no incluye el motor que hace rodar esos futuros. Alguien tiene que encargarse de llamar a poll() y gestionar la cola de tareas.

Macroquad necesita controlar de forma milimétrica el tiempo y los fotogramas del juego. Por ello, en lugar de usar un runtime de propósito general (como Tokio, que está diseñado para servidores web y bases de datos), implementa su propio bucle de control asíncrono optimizado para gráficos:

+ Gestión del bucle gráfico: El macro-bucle de Macroquad toma tu función async fn main() y ejecuta su código frame a frame.

+ Control del .await: Cuando tu código llega a next_frame().await, el planificador interno de Macroquad sabe exactamente que debe pausar tu función main, cederle el control a la tarjeta gráfica para que dibuje la pantalla y, justo en el siguiente fotograma, volver a despertar tu función para continuar con la lógica.

En resumen, se le llama "interno" porque viene dentro de la propia caja de Macroquad, permitiendo que los juegos en Rust funcionen de forma asíncrona con una configuración cero para el programador.

AQUI TERMINA LA CONSULTA

------------------------------------------------

== Ejemplo práctico: Integración en nuestro videojuego

--- [No hay un apartado anterior con Macroquad] ---

En el apartado anterior de Macroquad usamos next_frame().await. Ahora cobra sentido:

```rust
#[macroquad::main("Mi Juego Async")]
async fn main() {
    loop {
        // ... Lógica del juego ...

        // Detiene la máquina de estados de 'main' y le cede el control 
        // al motor gráfico para que dibuje. Cuando la tarjeta gráfica 
        // termina el frame, el runtime vuelve a despertar este bucle.
        next_frame().await; 
    }
}
```

==  Concurrencia Segura - El Superpoder de Rust
== ¿Qué es la concurrencia y por qué es difícil? El problema de los hilos de ejecución.
(De antes)

Normalmente, tus programas ejecutan una línea de código detrás de otra (secuencialmente). Sin embargo, los procesadores modernos tienen varios núcleos y pueden hacer varias tareas a la vez. Esto es la concurrencia.

Hacer esto en otros lenguajes es peligroso: si dos hilos intentan modificar la misma variable al mismo tiempo, el programa puede corromperse (lo que se conoce como condición de carrera). El compilador de Rust, gracias a sus reglas de propiedad (ownership), impide estos errores antes de que el programa se ejecute. A esto le llamamos Concurrencia sin miedo (Fearless Concurrency).

(Lo nuevo)

La concurrencia es la capacidad de un programa de ejecutar diferentes partes de su código de forma independiente y potencialmente simultánea. Tradicionalmente, esto se logra mediante hilos de ejecución (threads) gestionados por el sistema operativo. El gran problema de la concurrencia en lenguajes como C++ o Java es que los hilos comparten memoria por defecto.

Cuando varios hilos intentan acceder y modificar el mismo fragmento de datos al mismo tiempo sin la sincronización adecuada, ocurren condiciones de carrera (race conditions), corrupción de memoria y bloqueos mutuos (deadlocks). Estos errores son extremadamente difíciles de reproducir y depurar porque dependen del orden exacto en el que el sistema operativo planifica los hilos.

A continuación, se muestra una simulación conceptual del problema común de "lectura/escritura sucia" si no se tuviera el control estricto de Rust:

```rust
// Nota: Este patrón simula el peligro lógico de la concurrencia clásica.
// En otros lenguajes, si dos hilos modifican `cuenta_bancaria` a la vez, el resultado final es impredecible.

struct CuentaBancaria {
    balance: i32,
}

impl CuentaBancaria {
    fn retirar(&mut self, cantidad: i32) {
        let saldo_actual = self.balance;
        // Si otro hilo interrumpe aquí, ambos leerán el mismo saldo_actual
        self.balance = saldo_actual - cantidad;
    }
}
```


== 2.3. Creando hilos (std::thread)
Podemos lanzar un "hilo" secundario para que haga un trabajo pesado mientras el programa principal sigue su curso.

== El enfoque de Rust: Fearless Concurrency (Concurrencia sin miedo).
El superpoder de Rust radica en su concepto de Fearless Concurrency (Concurrencia sin miedo). En lugar de delegar la prevención de errores al programador mediante documentación y disciplina, el propio compilador de Rust valida la seguridad concurrente en tiempo de compilación.

- Rust logra esto extendiendo sus reglas de propiedad (ownership) y préstamo (borrowing) mediante dos traits marcadores del sistema de tipos:

- Send: Indica que la propiedad de un tipo puede transferirse entre hilos.

- Sync: Indica que es seguro que múltiples hilos accedan al mismo tipo a través de referencias compartidas (&T).

Si intentas escribir código que cause una condición de carrera, el código simplemente no compilará.

El siguiente ejemplo demuestra cómo el compilador bloquea un intento de compartir una referencia insegura entre hilos:

```rust
use std::thread;

fn main() {
    let mut datos = vec![1, 2, 3];

    // Intentamos crear un hilo que acceda a 'datos' de forma insegura
    // El compilador arrojará un error porque no puede garantizar la validez de la referencia
    /*
    thread::spawn(|| {
        datos.push(4); 
    });
    
    datos.push(5); // Error: Uso de un valor mutabilidad compartida entre hilos
    */
    println!("El compilador de Rust nos protege antes de ejecutar el programa.");
}
```
== Creando y gestionando hilos (std::thread)
Para crear un hilo nativo en Rust se utiliza la función thread::spawn de la biblioteca estándar, pasándole una clausura (closure) que contiene el código que debe ejecutar el hilo.

Debido a que los hilos pueden sobrevivir a la función que los creó, Rust nos obliga a transferir la propiedad de las variables del entorno al hilo mediante la palabra clave move. Para asegurarnos de que un hilo termine su ejecución antes de que el hilo principal finalice, guardamos el manejador devuelto (JoinHandle) y llamamos al método .join().

Ejemplo práctico de creación, paso de datos y sincronización de hilos:

```rust
use std::thread;
use std::time::Duration;

fn main() {
    let mensaje = String::from("Hola desde el hilo secundario");

    // Creamos un hilo. Usamos 'move' para transferir la propiedad de 'mensaje' al hilo
    let manejador = thread::spawn(move || {
        for i in 1..4 {
            println!("{} (Paso {})", mensaje, i);
            thread::sleep(Duration::from_millis(200));
        }
    });

    // El hilo principal hace su propio trabajo en paralelo
    for i in 1..3 {
        println!("Trabajando desde el hilo principal... (Paso {})", i);
        thread::sleep(Duration::from_millis(150));
    }

    // Esperamos obligatoriamente a que el hilo secundario termine
    manejador.join().unwrap();
    
    println!("¡Todos los hilos han terminado!");
}
```

==  Compartiendo datos de forma segura: Canales de comunicación (mpsc)
Una de las filosofías de concurrencia más populares (adoptada también por lenguajes como Go) es: "No te comuniques compartiendo memoria; en su lugar, comparte memoria comunicándote". Rust implementa esto mediante canales MPSC (Multi-Producer, Single-Consumer o Múltiples Productores, Un Solo Consumidor).

El módulo std::sync::mpsc::channel devuelve una tupla con dos elementos: un transmisor (Sender) y un receptor (Receiver). Podemos clonar el transmisor para enviar mensajes desde múltiples hilos concurrentes hacia un único hilo central que procesa los resultados de manera segura y ordenada.

Ejemplo práctico utilizando un canal MPSC con múltiples productores:

```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    // Creamos el canal de comunicación
    let (tx, rx) = mpsc::channel();

    // Clonamos el transmisor para tener un segundo productor
    let tx1 = tx.clone();

    // Hilo Productor 1
    thread::spawn(move || {
        let mensajes = vec![String::from("uno"), String::from("dos")];
        for msg in mensajes {
            tx1.send(msg).unwrap(); // Envía el mensaje por el canal
            thread::sleep(Duration::from_millis(200));
        }
    });

    // Hilo Productor 2
    thread::spawn(move || {
        let mensajes = vec![String::from("tres"), String::from("cuatro")];
        for msg in mensajes {
            tx.send(msg).unwrap(); // Envía el mensaje por el canal
            thread::sleep(Duration::from_millis(200));
        }
    });

    // Hilo Consumidor (Hilo principal)
    // El iterador del 'rx' se bloquea esperando mensajes hasta que todos los 'tx' se destruyen
    for recibido in rx {
        println!("Mensaje recibido de forma segura: {}", recibido);
    }
    
    println!("Canal cerrado. Todos los datos fueron procesados.");
}
```
== 2.4. Canales de comunicación (mpsc)
¿Cómo se pasan información los hilos? Rust utiliza canales. mpsc significa Multiple Producer, Single Consumer (Múltiples productores, un solo consumidor). Imagina que es un tubo donde varios hilos pueden meter mensajes, pero solo uno los recibe al final.

```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    // Creamos un canal. 'tx' es el transmisor (envía), 'rx' es el receptor (recibe)
    let (tx, rx) = mpsc::channel();

    // Lanzamos un hilo que calculará algo y enviará el resultado
    thread::spawn(move || {
        let resultado_calculo = "Resultado ultra secreto del sensor";
        thread::sleep(Duration::from_secs(2)); // Simulamos un trabajo largo
        tx.send(resultado_calculo).unwrap(); // Enviamos el dato
    });

    println!("Esperando los datos del hilo secundario...");
    
    // El hilo principal se bloquea de forma segura hasta que llegue el mensaje
    let mensaje_recibido = rx.recv().unwrap();
    println!("Recibido con éxito: {}", mensaje_recibido);
}
```
















#pagebreak()