/*
    Para evitar tener que acordarte de usar join() al final, ¿te gustaría ver cómo la Opción 2 que 
    te mostré al principio (los Scoped Threads con thread::scope) hace este join() de forma automática
    y obligatoria al cerrar el bloque?

    Si, vamos a verlo.
*/

/*
    Los hilos con alcance o Scoped Threads (introducidos en la librería estándar de Rust a partir 
    de la versión 1.63) son una maravilla precisamente por eso: eliminan la necesidad de escribir 
    join() manualmente y garantizan que ningún hilo quede abandonado.Aquí tienes el mismo ejemplo 
    de los 3 hilos paralelos, pero reescrito con thread::scope. Fíjate en lo limpio que queda: 
*/


use std::thread;
use std::time::Duration;
use std::sync::Mutex;

fn main() {
    // ¡Buenas noticias! Ya no necesitamos Arc ni Mutex si solo queremos leer,
    // pero como queremos MODIFICAR el vector desde los hilos de forma segura,
    // usamos un Mutex normal (sin Arc).

    let datos = Mutex::new(vec![]);

    println!("Iniciando el alcance (scope)...");

    // Creamos el entorno seguro con thread::scope
    thread::scope(|s| {
        // Lanzamos 3 hilos en paralelo usando 's.spawn' en lugar de 'thread::spawn'
        for i in 0..3 {
            // Pasamos una referencia normal gracias a que Rust garantiza que el hilo no vivirá más que main
            s.spawn(move || {
                thread::sleep(Duration::from_millis(100));
                
                let mut datos_bloqueados = datos.lock().unwrap();
                datos_bloqueados.push(i);
            }); // <-- ¡No guardamos handles ni llamamos a join()!
        }

        println!("El hilo principal hace cosas dentro del scope mientras los hilos trabajan...");
    }); 
    // <--- ¡BARRERA AUTOMÁTICA AQUÍ! 
    // Al llegar a la llave de cierre del scope, el hilo principal SE CONGELA automáticamente
    // y espera a que TODOS los hilos creados dentro (s.spawn) terminen.

    println!("El scope ha cerrado de forma segura.");

    // Ahora podemos acceder a los datos directamente sin peligro de que los hilos sigan vivos
    let datos_finales = datos.lock().unwrap();
    println!("Datos finales procesados en paralelo: {:?}", *datos_finales);
}
