fn main() {

    // El dueño del dato es comic_original
    let comic_original = String::from("Spiderman: Año Uno");
    
    // El dato SE MUEVE de dueño
    // El dueño del dato es ahora "otro_comic"
    let comic_prestado = comic_original; 

    // Aquí la variable comic_original ya no existe
    
    //  ⬇️  ❌ --- ERROR COMPILADOR: Intentas leer algo que ya no existe
    // println!("Voy a releer mi cómic: {}", comic_original); 
    
    println!("Mi amigo está leyendo: {}", comic_prestado); // Esto sí funciona
}
