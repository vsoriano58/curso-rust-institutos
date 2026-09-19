#import "config.typ": *

= Control de Flujo Avanzado: Coincidencia de Patrones (`match`)
En el tema anterior descubrimos los enumerados (enum) y cómo pueden almacenar datos complejos en sus variantes. Pero nos quedamos con una duda: ¿cómo podemos "abrir" esas variantes de forma segura para extraer y utilizar los datos que contienen? 

#nota("Vimos un ejemplo sencillo con la variante Some de un dato Option que almacenaba un 1, Some(1).")

Para conseguirlo, Rust nos ofrece la estructura de control definitiva: match (*coincidencia de patrones*). Piensa en *`match`* como una aduana ultra-segura. El compilador inspecciona tu *variable enum* y te obliga a programar un camino específico para cada una de las posibilidades existentes.

== La potencia de `match`: Desestructuración exhaustiva de datos
Una de las reglas de oro de Rust es la *exhaustividad*: un bloque *match* no compilará si dejas una sola variante del enumerado sin cubrir.

Recuperemos el ejemplo de los hechizos del bloque anterior para ver cómo match abre el contenido y extrae las variables internas (proceso llamado desestructuración):

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *match_hechizo.rs*

```rust
enum Hechizo {
    Curacion,
    BolaFuego { daño: u32, radio: f32 },
    Teletransporte(i32, i32),
}

fn lanzar_hechizo(hechizo: Hechizo) {
    // El match inspecciona la variante exacta y extrae sus valores internos
    match hechizo {
        Hechizo::Curacion => {
            println!("💚 Destellos verdes flotan en el aire. Te has curado 20 puntos de vida.");
        }
        Hechizo::BolaFuego { daño, radio } => {
            println!("🔥 ¡BOOM! Una bola de fuego estalla haciendo {} de daño en un radio de {} metros.", daño, radio);
        }
        Hechizo::Teletransporte(x, y) => {
            println!("🌀 Te desvaneces en el espacio y apareces en las coordenadas (X: {}, Y: {}).", x, y);
        }
    }
}

fn main(){
    let hechizo = Hechizo::BolaFuego{daño: 8, radio: 20.7f32};
    lanzar_hechizo(hechizo);
}
```
La ejecución del programa produce la siguiente salida:

🔥 ¡BOOM! Una bola de fuego estalla haciendo 8 de daño en un radio de 20.7 metros.

== El comodín de seguridad: El patrón por defecto `_`
En este apartado consideramos a match como una instrucción de control de flujo, similar a if-else pero con más poder. A veces trabajamos con tipos de datos que tienen millones de posibilidades, como un número entero (`u32`) o un carácter (`char`). Sería imposible en un match, escribir un camino para cada número. Para solucionarlo, usamos el guion bajo (`_`), que actúa como un "comodín" o caso por defecto para atrapar todo lo que no hayamos atrapado explícitamente.

La siguiente función *clasificar_puntuacion* tiene un parámetro *puntos* de tipo u32 (entero sin signo de 32 bits) y en función del argumento que se le pase a la función, ejecuta una u otra rama del match. Vemos que al principio hay tres caminos perfectamente definidos pero el cuarto camino se recoge con el patrón guión bajo `_` que atrapa cualquier valor que no se haya atrapado antes.

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *clasificar_puntuacion.rs*

```rust
fn clasificar_puntuacion(puntos: u32) {
    match puntos {
        0 => println!("🥉 ¿Es tu primera vez jugando? Ánimo."),
        1..=10 => println!("🥈 ¡Vas mejorando! Medalla de plata."),
        11..=50 => println!("🥇 ¡Increíble! Eres un profesional."),
        _ => println!("🏆 ¡Récord legendario superado!"), // Captura cualquier número mayor que 50
    }
}

fn main(){
    clasificar_puntuacion(0);
    clasificar_puntuacion(5);
    clasificar_puntuacion(25);
    clasificar_puntuacion(100);
    
}
```
La ejecución del programa produce la siguiente salida:

🥉 ¿Es tu primera vez jugando? Ánimo.\
🥈 ¡Vas mejorando! Medalla de plata.\
🥇 ¡Increíble! Eres un profesional.\
🏆 ¡Récord legendario superado!\

==  El atajo elegante: Control de flujo simplificado con `if let`
¿Qué ocurre si solo nos interesa gestionar *una sola variante* de un *enumerado* y queremos ignorar el resto? Usar un match nos obligaría a poner el comodín `_` => {} al final de forma obligatoria. Para evitar ese código repetitivo, Rust inventó el atajo *if let*.

