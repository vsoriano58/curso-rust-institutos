#import "config.typ": *


= Proyecto Final de Ciclo - Tu Primer Videojuego Gráfico
Para este proyecto utilizaremos Macroquad, una librería de Rust increíblemente ligera que no requiere configuraciones complejas de sistemas operativos ni herramientas pesadas, ideal para los ordenadores del instituto.

Nota de configuración para el Cargo.toml: ?????

== Introducción al desarrollo de videojuegos con Macroquad.
Macroquad es una biblioteca minimalista y extremadamente ligera para el desarrollo de videojuegos en Rust. Su principal ventaja es que elimina la configuración compleja (boilerplate) y no requiere pesadas dependencias del sistema operativo, permitiendo compilar fácilmente para escritorio (Windows, Mac, Linux), móviles y entornos web (WebAssembly).

A diferencia de otros motores que imponen patrones arquitectónicos rígidos, Macroquad utiliza funciones directas y globales para renderizar figuras, procesar la entrada del teclado o ratón y gestionar el tiempo, lo que la convierte en la herramienta ideal para estudiantes que dan sus primeros pasos en el desarrollo gráfico con Rust.

Para empezar, solo necesitas añadir macroquad = "0.4" (o la versión actual) a tu archivo Cargo.toml. A continuación se muestra la estructura mínima para abrir una ventana:

cargo add macroquad

```rust
use macroquad::prelude::*;

#[macroquad::main("Mi Primer Juego")]
async fn main() {
    // Aquí inicializaremos las variables de nuestro juego antes de arrancar
    let color_fondo = LIGHTGRAY;

    loop {
        // Limpiamos la pantalla en cada fotograma
        clear_background(color_fondo);

        // Dibujamos un círculo azul en el centro de la pantalla
        draw_circle(screen_width() / 2.0, screen_height() / 2.0, 50.0, BLUE);

        // Sincroniza con el refresco de la pantalla (espera al siguiente frame)
        next_frame().await
    }
}
```

== El bucle principal de un juego (Game Loop)
El Game Loop (Bucle de Juego) es el corazón de cualquier videojuego. Se trata de un ciclo infinito que se ejecuta continuamente (idealmente 60 veces por segundo o más) y realiza tres tareas fundamentales en un orden estricto: Leer entradas (mandos, teclado), Actualizar lógica (mover personajes, calcular colisiones) y Dibujar en pantalla.

Macroquad gestiona este bucle mediante una función asíncrona (async/await) combinada con un ciclo loop. La llamada a next_frame().await al final del bucle es crucial: detiene la ejecución temporalmente para ceder el control al hardware gráfica, asegurando que el juego no consuma el 100% de la CPU de forma descontrolada y manteniendo una tasa de fotogramas suave y constante.

El siguiente ejemplo muestra cómo estructurar estas tres fases integrando el movimiento por teclado:

```rust
use macroquad::prelude::*;

#[macroquad::main("El Bucle de Juego")]
async fn main() {
    let mut x = screen_width() / 2.0;
    let y = screen_height() / 2.0;
    let velocidad = 5.0;

    loop {
        // 1. LEER ENTRADAS & 2. ACTUALIZAR LÓGICA
        if is_key_down(KeyCode::Left) {
            x -= velocidad;
        }
        if is_key_down(KeyCode::Right) {
            x += velocidad;
        }

        // 3. DIBUJAR
        clear_background(BLACK);
        
        draw_text("Mueve el cuadrado con izquierda/derecha", 20.0, 30.0, 20.0, WHITE);
        draw_rectangle(x - 20.0, y - 20.0, 40.0, 40.0, RED);

        next_frame().await
    }
}
```

== Desarrollo Guiado: Clon de Pong / Rust-Bird
Para consolidar lo aprendido, desarrollaremos una versión simplificada del clásico Pong. El juego requiere estructurar la lógica mediante el control de una pala (jugador), el movimiento automático de la pelota y la detección matemática de colisiones básicas (cajas delimitadoras de la pala y límites de la pantalla).

Este proyecto práctico demuestra cómo la seguridad y velocidad de Rust operan en un entorno interactivo en tiempo real:

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

