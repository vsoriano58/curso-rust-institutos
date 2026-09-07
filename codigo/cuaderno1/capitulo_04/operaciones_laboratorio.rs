fn main() {
    // Datos fijos del juego (no necesitan cambiar, van sin 'mut')
    let nombre_jugador = "Halcón68";
    let puntos_por_enemigo = 150;

    // Datos dinámicos del juego (van a cambiar, necesitan 'mut')
    let mut puntuacion_total = 0;
    let mut nivel_actual = 1;

    println!("--- ESTADÍSTICAS DE {} ---", nombre_jugador);
    println!("Nivel: {} | Puntos: {}", nivel_actual, puntuacion_total);

    // El jugador derrota a un enemigo: aumentamos la puntuación
    puntuacion_total = puntuacion_total + points_por_enemigo; // ❌ <--- error, no funcionará
    // (Nota: ¡Ojo con el inglés! La variable se llama 'puntos_por_enemigo')

    // Corrección del error (sustituye la línea erronea de arriba por esta):
    // puntuacion_total = puntuacion_total + puntos_por_enemigo;
    nivel_actual = 2;

    println!("--- ¡ENEMIGO DERROTADO! ---");
    println!("Nivel: {} | Puntos Totales: {}", nivel_actual, puntuacion_total);
}