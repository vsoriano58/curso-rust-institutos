fn main() {
    let mut contador = 0;

    println!("¡Iniciando el motor de repetición!");

    // La palabra 'loop' abre un bucle infinito. 
    // Todo lo que esté aquí dentro se repetirá para siempre...
    loop {
        contador = contador + 1;
        println!("Vuelta número: {}", contador);

        // ❌ Si dejamos el código así, la Playground se colgará.
        // Necesitamos una condición de salida (un freno de mano).
        if contador == 5 {
            break; // 💡 ¡La palabra 'break' rompe el bucle y nos saca de aquí!
        }
    }

    println!("¡Bucle terminado con éxito! El contador final es: {}", contador);
}