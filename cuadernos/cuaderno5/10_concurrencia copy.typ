#import "config.typ": *

= Concurrencia
Como hemos indicado antes, la concurrencia se consigue creando y gestionando hilos del sistema operativo.

Ya hemos comentado las ventajas que ofrece Rust en cuanto a la concurrencia pero, seamos honestos, si programas en Rust de forma síncrona y bloqueante, el programa se va a congelar exactamente igual que en C++, Java o Python. A continuación mostramos un ejemplo de programa bloqueante:

💻 Copia el siguiente código y ejecútalo en la Playground

Fichero: *descarga_fichero_bloqueante.rs*

```rust
use std::thread;
use std::time::Duration;

fn descargar_archivo_pesado() {
    println!("[Hilo Principal] Iniciando descarga de 3 segundos...");
    // Esto congela el hilo actual por completo simulando una espera de red o disco
    thread::sleep(Duration::from_secs(3)); 
    println!("[Hilo Principal] ¡Descarga completada!");
}

fn main() {
    println!("[Hilo Principal] El usuario hace clic en el botón.");
    
    // Al llamar a la función, el programa se DETIENE aquí durante 3 segundos.
    descargar_archivo_pesado();
    
    // Esta línea no se ejecutará hasta que la descarga termine.
    // Durante 3 segundos, la interfaz o el juego habrían estado "congelados".
    println!("[Hilo Principal] El usuario ya puede mover el ratón y ver animaciones.");
}
```
La instrucción `thread::sleep(Duration::from_secs(3));` impone un tiempo de espera de 3 segundos al hilo actual, el hilo main, y la función `descargar_archivo_pesado()` simula el tiempo invertido en la descarga de un archivo desde la red o el disco.

Si ejecutas el programa comprobarás que tarda tres segundos en imprimir el mensaje final. Durante esos tres segundos no se han procesado instrucciones del programa. El hilo principal ha estado parado o dormido. El programa no pudo atender al ratón ni al teclado en caso de que lo hubiera necesitado..

Con la concurrencia se puede conseguir que durante esos tres segundos que tarda el hilo principal en descargar el archivo, el procesador esté realizando otra tarea en otro hilo.

En este apartado veremos cómo hacerlo.

== El Motor de la Concurrencia: Las Clausuras (Closures)

Antes de ordenar al Sistema Operativo que cree un hilo, debemos entender cómo Rust empaqueta el código que se va a ejecutar en paralelo. Para ello, el lenguaje utiliza una herramienta fundamental llamada *clausura* o *closure*.

*¿Qué es una Closure con palabras sencillas?*
Una closure es una función anónima (sin nombre) que podemos guardar en una variable, pasar como argumento a otras funciones y que, a diferencia de las funciones normales (`fn`), posee la capacidad de "capturar" y recordar las variables que están escritas en su entorno físico inmediato.

Veamos su evolución progresiva a través de tres ejemplos sencillos:

*1. Con parámetros (Como una función):*
Los parámetros de la closure se colocan entre barras verticales `||`. El compilador deduce los tipos automáticamente.

```rust
let sumar = |x, y| x + y;
let resultado = sumar(5, 3); // 8
```

*2. Capturando el entorno (Lectura):*
La closure "atrapa" una variable externa (curso) sin necesidad de recibirla por parámetro.

```rust
let curso = "Rust";
let info = || println!("Curso: {}", curso); // Curso: Rust
info();
```

*3. Modificando el entorno (Paso previo a los hilos):*
Si la closure quiere modificar lo que hay fuera, debemos marcarla como mutable (`mut`).

```rust
let mut cuenta = 0;
let mut incrementar = || {
    cuenta += 1;
    println!("Cuenta: {}", cuenta);
};
incrementar(); // Cuenta: 1
```

#nota("Si intentáramos replicar los ejemplos 2 y 3 usando funciones tradicionales con 'fn', el compilador arrojará un error inmediato. Las funciones normales no tienen memoria de su entorno; las closures sí.")

