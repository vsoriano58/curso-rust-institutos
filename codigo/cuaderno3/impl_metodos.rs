// 1. El contenedor de datos (El plano)
struct NaveEspacial {
    nombre: String,
    escudo: u32,
    municion: u32,
}

impl NaveEspacial {
  // Método de LECTURA (&self): No modifica nada, solo muestra información
  fn reportar_estado(&self) {
      println!("🛰️ [{}] Escudo al {}% | Munición: {} torpedos.", self.nombre, self.escudo, self.municion);
  }

  // Método de MODIFICACIÓN (&mut self): Altera las variables internas
  fn recibir_disparo(&mut self, daño: u32) {
      if daño >= self.escudo {
          self.escudo = 0;
          println!("💥 ¡AVISO! El escudo de la nave {} se ha destruido.", self.nombre);
      } else {
          self.escudo -= daño;
          println!("💥 ¡Impacto! El escudo absorbió el daño.");
      }
  }
}

fn main() {
  // Es obligatorio usar 'mut' para poder llamar a métodos que usen &mut self
  let mut mi_caza = NaveEspacial {
      nombre: String::from("Halcón Milenario"),
      escudo: 100,
      municion: 10,
  };

  mi_caza.reportar_estado(); // Llama al método de lectura
  mi_caza.recibir_disparo(40); // Llama al método de modificación
  mi_caza.reportar_estado(); // Volvemos a leer para comprobar los cambios
}