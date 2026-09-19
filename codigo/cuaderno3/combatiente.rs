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