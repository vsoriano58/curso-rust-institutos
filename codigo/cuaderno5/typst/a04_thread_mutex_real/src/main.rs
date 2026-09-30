use std::thread;
use std::sync::{Arc, Mutex};
use std::time::Duration;

fn main() {
    let datos = Arc::new(Mutex::new(vec![]));
    let mut hilos = vec![];

    // Lanzamos 3 hilos que van a correr EN PARALELO
    for i in 0..3 {
        let datos_hilo = Arc::clone(&datos);
        let handle = thread::spawn(move || {
            // Simulamos que el hilo hace un trabajo pesado antes de modificar los datos
            thread::sleep(Duration::from_millis(100));

            println!("Imprime el hilo: {i}"); 
            
            let mut datos_bloqueados = datos_hilo.lock().unwrap();
            datos_bloqueados.push(i);
            // El Mutex se libera automáticamente aquí al salir del bloque del hilo
        });
        
        // Guardamos el handle, pero NO hacemos join todavía.
        // Así los 3 hilos corren al mismo tiempo.
        hilos.push(handle);
    }

    // ¡Aquí el hilo principal podría hacer otra tarea pesada al mismo tiempo!
    println!("El hilo principal sigue ejecutando cosas mientras los otros 3 trabajan...");

    // Ahora que todos los hilos están corriendo en paralelo, los esperamos a todos juntos
    for handle in hilos {
        handle.join().unwrap();
    }

    // Al final, vemos el resultado de la ejecución paralela
    let datos_finales = datos.lock().unwrap();
    println!("Datos finales procesados en paralelo: {:?}", *datos_finales);
}


/*
    ¿Qué pasó aquí?
    ===============
    1. Verdadera Concurrencia: Los 3 hilos se ejecutaron a la vez. No sabemos cuál terminó primero 
       (el vector final podría quedar como [0, 1, 2], [1, 0, 2], etc.).

    2. El rol del Mutex: Como los 3 hilos terminan casi al mismo tiempo, intentan escribir en el vector 
       a la vez. El Mutex actúa como un "peaje". Si el Hilo 1 llega primero, bloquea el vector, añade 
       su número y lo libera. Mientras tanto, el Hilo 2 y 3 esperan pacientemente en la fila su turno 
       para escribir. Evita que el programa se rompa o corrompa la memoria.
    
    3. El rol del join(): Se movió al final del programa. Ya no vuelve el código secuencial; solo le dice 
    al hilo principal: "No cierres el programa de golpe, espera a que los 3 hilos paralelos terminen su trabajo".
*/

/*
    Si eliminamos:

    for handle in hilos {
        handle.join().unwrap();
    }

    El programa llega inmediatamente a su última línea e imprime:
    Datos finales procesados en paralelo: []

    Los hilos no han empezado siquiera a parpadear y han muerto con el hilo primcipal del programa.

    ===============

    En Rust (y en la mayoría de los lenguajes), cuando el hilo principal (main) termina, el proceso 
    completo muere inmediatamente.
    A los hilos secundarios no se les da la oportunidad de terminar, de limpiar su memoria, ni de "parpadear", 
    como bien dices. El sistema operativo destruye todo el proceso de golpe.
*/

/*
    ¿Por qué imprimió []?
    =====================
    1. El hilo principal lanza los hilos (lo cual es una operación rapidísima).
    2. Sin el join(), el hilo principal pasa directamente a la siguiente línea: 
       let datos_finales = datos.lock().unwrap();.
    3. Consigue el cerrojo del Mutex de inmediato 
    4. porque los hilos secundarios aún están durmiendo su sleep de 100 milisegundos.
       Imprime el vector (que todavía está vacío []).
    5. Llegamos al final de la función main(). El programa se cierra y los hilos secundarios 
       son aniquilados antes de que despierten.
*/

/*
    El verdadero propósito de join() en la concurrencia real
    ========================================================
    Con esto que acabas de descubrir, ya podemos definir exactamente para qué sirve cada herramienta 
    sin que el programa se vuelva secuencial:

    - El Mutex sirve para la seguridad en el acceso: Garantiza que si dos hilos coinciden en el mismo 
      microsegundo queriendo modificar el vector, no corrompan la memoria. Uno pasará primero y el otro 
      esperará.

    - El join() sirve para la sincronización del ciclo de vida: No se usa para frenar el programa 
      a mitad de camino, sino para poner una "barrera" al final. Le dice al hilo principal: "Sé que 
      ya terminaste tus tareas principales, pero por favor, quédate vivo un momento y espera a que tus 
      ayudantes terminen antes de apagar las luces de la fábrica".
*/

/*
    Para evitar tener que acordarte de usar join() al final, ¿te gustaría ver cómo la Opción 2 que 
    te mostré al principio (los Scoped Threads con thread::scope) hace este join() de forma automática
    y obligatoria al cerrar el bloque?

    Sí, vamos a verlo.

    Proyecto: a05_thread_join_aumatico
*/