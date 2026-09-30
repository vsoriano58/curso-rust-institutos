use std::io::{prelude::*, BufReader};
use std::net::{TcpListener, TcpStream};

fn main() {
    // 1. Escuchamos en la dirección local (localhost) en el puerto 8080
    // El unwrap() aquí asume que el puerto 8080 está libre en el sistema.
    let listener = TcpListener::bind("127.0.0.1:8080").unwrap();
    println!("Servidor web iniciado en http://127.0.0.1:8080");

    // 2. Esperamos y procesamos las conexiones de los clientes
    // listener.incoming() es un iterador que devuelve un Result<TcpStream, Error> por cada intento de conexión.
    for stream in listener.incoming() {
        let stream = stream.unwrap(); // Asumimos que la conexión de red no falló al establecerse
        gestionar_conexion(stream);
    }
}

fn gestionar_conexion(mut stream: TcpStream) {
    // Creamos un lector con búfer en memoria RAM para no saturar el hardware de red
    let buf_reader = BufReader::new(&mut stream);
    
    // Leemos únicamente la primera línea de la petición (ej. "GET / HTTP/1.1")
    // El primer unwrap() abre el Option del iterador; el segundo abre el Result de la lectura técnica.
    let linea_peticion = buf_reader.lines().next().unwrap().unwrap();
    println!("Petición recibida: {}", linea_peticion);

    // Definimos la respuesta HTTP con código 200 OK y contenido HTML
    let contenido_html = r#"
        <!DOCTYPE html>
        <html lang="es">
        <head>
            <meta charset="UTF-8">
            <title>Mi Servidor en Rust</title>
            <style>
                body { font-family: sans-serif; background-color: #f4f4f9; text-align: center; padding-top: 50px; }
                h1 { color: #df4b32; }
            </style>
        </head>
        <body>
            <h1>¡Hola desde mi servidor Rust!</h1>
            <p>Este servidor ha sido programado desde cero en 2º de Bachillerato.</p>
        </body>
        </html>
    "#;

    let longitud = contenido_html.len();
    // Construimos la estructura exacta que exige el protocolo HTTP/1.1
    let respuesta = format!(
        "HTTP/1.1 200 OK\r\nContent-Length: {}\r\n\r\n{}",
        longitud, contenido_html
    );

    // Enviamos la respuesta en bytes de vuelta a la tubería del cliente
    stream.write_all(respuesta.as_bytes()).unwrap();
}