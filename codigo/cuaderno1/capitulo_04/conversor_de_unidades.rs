fn main() {
    // === CONFIGURACIÓN DEL USUARIO (Cambia estos valores para probar) ===
    let millas_a_convertir = 5.0; // Usa números con punto decimal (f64)
    let celsius_a_convertir = 25.0;
    // ===================================================================

    println!("⚙️  INICIANDO CONVERSOR DE UNIDADES INTERACTIVO ⚙️\n");

    // 1. Conversión de Distancia (Millas a Kilómetros)
    // Regla matemática: 1 milla = 1.60934 kilómetros
    let factor_millas = 1.60934;
    let kilometros_resultantes = millas_a_convertir * factor_millas;
    
    println!("📍 [DISTANCIA]: {} millas equivalen a {:.2} kilómetros.", 
             millas_a_convertir, kilometros_resultantes);

    // 2. Conversión de Temperatura (Celsius a Fahrenheit)
    // Regla matemática: F = (C * 9/5) + 32
    let fahrenheit_resultantes = (celsius_a_convertir * 9.0 / 5.0) + 32.0;
    
    println!("🌡️  [TEMPERATURA]: {}°C equivalen a {:.1}°F.", 
             celsius_a_convertir, fahrenheit_resultantes);

    // ❌ Error de laboratorio provocado:
    // ¿Qué pasaría si intentas sumar un número entero a uno decimal?
    // Descomenta la línea de abajo quitando las barras para ver el enfado de Rust:
    // let error_calculo = millas_a_convertir + 10; 
}