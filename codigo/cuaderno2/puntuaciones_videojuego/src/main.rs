// Función que recibe un préstamo & del vector 'puntuaciones' 
// (de solo lectura) y devuelve la media (f32)
fn calcular_media(puntuaciones: &Vec<i32>) -> f32 {
    if puntuaciones.is_empty() {

        // Si no hay partidas, la media es cero.
        // La función devuelve 0.0 y termina con el return
        return 0.0; 
    }
    
    let mut suma_total = 0;
    for puntos in puntuaciones {

        // Sumamos los puntos de cada partida a suma_total
        // ¡Ojo con el * de puntos!
        suma_total += *puntos; 
    }
    
    // Convertimos numerador y denominador a f32 
    // para poder calcular decimales en la división
    suma_total as f32 / puntuaciones.len() as f32
}

// Función que busca el récord del jugador
fn obtener_record(puntuaciones: &Vec<i32>) -> i32 {
    if puntuaciones.is_empty() {
        return 0;
    }

    // Empezamos asumiendo que la primera puntuación es la mayor
    // Si no es así luego la iremos cambiando
    let mut maximo = puntuaciones[0]; 

    // Si encontramos algún valor en puntuaciones que sea mayor
    // cambiaremos el valor anterior
    // Recorremos todas las puntuaciones
    for puntos in puntuaciones {
        // El asterisco en *puntos es necesario para leer el valor de puntos
        // porque el vector puntuaciones es un préstamo & (igual que en la
        // función anterior)
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
    // Vec::new() es un vector que no tiene elementos todavía
    let mut mis_partidas: Vec<i32> = Vec::new();

    // Simulamos que el jugador termina 3 partidas en la máquina arcade.
    // La instrucción:  mis_partidas.push(2500); introduce elvalor 2500
    // en el vector mis_partidas. 
    // Las siguientes instrucciones .push(valor) añaden elementos al vector.
    mis_partidas.push(2500);
    mis_partidas.push(4200);
    mis_partidas.push(1800);

    // Imprimimos el estado actual
    println!("🎮 Puntuaciones de la sesión: {:?}", mis_partidas);
    
    // Calculamos estadísticas llamando a nuestras funciones especializadas

    // Ejecutamos la función calcular_media y le pasamos como argumento
    // &mis_partidas, es decir, un préstamo del vector mis_partidas. Por tanto
    // la función calculará y devolverá la media de los valores que hemos
    // introducido antes en mis_partidas.
    // Lo que devuele la función se coloca en la variable media
    let media = calcular_media(&mis_partidas); 

    // La función obtener_record
    // calcula y devuelve el record de las puntuaciones 
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

    // Imprimimos el estado actual
    println!("🎮 Puntuaciones de la sesión: {:?}", mis_partidas);
}