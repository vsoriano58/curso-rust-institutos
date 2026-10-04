// Simulación del módulo 'validador' que estaría en otro archivo

pub struct Registro {
    usuario: String,
    clave: String,
}

impl Registro {
    pub fn new(usuario: &str, clave: &str) -> Registro {
        Registro {
            usuario: String::from(usuario),
            clave: String::from(clave),
        }
    }

    // Analiza las reglas del sistema y devuelve un Option
    // Si hay un error, devuelve Some(Mensaje). Si todo está limpio, devuelve None.
    // Funciona con la lógica cambiada. 
    // Utiliza Some para indicar error y None cuando todo está bien
    pub fn procesar_seguridad(&self) -> Option<String> {
        if self.usuario.len() < 4 {
            return Some(String::from("El nombre de usuario debe tener al menos 4 caracteres."));
        }
        if self.clave.len() < 6 {
            return Some(String::from("La contraseña es demasiado corta e insegura (mínimo 6)."));
        }
        if self.clave == self.usuario {
            return Some(String::from("La contraseña no puede ser idéntica al nombre de usuario."));
        }
        
        // Mandamos None para indicar que no hay mensajes de error: Todo perfecto
        None 
    }
}
