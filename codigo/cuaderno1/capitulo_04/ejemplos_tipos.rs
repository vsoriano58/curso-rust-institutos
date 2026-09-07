#![allow(warnings)] // <-- ¡Esta línea mágica:elimina todos los avisos amarillos en este fichero!

fn main() {
    // --- 1. TIPOS ESCALARES (Un solo valor) ---

    // Enteros: Rust adivina que es i32 por defecto
    let vidas = 3; 
    // Obligamos a que sea un u8 (solo de 0 a 255), ideal para ahorrar memoria
    let nivel: u8 = 10; 

    // Flotantes: Números con decimales
    let puntuacion = 95.5; // f64 por defecto
    let gravedad: f32 = 9.81; // Forzamos precisión simple

    // Booleanos: ¡Verdadero o Falso!
    let partida_terminada = false;
    let tiene_llave = true;

    // Caracteres: ¡Ojo! Van con comillas SIMPLES ''
    let inicial = 'H';
    let mi_emoji = '🚀'; // ¡Sí, Rust acepta emojis en los caracteres!


    // --- 2. TIPOS COMPUESTOS (Varios valores juntos) ---

    // Tupla: Un combo de datos de diferentes tipos (Nombre, Puntuación, ¿Está vivo?)
    let jugador: (&str, i32, bool) = ("Halcón", 2500, true);

    // Para sacar los datos de la tupla usamos un punto y su posición (empezando desde 0)
    let nombre_jugador = jugador.0;
    let puntos_jugador = jugador.1;

    // Array: Una lista fija de elementos que TIENEN que ser del mismo tipo
    // Guardamos las puntuaciones de las últimas 4 partidas
    let historial_puntos: [i32; 4] = [120, 98, 101, 63];

    // Para sacar un dato del array usamos corchetes [] y la posición (el primero es el 0)
    let primera_partida = historial_puntos[0]; 


    // --- ¡VAMOS A MOSTRARLO EN PANTALLA! ---
    println!("¡Bienvenido al juego, {}!", nombre_jugador);
    println!("Tu inicial es la {} y tienes {} vidas.", inicial, vidas);
    println!("En tu primera partida ganaste {} puntos y ahora tienes {}.", primera_partida, puntos_jugador);
    println!("¿Estás listo para despegar? {}", mi_emoji);
}