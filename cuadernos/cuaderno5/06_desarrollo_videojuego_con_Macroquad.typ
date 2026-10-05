#import "config.typ": *


= Proyecto Final de Ciclo - Videojuego Gráfico Macroquad
`"`¡Ajá!`"` vamos a ver cómo la teoría se convierte en un videojuego interactivo que responde en tiempo real.

Para este proyecto utilizaremos Macroquad, una librería de Rust increíblemente ligera que no requiere configuraciones complejas de sistemas operativos ni herramientas pesadas, ideal para los ordenadores del instituto.

Para conectar de forma brillante el mundo de los hilos con el de los videojuegos usando Macroquad, debemos estructurar la explicación en torno a una sola pregunta: ¿Por qué no usamos los hilos independientes (std::thread) que acabamos de aprender para mover los personajes del juego?

*1. El Puente Pedagógico: El problema de los hilos en los videojuegos*

Si intentáramos programar un videojuego creando un hilo para el jugador, otro hilo para la pelota y otro hilo para los enemigos, nos toparíamos con dos problemas catastróficos:

- El Caos del Sincronismo: Los hilos van a su propio ritmo. Si el hilo de la pelota calcula su posición a mitad de camino mientras el hilo del jugador se está moviendo, la pelota podría atravesar la pala antes de que el procesador dibuje la imagen. El juego daría tirones horribles.

- Coste Innecesario: Como vimos en la tabla, crear un hilo cuesta 2 MB de memoria. Un juego con 50 enemigos gastaría 100 MB solo en "peajes de hilos" para mover simples numeritos en la pantalla

La Solución de Macroquad: Usar Asincronía Cooperativa (async/await) sobre un solo hilo principal.

*2. Cómo funciona la magia de Macroquad por dentro*

Cuando abras el proyecto del juego, te encuentrás con esta cabecera obligatoria:

```rust
#[macroquad::main("Mi Juego")]
async fn main() {
    loop {
        // ... Lógica del juego ...
        next_frame().await; // <--- El punto de conexión clave
    }
}
```
¿Qué está pasando realmente aquí?

- Un único hilo de la CPU ejecuta todo el juego. No hay peligro de corrupción de memoria ni peleas por variables. No hacen falta *`Arc<Mutex>`* porque una sola línea temporal lee los datos en orden de arriba a abajo.

- La palabra clave *async* le avisa a Rust de que esta función main es una "máquina de estados" que tiene permiso para pausarse en medio de su ejecución.

- La palabra clave *.await* es el botón de pausa cooperativo.

*3. La analogía definitiva: El Director de Cine y el Dibujante*

Para entenderlo de forma visual:

- El bucle loop es un Director de Cine. Calcula dónde debe estar el jugador y la pelota en el siguiente fotograma.

- Al llegar a *next_frame().await*, el Director se para en seco, levanta la mano y le dice al hilo del motor gráfico: "Oye, ya he calculado las posiciones. Te cedo el control. Dibuja el fotograma en la pantalla y, cuando la tarjeta gráfica termine, avísame para que continúe".

- Mientras la tarjeta gráfica trabaja, el hilo de software no se congela de forma destructiva; simplemente cede el control a la espera de la señal gráfica. Cuando el fotograma se muestra en el monitor, la máquina de estados se "despierta" en el mismo punto exacto y arranca la siguiente iteración del bucle.

*4. El Gran Cierre: ¿Y si metemos canales mpsc en el juego?*

Para demostrar que todo lo aprendido en el cuaderno está conectado, podemos plantear el desafío de crear analíticas o logs que mencionamos al principio.

Imagina que el juego tiene que guardar en un archivo de texto cada vez que el jugador mete un punto. Escribir en el disco duro es una operación síncrona lenta que congelaría la pantalla del juego un milisegundo (provocando un molesto tirón o lag).

*¿Cómo lo solucionamos uniendo los dos mundos?*

- Creamos un canal mpsc antes de arrancar el juego.

- Lanzamos un hilo secundario independiente (std::thread::spawn) fuera del juego que se queda escuchando el receptor (rx). Su único trabajo es escribir en el disco duro.

- El bucle asíncrono del juego (Macroquad) se queda con el transmisor (tx). Cada vez que hay un punto, lanza un mensaje por el canal y sigue jugando a 60 FPS sin detenerse ni un microsegundo. El hilo secundario se encargará del trabajo sucio de fondo.

