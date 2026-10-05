use std::time::Duration;
use tokio::time::sleep;

// 1. Definimos una función asíncrona usando 'async'
async fn descargar_archivo(id: u32) -> String {
    println!("Iniciando descarga del archivo {}...", id);
    
    // Simulamos una espera de red de 2 segundos sin bloquear el hilo principal
    sleep(Duration::from_secs(2)).await; 
    
    format!("Contenido del archivo {}", id)
}

// 2. La función principal también debe ser asíncrona y gestionada por un runtime
#[tokio::main]
async fn main() {
    println!("Iniciando el gestor de descargas.");

    // Creamos dos futuros (no se ejecutan todavía)
    let descarga1 = descargar_archivo(1);
    let descarga2 = descargar_archivo(2);

    // Con tokio::join! ejecutamos ambos futuros en paralelo de forma asíncrona
    // El programa tardará ~2 segundos en total, no 4.
    let (resultado1, resultado2) = tokio::join!(descarga1, descarga2);

    println!("Resultado 1: {}", resultado1);
    println!("Resultado 2: {}", resultado2);
    println!("¡Todas las descargas finalizadas!");
}
