use std::thread;

fn main() {
    // let mut static datos = vec![1, 2, 3];

    // Intentamos crear un hilo que acceda a 'datos' de forma insegura
    // El compilador arrojará un error porque no puede garantizar la validez de la referencia
    
    thread::spawn(|| {
        datos.push(4); 
    });
    
    datos.push(5); // Error: Uso de un valor mutabilidad compartida entre hilos

    println!("El compilador de Rust nos protege antes de ejecutar el programa.");
}

/*
    El programa no compila
    ======================

    En Rust, el compilador no puede garantizar cuánto tiempo vivirá el hilo creado con thread::spawn. 
    Por lo tanto, exige que cualquier variable que entre al hilo se mueva completamente (usando la palabra 
    clave move) o que tenga una vida útil válida durante todo el programa ('static) (si es mutable no se puede).

    El error exacto del compilador
    ==============================
    Si intentas compilarlo, verás un error similar a este:
    - Closure may outlive the current function: El hilo podría seguir ejecutándose después de que main termine.
    - Borrow of moved value: Si añades move, el error pasará a la línea de datos.push(5) porque ya no eres dueño 
      de la variable en el hilo principal.

    Cómo solucionarlo?
    ==================
    Dependiendo de lo que busques hacer, tienes dos soluciones principales:

    - Opción 1: Si necesitas que ambos hilos modifiquen los datos a la vez

        Para compartir datos mutables entre hilos de forma segura, debes envolver el vector en un puntero con conteo 
        de referencias atómico (Arc) y protegerlo con un cerrojo de exclusión mutua (Mutex).
            
            Programa: thread_codigo_seguro_mutex
            ====================================

    - Opción 2: Opción 2: Usar hilos con alcance (Scoped Threads)
    
        Si solo necesitas que el hilo trabaje temporalmente con los datos y garantizas que terminará antes de que 
        main continúe, puedes usar thread::scope (disponible desde Rust 1.63). Esto evita tener que usar Arc o Mutex.
           
            Programa: thread_codigo_seguro_scope
            ====================================

*/