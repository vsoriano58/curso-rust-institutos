mod validador;

// Ahora no utilizamos `use`, por cambiar
// use validador::Registro 
// Nos obliga a utilizar rutas completas: validador::Registro::new("H68", "123")


fn main() {
    println!("--- FORMULARIO DE INSCRIPCIÓN ---");

    // Caso de prueba 1: Intento de registro erróneo
    let intento_uno = validador::Registro::new("H68", "123");
    
    // Evaluamos el resultado usando el control de flujo match sobre el Option
    match intento_uno.procesar_seguridad() {
        Option::Some(error) => println!("❌ Registro denegado: {}", error),
        Option::None => println!("🎉 ¡Cuenta creada con éxito!"),
    }

    // Caso de prueba 2: Intento de registro correcto
    let intento_dos = validador::Registro::new("FalconRustaceo", "ClaveSegura2026");
    
    match intento_dos.procesar_seguridad() {
        Option::Some(error) => println!("❌ Registro denegado: {}", error),
        Option::None => println!("🎉 ¡Cuenta creada con éxito! El sistema está listo."),
    }
}