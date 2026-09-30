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