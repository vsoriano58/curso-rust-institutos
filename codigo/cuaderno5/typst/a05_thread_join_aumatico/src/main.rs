use std::thread;
use std::time::Duration;
use std::sync::Mutex;

fn main() {
    let datos = Mutex::new(vec![]);

    println!("Iniciando el alcance (scope)...");

    thread::scope(|s| {
        for i in 0..3 {
            // ¡ESTA ES LA CLAVE! 
            // Creamos una referencia local al Mutex. 
            // Al hacer el 'move' del hilo, el hilo se adueñará de la REFERENCIA (&), no del Mutex real.
            let datos_ref = &datos; 
            
            s.spawn(move || {
                thread::sleep(Duration::from_millis(100));
                
                // Usamos la referencia local
                let mut datos_bloqueados = datos_ref.lock().unwrap();
                datos_bloqueados.push(i);
            }); 
        }

        println!("El hilo principal hace cosas dentro del scope mientras los hilos trabajan...");
    }); // <-- Aquí se hace el join automático

    println!("El scope ha cerrado de forma segura.");

    // Ahora datos sigue estando disponible en main porque nunca fue movido, solo prestado
    let datos_finales = datos.lock().unwrap();
    println!("Datos finales procesados en paralelo: {:?}", *datos_finales);
}


/*
    ¿Por qué esto sí funciona?
    ==========================
    
    Al escribir let datos_ref = &datos;, estamos creando un puntero de lectura. Cuando la clausura ejecuta 
    el move, se adueña de datos_ref. Mover una referencia compartida (&) es completamente válido y seguro 
    en Rust, por lo que el Mutex original permanece intacto en el hilo principal esperando a que termine 
    el scope.
*/