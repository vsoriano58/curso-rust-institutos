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