use std::fs::File;
use std::io::Write;

fn main() {
    let mensaje = "LOG: El sistema se inició correctamente.";

    // 1. Intentamos crear/abrir el archivo
    match File::create("registro.log") {
        Ok(mut archivo) => {
            // 2. Si el archivo se creó con éxito, intentamos escribir los bytes
            match archivo.write_all(mensaje.as_bytes()) {
                Ok(_) => {
                    // Si todo salió bien
                    println!("Datos guardados exitosamente.");
                }
                Err(e) => {
                    // Si falló la escritura
                    println!("No se pudo escribir en el disco: {}", e);
                }
            }
        }
        Err(e) => {
            // Si falló la creación del archivo
            println!("No se pudo crear el archivo 'registro.log': {}", e);
        }
    }
}