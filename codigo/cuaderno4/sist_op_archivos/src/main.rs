use std::fs;

fn main() {
    let contenido = fs::read_to_string("config.txt");

    match contenido {
        Ok(datos) => println!("Contenido del archivo:\n{}", datos),
        Err(e) => println!("Error al leer el archivo: {}", e),
    }
}
