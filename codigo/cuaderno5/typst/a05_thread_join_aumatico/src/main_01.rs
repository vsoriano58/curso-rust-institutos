use std::thread;
use std::time::Duration;
use std::sync::Mutex;

fn main() {
    let datos = Mutex::new(vec![]);

    println!("Iniciando el alcance (scope)...");

    thread::scope(|s| {
        for i in 0..3 {
            // ¡Añadimos 'move' aquí! Esto copia 'i' dentro de cada hilo de forma segura
            s.spawn(move || {
                thread::sleep(Duration::from_millis(100));
                
                let mut datos_bloqueados = datos.lock().unwrap();
                datos_bloqueados.push(i);
            }); 
        }

        println!("El hilo principal hace cosas dentro del scope mientras los hilos trabajan...");
    }); // <-- Aquí se hace el join automático de todos los hilos que "movieron" su 'i'

    println!("El scope ha cerrado de forma segura.");

    let datos_finales = datos.lock().unwrap();
    println!("Datos finales procesados en paralelo: {:?}", *datos_finales);
}


/*
    No compila
    ===========

    ¿Por qué ocurre este nuevo error?
    =================================
    Cuando pusimos move ||, le dijimos al hilo: "Toma posesión de todo lo que uses aquí dentro".
    1. El primer hilo entra al bucle (i = 0), ve que usas datos y se adueña por completo del Mutex. 
       Lo saca de main y se lo queda él.
    2. Cuando el bucle intenta dar la segunda vuelta (i = 1), el segundo hilo intenta hacer lo mismo, 
       pero datos ya no existe en main. ¡El primer hilo se lo robó! De ahí el error: value moved into 
       closure here, in previous iteration of loop.
    
    La Solución Definitiva: Crear una referencia explícita
    ======================================================
    Para solucionar esto, necesitamos que el hilo haga un move de i (porque necesitamos su valor propio), 
    pero solo capture una referencia de datos.

    La forma limpia y correcta de hacer esto en Rust es crear una referencia local justo antes de entrar 
    al hilo. Así, el move solo se llevará la referencia (que sí se puede copiar) y no el Mutex completo.

    La solución buena estará en main.rs. main_00.rs y main_01.rs (el actual) dieron problemas.


*/