fn main() {
    let numeros = [2, 4, 34, 98];

    // numeros.len() es 4, así que el rango va de 0 a 3
    for i in 0..numeros.len() {
        println!("Índice: {}, Valor: {}", i, numeros[i]);
    }
}