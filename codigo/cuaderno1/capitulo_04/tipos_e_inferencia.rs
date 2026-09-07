fn main() {
    // 1. Declaración Explícita (Le decimos a Rust exactamente qué tipo es)
    // i32 significa: Número Entero de 32 bits (números sin decimales)
    let edad: i32 = 14; 
    
    // &str significa: Cadena de texto (letras entre comillas)
    let nombre: &str = "Halcón68"; 

    println!("Alumno: {}, Edad: {} años", nombre, edad);

    // Intentar guardar un texto en una caja reservada para números:
    let puntos: i32 = "diez";   // ❌ <--- error, no funcionará

    // 2. La Magia de la Inferencia (Rust es listo y adivina el tipo)
    let nivel = 1;           // Rust sabe automáticamente que es un número entero (i32)
    let lenguaje = "Rust";   // Rust sabe automáticamente que es texto (&str)
    
    println!("Estudias el nivel {} de {}", nivel, lenguaje);
}