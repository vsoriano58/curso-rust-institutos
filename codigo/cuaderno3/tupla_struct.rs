// Una estructura de tupla para almacenar coordenadas en 3D (X, Y, Z)
// Los campos no tienen nombre (se sobreentienden)
struct Posicion3D(f32, f32, f32);

// Una estructura unitaria para marcar un estado o evento
// Veremos más adelante como utilizarla
struct FinDelJuego;

fn main() {
  // Instanciamos la Tuple Struct
  let origen = Posicion3D(0.0, 15.2, -3.4);
  
  // Para acceder a sus campos, usamos índices numéricos como en las tuplas normales
  println!("El jugador está en la altura Y: {}", origen.1);
}