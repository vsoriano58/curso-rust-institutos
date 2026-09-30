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

== Las formas de crear hilos
Para solucionar el problema del programa bloqueante que vimos al principio, abrimos "líneas temporales paralelas" (Hilos de software). En Rust básico hay dos formas principales de gestionar esto mediante la biblioteca estándar.

- Forma A: El hilo independiente (*thread::spawn con clausura*)
 - Se corresponde con los ejemplos anteriores utilizados en la explicación de las closures.

- Forma B: Hilos con Ámbito o Concurrencia Estructurada (*thread::scope*)

=== A: El hilo independiente (*thread::spawn con clausura*)
Lanzamos un hilo y nos olvidamos de él temporalmente mientras hacemos otra cosa en el hilo principal.

💻 Copia el siguiente código y ejecútalo en la Playground

Fichero: *hilo_independiente.rs*

```rust
use std::thread;
use std::time::Duration;

fn main() {
    println!("[Hilo Principal] Iniciando el programa.");

    // FORMA A: Creamos un hilo secundario independiente
    let manejador = thread::spawn(|| {
        // ---- TODO ESTE BLOQUE SE EJECUTA EN EL HILO SECUNDARIO ----
        println!("[Hilo Secundario] ¡Hola! Estoy descargando el archivo en paralelo...");
        thread::sleep(Duration::from_secs(3));
        println!("[Hilo Secundario] Descarga finalizada en segundo plano.");
        // -----------------------------------------------------------
    });

    // ---- TODO ESTO SIGUE EJECUTÁNDOSE EN EL HILO PRINCIPAL EN PARALELO ----
    for i in 1..4 {
        println!("[Hilo Principal] Yo sigo libre. Dibujando fotograma {}...", i);
        thread::sleep(Duration::from_millis(500));
    }

    println!("[Hilo Principal] Ya no tengo más que hacer, ahora sí espero al secundario.");
    // Obligamos al hilo principal a esperar a que el secundario termine si no lo ha hecho
    manejador.join().unwrap(); 
    
    println!("[Hilo Principal] Fin del programa.");
}
```

#nota[Las instruccion *thread::sleep(Duration::from_secs(3));* produce una espera en el hilo que se ejecute de 3 segundos. En este caso en el hilo secundario.]

La ejecución del programa debe producir la siguiente salida:

```
[Hilo Principal] Iniciando el programa.
[Hilo Principal] Yo sigo libre. Dibujando fotograma 1...
[Hilo Secundario] ¡Hola! Estoy descargando el archivo en paralelo...
[Hilo Principal] Yo sigo libre. Dibujando fotograma 2...
[Hilo Principal] Yo sigo libre. Dibujando fotograma 3...
[Hilo Principal] Ya no tengo más que hacer, ahora sí espero al secundario.
[Hilo Secundario] Descarga finalizada en segundo plano.
[Hilo Principal] Fin del programa.
```

