use axum::{routing::get, Router};
use std::net::SocketAddr;
use std::time::Duration; // Para pausar el tiempo

#[tokio::main]
async fn main() {
    // 1. Definimos la ruta de nuestra web
    let app = Router::new().route("/", get(leer_sensor));

    // 2. Configuramos la dirección de red
    let direccion = SocketAddr::from(([0, 0, 0, 0], 3000));
    println!("--- Servidor del Sensor Activo ---");
    println!("Pruébalo en este ordenador abriendo: http://localhost:3000");

    // [NUEVO] Lanzamos la tarea cíclica de fondo (conteo 1 al 10)
    // Tokio se encarga de ejecutar esto de manera asíncrona en paralelo
    tokio::spawn(async {
        let mut contador = 1;
        loop {
            println!("Contador cíclico: {}", contador);
            contador += 1;
            if contador > 10 {
                contador = 1;
            }
            // Pausa asíncrona de 1 segundo sin bloquear el hilo
            tokio::time::sleep(Duration::from_secs(1)).await;
        }
    });

    // 3. Encendemos el servidor y lo dejamos escuchando
    // Nota: Esta línea bloquea el final de main, si no, el programa se cerraría
    let listener = tokio::net::TcpListener::bind(direccion).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

// Función asíncrona que simula leer un sensor
async fn leer_sensor() -> String {
    // Simulamos que el sensor tarda 2 segundos en responder
    tokio::time::sleep(Duration::from_secs(2)).await;
    
    let temperatura = 24.5; // Un valor simulado
    format!("Temperatura actual del sensor: {} °C", temperatura)
}