use std::thread;
use std::sync::{Arc, Mutex};

fn main() {
    // Envolvemos el vector en un Arc y un Mutex
    let datos = Arc::new(Mutex::new(vec![1, 2, 3]));

    // Clonamos el Arc para el nuevo hilo
    let datos_hilo = Arc::clone(&datos);
    
    let handle = thread::spawn(move || {
        // Bloqueamos el Mutex para poder modificar los datos de forma segura
        let mut datos_bloqueados = datos_hilo.lock().unwrap();
        datos_bloqueados.push(4); 
    });
    
    // Esperamos a que el hilo termine para evitar condiciones de carrera
    // Esto es lo que motiva todas las aclariones
    // ==========================================
    handle.join().unwrap();

    // El hilo principal bloquea y modifica
    let mut datos_principales = datos.lock().unwrap();
    datos_principales.push(5); 

    println!("Datos finales: {:?}", *datos_principales);
}

/*
    1. ¿Para qué sirve el Mutex si ya usamos join() y todo parece secuencial?
    =========================================================================
    En el ejemplo anterior, el Mutex parece "inútil" porque obligamos al hilo principal a esperar. 
    Sin embargo, el Mutex es el que convence al compilador de Rust de que el código es seguro.

    Rust tiene una regla de oro: puedes tener muchas referencias de lectura, o una sola referencia de 
    escritura (mutable), pero nunca ambas a la vez.
    - El compilador no sabe en qué milisegundo exacto se va a ejecutar el hilo secundario ni cuándo se 
      ejecutará el principal.
    - Aunque tú como programador sepas que pusiste un join(), el compilador necesita una estructura que 
      garantice en tiempo de ejecución que dos hilos no van a escribir en la memoria al mismo tiempo. 
      El Mutex proporciona esa garantía de exclusión mutua.
*/

/*
    2. ¿El programa se vuelve secuencial?
    =====================================
    En ese ejemplo específico, sí. Si creas un hilo y de inmediato lo esperas con join(), has destruido 
    el beneficio de la concurrencia. El hilo principal se queda congelado esperando al secundario.

    El mundo real: Concurrencia verdadera con Mutex
    Para que el Mutex y los hilos tengan sentido, el hilo principal debe seguir haciendo otras tareas mientras 
    el hilo secundario trabaja, o bien debes lanzar múltiples hilos a la vez compitiendo por el Mutex.

    Mira este ejemplo donde sí hay concurrencia real. Vamos a lanzar 3 hilos en paralelo para que añadan números 
    al mismo vector al mismo tiempo:

    Proyecto: thread_codigo_mutex_real
    ==================================

*/