- Con *let manejador = thread::spawn(|| {...* creamos el hilo y obtenemos el * manejador* para obligar al hilo principal (main) a esperar a que termine el hilo secundario si no lo ha hecho ya.

-  La instrucción *manejador.join().unwrap();* es la que hace esperar al hilo prncipal. El *.unwrap()* desempaqueta de forma bligatoria lo que tenemos a la izquierda. En este caso lo suponemos seguro aunque bajo ciertas condiciones muy poco probables podría fallar. Evitamos el tratamiento de errores para simplificar el código. 

=== B: Hilos con Ámbito o Concurrencia Estructurada (thread::scope)
Esta forma se añadió en versiones más recientes de Rust y es maravillosa para la enseñanza. Te permite crear hilos que garantizan que terminarán antes de que acabe el bloque de código (ver listado), lo que te permite compartir variables locales del hilo principal sin usar trucos raros.

La closure toma "prestada" (mediante una referencia) la variable del main que va a utilizar. Si el hilo principal (`main`) pudiera terminar antes que el secundario, podría limpiar la memoria y destruir la variable. Si eso ocurriera, el hilo secundario intentaría leer un espacio de memoria vacío o corrupto.

💻 Copia el siguiente código y ejecútalo en la Playground

Fichero: *hilo_scope.rs*

```rust
use std::thread;
use std::time::Duration;

fn main() {
    let mut datos_compartidos = vec![1, 2, 3];

    println!("[Hilo Principal] Iniciando ámbito de hilos.");

    // FORMA B: Creamos un "ámbito" seguro
    thread::scope(|scope| {
        // Lanzamos el Hilo Secundario 1 dentro del scope
        scope.spawn(|| {
            println!("[Hilo Secundario 1] Leyendo datos: {:?}", datos_compartidos);
            thread::sleep(Duration::from_millis(200));
        });

        // Lanzamos el Hilo Secundario 2 dentro del mismo scope
        scope.spawn(|| {
            println!("[Hilo Secundario 2] Yo también puedo verlos: {:?}", datos_compartidos);
        });
        
        // ---- EL HILO PRINCIPAL TAMBIÉN PUEDE TRABAJAR AQUÍ ----
        println!("[Hilo Principal] Trabajando dentro del scope...");
    }); 
    // <--- Al llegar aquí, el 'scope' se bloquea automáticamente y ESPERA 
    // a que todos los hilos secundarios terminen. No hace falta usar .join() a mano.

    println!("[Hilo Principal] Fuera del scope. Todos los hilos han muerto con certeza.");
}
```

La salida del programa debe ser la siguiente:

```
[Hilo Principal] Iniciando ámbito de hilos.
[Hilo Principal] Trabajando dentro del scope...
[Hilo Secundario 2] Yo también puedo verlos: [1, 2, 3]
[Hilo Secundario 1] Leyendo datos: [1, 2, 3]
[Hilo Principal] Fuera del scope. Todos los hilos han muerto con certeza.
```

El hilo con scope (ámbito) se crea co la sintaxis: * thread::scope(|scope| {...*

*Observaciones*

¿Por qué se puede acceder desde dos hilos distinos a la misma variable? Porque es solo lectura y porque el scope garantiza que esos hilos no sobrevivirán a la variable *datos_compartidos* del main.

Recordemos la: 💡 Regla de oro de Rust: Puedes tener infinitas referencias de solo lectura (&T) a un dato al mismo tiempo, O puedes tener una única referencia mutable (&mut T), pero nunca ambas cosas a la vez.

En el código, cuando hacemos *println!("{:?}", datos_compartidos)* dentro de los hilos, el compilador detecta que los hilos solo necesitan leer el vector. Por lo tanto, el scope les permite hacer un préstamo de solo lectura (&datos_compartidos).

*Y si modificamos la variable, podríamos hacerlo desde los dos hilos?*

Depende. Si intentas modificarla alegremente como en otros lenguajes, el compilador de Rust detendrá el programa en seco antes de compilarlo.

Veamos los dos escenarios posibles de mutación:

*A: Un hilo intenta modificarla mientras otro la lee (ERROR)*

Si intentas hacer esto:

```rust
thread::scope(|scope| {
    // Hilo 1 intenta MODIFICAR
    scope.spawn(|| {
        datos_compartidos.push(4); // ❌ Intenta pedir un préstamo mutable (&mut)
    });

    // Hilo 2 intenta LEER
    scope.spawn(|| {
        println!("{:?}", datos_compartidos); // ❌ Intenta pedir un préstamo de lectura (&)
    });
});
```

El compilador no te dejará. Te dará un error diciendo que no puedes prestar *datos_compartidos* como mutable e immutable al mismo tiempo. ¿El motivo físico? Si el Hilo 1 añade un elemento, el vector podría necesitar reasignar su memoria RAM justo en el microsegundo en que el Hilo 2 intenta leerlo, provocando que el Hilo 2 apunte a memoria basura (un bug gravísimo).


*B: Un ÚNICO hilo la modifica dentro del scope (PERMITIDO)*

Si solo un hilo la usa y la modifica, sí se puede:

```rust
thread::scope(|scope| {
    // Un único hilo se adueña del acceso mutable
    scope.spawn(|| {
        datos_compartidos.push(4); //  ¡Permitido! Nadie más la está mirando
    });
});
```
== Compartir Datos Mutables: El Poder del Mutex

Hasta ahora hemos visto cómo `move` aísla los hilos transfiriendo la propiedad de las variables. Pero en el mundo real, a menudo necesitamos que *varios hilos accedan y modifiquen los mismos datos en paralelo*. 

Si dos hilos intentan escribir en la misma porción de memoria al mismo tiempo, se produce una *condición de carrera* (race condition), lo que corrompe los datos o rompe el programa. Rust prohíbe esto en tiempo de compilación. Para lograrlo de forma segura, necesitamos dos herramientas que trabajan en equipo: el *Mutex* y el *Arc*.

*Qué es el struct `Arc<Mutex<T>>`*

Veamos:

1. *T* es simplemente una caja genérica. Representa cualquier tipo de dato que queramos proteger (un número, un vector, una estructura).
2. *Mutex* actúa sobre esa T para ponerle el cerrojo.
3. *Arc* envuelve al Mutex entero para permitir que varios hilos sean "dueños" de esa misma caja al mismo tiempo.
4. ¡Arc podría envolver a otras cosas que no sean un Mutex!

Vamos a utilizar la siguiente analogía: *La Caja Fuerte Portátil*

Imagínate que tenemos un tesoro (nuestra T, que en el ejemplo de abajo será un simple número `contador`).

- *Mutex`<T>` (El Cerrojo)*: Metemos nuestro `contador` dentro de una caja fuerte. La caja tiene una única llave adjunta. Si un hilo quiere ver o cambiar el contador, tiene que pedir la llave (*.lock()*). Mientras ese hilo tenga la llave, nadie más puede abrir la caja.

- *Arc`<Mutex<T>>`(El Duplicador de Propiedad)*: Aquí viene el problema de Rust. Por las reglas de ownership, un objeto solo puede tener un único dueño. Si le entregamos la caja fuerte al Hilo 1, el Hilo 2 ya no puede tenerla. Para solucionar esto, metemos la caja fuerte dentro de un envoltorio *Arc* (significa Atomic Reference Counted). El Arc nos permite hacer clones exactos del contenedor. Ojo: no clona lo que hay dentro de la caja fuerte, sino que crea "mandos a distancia" o accesos compartidos a la misma caja fuerte física.

Por tanto, *`Arc<Mutex<T>`* se traduce como: Un acceso compartido (*Arc*) a una caja fuerte (Mutex) que protege a un dato genérico (*T*).

En el siguiente programa, pondremos a 3 hilos independientes a incrementar el mismo número *contador* a la vez. Verás lo honesto y robusto que es el código:

💻 Copia el siguiente código y ejecútalo en la Playground

Fichero: *hilos_mutex.rs*

```rust
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

fn main() {
    // 1. Creamos el dato original (un número 0) protegido por el Mutex y compartido por el Arc
    // T en este caso resulta ser un entero 'i32'
    let contador_compartido = Arc::new(Mutex::new(0));

    // Guardaremos los manejadores de los hilos para sincronizarlos al final
    let mut manejadores = vec![];

    println!("[Hilo Principal] Lanzando 3 hilos obreros...");

    for id_hilo in 1..=3 {
        // 2. ¡EL PASO CLAVE! Clonamos el 'Arc'. 
        // Esto NO duplica el número 0 de la memoria. Crea un "acceso numerado" nuevo
        // hacia la misma caja fuerte original.
        let contador_clon = Arc::clone(&contador_compartido);

        let manejador = thread::spawn(move || {
            // ---- CÓDIGO DENTRO DEL HILO SECUNDARIO ----
            println!("[Hilo {}] Esperando mi turno para abrir la caja...", id_hilo);
            
            // 3. Abrimos el cerrojo. Si otro hilo lo está usando, este hilo se detiene a esperar.
            // '.unwrap()' se usa por si la caja se rompe (pánico en otro hilo).
            let mut dato_interno = contador_clon.lock().unwrap();	// lock() devuelve Result
            
            // 4. Modificamos el valor con total seguridad
            *dato_interno += 1; 
            
            println!("[Hilo {}] He incrementado el contador a: {}", id_hilo, *dato_interno);
            
            // Simulamos que el hilo tarda un poco haciendo cosas con la caja abierta
            thread::sleep(Duration::from_millis(50));
            
            // 5. ¡Magia automática de Rust! 
            // Al llegar al final de la función del hilo, la variable 'dato_interno' se destruye
            // y el Mutex SE CIERRA SOLO de forma automática liberando la llave para el siguiente hilo.
        });

        manejadores.push(manejador);
    }

    // El hilo principal espera a que los 3 terminen
    for manejador in manejadores {
        manejador.join().unwrap();
    }

    // 6. El hilo principal pide la llave por última vez para ver el resultado final
    let resultado_final = contador_compartido.lock().unwrap();
    println!("[Hilo Principal] Todos terminaron. El valor final es: {}", *resultado_final);
}
```
*Aclaraciones*

En el programa hay dos tipos de unwrap() que hacen trabajos de seguridad muy específicos:

1. El unwrap() después de *.lock()*

Cuando hacemos contador_compartido.lock(), Rust no te devuelve directamente el número. Te devuelve un Result. ¿Por qué puede fallar abrir un cerrojo?

- Si el Hilo 1 abre la caja fuerte (.lock()) y mientras tiene el dinero en la mano sufre un error grave imprevisto (un pánico, por ejemplo, si dividieras por cero ahí dentro), el hilo muere de golpe.
- Al morir así, el cerrojo se queda en un estado especial llamado envenenado (poisoned).
- Si el Hilo 2 intenta hacer .lock() en una caja envenenada, Rust te avisa devolviendo un Err para decirte: "Oye, el último que entró aquí murió de forma violenta y los datos dentro de la caja podrían estar corruptos".
- Al poner .unwrap(), estás diciendo: "Si la caja está envenenada, prefiero que mi hilo también muera en ese mismo instante".

2. El unwrap() después de *.join()*
Cuando haces manejador.join(), le dices al hilo principal que espere a que el hilo secundario termine. .join() también devuelve un Result.

- Si el hilo secundario termina su trabajo felizmente, .join() devuelve Ok. El .unwrap() lo lee, ve que todo está bien y el programa continúa.
- Si el hilo secundario hubiera muerto por un pánico interno, .join() devolvería un Err. El .unwrap() capturaría ese error y haría que el hilo principal también explotara, evitando que el juego continúe con datos corruptos o hilos zombies.

*¿Por qué esta combinación es tan sincera y potente en Rust?*

Otros lenguajes también usan Mutex. La diferencia crucial aquí es la línea: `*dato_interno += 1.`

El asterisco `*` se llama operador de desreferenciación. Rust no te deja modificar la variable *contador_clon* directamente. Te obliga a pasar por el peaje del *.lock()*. Al obtener el cerrojo, te devuelve un "puntero inteligente" (MutexGuard), y solo al desreferenciarlo con `*` puedes tocar el número de verdad.

Si olvidas poner el .lock(), el compilador de Rust detendrá la compilación gritando: "¡Error! No puedes modificar un Arc directamente, necesitas abrir el Mutex primero!". Eso es Concurrencia sin miedo.

== Los Canales MPSC: pasar Mensajes en lugar de compartir Memoria
Hasta ahora hemos aprendido a coordinar hilos mediante *memoria compartida*: metemos los datos dentro de un cofre (`Mutex`) y hacemos que los hilos se peleen por el cerrojo. Aunque es un sistema robusto, puede volverse complejo y provocar atascos si muchos hilos compiten a la vez.

Existe una filosofía alternativa y sumamente elegante: *la transferencia de mensajes*. En lugar de que los hilos compartan un cofre de datos, los hilos trabajan de forma aislada y se envían los resultados a través de un *Canal*.

Para muchos programadores la utilización de canales MPSC es la forma más elegante porque evita tener que lidiar con cerrojos, llaves o *`Arc<Mutex<T>>`*.

*¿Qué significa MPSC?*

Las siglas MPSC significan Multi-Producer, Single-Consumer (Múltiples Productores, Un solo Consumidor).La analogía perfecta es un Río donde confluyen varios arroyos, o un Buzón de correos de una oficina:

- Varios hilos obreros (los "Productores") pueden escribir mensajes y lanzarlos por el canal.

- Pero solo un hilo central (el "Consumidor", que suele ser el Hilo Principal) está sentado al final del canal escuchando y procesando los mensajes que van llegando, uno a uno y en orden.

A diferencia del Mutex (donde los hilos se pelean por la misma variable), aquí los hilos secundarios simplemente envían copias de sus datos a través de una tubería hacia el hilo principal.

💻 Copia el siguiente código y ejecútalo en la Playground

Fichero: *hilos_canales.rs*

```rust
use std::sync::mpsc; // Importamos el módulo de canales
use std::thread;
use std::time::Duration;

fn main() {
    // 1. Creamos el canal. Nos devuelve una tupla con:
    // tx: El Transmisor (Transmitter) -> Para enviar datos
    // rx: El Receptor (Receiver)     -> Para recoger datos
    let (tx, rx) = mpsc::channel();

    println!("[Hilo Principal] Creando hilos obreros...");

    for id_obrero in 1..=3 {
        // 2. Como MPSC permite MÚLTIPLES productores, clonamos el transmisor 'tx' 
        // para darle una copia a cada hilo nuevo que creamos.
        let tx_clonado = tx.clone();

        thread::spawn(move || {
            // ---- CÓDIGO DENTRO DEL HILO OBRERO ----
            thread::sleep(Duration::from_millis(id_obrero * 100)); // Esperas escalonadas
            
            let mensaje = format!("Hola desde el obrero {}", id_obrero);
            
            // 3. El hilo lanza el mensaje por su copia de la tubería
            tx_clonado.send(mensaje).unwrap();
            
            // Aquí el hilo termina y muere de forma limpia.
        });
    }

    // 4. ¡TRUCO CRUCIAL DE RUST! 
    // El 'tx' original que creamos en la línea 8 sigue vivo en el hilo principal.
    // Si no lo destruimos o dejamos caer, el Receptor se quedará esperando eternamente 
    // pensando que el hilo principal aún podría enviar algo. Al soltarlo, el canal sabe 
    // que solo quedan vivos los transmisores clonados de los hilos obreros.
    drop(tx);

    println!("[Hilo Principal] Sentado a esperar mensajes en el receptor...");

    // 5. El hilo principal se queda leyendo el receptor 'rx' en un bucle.
    // Este bucle 'for' se bloquea pacientemente esperando paquetes.
    // Cuando todos los hilos obreros mueren y sus transmisiones se cierran, el bucle termina solo.
    for mensaje_recibido in rx {
        println!("[Hilo Principal] He recibido: '{}'", mensaje_recibido);
    }

    println!("[Hilo Principal] Canal cerrado. Todas las tareas terminaron.");
}
```

La salida del programa debe ser la siguiente:

```
[Hilo Principal] Creando hilos obreros...
[Hilo Principal] Sentado a esperar mensajes en el receptor...
[Hilo Principal] He recibido: 'Hola desde el obrero 1'
[Hilo Principal] He recibido: 'Hola desde el obrero 2'
[Hilo Principal] He recibido: 'Hola desde el obrero 3'
[Hilo Principal] Canal cerrado. Todas las tareas terminaron.
```
La Magia de la Propiedad en los Canales*
*
Presta mucha atención a lo que ocurre en la línea `tx_clonado.send(mensaje)`:

- En otros lenguajes, enviar un objeto por un canal puede provocar que dos hilos lean el mismo objeto a la vez, corrompiendo la memoria.

- En Rust, la función `.send()` *toma la propiedad (`ownership`)* de la variable. En cuanto el hilo secundario envía el `String`, ese hilo ya no puede volver a usarlo. El dato viaja flotando por el canal de manera 100% segura hasta que `main` lo recibe y se adueña de él. ¡No hay posibilidad de conflictos en la memoria!

*Resumen para comparar: Mutex o Canales?*

La regla de oro es la siguiente: 

- Si los hilos necesitan modificar la misma estructura a la vez (ej. una lista de usuarios conectados en un servidor de juego): Usa *`Arc<Mutex<T>>`*.

- Si los hilos solo hacen un trabajo independiente en segundo plano y te quieren mandar el resultado final cuando terminen: Usa Canales mpsc.

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