== Proyecto Guiado: Nuestro primer juego gráfico (Clon de Pong)
Aquí tienes la guía paso a paso para el desarrollo del clon de Pong, diseñada específicamente para el Cuaderno 5. Esta guía conecta de manera directa la lógica del juego con el funcionamiento de la máquina de estados asíncrona de Macroquad.

En este proyecto práctico vamos a construir el clásico juego de Pong. La clave de este desarrollo es entender cómo el Game Loop (Bucle de juego) gestiona todo de forma asíncrona en un solo hilo, pausándose exactamente cuando se lo pedimos para sincronizarse con la tarjeta gráfica.

*Paso 1: Configurar el entorno de juego (Cargo.toml)*

💻 Abre una terminal integrada de VS Code en el directorio *proyectos-rust* creado al principio o en cualquier otro y crea un proyecto Rust con la orden: *cargo new juego_pong*.

Sitúate en la carpeta del proyecto mediante *cd juego_pong* e instala la dependencia *macroquad* con la orden: *cargo add macroquad*.

Tu fichero Cargo.toml debe lucir algo así:

```
[package]
name = "juego_pong"
version = "0.1.0"
edition = "2024"

[dependencies]
macroquad = "0.4.16"
```

*Paso 2: Definir las Entidades del juego*

En lugar de tener variables sueltas por el código, utilizaremos el sistema de estructuras (struct) de Rust para modelar los dos elementos clave de la pantalla: las palas (rectángulos) y la pelota (un círculo).

💻 Copia el siguiente código en el archivo src/main.rs

*src/main.rs*

```rust
use macroquad::prelude::*;

struct Pala {
    x: f32,
    y: f32,
    ancho: f32,
    alto: f32,
    velocidad: f32,
}

struct Pelota {
    x: f32,
    y: f32,
    radio: f32,
    vel_x: f32,
    vel_y: f32,
}
```

*Paso 3: Inicializar la máquina de estados (async fn main)*

El punto de entrada del juego no es una función normal. Lleva el macro *`#[macroquad::main]`* y está marcada como *async*. Esto le dice al compilador de Rust que prepare la infraestructura asíncrona interna del motor para controlar el tiempo.

Tu programa debe tener este aspecto:

```rust
use macroquad::prelude::*;

struct Pala {
    x: f32,
    y: f32,
    ancho: f32,
    alto: f32,
    velocidad: f32,
}

struct Pelota {
    x: f32,
    y: f32,
    radio: f32,
    vel_x: f32,
    vel_y: f32,
}

#[macroquad::main("Rust Pong Educativo")]
async fn main() {
    // Inicializamos al jugador en el lado izquierdo
    let mut jugador = Pala {
        x: 40.0,
        y: screen_height() / 2.0 - 40.0,
        ancho: 15.0,
        alto: 80.0,
        velocidad: 6.0,
    };

    // Inicializamos la pelota en el centro exacto de la pantalla
    let mut pelota = Pelota {
        x: screen_width() / 2.0,
        y: screen_height() / 2.0,
        radio: 8.0,
        vel_x: 4.0,
        vel_y: 4.0,
    };
    
 } // Continuará en el Paso 4…
```

El programa ya se puede ejecutar sin dar ningún error pero se abre y se cierra inmeditamente porque no tenemos nada que visualizar.


*Paso 4: El Corazón Asíncrono (El Game Loop)*

Dentro de la función *main*, abrimos un bucle infinito *loop*. En cada vuelta (fotograma) ejecutaremos de forma secuencial las tres fases esenciales del desarrollo de videojuegos: Entradas, Lógica y Dibujo. Rematamos el bucle con un .await cooperativo.

El programa completo después del paso 4 es el siguiente:

