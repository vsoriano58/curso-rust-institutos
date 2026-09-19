enum Hechizo {
    Curacion,
    BolaFuego { daño: u32, radio: f32 },
    Teletransporte(i32, i32),
}

fn lanzar_hechizo(hechizo: Hechizo) {
    // El match inspecciona la variante exacta y extrae sus valores internos
    match hechizo {
        Hechizo::Curacion => {
            println!("💚 Destellos verdes flotan en el aire. Te has curado 20 puntos de vida.");
        }
        Hechizo::BolaFuego { daño, radio } => {
            println!("🔥 ¡BOOM! Una bola de fuego estalla haciendo {} de daño en un radio de {} metros.", daño, radio);
        }
        Hechizo::Teletransporte(x, y) => {
            println!("🌀 Te desvaneces en el espacio y apareces en las coordenadas (X: {}, Y: {}).", x, y);
        }
    }
}

fn main(){
    let hechizo = Hechizo::BolaFuego{daño: 8, radio: 20.7f32};
    lanzar_hechizo(hechizo);
}
