fn main() {
    // === CONFIGURACIÓN DE TU HISTORIA (¡Cambia estas palabras!) ===
    let protagonista = "Un robot con sombrero";
    let lugar = "la cocina de la abuela";
    let objeto = "una cuchara de madera";
    let accion = "bailar la macarena";
    let año = 2085; // Un número entero
    // =============================================================

    println!("📖 GENERADOR DE HISTORIAS MÁGICAS ACTIVADO 📖\n");

    // Rust se encarga de tejer la historia usando los marcadores {}
    println!("Corría el año {}, cuando ocurrió algo inaudito.", año);
    println!("El valiente {} se encontraba en medio de {}.", protagonista, lugar);
    
    println!("De repente, sacó {} de su mochila y, sin pensarlo dos veces,", objeto);
    println!("¡se puso a {} frente a todos los presentes!", accion);

    println!("\n🎭 Fin de la aventura. ¡Vuelve a cambiar las variables para otra historia!");
}