```rust
use macroquad::prelude::*;

struct Pala {
    x: f32,
    y: f32,
    ancho: f32,
    alto: f32,
    velocidad: f32,
}

struct Pelota {
    x: f32,
    y: f32,
    radio: f32,
    vel_x: f32,
    vel_y: f32,
}

#[macroquad::main("Rust Pong Educativo")]
async fn main() {
    // Inicializamos al jugador en el lado izquierdo
    let mut jugador = Pala {
        x: 40.0,
        y: screen_height() / 2.0 - 40.0,
        ancho: 15.0,
        alto: 80.0,
        velocidad: 6.0,
    };

    // Inicializamos la pelota en el centro exacto de la pantalla
    let mut pelota = Pelota {
        x: screen_width() / 2.0,
        y: screen_height() / 2.0,
        radio: 8.0,
        vel_x: 4.0,
        vel_y: 4.0,
    };

    loop {
        // --- 1. ENTRADAS (Leer Teclado) ---
        // Si el usuario pulsa Flecha Arriba y no se sale de la pantalla, sube
        if is_key_down(KeyCode::Up) && jugador.y > 0.0 {
            jugador.y -= jugador.velocidad;
        }
        // Si pulsa Flecha Abajo y no se sale por el suelo, baja
        if is_key_down(KeyCode::Down) && jugador.y < screen_height() - jugador.alto {
            jugador.y += jugador.velocidad;
        }

        // --- 2. LÓGICA (Mover pelota y calcular colisiones) ---
        pelota.x += pelota.vel_x;
        pelota.y += pelota.vel_y;

        // Rebote en el techo y suelo
        if pelota.y - pelota.radio < 0.0 || pelota.y + pelota.radio > screen_height() {
            pelota.vel_y = -pelota.vel_y; // Invierte la dirección vertical
        }

        // Rebote automático en la pared derecha (Para poder jugar solos)
        if pelota.x + pelota.radio > screen_width() {
            pelota.vel_x = -pelota.vel_x;
        }

        // Detección de colisión matemática con la pala del jugador
        if pelota.x - pelota.radio <= jugador.x + jugador.ancho
            && pelota.y >= jugador.y
            && pelota.y <= jugador.y + jugador.alto
        {
            pelota.vel_x = -pelota.vel_x; // Rebota hacia la derecha
            pelota.x = jugador.x + jugador.ancho + pelota.radio; // Antiatasco
        }

        // Reinicio si la pelota se escapa por la izquierda (Derrota)
        if pelota.x < 0.0 {
            pelota.x = screen_width() / 2.0;
            pelota.y = screen_height() / 2.0;
            pelota.vel_x = 4.0;
        }

        // --- 3. DIBUJO (Pintar en pantalla) ---
        clear_background(BLACK); // Limpia el frame anterior dejando el fondo negro

        // Dibujamos la pala del jugador (Blanca) y la pelota (Amarilla)
        draw_rectangle(jugador.x, jugador.y, jugador.ancho, jugador.alto, WHITE);
        draw_circle(pelota.x, pelota.y, pelota.radio, YELLOW);

        // --- 4. LA PAUSA ASÍNCRONA ---
        // Aquí cedemos el control al runtime de Macroquad. El hilo se
        // pausa de forma  segura para que la tarjeta gráfica dibuje la
        // escena. 
        // En cuanto el monitor está listo para el siguiente frame, 
        // nuestra función se "despierta" sola.
        next_frame().await;
    }
}
```

¡Ya puedes ejecutar el programa con *cargo run* y jugar!

*Cosas a resaltar*

- *La linealidad protectora*: Fíjate que el código lee el teclado, luego calcula la posición de la pelota y finalmente dibuja. Al ejecutarse secuencialmente en un único hilo, es físicamente imposible que ocurra una condición de carrera. No necesitamos Arc ni Mutex porque ningún elemento compite por los datos.

- *El coste cero de la pausa*: La llamada a *next_frame().await* congela temporalmente la ejecución guardando el estado de nuestras estructuras jugador y pelota. No consume ciclos de CPU inútilmente mientras la pantalla se refresca, demostrando el potencial del modelo asíncrono frente al bloqueo tradicional de un thread::sleep.

=== Añadir un sistema de puntuación al código

Aquí tienes el listado completo del juego con el sistema de puntuación integrado. Hemos creado una estructura llamada *Marcador* para almacenar los puntos y utilizamos la función *draw_text* para renderizar el marcador en tiempo real en la parte superior de la pantalla. El contador de puntos del jugador se incrementa cada vez que la pelota golpea con éxito la pala, y el de la IA / Fallos sube si la pelota se escapa por el lado izquierdo:

Proyecto: *juego_pong_puntuacion*

*src/main.rs*

