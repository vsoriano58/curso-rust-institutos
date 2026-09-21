// Importamos 'OpenOptions' para configurar de forma avanzada cómo abrimos los archivos.
// Importamos 'read_to_string' como un atajo rápido para volcar un archivo entero en memoria.
use std::fs::{OpenOptions, read_to_string};

// Importamos el módulo 'io' para usar estructuras comunes como 'Result', 'stdin' y 'stdout'.
// Importamos explícitamente el trait 'Write' para habilitar métodos de escritura (como flushing).
use std::io::{self, Write};

// Definimos una constante global estática para el nombre del archivo.
// Al centralizarlo aquí, evitamos errores tipográficos si decidimos cambiar el nombre en el futuro.
const ARCHIVO_TAREAS: &str = "tareas.txt";

/// Función encargada de leer el archivo de texto y volcar su contenido en la pantalla.
fn mostrar_tareas() {
    println!("\n--- MIS TAREAS PENDIENTES ---");
    
    // Intentamos leer todo el archivo como un único String de golpe.
    match read_to_string(ARCHIVO_TAREAS) {
        // Caso de éxito: El archivo existe y se pudo leer correctamente.
        Ok(contenido) => {
            // .trim() elimina espacios en blanco y saltos de línea al inicio y al final.
            // .is_empty() verifica si, tras la limpieza, el archivo carece de texto.
            if contenido.trim().is_empty() {
                println!("No tienes tareas pendientes.");
            } else {
                // Si contiene texto, imprimimos directamente todo el bloque en la consola.
                println!("{}", contenido);
            }
        }
        // Caso de error: Ocurre si el archivo aún no existe (por ejemplo, en la primera ejecución).
        // Usamos el comodín '_' porque en este punto no necesitamos inspeccionar los detalles del error.
        Err(_) => println!("No se encontró archivo previo. ¡Añade tu primera tarea!"),
    }
}

/// Función que añade una nueva línea de texto al final de nuestro archivo.
/// Retorna un 'io::Result<()>' permitiendo propagar errores de I/O mediante el operador '?'.
fn agregar_tarea(tarea: &str) -> io::Result<()> {
    // Usamos el patrón constructor (Builder Pattern) de OpenOptions para configurar el acceso al archivo:
    // .write(true) -> Habilita permisos de escritura.
    // .append(true) -> Posiciona el puntero al final del archivo para no sobrescribir lo existente.
    // .create(true) -> Si el archivo 'tareas.txt' no existe, el sistema operativo lo creará automáticamente.
    let mut archivo = OpenOptions::new()
        .write(true)
        .append(true)
        .create(true)
        .open(ARCHIVO_TAREAS)?; // Si falla la apertura/creación, el operador '?' retorna el error inmediatamente.
    
    // La macro 'writeln!' funciona igual que 'println!', pero escribe en el buffer del archivo en lugar de la consola.
    // Añade automáticamente un salto de línea (\n) al final del string.
    writeln!(archivo, "- {}", tarea)?; // Si falla la escritura física en disco, se propaga el error.
    
    // Si todo el proceso se ejecuta correctamente, devolvemos la variante Ok con la tupla vacía ().
    Ok(())
}

fn main() {
    // Iniciamos un bucle infinito interactivo (REPL: Read-Eval-Print Loop).
    loop {
        // En cada iteración del bucle, volvemos a leer el disco para mostrar el estado actualizado de la lista.
        mostrar_tareas();
        
        println!("\nOpciones: [1] Añadir tarea  [2] Salir");
        print!("Selecciona una opción: ");
        
        // El macro 'print!' almacena el texto en un buffer interno. En muchos sistemas operativos,
        // no se muestra en pantalla hasta que no encuentra un salto de línea (\n).
        // Forzamos la salida inmediata del texto con '.flush()' para que la invitación aparezca antes de leer la entrada.
        // Usamos '.unwrap()' porque un fallo al vaciar la consola estándar es un error crítico e improbable.
        io::stdout().flush().unwrap();

        // Creamos un String dinámico vacío en memoria heap para almacenar la entrada del usuario.
        let mut opcion = String::new();
        
        // Bloqueamos el hilo actual esperando que el usuario escriba algo en el teclado y pulse Enter.
        // '.read_line()' añade el texto introducido a nuestra variable, INCLUYENDO el salto de línea (\n).
        io::stdin().read_line(&mut opcion).unwrap();

        // Evaluamos la opción utilizando concordancia de patrones (Pattern Matching).
        // '.trim()' es indispensable para remover el salto de línea (\n) capturado por la consola.
        match opcion.trim() {
            "1" => {
                print!("Escribe la nueva tarea: ");
                io::stdout().flush().unwrap(); // Aseguramos que el texto se muestre antes de pausar el programa.
                
                let mut nueva_tarea = String::new();
                io::stdin().read_line(&mut nueva_tarea).unwrap(); // Capturamos la cadena de texto de la tarea.
                
                // Intentamos guardar la tarea limpiando espacios en blanco innecesarios.
                // Usamos 'if let' para reaccionar únicamente si la función devuelve la variante 'Err'.
                if let Err(e) = agregar_tarea(nueva_tarea.trim()) {
                    println!("Error al guardar la tarea: {}", e);
                }
            }
            "2" => {
                println!("¡Hasta luego!");
                break; // Rompe de forma limpia el bucle infinito 'loop', finalizando el programa.
            }
            _ => {
                // Esta es la rama por defecto. Captura cualquier entrada que no sea exactamente "1" o "2".
                println!("Opción no válida.");
            }
        }
    }
}