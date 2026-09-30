use std::net::{TcpListener, TcpStream};
use std::process; // Herramienta para cerrar el programa limpiamente

fn main() {
    // 1. Intentamos adueñarnos del puerto usando un 'match' asignado a una variable
    let listener = match TcpListener::bind("127.0.0.1:8080") {
        // Si la caja trae éxito, extraemos el TcpListener real, 
        // lo llamamos "servidor" un instante y lo "lanzamos" hacia la variable 'listener'
        Ok(servidor) => servidor, 
        
        // Si la caja trae un fallo del sistema operativo, entramos aquí
        Err(e) => {
            println!("❌ Error crítico: No se pudo iniciar el servidor.");
            println!("Detalle del sistema operativo: {}", e);
            println!("💡 Consejo: Comprueba si dejaste el servidor encendido en otra terminal.");
            
            // Como el programa no puede funcionar sin puerto, cerramos aquí mismo.
            // Al llamar a exit(), el código de abajo nunca se ejecuta.
            process::exit(1); 
        }
    }; // <-- El punto y coma cierra la instrucción 'let listener = match ...;'

    // Si el programa llegó a esta línea, es porque el match fue exitoso y
    // la variable 'listener' contiene nuestro servidor listo para funcionar.
    println!("Servidor escuchando de forma segura en http://127.0.0.1:8080");

    for stream in listener.incoming() {
        match stream {
            Ok(mut stream) => {
                // Usamos 'if let' para gestionar el resultado de la conexión
                if let Err(e) = manejar_conexion(&mut stream) {
                    println!("Error al procesar la petición: {}", e);
                }
            }
            Err(e) => {
                println!("Error al recibir una conexión: {}", e);
            }
        }
    }
}

// Función que procesa la petición de forma segura
fn manejar_conexion(stream: &mut TcpStream) -> Result<(), std::io::Error> {
    // Simulamos la variable para evitar problemas de acentos con la URL
    let usuario_simulado = Some("Halcón68");

    println!("--- Nueva conexión recibida ---");

    // Aplicamos 'if let' para verificar si el usuario simulado existe
    if let Some(variable) = usuario_simulado {
        println!("¡Variable procesada en el servidor! Valor: {}", variable);

        match variable {
            "admin" => {
                responder_html(stream, "<h1>Modo Administrador Activo</h1>")?;
            }
            _ => {
                let respuesta = format!("<h1>Hola {}, bienvenido a la V2</h1>", variable);
                responder_html(stream, &respuesta)?;
            }
        }
    } else {
        responder_html(stream, "<h1>Servidor Rust V2 (Sin usuario)</h1>")?;
    }

    Ok(())
}

// Función auxiliar que envía la respuesta HTTP
fn responder_html(stream: &mut TcpStream, cuerpo: &str) -> Result<(), std::io::Error> {
    use std::io::Write; // Importación local y segura del trait de escritura
    
    let respuesta = format!(
        "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: {}\r\n\r\n{}",
        cuerpo.len(),
        cuerpo
    );
    
    stream.write_all(respuesta.as_bytes())
}