En el siguiente ejemplo, la variable *cofre_tesoro* está inicializada con la variante Some de un Option. En el programa suponemos que solo nos interesa saber lo que contiene la variable *cofre_tesoro* si es un Some y nos da igual en caso contrario.
  
El *if let*, si la variable *cofre_tesoro* coincide exactamente con el patrón *Some*, extrae el texto en el argumento *arma* que se le pasa al Some. Es decir, *arma* pasará a valer `"`Espada Excalibur`"` y la podremos utilizar en el println!.

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *cofre_tesoro.rs*

```rust
fn main() {
    let cofre_tesoro: Option<String> = Option::Some(String::from("Espada Excalibur"));

    
    if let Option::Some(arma) = cofre_tesoro {
        println!("🎁 ¡Has abierto un cofre y has encontrado una {}!", arma);
    } else {
        println!("💨 El cofre estaba completamente vacío.");
    }
}
```
La salida del programa es:

🎁 ¡Has abierto un cofre y has encontrado una Espada Excalibur!

== Proyecto Práctico II: Mini-RPG de texto basado en turnos
Vamos a unir todo lo aprendido en el Cuaderno 3 (estructuras, métodos impl, enumerados Option y control de flujo match) para crear un simulador de combate clásico por turnos entre un Héroe y un Monstruo.

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *combatiente.rs*

Después del listado damos algunas explicaciones.

```rust
// 1. Definimos las acciones que puede tomar el jugador en su turno
enum Accion {
    Atacar,
    Curar,
    Huir,
}

// 2. Definimos la estructura de los combatientes
struct Combatiente {
    nombre: String,
    salud: i32,
    salud_maxima: i32,
    fuerza_ataque: i32,
}

impl Combatiente {
    // Constructor de personajes
    fn new(nombre: &str, salud_max: i32, fuerza: i32) -> Combatiente {
        Combatiente {
            nombre: String::from(nombre),
            salud: salud_max,
            salud_maxima: salud_max,
            fuerza_ataque: fuerza,
        }
    }

    // Método para recibir un impacto
    fn recibir_daño(&mut self, cantidad: i32) {
        self.salud -= cantidad;
        if self.salud < 0 {
            self.salud = 0;
        }
        println!("💥 {} recibe {} puntos de daño. (Vida actual: {}/{})", self.nombre, cantidad, self.salud, self.salud_maxima);
    }

    // Método para curarse
    fn usar_pocion(&mut self) {
        let curacion = 25;
        self.salud += curacion;
        if self.salud > self.salud_maxima {
            self.salud = self.salud_maxima;
        }
        println!("💚 {} bebe una poción y recupera {} de vida. (Vida actual: {}/{})", self.nombre, curacion, self.salud, self.salud_maxima);
    }

    // Comprobar si el personaje sigue en pie
    fn esta_vivo(&self) -> bool {
        self.salud > 0
    }
}

fn main() {
    println!("=== 🏰 BIENVENIDO A RUST-RPG 🏰 ===");
    
    // Instanciamos a los combatientes
    let mut heroe = Combatiente::new("Sir Isaac", 80, 18);
    let mut monstruo = Combatiente::new("Gólem de Roca", 100, 12);

    // Simulamos la lista de comandos/turnos predefinidos del jugador
    let turnos_jugador = [Accion::Atacar, Accion::Curar, Accion::Atacar, Accion::Huir];
    let mut numero_turno = 1;

    for accion in turnos_jugador {
        if !heroe.esta_vivo() || !monstruo.esta_vivo() {
            break;
        }

        println!("\n--- ⏳ TURNO {} ---", numero_turno);
        
        // --- FASE DEL HÉROE ---
        // Usamos match para decidir qué superpoder o acción ejecuta el jugador
        match accion {
            Accion::Atacar => {
                println!("⚔️ {} alza su espada contra el {}!", heroe.nombre, monstruo.nombre);
                monstruo.recibir_daño(heroe.fuerza_ataque);
            }
            Accion::Curar => {
                heroe.usar_pocion();
            }
            Accion::Huir => {
                println!("🏃 {} ha decidido retirarse del combate de forma segura. ¡Fin de la partida!", heroe.nombre);
                return; // Corta la ejecución completa del main
            }
        }

        // --- FASE DEL ENEMIGO (Si sigue vivo) ---
        if monstruo.esta_vivo() {
            println!("👹 El {} ruge con furia y contraataca!", monstruo.nombre);
            heroe.recibir_daño(monstruo.fuerza_ataque);
        }

        numero_turno += 1;
    }

    // --- RESOLUCIÓN DEL COMBATE ---
    println!("\n==================================");
    if heroe.esta_vivo() && !monstruo.esta_vivo() {
        println!("🎉 ¡VICTORIA! El {} ha sido derrotado. Eres el héroe del reino.", monstruo.nombre);
    } else if !heroe.esta_vivo() && monstruo.esta_vivo() {
        println!("💀 HAS MUERTO. El {} ha protegido su mazmorra con éxito.", monstruo.nombre);
    } else {
        println!("⚔️ El combate ha quedado en tablas.");
    }
    println!("==================================");
}
```
*Explicaciones sobre el listado*

