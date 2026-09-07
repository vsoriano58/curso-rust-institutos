fn main() {
    // Definimos una variable de ejemplo
    let puntuacion = 85;

    // 1. Un "if" en solitario (completamente válido)
    if puntuacion >= 50 {
        println!("¡Has aprobado el examen!");
    }

    // 2. Una estructura completa con "else if" y "else"
    if puntuacion >= 90 {
        println!("Excelente: Tienes una A.");
    } else if puntuacion >= 80 {
        println!("Muy bien: Tienes una B.");
    } else if puntuacion >= 70 {
        println!("Bien: Tienes una C.");
    } else {
        println!("Necesitas mejorar tu nota.");
    }
}