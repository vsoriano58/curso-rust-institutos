// Función que recibe un préstamo del vector (solo lectura) 
// de elementos enteros de 32 bits y devuelve la media (f32)
// que es un valor decimal de 32 bits
fn calcular_media(puntuaciones: &Vec<i32>) -> f32 {
    if puntuaciones.is_empty() {
        return 0.0; // Si no hay partidas, la media es cero
    }
    
    let mut suma_total = 0;
    for puntos in puntuaciones {
        suma_total += *puntos; // Sumamos los puntos de cada partida
    }
    
    // Convertimos a f32 para poder calcular decimales en la división
    suma_total as f32 / puntuaciones.len() as f32
}

// Función que busca el récord del jugador
fn obtener_record(puntuaciones: &Vec<i32>) -> i32 {
    if puntuaciones.is_empty() {
        return 0;
    }

    // Empezamos asumiendo que la primera es la mayor
    let mut maximo = puntuaciones[0]; 

    // Si encontramos algún valor en puntuaciones que sea mayor
    // cambiaremos el valor anterior
    for puntos in puntuaciones {
        // El asterisco en *puntos es necesario para leer el valor de puntos
        // porque el vector puntuaciones es un préstamo &
        if *puntos > maximo {
            // Si encontramos una mayor, actualizamos el récord
            maximo = *puntos; 
        }
    }
    // Devolvemos el máximo encontrado
    maximo
}

fn main() {
    // Creamos la tabla de puntuaciones vacía del jugador
    let mut mis_partidas: Vec<i32> = Vec::new();

    // Simulamos que el jugador termina 3 partidas en la máquina arcade
    mis_partidas.push(2500);
    mis_partidas.push(4200);
    mis_partidas.push(1800);

    // Imprimimos el estado actual
    println!("🎮 Puntuaciones de la sesión: {:?}", mis_partidas);
    
    // Calculamos estadísticas llamando a nuestras funciones especializadas
    let media = calcular_media(&mis_partidas);
    let record = obtener_record(&mis_partidas);

    println!("📊 Estadísticas del Jugador:");
    println!("   -> Puntuación Media: {:.2} puntos", media);
    println!("   -> Récord Actual: 🔥 {} puntos", record);

    // Simulamos una última partida espectacular
    let nueva_partida = 5000;
    println!("\n🚀 ¡Nueva partida terminada! Consigues {} puntos.", nueva_partida);
    
    if nueva_partida > record {
        println!("🎉 ¡BRUTAL! Has batido tu propio récord histórico.");
    }
    
    mis_partidas.push(nueva_partida);
}