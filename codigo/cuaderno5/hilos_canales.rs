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