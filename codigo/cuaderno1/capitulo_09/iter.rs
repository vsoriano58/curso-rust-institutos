fn main() {
    let nombres = vec![String::from("Halcón"), String::from("Rust")];

    // .iter() devuelve referencias (&String)
    let mut iterador = nombres.iter();

    if let Some(nombre_ref) = iterador.next() {
        // nombre_ref es un &String. No podemos moverlo, solo leerlo.
        println!("Encontrado: {}", nombre_ref);
    }
    
    if let Some(nombre_ref) = iterador.next() {
        // nombre_ref es un &String. No podemos moverlo, solo leerlo.
        println!("Encontrado: {}", nombre_ref);
    }
    
    // La lista 'nombres' sigue perfectamente accesible aquí.
    println!("Lista completa: {:?}", nombres);
}