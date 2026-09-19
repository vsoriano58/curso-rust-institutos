#import "config.typ": *

= Ejercicios Resueltos del Cuaderno 3

== ENUNCIADOS

=== Ejercicio 1: Tu propia Struct y Función Asociada (Constructor)

*Enunciado:*  Crea una estructura llamada *Dimensiones2D* que contenga los campos *ancho* y *alto* (ambos f32). Implementa un bloque *impl* que contenga una función asociada llamada cuadrado que reciba un solo parámetro (el lado) y devuelva una instancia de la estructura donde el ancho y el alto sean iguales. Pruébalo en el main.

=== Ejercicio 2: Métodos Mutables (`&mut self`)

*Enunciado:* Define una estructura *Contador* que guarde un valor entero *u32*. Crea un *método mutable llamado incrementar* que sume 1 al valor interno, y otro método de lectura llamado *obtener_valor* que devuelva dicho número. Simula un par de incrementos en el main.

=== Ejercicio 3: Enumerados con Datos Asociados

*Enunciado:* Diseña un enumerado llamado *Dispositivo* que represente elementos de una red informática. Tendrá dos variantes: *Ordenador* (que guarda un String con el nombre de usuario) y *Router* (que guarda una tupla con 4 números u8 para simular su dirección IP). Instancia uno de cada tipo en el main.

=== Ejercicio 4: Extrayendo Datos con `match`

*Enunciado:* Utilizando el enumerado *Dispositivo* del ejercicio anterior, escribe una función que *reciba dicho enumerado* y, mediante un *bloque match*, imprima un mensaje personalizado. Si es un ordenador, debe decir a quién pertenece; si es un router, debe mostrar su dirección IP formateada con puntos.

=== Ejercicio 5: El patrón por defecto `_` e `if let` con `Option`

*Enunciado:* En los videojuegos, la tasa de críticos multiplica el daño. Crea una variable de tipo Option*`<u32>`* que represente el daño crítico extra. Si tiene valor (Some), imprímelo en pantalla. Si no tiene valor (None), usa un *bloque if let* para capturar de forma directa el estado y mostrar un mensaje avisando que ha sido un ataque normal.

== SOLUCIONES

=== Ejercicio 1: Tu propia Struct y Función Asociada
```rust
struct Dimensiones2D {
    ancho: f32,
    alto: f32,
}

impl Dimensiones2D {
    // Función asociada que actúa como constructor específico para cuadrados
    fn cuadrado(lado: f32) -> Dimensiones2D {
        Dimensiones2D {
            ancho: lado,
            alto: lado,
        }
    }
}

fn main() {
    let lienzo = Dimensiones2D::cuadrado(4.5);
    println!("Lienzo creado: {}m de ancho por {}m de alto.", lienzo.ancho, lienzo.alto);
}
```
*Explicación:* Las funciones asociadas no reciben self porque no operan sobre un objeto ya existente. En este caso, funciona como un constructor alternativo muy útil cuando queremos inicializar una estructura con reglas específicas de forma limpia.

=== Ejercicio 2: Métodos Mutables (`&mut self`)
```rust
struct Contador {
    valor: u32,
}

impl Contador {
    // Método mutable: necesita modificar el estado interno
    fn incrementar(&mut self) {
        self.valor += 1;
    }

    // Método de lectura: solo lee el valor
    fn obtener_valor(&self) -> u32 {
        self.valor
    }
}

fn main() {
    // La instancia DEBE ser mutable para poder usar &mut self
    let mut mi_contador = Contador { valor: 0 };
    
    mi_contador.incrementar();
    mi_contador.incrementar();
    
    println!("El valor del contador es: {}", mi_contador.obtener_valor());
}
```
*Explicación:* En Rust, si un método necesita alterar los datos que están dentro de la estructura, debe declararse explícitamente con *&mut self*. Además, cualquier variable (ej: mi_contador) que use dicho método en el main debe ser declarada obligatoriamente con la palabra clave *mut*.

=== Ejercicio 3: Enumerados con Datos Asociados
```rust
enum Dispositivo {
    Ordenador(String),
    Router(u8, u8, u8, u8),
}

fn main() {
    let pc_alumno = Dispositivo::Ordenador(String::from("Lucas"));
    let router_aula = Dispositivo::Router(192, 168, 1, 1);
    
    println!("Dispositivos configurados en la memoria correctamente.");
}
```
*Explicación:* A diferencia de los enumerados clásicos de otros lenguajes, Rust nos permite adjuntar información heterogénea a cada variante. El tipo *Dispositivo* puede contener tanto *una cadena de texto* como *una tupla de cuatro bytes* según la variante que esté activa.

=== Ejercicio 4: Extrayendo Datos con `match`
```rust
enum Dispositivo {
    Ordenador(String),
    Router(u8, u8, u8, u8),
}

fn identificar_nodo(aparato: Dispositivo) {
    match aparato {
        Dispositivo::Ordenador(usuario) => {
            println!("💻 Estación de trabajo activa. Usuario actual: {}", usuario);
        }
        Dispositivo::Router(a, b, c, d) => {
            println!("🌐 Puerta de enlace detectada. IP: {}.{}.{}.{}", a, b, c, d);
        }
    }
}

fn main() {
    let pc = Dispositivo::Ordenador("Juan".to_string());
    let nodo = Dispositivo::Router(10, 0, 0, 254);

    identificar_nodo(pc);
    identificar_nodo(nodo);
}
```
*Explicación:* El bloque match no solo comprueba qué variante del enumerado se está ejecutando, sino que realiza un proceso llamado desestructuración: "abre" la variante y extrae las variables internas (usuario o los octetos a, b, c, d) para que podamos operar con ellas dentro de las llaves correspondientes.

===  Ejercicio 5: El patrón por defecto `_` e `if let` con `Option`
```rust
fn main() {
    // El jugador ha tenido mala suerte y no ha obtenido bonificador crítico
    let daño_critico: Option<u32> = Option::None;

    // Usamos 'if let' para buscar únicamente el caso de éxito (Some)
    if let Option::Some(bono) = daño_critico {
        println!("🔥 ¡Golpe Crítico! Daño extra: +{}", bono);
    } else {
        // El bloque else actúa como el patrón por defecto para capturar el None
        println!("⚔️ Ataque normal. No se aplicaron multiplicadores.");
    }
}
```
*Explicación:* El atajo *if let* reduce enormemente las líneas de código cuando *solo nos interesa reaccionar ante una variante específica de un enumerado* (normalmente Some), relegando todas las demás opciones posibles a un *bloque else* general sin necesidad de escribir un match exhaustivo.