use std::io::{self, Write}; 

fn main() {
     // Pedimos al usuario que introduzca una palabra
    print!("Introduce cualquier palabra: ");

    // Fuerza a la terminal a mostrar el texto en pantalla
    io::stdout().flush().unwrap();

    // Creamos un String mutable (variable algo) vacío
    let mut algo = String::new();

    // Esperamos a que el usuario escriba una palabra
    // y teclee Return.
    // Después colocamos la palabra que haya escrito
    // en la variable 'algo'
    io::stdin().read_line(&mut algo).unwrap();

    // Limpiamos la variable 'algo' de espacios al inicio
    // y al final, y la convertimos en String.
    let algo = algo.trim().to_string();
    
    // Imprimimos lo que ha escrito el usuario
    println!("✅ Has escrito: {}", algo);
}