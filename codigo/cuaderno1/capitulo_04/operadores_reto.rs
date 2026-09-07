#![allow(warnings)] // Evitamos los avisos amarillos para concentrarnos

fn main() {
    // --- DATOS DEL JUGADOR (Puedes cambiar estos valores para hacer pruebas) ---
    let puntos_base = 40;
    let puntos_extra = 25;
    let tiene_llave = true;

    // --- 1. OPERACIÓN MATEMÁTICA ---
    // Multiplica los puntos_extra por 2 y súmaselos a los puntos_base
    let puntuacion_total = puntos_base + (puntos_extra * 2);

    // --- 2. OPERADOR DE COMPARACIÓN Y LÓGICO ---
    // Comprueba si la puntuación es mayor o igual a 80 Y ADEMÁS tiene la llave
    let puede_entrar = (puntuacion_total >= 80) && (tiene_llave == true);

    // --- 3. EL VEREDICTO DEL ORDENADOR ---
    println!("--- ESTADO DE LA MISIÓN ---");
    println!("Puntuación final conseguida: {} puntos.", puntuacion_total);
    println!("¿Tiene el objeto mágico?: {}", tiene_llave);
    println!("¿Se abre la puerta de la mazmorra?: {}", puede_entrar);
}