```rust
use macroquad::prelude::*;

// ============================================================================
// 1. ESTRUCTURAS DE DATOS (Entidades del juego)
// ============================================================================

struct Pala {
    x: f32,
    y: f32,
    ancho: f32,
    alto: f32,
    velocidad: f32,
}

struct Pelota {
    x: f32,
    y: f32,
    radio: f32,
    vel_x: f32,
    vel_y: f32,
}

struct Marcador {
    puntos_jugador: u32,
    fallos: u32,
}

// ============================================================================
// 2. FUNCIÓN PRINCIPAL ASÍNCRONA (Inicialización del Entorno)
// ============================================================================

#[macroquad::main("Rust Pong Educativo")]
async fn main() {
    // Inicializamos la pala del jugador en el extremo izquierdo
    let mut jugador = Pala {
        x: 40.0,
        y: screen_height() / 2.0 - 40.0,
        ancho: 15.0,
        alto: 80.0,
        velocidad: 6.0,
    };

    // Inicializamos la pelota en el centro geométrico de la pantalla
    let mut pelota = Pelota {
        x: screen_width() / 2.0,
        y: screen_height() / 2.0,
        radio: 8.0,
        vel_x: 4.0,
        vel_y: 4.0,
    };

    // Inicializamos el sistema de puntuación en cero
    let mut marcador = Marcador {
        puntos_jugador: 0,
        fallos: 0,
    };

    // ========================================================================
    // 3. EL BUCLE DE JUEGO (Game Loop Asíncrono)
    // ========================================================================
    loop {
        // --------------------------------------------------------------------
        // FASE A: ENTRADAS (Control de teclado del Jugador)
        // --------------------------------------------------------------------
        if is_key_down(KeyCode::Up) && jugador.y > 0.0 {
            jugador.y -= jugador.velocidad;
        }
        if is_key_down(KeyCode::Down) && jugador.y < screen_height() - jugador.alto {
            jugador.y += jugador.velocidad;
        }

        // --------------------------------------------------------------------
        // FASE B: LÓGICA (Físicas, Movimiento y Colisiones)
        // --------------------------------------------------------------------
        // Desplazamos la pelota según su velocidad actual
        pelota.x += pelota.vel_x;
        pelota.y += pelota.vel_y;

        // Rebote elástico en los límites superior e inferior de la ventana
        if pelota.y - pelota.radio < 0.0 || pelota.y + pelota.radio > screen_height() {
            pelota.vel_y = -pelota.vel_y; // Invierte el vector vertical
        }

        // Rebote automático en la pared derecha (Simulación de rival estático)
        if pelota.x + pelota.radio > screen_width() {
            pelota.vel_x = -pelota.vel_x;
        }

        // Detección de colisión por caja delimitadora (AABB) con la pala del Jugador
        if pelota.x - pelota.radio <= jugador.x + jugador.ancho
            && pelota.y >= jugador.y
            && pelota.y <= jugador.y + jugador.alto
        {
            pelota.vel_x = -pelota.vel_x; // Rebota hacia la derecha
            pelota.x = jugador.x + jugador.ancho + pelota.radio; // Corrige intersección
            
            // ¡PUNTO LOGRADO! Incrementamos la puntuación del jugador por salvar la pelota
            marcador.puntos_jugador += 1;
        }

        // Reinicio del punto si la pelota cruza el límite izquierdo (Punto perdido)
        if pelota.x < 0.0 {
            pelota.x = screen_width() / 2.0;
            pelota.y = screen_height() / 2.0;
            pelota.vel_x = 4.0; // Restablece dirección inicial
            
            // ¡FALLO! El jugador no llegó a tiempo
            marcador.fallos += 1;
        }

        // --------------------------------------------------------------------
        // FASE C: RENDERIZADO (Dibujo Gráfico)
        // --------------------------------------------------------------------
        clear_background(BLACK); // Borra el fotograma anterior aplicando fondo negro

        // Pintamos los elementos activos en la pantalla
        draw_rectangle(jugador.x, jugador.y, jugador.ancho, jugador.alto, WHITE);
        draw_circle(pelota.x, pelota.y, pelota.radio, YELLOW);

        // --- RENDERIZADO DEL MARCADOR ---
        // Dibujamos los textos formateados en la parte superior central
        let texto_marcador = format!("Jugador: {}  |  Fallos: {}", marcador.puntos_jugador, marcador.fallos);
        draw_text(&texto_marcador, screen_width() / 2.0 - 120.0, 40.0, 30.0, GREEN);

        // Mensaje instruccional estático para el alumno
        draw_text("Controles: FLECHA ARRIBA / FLECHA ABAJO", 20.0, screen_height() - 20.0, 20.0, GRAY);

        // --------------------------------------------------------------------
        // FASE D: SINCRONIZACIÓN ASÍNCRONA COOPERATIVA
        // --------------------------------------------------------------------
        next_frame().await;
    }
}
```

