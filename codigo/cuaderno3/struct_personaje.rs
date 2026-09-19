// Definimos el plano de lo que es un "Personaje" en nuestro código
struct Personaje {
    nombre: String,
    salud: u32,
    nivel: u16,
    es_activo: bool,
}

fn main() {
    // Instanciamos (creamos) el personaje basándonos en el plano
    let héroe = Personaje {
        nombre: String::from("Aragorn"),
        salud: 100,
        nivel: 1,
        es_activo: true,
    };

    // Accedemos a sus datos individuales usando el punto
    println!("¡Bienvenido al mundo, {}!", héroe.nombre);
    println!("Tu salud inicial es de {} puntos y eres nivel {}.", héroe.salud, héroe.nivel);
}