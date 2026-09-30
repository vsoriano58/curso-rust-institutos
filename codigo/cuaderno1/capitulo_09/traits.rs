/* 
    --- Este es el contrato ---
    Cualquier tipo (de dato) que sea un "Hablador" 
    debe saber hacer_sonido
*/

// Definimos el trait Hablador
trait Hablador {
    fn hacer_sonido(&self);
}

// Estructura del objeto perro
struct Perro {
    nombre: String,
}

// Estructura del objeto pato
struct Pato {
    nombre: String,
}

// El Perro firma el contrato "Hablador"
impl Hablador for Perro {
    fn hacer_sonido(&self) {
        println!("¡Guau! Soy el perro {}", self.nombre);
    }
}

// El Pato firma el contrato "Hablador"
impl Hablador for Pato {
    fn hacer_sonido(&self) {
        println!("¡Cuaic! Soy el pato {}", self.nombre);
    }
}

fn main() {
    let perro = Perro {
        nombre: String::from("Jerry"),
    };
    
    let pato = Pato {
        nombre: String::from("Lucas"),
    };

    perro.hacer_sonido();
    pato.hacer_sonido();
}