== El problema de los hilos y la solución con `move`
Los hilos se crean usando `thread::spawn` y enviándole una closure.

Cuando intentamos enviar una closure a otro hilo usando `thread::spawn`, el compilador de Rust interviene para protegernos de un peligro crítico de memoria:

```rust
use std::thread;

fn main() {
    let saludo = String::from("¡Hola desde el hilo!");
    
    // ❌ --- error: El hilo podría vivir más tiempo que la variable 'saludo'
    thread::spawn(|| {
        println!("{}", saludo); 
    }); 
}
```

*¿Por qué falla?* 
Por defecto, la closure intenta tomar "prestada" (mediante una referencia) la variable `saludo`. Sin embargo, como el hilo secundario se ejecuta en paralelo de forma independiente, el hilo principal (`main`) podría terminar antes de tiempo, limpiar la memoria y destruir la variable. Si eso ocurriera, el hilo secundario intentaría leer un espacio de memoria vacío o corrupto.

*El trabajo de la palabra clave `move`*
Para solucionar este dilema, anteponemos la palabra clave `move` antes de las barras de la closure. 

```rust
// SOLUCIÓN COMPILADA CON ÉXITO
let handle = thread::spawn(move || {
    println!("{}", saludo); // La variable ahora vive aquí dentro
});
```

Al añadir `move`, el compilador altera drásticamente el comportamiento de la memoria:
1. *Transferencia de propiedad (Ownership):* La closure deja de pedir prestado. Corta los lazos con el hilo principal y se adueña físicamente de la variable `saludo`, mudándola al espacio de memoria del nuevo hilo.
2. *Aislamiento seguro:* Como la variable ahora le pertenece por completo al hilo secundario, da igual si `main` termina antes o después; los datos están a salvo del borrado accidental.
3. *Restricción en el origen:* Como consecuencia de la mudanza, el hilo principal pierde todos los derechos sobre la variable. Intentar usar `saludo` en `main` después de un `move` causará un error de compilación.

#align(center)[
  #block(fill: rgb("f0f9ff"), inset: 10pt, radius: 4pt, stroke: 0.5pt + rgb("bae6fd"))[
    *En una sola frase:* El trabajo de `move` es transformar una closure que *toma prestados* datos del entorno en una closure que *se adueña* de ellos, logrando que el nuevo hilo sea 100% autónomo y seguro.
  ]
]

== Compartir Datos Mutables: El Poder del Mutex

Hasta ahora hemos visto cómo `move` aísla los hilos transfiriendo la propiedad de las variables. Pero en el mundo real, a menudo necesitamos que *varios hilos accedan y modifiquen los mismos datos en paralelo*. 

Si dos hilos intentan escribir en la misma porción de memoria al mismo tiempo, se produce una *condición de carrera* (race condition), lo que corrompe los datos o rompe el programa. Rust prohíbe esto en tiempo de compilación. Para lograrlo de forma segura, necesitamos dos herramientas que trabajan en equipo: el *Mutex* y el *Arc*.

=== ¿Qué es un Mutex?
La palabra *Mutex* viene de *Mutual Exclusion* (Exclusión Mutua). Imagínalo como *un cerrojo o un peaje de seguridad* que envolvemos alrededor de nuestros datos. 

- Un hilo no puede tocar los datos directamente. Primero debe pedir el cerrojo llamando a `.lock()`.
- Si el Mutex está libre, el hilo entra, modifica los datos y nadie más puede pasar.
- Si otro hilo intenta entrar mientras el Mutex está ocupado, se queda congelado en la puerta esperando su turno. En cuanto el primer hilo termina, el cerrojo se libera automáticamente y pasa el siguiente operario de la fila.

=== El problema del Ownership en hilos: ¿Por qué necesitamos Arc?
Si intentamos pasar un `Mutex` a secas a varios hilos usando un bucle, nos toparemos con un viejo conocido:

