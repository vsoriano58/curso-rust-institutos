// src/autenticacion.rs

pub struct Usuario {
    pub nombre_usuario: String,
    email: String, // Privado: controlamos su acceso
}

impl Usuario {
    pub fn new(nombre: &str, correo: &str) -> Usuario {
        Usuario {
            nombre_usuario: String::from(nombre),
            email: String::from(correo),
        }
    }

    // Método público para verificar si el correo es institucional: contiene la @ y termina en .com
    pub fn tiene_email_valido(&self) -> bool {
        self.email.contains('@') && self.email.ends_with(".com")
    }
}