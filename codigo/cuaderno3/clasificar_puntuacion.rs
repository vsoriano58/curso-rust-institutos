fn clasificar_puntuacion(puntos: u32) {
    match puntos {
        0 => println!("🥉 ¿Es tu primera vez jugando? Ánimo."),
        1..=10 => println!("🥈 ¡Vas mejorando! Medalla de plata."),
        11..=50 => println!("🥇 ¡Increíble! Eres un profesional."),
        _ => println!("🏆 ¡Récord legendario superado!"), // Captura cualquier número mayor que 50
    }
}

fn main(){
    clasificar_puntuacion(0);
    clasificar_puntuacion(5);
    clasificar_puntuacion(25);
    clasificar_puntuacion(100);
    
}