```rust
// ESTO NO COMPILA
let datos = Mutex::new(vec![]);
for i in 0..3 {
    thread::spawn(move || {
        let mut lista = datos.lock().unwrap(); // ERROR: 'datos' ya fue movido en la primera vuelta
        lista.push(i);
    });
}
```
*Explicación para el alumno:* El primer hilo hace un `move` del `Mutex` y se adueña de él. En la segunda vuelta del bucle, el hilo principal ya no tiene el `Mutex` para dárselo al segundo hilo. ¡Necesitamos una forma de que *varios hilos sean dueños del mismo Mutex a la vez*!

La solución es *`Arc`* (*Atomically Reference Counted* / Conteo de Referencias Atómico). Un `Arc` es un envoltorio inteligente (un puntero clonable) que cuenta cuántos hilos están apuntando al mismo dato en la memoria RAM. Cuando clonas un `Arc`, no duplicas los datos; solo creas un nuevo "mando a distancia" que apunta al mismo `Mutex` original.

=== Código Final: Concurrencia Real en Paralelo

Este es el patrón estándar en Rust para compartir datos mutables entre múltiples hilos del Sistema Operativo:

```rust
use std::thread;
use std::sync::{Arc, Mutex};
use std::time::Duration;

fn main() {
    // 1. Envolvemos el vector en un Mutex (seguridad) y luego en un Arc (propiedad compartida)
    let datos = Arc::new(Mutex::new(vec![]));
    let mut hilos = vec![];

    for i in 0..3 {
        // 2. Clonamos el "mando a distancia" (Arc) para este hilo específico
        let datos_hilo = Arc::clone(&datos);
        
        let handle = thread::spawn(move || {
            // Simulamos un trabajo pesado
            thread::sleep(Duration::from_millis(100)); 
            
            // 3. Bloqueamos el Mutex para modificar el vector de forma segura
            let mut lista_bloqueada = datos_hilo.lock().unwrap();
            lista_bloqueada.push(i); 
            // El Mutex se abre AUTOMÁTICAMENTE aquí al salir del bloque del hilo
        });
        
        // Guardamos el handle sin hacer join() todavía para que corran EN PARALELO
        hilos.push(handle);
    }

    // 4. El hilo principal espera a que TODOS los hilos paralelos terminen su trabajo
    for handle in hilos {
        handle.join().unwrap();
    }

    // 5. Imprimimos el resultado final
    let resultado = datos.lock().unwrap();
    println!("Datos finales procesados en paralelo: {:?}", *resultado);
}
```

#nota("El orden en el que los hilos consiguen el cerrojo del Mutex es completamente impredecible y depende del Sistema Operativo. Si ejecutas el programa varias veces, verás que el vector final puede terminar como `[0, 1, 2]`, `[1, 0, 2]`, `[2, 1, 0]`, etc. ¡Eso es la verdadera concurrencia en acción!")

#align(center)[
  #block(fill: rgb("fef2f2"), inset: 10pt, radius: 4pt, stroke: 0.5pt + rgb("fecaca"))[
    *Regla de Oro en Rust:* Para compartir datos mutables entre hilos, grábate a fuego esta combinación: *`Arc::new(Mutex::new(datos))`*. El `Arc` permite que todos los hilos tengan acceso al cofre, y el `Mutex` garantiza que solo un hilo a la vez pueda abrirlo y modificar su contenido.
  ]
]

== Hilos con Alcance (Scoped Threads): Concurrencia sin Arc

En el apartado anterior aprendimos que para compartir datos mutables entre hilos necesitábamos emparejar un `Mutex` con un `Arc`. El `Arc` era obligatorio porque `thread::spawn` crea hilos "independientes" que el compilador teme que sobrevivan a la función `main`.

