fn main() {
    // Empezamos con la batería al 100%
    let mut bateria = 100;

    println!("📱 Teléfono encendido. Batería al {}%", bateria);

    // MIENTRAS la batería sea mayor que cero, el teléfono sigue funcionando:
    while bateria > 0 {
        // En cada vuelta del bucle, el teléfono gasta un 25% de energía
        bateria = bateria - 25;
        
        println!("Usa una aplicación... Batería restante: {}%", bateria);
    }

    // ❌ Error oculto en tu cuaderno:
    // ¿Qué pasaría si dentro del bucle olvidamos restar energía?
    // (Ejemplo: // bateria = bateria - 25;)

    println!("🪫 ¡Batería agotada! El teléfono se ha apagado.");
}