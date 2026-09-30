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