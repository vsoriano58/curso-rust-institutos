use std::thread;

fn main() {
    let mut datos = vec![1, 2, 3];

    // Creamos un alcance (scope) que garantiza que los hilos terminan dentro del bloque
    thread::scope(|scope| {
        scope.spawn(|| {
            // El compilador sabe que este hilo morirá antes de salir del scope
            // Nota: Aquí se requiere acceso exclusivo, por lo que el push de abajo
            // tendría que ir fuera o gestionarse de otra manera si es simultáneo.
            println!("Leyendo desde el hilo: {:?}", datos);
        });
    });
    
    datos.push(5); // Completamente seguro aquí fuera
    println!("Datos finales: {:?}", datos);
}
