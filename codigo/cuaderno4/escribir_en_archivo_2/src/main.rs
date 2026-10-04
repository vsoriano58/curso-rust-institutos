use std::fs::File;
use std::io::Write;

fn guardar_registro(mensaje: &str) -> std::io::Result<()> {
    let mut archivo = File::create("registro.log")?;
    archivo.write_all(mensaje.as_bytes())?;
    Ok(())
}
fn main() {
    if let Err(e) = guardar_registro("LOG: El sistema se inició correctamente.") {
        println!("No se pudo escribir en el disco: {}", e);
    } else {
        println!("Datos guardados exitosamente.");
    }
}
