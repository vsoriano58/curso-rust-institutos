use std::env;
use std::fs;

fn main() {
    // Captura los argumentos de la línea de comandos
    // (ej: cargo run -- limpiar archivo.txt)
    let argumentos: Vec<String> = env::args().collect();

    // Imprimimos el vector argumentos para ver lo que contiene
    println!("{:?}", argumentos);

    if argumentos.len() < 3 {
        println!("Uso incorrecto del programa.");
        println!("Ejemplo: cargo run -- <accion> <nombre_archivo>");
        println!("Acciones disponibles: eliminar, crear");
        return;
    }

    let accion = &argumentos[1];
    let nombre_archivo = &argumentos[2];

    match accion.as_str() {
        "crear" => {
            match fs::File::create(nombre_archivo) {
                Ok(_) => println!("Automatización: Archivo '{}' creado con éxito.", nombre_archivo),
                Err(e) => println!("Error al crear el archivo: {}", e),
            }
        }
        "eliminar" => {
            match fs::remove_file(nombre_archivo) {
                Ok(_) => println!("Automatización: Archivo '{}' eliminado de forma segura.", nombre_archivo),
                Err(e) => println!("Error al eliminar el archivo: {}", e),
            }
        }
        _ => println!("Acción desconocida. Prueba con 'crear' o 'eliminar'."),
    }
}