Ahora podrás ver como sube el contador de puntos del jugador, que se incrementa cada vez que la pelota golpea con éxito la pala, y el de la IA que representa fallos del jugador.

=== Integr un canal mpsc y un hilo secundario para registrar los puntos en segundo plano
Aquí tienes el listado completo y definitivo del juego. Este código es la cumbre pedagógica de todo el Cuaderno 5, ya que fusiona en un solo archivo los dos grandes mundos que hemos estudiado: el *Game Loop asíncrono* (que corre a 60 FPS sin retrasos) y un hilo secundario concurrente conectado mediante canales MPSC para escribir los eventos en disco.

Cada vez que el jugador suma un punto o comete un fallo, el bucle asíncrono lanza un mensaje por el canal de forma instantánea. El hilo secundario capta el mensaje e imprime los datos, simulando una escritura pesada en disco sin provocar ni un solo tirón (lag) en la pantalla:

Proyecto: *juego_pong_canal_mpsc*

*src/main.rs*

```rust
use macroquad::prelude::*;
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

// ============================================================================
// 1. ESTRUCTURAS DE DATOS (Entidades del juego)
// ============================================================================

struct Pala {
    x: f32,
    y: f32,
    ancho: f32,
    alto: f32,
    velocidad: f32,
}

struct Pelota {
    x: f32,
    y: f32,
    radio: f32,
    vel_x: f32,
    vel_y: f32,
}

struct Marcador {
    puntos_jugador: u32,
    fallos: u32,
}

// ============================================================================
// 2. FUNCIÓN PRINCIPAL ASÍNCRONA (Inicialización del Entorno)
// ============================================================================

#[macroquad::main("Rust Pong Educativo Completo")]
async fn main() {
    // ------------------------------------------------------------------------
    // PARTE CONCURRENTE: CONFIGURACIÓN DEL CANAL MPSC E HILO SECUNDARIO
    // ------------------------------------------------------------------------
    // Creamos el canal MPSC (Múltiples Productores, Un Solo Consumidor)
    let (tx, rx) = mpsc::channel::<String>();

    // Levantamos un hilo de ejecución secundario (nativo del S.O.)
    // Este hilo vivirá en paralelo al juego y se encargará del "trabajo sucio"
    thread::spawn(move || {
        // El bucle 'for' mantiene al hilo escuchando el receptor permanentemente
        for log in rx {
            // Simulamos que guardar este dato en el disco duro tarda un poco
            thread::sleep(Duration::from_millis(200));
            println!("[HILO SECUNDARIO - DISCO] Registrado con éxito: {}", log);
        }
        println!("[HILO SECUNDARIO] Canal cerrado. El hilo termina de forma limpia.");
    });

    // ------------------------------------------------------------------------
    // INITIALIZACIÓN DE ENTIDADES GRÁFICAS
    // ------------------------------------------------------------------------
    let mut jugador = Pala {
        x: 40.0,
        y: screen_height() / 2.0 - 40.0,
        ancho: 15.0,
        alto: 80.0,
        velocidad: 6.0,
    };

    let mut pelota = Pelota {
        x: screen_width() / 2.0,
        y: screen_height() / 2.0,
        radio: 8.0,
        vel_x: 4.0,
        vel_y: 4.0,
    };

    let mut marcador = Marcador {
        puntos_jugador: 0,
        fallos: 0,
    };

    // ========================================================================
    // 3. EL BUCLE DE JUEGO (Game Loop Asíncrono)
    // ========================================================================
    loop {
        // --------------------------------------------------------------------
        // FASE A: ENTRADAS (Control de teclado del Jugador)
        // --------------------------------------------------------------------
        if is_key_down(KeyCode::Up) && jugador.y > 0.0 {
            jugador.y -= jugador.velocidad;
        }
        if is_key_down(KeyCode::Down) && jugador.y < screen_height() - jugador.alto {
            jugador.y += jugador.velocidad;
        }

        // --------------------------------------------------------------------
        // FASE B: LÓGICA (Físicas, Movimiento y Colisiones)
        // --------------------------------------------------------------------
        pelota.x += pelota.vel_x;
        pelota.y += pelota.vel_y;

        // Rebote elástico en los límites superior e inferior de la ventana
        if pelota.y - pelota.radio < 0.0 || pelota.y + pelota.radio > screen_height() {
            pelota.vel_y = -pelota.vel_y;
        }

        // Rebote automático en la pared derecha
        if pelota.x + pelota.radio > screen_width() {
            pelota.vel_x = -pelota.vel_x;
        }

        // Detección de colisión con la pala del Jugador
        if pelota.x - pelota.radio <= jugador.x + jugador.ancho
            && pelota.y >= jugador.y
            && pelota.y <= jugador.y + jugador.alto
        {
            pelota.vel_x = -pelota.vel_x;
            pelota.x = jugador.x + jugador.ancho + pelota.radio;
            
            marcador.puntos_jugador += 1;

            // ¡CONEXIÓN ENTRE LOS DOS MUNDOS! 
            // Enviamos un informe al hilo secundario. Como el método .send() es instantáneo,
            // el juego no sufre ningún parón gráfico (anti-lag).
            let mensaje = format!("¡PUNTO! Marcador actual -> J:{} F:{}", marcador.puntos_jugador, marcador.fallos);
            tx.send(mensaje).unwrap();
        }

        // Reinicio del punto si la pelota se escapa por la izquierda
        if pelota.x < 0.0 {
            pelota.x = screen_width() / 2.0;
            pelota.y = screen_height() / 2.0;
            pelota.vel_x = 4.0;
            
            marcador.fallos += 1;

            // Enviamos el aviso de fallo por el canal MPSC
            let mensaje = format!("¡FALLO! El jugador no llegó. Total fallos: {}", marcador.fallos);
            tx.send(mensaje).unwrap();
        }

        // --------------------------------------------------------------------
        // FASE C: RENDERIZADO (Dibujo Gráfico)
        // --------------------------------------------------------------------
        clear_background(BLACK);

        draw_rectangle(jugador.x, jugador.y, jugador.ancho, jugador.alto, WHITE);
        draw_circle(pelota.x, pelota.y, pelota.radio, YELLOW);

        // Renderizado del marcador en pantalla
        let texto_marcador = format!("Jugador: {}  |  Fallos: {}", marcador.puntos_jugador, marcador.fallos);
        draw_text(&texto_marcador, screen_width() / 2.0 - 120.0, 40.0, 30.0, GREEN);

        // Información de depuración educativa
        draw_text("El hilo secundario está registrando los eventos en paralelo...", 20.0, screen_height() - 40.0, 18.0, DARKGRAY);
        draw_text("Controles: FLECHA ARRIBA / FLECHA ABAJO", 20.0, screen_height() - 20.0, 18.0, GRAY);

        // --------------------------------------------------------------------
        // FASE D: SINCRONIZACIÓN ASÍNCRONA COOPERATIVA
        // --------------------------------------------------------------------
        next_frame().await;
    }
}
```

