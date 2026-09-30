=  Asincronia: async / await en Rust

A diferencia de JavaScript o `C#`, donde la asincronía viene integrada con un motor interno y recolección de basura, en Rust la asincronía es de coste cero (Zero-Cost Abstraction) y no incluye un planificador por defecto.

Un hilo asíncrono se carateriza porque puede ser pausado y reanudado co una penalización muy baja para el sistema.

El funcionamiento se basa en tres pilares: El Trait Future, Las Máquinas de Estados (async) y El Ejecutor (Runtime).

== ¿Qué es un Trait?
Un Trait (que significa *rasgo o característica* en inglés) es simplemente una lista de tareas o habilidades que un tipo de datos promete saber hacer. En otros lenguajes de programación se le conoce como una Interfaz.

Decimos que un tipo de datos implementa un trait cuando posee todas las habilidades que componen el trait. El trait se implementa mediante código.

Veamos un ejemplo muy sencillo. Definimos el trait *Hablador* con un solo método, *hacer_sonido(&self)*. Los traits pueden contener cualquier número de métodos. Cuando se definen los métodos en el trait solo se pone su cabecera. Los tipos que implementen el trait tienen que dar código a esos metodos cuya cabecera heredan del trait.

En el ejemplo, los struct *Perro* y *Pato* implementan (con la sentencia *impl*) el trait *Hablador* y dan código cada uno por su cuenta al método *hacer_sonido*. Podemos ver en el main como se instancian los objetos *perro* y *pato* y llaman a su própio método *hacer_sonido()*.

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

// Estructura del objeto perro
struct Perro {
    nombre: String,
}

// Estructura del objeto pato
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

Gracias a este mecanismo, podemos crear funciones que no necesitan saber si tratan con un perro o con un pato; solo necesitan saber que el objeto que reciben cumple con el contrato de *Hablador*.

De la misma forma, el *Trait Future* del que hablaremos después es simplemente un contrato que dice: "No me importa qué tipo de tarea asíncrona seas (red, disco, base de datos), si firmas este contrato, te obligas a ti mismo a tener una función llamada *poll* para que pueda preguntarte si ya has terminado".

==  A. El Trait Future (El modelo de "Tirar" o Poll)
En la mayoría de lenguajes, cuando lanzas una función asíncrona, esta empieza a ejecutarse inmediatamente en segundo plano (modelo Push). En Rust no.

Una función async devuelve un objeto que implementa el *trait Future*. Un Future es una estructura perezosa (lazy): no hace absolutamente nada hasta que alguien se lo pide. Su diseño simplificado es el siguiente:

```rust
pub trait Future {
    type Output;
    // El runtime llama a 'poll' para ver si el valor ya está listo
    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output>;
}
```
El Runtime llama al método poll(). Este responde *Poll::Pending* (si sigue esperando el archivo o la red) o *Poll::Ready(valor)* (si ya terminó).

== B. Qué hace async por dentro: La Máquina de Estados
Cuando marcas una función o bloque con la palabra clave *async*, el compilador de Rust transforma mágicamente tu código secuencial en una estructura de datos que actúa como una máquina de estados.

Cada vez que pones un *.await*, el compilador genera un punto de interrupción en esa máquina de estados.

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
Cuando la ejecución topa con un *.await*, el estado de la función se guarda en memoria (en el stack de la tarea, no del hilo) y la función retorna el control inmediatamente.

== C. El Rol del Runtime (Ej. Tokio o el de Macroquad)
Dado que la biblioteca estándar de Rust no incluye un planificador asíncrono para mantener los binarios lo más pequeños posibles, necesitas un Runtime externo (como Tokio para servidores o el interno de Macroquad para juegos).

- El Runtime mantiene una cola de Futures.
- Llama a poll() en el Future.
- Si el Future devuelve Poll::Pending, el Runtime lo registra en el sistema operativo (usando herramientas eficientes como epoll en Linux o IOCP en Windows) para que el hardware le avise cuando haya actividad en la tarjeta de red o el disco.
- Mientras tanto, ese hilo del Runtime pasa a procesar otro Future de la cola.
- Cuando el S.O. avisa que los datos llegaron, el Runtime despierta al Future correspondiente mediante un componente llamado Waker y vuelve a llamar a poll(), avanzando al siguiente estado. 

== Observaciones
*¿Por qué llamamos a Macroquad Runtime interno?*

Llamamos a *Macroquad* "runtime interno" porque el propio motor del juego incluye e implementa su propio *planificador asíncrono* dentro de su código base, sin obligarte a depender de herramientas externas como *Tokio* o *async-std*.

En el siguiente apartado utilizaremos Macroquad para programar un juego.

En Rust, la biblioteca estándar provee la sintaxis (async, await) y el trait base (Future), pero no incluye el motor que hace rodar esos futuros. Alguien tiene que encargarse de llamar a poll() y gestionar la cola de tareas.

Macroquad necesita controlar de forma milimétrica el tiempo y los fotogramas del juego. Por ello, en lugar de usar un runtime de propósito general (como Tokio, que está diseñado para servidores web y bases de datos), implementa su propio *bucle de control asíncrono* optimizado para gráficos:

+ Gestión del bucle gráfico: El macro-bucle de Macroquad toma tu función *`async fn main()`* y ejecuta su código frame a frame.

+ Control del .await: Cuando tu código llega a *next_frame().await*, el planificador interno de Macroquad sabe exactamente que debe pausar tu función main, cederle el control a la tarjeta gráfica para que dibuje la pantalla y, justo en el siguiente fotograma, volver a despertar tu función para continuar con la lógica.

En resumen, se le llama "interno" porque viene dentro de la propia caja de Macroquad, permitiendo que los juegos en Rust funcionen de forma asíncrona con una configuración cero para el programador.


#pagebreak()