Sin embargo, a partir de Rust 1.63, existe una alternativa mucho más elegante y eficiente cuando los hilos solo necesitan realizar tareas temporales: los *Scoped Threads* (Hilos con Alcance).

=== ¿Cómo funcionan?
Mediante la función `thread::scope`, creamos un bloque o "entorno seguro". La clave de este entorno es la llave de cierre `}` del bloque: actúa como una *barrera automática e infranqueable*. El hilo principal se congelará en esa llave y esperará a que todos los hilos creados dentro terminen, haciendo el `join()` de forma automática e implícita.

Gracias a que el compilador garantiza que ningún hilo escapará vivo de ese bloque, se produce la magia: *ya no necesitamos clonar punteros `Arc`*. Los hilos secundarios pueden acceder a las variables de `main` usando referencias locales normales (`&`).

=== El Código: Paralelismo Limpio

Mira cómo se simplifica el ejemplo de los 3 hilos paralelos si usamos `thread::scope`. Nota que seguimos usando `Mutex` porque los hilos modifican el vector a la vez, pero el `Arc` ha desaparecido por completo:

```rust
use std::thread;
use std::time::Duration;
use std::sync::Mutex;

fn main() {
    // Un Mutex normal y corriente, sin Arc
    let datos = Mutex::new(vec![]);

    println!("Iniciando el alcance (scope)...");

    // 1. Creamos el entorno seguro. 's' representa nuestro gestor del scope
    thread::scope(|s| {
        for i in 0..3 {
            // 2. Creamos una referencia local al Mutex
            let datos_ref = &datos; 
            
            // 3. Lanzamos el hilo usando 's.spawn' en lugar de 'thread::spawn'
            s.spawn(move || {
                thread::sleep(Duration::from_millis(100));
                
                let mut lista_bloqueada = datos_ref.lock().unwrap();
                lista_bloqueada.push(i);
            }); 
        }
        println!("El hilo principal hace tareas dentro del scope...");
    }); 
    // <--- ¡BARRERA AUTOMÁTICA AQUÍ! 
    // El hilo principal espera aquí a que los 3 hilos terminen. No necesitas llamar a join() manualmente.

    println!("El scope ha cerrado de forma segura.");

    // 4. Accedemos al resultado final directamente
    let resultado = datos.lock().unwrap();
    println!("Datos finales procesados: {:?}", *resultado);
}
```

=== ¿Por qué es necesario el `let datos_ref = &datos;` y el `move`?
Este es un sutil detalle de protección de Rust que suele causar tropiezos:
- Necesitamos el `move` para que cada hilo *tome posesión de su propio número `i`* del bucle. Sin `move`, el hilo intentaría tomar prestado un `i` que cambia en cada vuelta.
- Pero al poner `move`, la closure intentaría secuestrar el `Mutex` completo (`datos`), impidiendo que la siguiente vuelta del bucle lo use.
- Al crear `let datos_ref = &datos;` justo antes, el `move` solo se lleva una *copia de la referencia (el puntero)*, dejando el `Mutex` original intacto en el hilo principal.

#align(center)[
  #block(fill: rgb("f0fdf4"), inset: 10pt, radius: 4pt, stroke: 0.5pt + rgb("bbf7d0"))[
    *Ventajas de los Scoped Threads:* \
    1. *Código más limpio:* Evitas el ruido visual de escribir `Arc::clone` y múltiples `join()`. \
    2. *Mayor rendimiento:* Al usar referencias normales (`&`), la CPU no pierde tiempo actualizando contadores atómicos en la memoria RAM. \
    3. *Seguridad garantizada:* Es imposible olvidarse de esperar a un hilo; el propio lenguaje te obliga a hacerlo al cerrar el bloque.
  ]
]

== Canales de Comunicación (Channels): Pasar Mensajes en lugar de Compartir Memoria

