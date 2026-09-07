fn main() {
    // Genera un número aleatorio entre 1 y 6 directamente (el 7 no se incluye)
    let numero_dado = rand::random_range(1..7);
    
    println!("🎲 Has lanzado el dado y ha salido un: {}", numero_dado);
}