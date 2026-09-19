// Definimos la estructura de un Videojuego individual
struct Videojuego {
    titulo: String,
    precio: f64,
    stock: u32,
}

impl Videojuego {
    // Constructor de un juego
    fn new(titulo: &str, precio: f64, stock: u32) -> Videojuego {
        Videojuego {
            titulo: String::from(titulo),
            precio,
            stock,
        }
    }
}

// Definimos la estructura de la Tienda, que albergará una lista de videojuegos
struct Tienda {
    nombre: String,
    inventario: Vec<Videojuego>, // Usamos un vector dinámico de estructuras
}

impl Tienda {
    // Constructor de la tienda
    fn new(nombre: &str) -> Tienda {
        Tienda {
            nombre: String::from(nombre),
            inventario: Vec::new(), // Empezamos con el inventario vacío
        }
    }

    // Método para añadir un videojuego al inventario
    fn agregar_juego(&mut self, juego: Videojuego) {
        println!("📦 Añadiendo al almacén: {}", juego.titulo);
        self.inventario.push(juego);
    }

    // Método de lectura para listar todos los productos en stock
    fn mostrar_inventario(&self) {
        println!("\n--- 🛒 INVENTARIO DE: {} ---", self.nombre.to_uppercase());
        for juego in &self.inventario {
            println!("• {} | Precio: {:.2}€ | Unidades: {}", juego.titulo, juego.precio, juego.stock);
        }
        println!("--------------------------------------\n");
    }

    // Método mutable para simular una venta
    fn vender_juego(&mut self, titulo_juego: &str) {
        let mut encontrado = false;

        for juego in &mut self.inventario {
            if juego.titulo == titulo_juego {
                encontrado = true;
                if juego.stock > 0 {
                    juego.stock -= 1;
                    println!("✅ ¡Venta realizada con éxito! Disfruta de: {}", juego.titulo);
                } else {
                    println!("❌ Lo sentimos, no queda stock de: {}", juego.titulo);
                }
                break; // Salimos del bucle al encontrar el juego
            }
        }

        if !encontrado {
            println!("🔍 El juego '{}' no se encuentra en nuestro catálogo.", titulo_juego);
        }
    }
}

fn main() {
    // 1. Inauguramos nuestra tienda
    let mut mi_tienda = Tienda::new("Pixel & Bits");

    // 2. Creamos y añadimos stock de productos
    let juego1 = Videojuego::new("Rust: Survival Evolved", 39.99, 3);
    let juego2 = Videojuego::new("Cyberpunk 2077", 59.99, 1);
    
    mi_tienda.agregar_juego(juego1);
    mi_tienda.agregar_juego(juego2);

    // 3. Mostramos el estado inicial
    mi_tienda.mostrar_inventario();

    // 4. Simulamos compras por parte de los clientes
    mi_tienda.vender_juego("Cyberpunk 2077"); // Quedará con stock 0
    mi_tienda.vender_juego("Cyberpunk 2077"); // Debería dar error de falta de stock
    mi_tienda.vender_juego("Minecraft");      // No existe en la tienda

    // 5. Comprobamos cómo ha quedado el inventario final
    mi_tienda.mostrar_inventario();
}