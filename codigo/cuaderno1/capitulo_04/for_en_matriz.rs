fn main() {
    // Matriz de 2 filas (alto) y 3 columnas (ancho)
    let matriz = [
        [2, 9, 32],
        [65, 90,4]
    ];

    let alto = 2;
    let ancho = 3;

    // Bucle externo para recorrer las filas (2)
    for fila in 0..alto {
        // Bucle interno para recorrer las columnas (3)
        for columna in 0..ancho {
            print!("{} ", matriz[fila][columna]);
        }
        println!(); // Salto de línea al terminar cada fila
    }
}