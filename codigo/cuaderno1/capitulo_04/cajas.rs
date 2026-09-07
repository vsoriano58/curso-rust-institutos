fn main() {
    // En Rust, cuando creamos una variable (una caja) es como cerrarla con un candado.
    let puntuacion = 10;
    println!("Tu puntuación inicial es: {}", puntuacion);

    // Intentamos cambiar el valor de la caja cerrada:
    puntuacion = 20; // ❌ <--- error, no funcionará

    // El ordenador no te dejará ejecutar el programa porque por defecto las variables 
    // son "inmutables" (no se pueden cambiar) por defecto para evitar accidentes.
}