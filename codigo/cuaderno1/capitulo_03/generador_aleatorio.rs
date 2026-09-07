// 1. Traemos el trait 'RngExt' para activar los métodos del generador
// Y traemos el módulo raíz 'rand' para llamar a la función .rng()
use rand::RngExt; 

fn main() {
    // 2. Le pedimos a Rust que prepare el generador de números aleatorios
    let mut generador = rand::rng();
    
    // 3. Lanzamos el dado: simulado con .random_range(1..7)
    let numero_dado = generador.random_range(1..7);
    
    println!("🎲 Has lanzado el dado y ha salido un: {}", numero_dado);
}