Hasta ahora hemos aprendido a coordinar hilos mediante *memoria compartida*: metemos los datos dentro de un cofre (`Mutex`) y hacemos que los hilos se peleen por el cerrojo. Aunque es un sistema robusto, puede volverse complejo y provocar atascos si muchos hilos compiten a la vez.

Existe una filosofía alternativa y sumamente elegante: *la transferencia de mensajes*. En lugar de que los hilos compartan una carretilla de datos, los hilos trabajan de forma aislada y se envían los resultados a través de un *Canal*.

=== El Canal MPSC (Múltiples Productores, Un Consumidor)
La librería estándar de Rust proporciona el canal *MPSC* (*Multiple Producer, Single Consumer*). Imagínalo como un tubo neumático unidireccional:
- Puedes clonar el extremo de envío (*Transmitter* o `tx`) para que *muchos hilos* metan mensajes por el tubo.
- Sin embargo, solo existe un único extremo de recogida (*Receiver* o `rx`). *Un solo hilo* (normalmente el hilo principal `main`) se encarga de recibir y procesar los mensajes.

=== El Código: Enviar Mensajes desde Múltiples Hilos

Veamos cómo tres hilos independientes realizan un cálculo (en este caso, generar un texto) y le envían el resultado al hilo principal sin usar un solo `Mutex`:

```rust
use std::thread;
use std::sync::mpsc; // Importamos el módulo de canales
use std::time::Duration;

fn main() {
    // 1. Creamos el canal. Rust nos devuelve el Transmisor (tx) y el Receptor (rx)
    let (tx, rx) = mpsc::channel();

    // 2. Lanzamos 3 hilos en un bucle
    for i in 0..3 {
        // Clonamos el transmisor para que cada hilo tenga su propio "tubo" de envío
        let tx_hilo = tx.clone();
        
        thread::spawn(move || {
            thread::sleep(Duration::from_millis(100));
            
            let mensaje = format!("Resultado del hilo número {}", i);
            
            // 3. Enviamos el mensaje por el canal. 
            // El 'move' le transfiere la propiedad del String al canal de forma segura.
            tx_hilo.send(mensaje).unwrap();
        });
    }

    // 4. ¡TRUCO CRÍTICO! Debemos soltar el transmisor original de main.
    // Si no lo destruimos, el receptor 'rx' se quedará esperando eternamente 
    // pensando que 'main' aún podría enviar algo.
    drop(tx);

    // 5. El hilo principal se queda escuchando el canal.
    // El bucle 'for' leerá los mensajes a medida que vayan llegando 
    // y terminará automáticamente cuando todos los transmisores mueran.
    for mensaje_recibido in rx {
        println!("[Main] He recibido: {}", mensaje_recibido);
    }
    
    println!("Canal cerrado de forma segura y programa terminado.");
}
```

=== La Magia de la Propiedad en los Canales
Presta mucha atención a lo que ocurre en la línea `tx_hilo.send(mensaje)`:
- En otros lenguajes, enviar un objeto por un canal puede provocar que dos hilos lean el mismo objeto a la vez, corrompiendo la memoria.
- En Rust, la función `.send()` *toma la propiedad (`ownership`)* de la variable. En cuanto el hilo secundario envía el `String`, ese hilo ya no puede volver a usarlo. El dato viaja flotando por el canal de manera 100% segura hasta que `main` lo recibe y se adueña de él. ¡No hay posibilidad de conflictos en la memoria!

#align(center)[
  #block(fill: rgb("faf5ff"), inset: 10pt, radius: 4pt, stroke: 0.5pt + rgb("e9d5ff"))[
    *¿Cuándo usar Canales en lugar de Mutex?* \
    Usa *Mutex* cuando tengas una estructura de datos central (como una base de datos en caché) que muchos hilos necesiten modificar constantemente en el sitio. \
    Usa *Canales* cuando tengas hilos que actúan como "generadores de datos" o "trabajadores" independientes que solo necesitan escupir sus resultados finales hacia un hilo central.
  ]
]

#pagebreak()