*🧠 Resumen didáctico de la arquitectura de este código:*

El Emisor (tx): Viaja dentro del bucle asíncrono (macroquad). Cada vez que la pelota colisiona, mete un texto en la tubería y sigue renderizando.

El Receptor (rx): Está en posesión exclusiva de un hilo nativo fuera del juego. Bloquea su propio flujo temporal ejecutando la espera lenta de thread::sleep, pero como pertenece a un núcleo distinto o un hilo independiente, la pantalla principal ni se entera.

Seguridad Absoluta: Rust garantiza mediante tipos que el canal se mantendrá íntegro y que el trasvase de hilos no provocará corrupciones de memoria.

== Ejercicios propuestos
Para evaluar la asimilación del contenido, te proponemos modificar el código base añadiendo alguna de estas características:

- Incremento de dificultad: Hacer que la velocidad de la pelota aumente gradualmente cada vez que golpee la barra.

- Integración Web/Concurrente (Opcional): Usar hilos para guardar la puntuación más alta en un archivo en segundo plano sin congelar los gráficos del juego.

== Desafío propuesto para el alumno (Personalización e integración)
Una vez que el motor base funciona de forma estable, puedes aplicar los conceptos avanzados estudiados a lo largo de los cuadernos de Rust para expandir las capacidades del videojuego.

Se propone el siguiente desafío:

- Enemigo Automatizado (IA Simple): Añade una segunda pala en el extremo derecho de la pantalla controlada por el juego. Puedes programar una lógica básica que compare la coordenada y de la pelota con la coordenada y de la pala enemiga para que esta se desplace hacia arriba o hacia abajo intentando interceptarla.


#pagebreak()