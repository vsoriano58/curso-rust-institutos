// src/main.rs

// 1. Le decimos a Rust que busque y cargue el archivo 'autenticacion.rs'
mod autenticacion; 

// Opcional: usamos 'use' para crear un atajo y no escribir la ruta completa cada vez
use autenticacion::Usuario;

fn main() {
    println!("=== 🛡️ SISTEMA DE ALTA DE USUARIOS ===");

    // 2. Instanciamos el objeto usando el módulo externo
    let nuevo_perfil = Usuario::new("Halcón_Retro", "halcon68@correo.com");

    // 3. Ejecutamos la lógica aislada
    if nuevo_perfil.tiene_email_valido() {
        println!("✅ Registro completado. Bienvenido, {}.", nuevo_perfil.nombre_usuario);
    } else {
        println!("❌ Error: El correo electrónico no cumple con los requisitos.");
    }
}
