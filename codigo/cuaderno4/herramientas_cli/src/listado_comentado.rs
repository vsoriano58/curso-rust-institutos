// Importamos el módulo 'env' (environment) de la biblioteca estándar.
// Este módulo contiene herramientas para interactuar con el entorno del sistema operativo,
// como las variables de entorno y los argumentos pasados por la terminal.
use std::env;

// Importamos el módulo 'fs' (file system) de la biblioteca estándar.
// Nos proporciona funciones para interactuar con el sistema de archivos (crear, borrar, modificar).
use std::fs;

fn main() {
    // 'env::args()' devuelve un iterador sobre los argumentos pasados al programa.
    // El primer argumento (índice 0) siempre es la ruta del propio ejecutable.
    // '.collect()' transforma ese iterador en una colección concreta.
    // Aquí especificamos explícitamente el tipo 'Vec<String>' para indicarle a Rust 
    // que queremos almacenar esos argumentos en un vector de cadenas de texto dinámicas.
    let argumentos: Vec<String> = env::args().collect();

    // Verificamos si el usuario ha introducido suficientes parámetros.
    // El tamaño debe ser mínimo 3: [0] ejecutable, [1] acción, [2] nombre del archivo.
    // Si tiene menos de 3, significa que faltan datos esenciales para que el programa opere.
    if argumentos.len() < 3 {
        println!("Uso incorrecto del programa.");
        // Explicamos al usuario el uso de '--'. En Cargo, todo lo que vaya después de '--'
        // se transmite directamente a nuestro binario en lugar de ser interpretado por Cargo.
        println!("Ejemplo: cargo run -- <accion> <nombre_archivo>");
        println!("Acciones disponibles: eliminar, crear");
        
        // Detenemos la ejecución del 'main' de forma prematura. 
        // Como 'main' no devuelve nada, un simple 'return' rompe el flujo limpiamente.
        return;
    }

    // Tomamos una referencia indexada al segundo elemento del vector.
    // Al usar '&', evitamos extraer el String del vector, respetando las reglas de propiedad (ownership).
    let accion = &argumentos[1];
    
    // Tomamos una referencia indexada al tercer elemento del vector (nombre del archivo sobre el que actuar).
    let nombre_archivo = &argumentos[2];

    // Evaluamos la cadena de texto de la acción mediante coincidencia de patrones (pattern matching).
    // Usamos '.as_str()' para convertir el '&String' en un '&str', lo cual permite 
    // compararlo de manera directa y eficiente con literales de cadena ("crear", "eliminar").
    match accion.as_str() {
        // Primer brazo del match: Si el usuario escribió exactamente "crear".
        "crear" => {
            // Intentamos crear el archivo en el disco.
            // 'fs::File::create' trunca (vacía) el archivo si ya existía, o lo crea nuevo si no.
            // Devuelve un tipo 'Result'. Evaluamos su éxito o fallo con un 'match' interno.
            match fs::File::create(nombre_archivo) {
                // Variante de éxito: El archivo se creó correctamente en el sistema de archivos.
                // Usamos '_' porque la función devuelve el manejador del archivo ('File'), 
                // pero como solo queríamos crearlo y no escribir en él ahora, lo ignoramos.
                Ok(_) => println!("Automatización: Archivo '{}' creado con éxito.", nombre_archivo),
                
                // Variante de error: Ocurre si, por ejemplo, la ruta no existe o no hay permisos de escritura.
                // Capturamos el error en la variable 'e' para imprimirlo en pantalla.
                Err(e) => println!("Error al crear el archivo: {}", e),
            }
        }
        
        // Segundo brazo del match: Si el usuario escribió exactamente "eliminar".
        "eliminar" => {
            // 'fs::remove_file' solicita al sistema operativo borrar el archivo de forma definitiva.
            // Al igual que 'create', devuelve un 'Result' que debemos gestionar de forma segura.
            match fs::remove_file(nombre_archivo) {
                // Variante de éxito: El archivo fue removido del almacenamiento de manera correcta.
                // Como no devuelve ningún dato interno útil más allá del éxito, la variante es 'Ok(())'.
                Ok(_) => println!("Automatización: Archivo '{}' eliminado de forma segura.", nombre_archivo),
                
                // Variante de error: Ocurre si el archivo no existe o el sistema bloquea su borrado.
                Err(e) => println!("Error al eliminar el archivo: {}", e),
            }
        }
        
        // Brazo comodín o por defecto (_): Obligatorio en Rust debido a que 'match' debe ser exhaustivo.
        // Captura cualquier palabra que no sea "crear" o "eliminar", protegiendo al programa de estados inválidos.
        _ => println!("Acción desconocida. Prueba con 'crear' o 'eliminar'."),
    }
}
