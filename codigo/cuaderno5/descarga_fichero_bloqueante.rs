use std::thread;
use std::time::Duration;

fn descargar_archivo_pesado() {
    println!("[Hilo Principal] Iniciando descarga de 3 segundos...");
    // Esto congela el hilo actual por completo simulando una espera de red o disco
    thread::sleep(Duration::from_secs(3)); 
    println!("[Hilo Principal] ¡Descarga completada!");
}

fn main() {
    println!("[Hilo Principal] El usuario hace clic en el botón.");
    
    // Al llamar a la función, el programa se DETIENE aquí durante 3 segundos.
    descargar_archivo_pesado();
    
    // Esta línea no se ejecutará hasta que la descarga termine.
    // Durante 3 segundos, la interfaz o el juego habrían estado "congelados".
    println!("[Hilo Principal] El usuario ya puede mover el ratón y ver animaciones.");
}