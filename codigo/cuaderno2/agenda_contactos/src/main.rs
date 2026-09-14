use std::io::{self, Write}; // Necesario para poder leer lo que el usuario escribe en el teclado

// --- FUNCIÓN 1: MOSTRAR TODOS LOS CONTACTOS ---
// Recibe préstamos de lectura (&) de los vectores porque solo queremos mirar los datos
fn mostrar_contactos(nombres: &Vec<String>, telefonos: &Vec<String>) {
    println!("\n=== 👥 LISTA DE CONTACTOS DE LA AGENDA ===");
    
    if nombres.is_empty() {
        println!("⚠️ La agenda está completamente vacía.");
        return;
    }

    // Recorremos las posiciones usando un índice numérico desde 0 hasta el tamaño del vector
    for i in 0..nombres.len() {
        // Accedemos de forma segura a cada posición usando [i]
        println!("{}. 👤 Nombre: {} | 📞 Teléfono: {}", i + 1, nombres[i], telefonos[i]);
    }
    println!("==========================================");
}

// --- FUNCIÓN 2: AÑADIR UN NUEVO CONTACTO ---
// ¡Ojo! Recibe préstamos MUTABLES (&mut) porque vamos a alterar los vectores originales (.push)
fn añadir_contacto(nombres: &mut Vec<String>, telefonos: &mut Vec<String>) {
    println!("\n--- 🆕 Añadir Nuevo Contacto ---");
    
    // Pedimos el nombre
    print!("Introduce el nombre: ");
    io::stdout().flush().unwrap(); // Fuerza a la terminal a mostrar el texto en pantalla inmediatamente
    let mut nombre = String::new();
    io::stdin().read_line(&mut nombre).unwrap();
    let nombre = nombre.trim().to_string(); // .trim() elimina el "Enter" invisible del teclado

    // Pedimos el teléfono
    print!("Introduce el teléfono: ");
    io::stdout().flush().unwrap();
    let mut telefono = String::new();
    io::stdin().read_line(&mut telefono).unwrap();
    let telefono = telefono.trim().to_string();

    // Guardamos los datos en sus respectivos cajones
    nombres.push(nombre);
    telefonos.push(telefono);
    
    println!("✅ ¡Contacto guardado con éxito!");
}

// --- FUNCIÓN 3: BUSCAR UN CONTACTO ---
fn buscar_contacto(nombres: &Vec<String>, telefonos: &Vec<String>) {
    println!("\n--- 🔍 Buscar por Nombre ---");
    print!("¿A quién estás buscando?: ");
    io::stdout().flush().unwrap();
    let mut busqueda = String::new();
    io::stdin().read_line(&mut busqueda).unwrap();
    let busqueda = busqueda.trim().to_string();

    let mut encontrado = false;

    // Buscamos en el vector de nombres
    for i in 0..nombres.len() {
        // Comparamos el nombre guardado con la búsqueda del usuario (sin importar mayúsculas)
        if nombres[i].to_lowercase() == busqueda.to_lowercase() {
            println!("🎉 ¡Encontrado! El teléfono de {} es: 📞 {}", nombres[i], telefonos[i]);
            encontrado = true;
            break; // Salimos del bucle porque ya lo hemos encontrado
        }
    }

    if !encontrado {
        println!("❌ Lo siento, '{}' no figura en tu lista de contactos.", busqueda);
    }
}

// --- FUNCIÓN PRINCIPAL: EL MENU INTERACTIVO ---
fn main() {
    // Creamos las bases de datos de la agenda (vacías al iniciar)
    let mut agenda_nombres: Vec<String> = Vec::new();
    let mut agenda_telefonos: Vec<String> = Vec::new();

    println!("=========================================");
    println!("  📱 ¡BIENVENIDO A TU AGENDA EN RUST!   ");
    println!("=========================================");

    // Iniciamos un bucle loop infinito. Solo terminará cuando el usuario elija salir.
    loop {
        println!("\n🎯 ¿Qué deseas hacer hoy?");
        println!("1. Ver todos los contactos");
        println!("2. Añadir un contacto");
        println!("3. Buscar un contacto");
        println!("4. 🚪 Salir de la aplicación");
        print!("👉 Selecciona una opción (1-4): ");
        io::stdout().flush().unwrap();

        // Leemos la opción del usuario por teclado
        let mut opcion = String::new();
        io::stdin().read_line(&mut opcion).unwrap();
        let opcion = opcion.trim();

        // Estructura match (como un if gigante) para decidir qué función ejecutar
        match opcion {
            "1" => mostrar_contactos(&agenda_nombres, &agenda_telefonos),
            "2" => añadir_contacto(&mut agenda_nombres, &mut agenda_telefonos),
            "3" => buscar_contacto(&agenda_nombres, &agenda_telefonos),
            "4" => {
                println!("\n👋 ¡Gracias por usar la agenda en Rust! Cerrando sistema...");
                break; // Rompe el bucle loop y el programa termina
            }
            _ => println!("⚠️ Opción no válida. Por favor, introduce un número del 1 al 4."),
        }
    }

    // Esta instrucción es solo para demostrar que como hemos pasado 
    // prestamo &agenda_nombres a la función, la variable agenda_nombres
    // sigue aún activa en el main
    // Para verlo, utiliza primero la opción 2 para añadir un contacto
    // y luegola 4 que sale del loop y cae en el main, ejecutando la 
    // instruccion de abajo.

    println!("Imprimimos desde última línea: {:?}", agenda_nombres)
}
