// Ejemplo sencillo de Option
fn buscar_usuario(id: u32) -> Option<String> {
    if id == 10 {
        Some(String::from("Alicia"))
    } else {
        None
    }
}

fn main() {
    let usuario_id = 10;
    
    match buscar_usuario(usuario_id) {
        Some(nombre) => println!("Usuario encontrado: {}", nombre),
        None => println!("Error: El usuario no existe en la base de datos."),
    }
}