La mejor forma de seguir este apartado es editando en la Playground el listado del programa e ir identificando las explicaciones con el listado. Ten en cuenta que no se van a explicar las líneas una por una en todos los casos sino que a menudo explicaremos grupos de líneas.

*1. Lo primero es indicar las estructuras de datos que tenemos:*

- *enum Accion*: Tiene tres variantes, *Atacar*, *Curar* y *Huir*

- *struct Combatiente*: Tiene cuatro campos. Utilizaremos este struct para crear tanto el heroe como el monstruo.

- *impl Combatiente*: Define el constructor *new*, y los métodos *recibir_daño*, *usar_pocion* y *esta_vivo* que pueden actuar sobre un objeto de tipo *Combatiente*. El constructor new simplemente lo crea.

*2. La función main*

- En primer lugar crea el *heroe* y el *monstruo* con el constructor *new* del *struct Combatiente*. Utiliza *mut* para poder luego cambiar sus propiedades.
```rust
let mut heroe = Combatiente::new("Sir Isaac", 80, 18);
let mut monstruo = Combatiente::new("Gólem de Roca", 100, 12);
```
- A continuación crea dos variable más:
```rust
let turnos_jugador = [Accion::Atacar, Accion::Curar, Accion::Atacar, Accion::Huir];
let mut numero_turno = 1;
```
*turno_jugador* es un array con 4 acciones que luego recorreremos con un bucle for.

La variable *numero_turno* se in icializa a 1 antes de entrar en el for y luego se aumenta en uno al final del for en cada pasada del mismo.

*3. El bucle for*
Se introduce con la siguiente línea:
```rust
for accion in turnos_jugador {

    // instruciones del for

} // Llave de cierre del for
```
Hemos visto antes que *turnos_jugador* es un array de cuatro acciones. El bucle for recorrerá las cuatro posiciones del array entregando a la variable *accion* el valor correspondiente en cada pasada. Por ejemplo, en la primera pasada, accion valdrá Accion::Atacar, en la segunda valdrá Accion::Curar y así sucesivamente. En cada pasada se ejecutan todas las instrucciones del bucle.

*4. El match*
Cuando el bucle for llega al *match*, desempaqueta la variable *accion* y según su contenido ejecuta una de sus ramas:
```rust
match accion {
    Accion::Atacar => {
        println!("⚔️ {} alza su espada contra el {}!", heroe.nombre, monstruo.nombre);
        monstruo.recibir_daño(heroe.fuerza_ataque);
    }
    Accion::Curar => {
        heroe.usar_pocion();
    }
    Accion::Huir => {
        println!("🏃 {} ha decidido retirarse del combate de forma segura. ¡Fin de la partida!", heroe.nombre);
        return; // Corta la ejecución completa del main
    }
}
```
*5. ¿El monstruo sigue vivo?*
Si sigue vivo se le aplica:
```rust
heroe.recibir_daño(monstruo.fuerza_ataque);
```
¿Cuanto vale *monstruo.fuerza_ataque*? Según hemos creado el monstruo con la instrucción new, fuerza_ataque es el tercer argumento, luego vale 12.

*6. Evolución del for*
El bucle for irá avanzando entre las cuatro acciones del array *turnos_jugador* y para cada una de ellas ejecutará todas las instrucciones existentes entre su llave de apertura y su llave de cierre.

*7. Impresión de resultados*
Después de que el for de sus cuatro vueltas, las últimas líneas imprimen el resultado del combate según como hayan quedado los estados del heroe y del monstruo.

#pagebreak()