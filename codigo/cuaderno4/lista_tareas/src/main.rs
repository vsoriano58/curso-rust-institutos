
use std::fs::{OpenOptions, read_to_string};
use std::io::{self, Write};

const ARCHIVO_TAREAS: &str = "tareas.txt";

fn mostrar_tareas() {
    println!("\n--- MIS TAREAS PENDIENTES ---");
    match read_to_string(ARCHIVO_TAREAS) {
        Ok(contenido) => {
            if contenido.trim().is_empty() {
                println!("No tienes tareas pendientes.");
            } else {
                println!("{}", contenido);
            }
        }
        Err(_) => println!("No se encontró archivo previo. ¡Añade tu primera tarea!"),
    }
}

fn agregar_tarea(tarea: &str) -> io::Result<()> {
    // Abrimos el archivo en modo "añadir" (append) o lo creamos si no existe
    let mut archivo = OpenOptions::new()
        .write(true)
        .append(true)
        .create(true)
        .open(ARCHIVO_TAREAS)?;
    
    writeln!(archivo, "- {}", tarea)?;
    Ok(())
}

fn main() {
    loop {
        mostrar_tareas();
        println!("\nOpciones: [1] Añadir tarea  [2] Salir");
        print!("Selecciona una opción: ");
        io::stdout().flush().unwrap();

        let mut opcion = String::new();
        io::stdin().read_line(&mut opcion).unwrap();

        match opcion.trim() {
            "1" => {
                print!("Escribe la nueva tarea: ");
                io::stdout().flush().unwrap();
                let mut nueva_tarea = String::new();
                io::stdin().read_line(&mut nueva_tarea).unwrap();
                
                if let Err(e) = agregar_tarea(nueva_tarea.trim()) {
                    println!("Error al guardar la tarea: {}", e);
                }
            }
            "2" => {
                println!("¡Hasta luego!");
                break;
            }
            _ => println!("Opción no válida."),
        }
    }
}
