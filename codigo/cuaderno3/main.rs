// Definimos un módulo interno llamado 'sistema_seguridad'
mod sistema_seguridad {
    // Esta estructura es PÚBLICA porque lleva 'pub'
    pub struct TarjetaAcceso {
        pub codigo: u32,
        secreto_interno: u32, // Este campo es PRIVADO (no lleva pub)
    }

    impl TarjetaAcceso {
        // Constructor público
        pub fn new(codigo: u32, secreto: u32) -> TarjetaAcceso {
            TarjetaAcceso { codigo, secreto_interno: secreto }
        }

        // Método público para validar
        pub fn verificar(&self) -> bool {
            // Un método del módulo sí puede leer sus propios campos privados
            self.secreto_interno > 1000 
        }
    }
}

fn main() {
    // Para acceder al contenido del módulo usamos la ruta con los cuatro puntos (::)
    let tarjeta = sistema_seguridad::TarjetaAcceso::new(101, 5555);

    // Esto funciona porque el campo 'codigo' es público:
    println!("Leyendo tarjeta número: {}", tarjeta.codigo);

    // ❌ ERROR DE COMPILACIÓN: Si descomentas la siguiente línea, Rust fallará:
    // println!("El secreto es: {}", tarjeta.secreto_interno); 
    
    if tarjeta.verificar() {
        println!("🔓 Acceso concedido al servidor central.");
    }
}