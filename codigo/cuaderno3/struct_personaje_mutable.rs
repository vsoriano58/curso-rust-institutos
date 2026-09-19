struct Personaje {
    nombre: String,
    salud: u32,
    nivel: u16,
    es_activo: bool,
}

fn main() {
    // Declaramos la instancia como mutable usando 'mut'
    let mut enemigo = Personaje {
        nombre: String::from("Orco Gruñón"),
        salud: 80,
        nivel: 2,
        es_activo: true,
    };

    println!("El {} bloquea el camino con {} de vida.", enemigo.nombre, enemigo.salud);

    // ¡El jugador ataca! Modificamos los campos internos
    enemigo.salud = 50; // El enemigo pierde 30 de salud
    enemigo.nivel = 3;  // El enemigo se enfurece y sube 1 de nivel

    println!("Tras el impacto, el {} tiene {} de vida y nivel {}.", enemigo.nombre, enemigo.salud, enemigo.nivel);
}