#[macroquad::main("Rust Pong Simplificado")]
async fn main() {
    let mut jugador = Pala {
        x: 50.0,
        y: screen_height() / 2.0 - 40.0,
        ancho: 15.0,
        alto: 80.0,
        velocidad: 7.0,
    };

    let mut pelota = Pelota {
        x: screen_width() / 2.0,
        y: screen_height() / 2.0,
        radio: 8.0,
        vel_x: 5.0,
        vel_y: 5.0,
    };

    loop {
        // Entrada del Jugador
        if is_key_down(KeyCode::Up) && jugador.y > 0.0 {
            jugador.y -= jugador.velocidad;
        }
        if is_key_down(KeyCode::Down) && jugador.y < screen_height() - jugador.alto {
            jugador.y += jugador.velocidad;
        }

        // Movimiento de la pelota
        pelota.x += pelota.vel_x;
        pelota.y += pelota.vel_y;

        // Rebote en techo y suelo
        if pelota.y - pelota.radio < 0.0 || pelota.y + pelota.radio > screen_height() {
            pelota.vel_y = -pelota.vel_y;
        }

        // Rebote en pared derecha (Simulación de rival)
        if pelota.x + pelota.radio > screen_width() {
            pelota.vel_x = -pelota.vel_x;
        }

        // Colisión simple con la pala del Jugador
        if pelota.x - pelota.radio <= jugador.x + jugador.ancho
            && pelota.y >= jugador.y
            && pelota.y <= jugador.y + jugador.alto
        {
            pelota.vel_x = -pelota.vel_x;
            pelota.x = jugador.x + jugador.ancho + pelota.radio; // Evita atascarse
        }

        // Reinicio si sale por la izquierda (Derrota)
        if pelota.x < 0.0 {
            pelota.x = screen_width() / 2.0;
            pelota.y = screen_height() / 2.0;
            pelota.vel_x = 5.0;
        }

        // Renderizado
        clear_background(DARKGRAY);
        
        // Dibujar pala y pelota
        draw_rectangle(jugador.x, jugador.y, jugador.ancho, jugador.alto, WHITE);
        draw_circle(pelota.x, pelota.y, pelota.radio, YELLOW);

        next_frame().await
    }
}
```



== 3.3. Desarrollo Guiado: Un clon de Pong simplificado
Vamos a programar una versión básica de Pong donde controlamos una barra que debe rebotar una pelota para evitar que caiga.Código del juego (src/main.rs):

```rust
use macroquad::prelude::*;

#[macroquad::main("Mi primer juego en Rust")]
async fn main() {
    // Variables de la pelota
    let mut bola_x = screen_width() / 2.0;
    let mut bola_y = screen_height() / 2.0;
    let mut velocidad_x = 4.0;
    let mut velocidad_y = 4.0;
    let radio_bola = 15.0;

    // Variables de la barra del jugador
    let ancho_barra = 120.0;
    let alto_barra = 20.0;
    let mut barra_x = (screen_width() - ancho_barra) / 2.0;
    let barra_y = screen_height() - 40.0;
    let velocidad_barra = 7.0;

    let mut puntuacion = 0;

    // --- EL BUCLE PRINCIPAL del juego ---
    loop {
        // 1. Entrada de usuario
        if is_key_down(KeyCode::Left) && barra_x > 0.0 {
            barra_x -= velocidad_barra;
        }
        if is_key_down(KeyCode::Right) && barra_x < screen_width() - ancho_barra {
            barra_x += velocidad_barra;
        }

        // 2. Actualizar lógica del juego
        bola_x += velocidad_x;
        bola_y += velocidad_y;

        // Rebote en paredes laterales
        if bola_x - radio_bola < 0.0 || bola_x + radio_bola > screen_width() {
            velocidad_x = -velocidad_x;
        }
        // Rebote en el techo
        if bola_y - radio_bola < 0.0 {
            velocidad_y = -velocidad_y;
        }

        // Colisión con la barra del jugador
        if bola_y + radio_bola >= barra_y 
            && bola_x >= barra_x 
            && bola_x <= barra_x + ancho_barra 
        {
            velocidad_y = -velocidad_y;
            puntuacion += 1;
        }

        // Condición de derrota (La pelota cae al fondo)
        if bola_y > screen_height() {
            // Reiniciar juego
            bola_x = screen_width() / 2.0;
            bola_y = screen_height() / 2.0;
            puntuacion = 0;
        }

        // 3. Dibujar en la pantalla
        clear_background(DARKGRAY);

        // Dibujar Pelota
        draw_circle(bola_x, bola_y, radio_bola, WHITE);

        // Dibujar Barra
        draw_rectangle(barra_x, barra_y, ancho_barra, alto_barra, RED);

        // Dibujar Puntuación
        draw_text(&format!("Puntos: {}", puntuacion), 20.0, 40.0, 30.0, GREEN);

        // Espera al siguiente fotograma (mantiene los 60 FPS)
        next_frame().await
    }
}
```