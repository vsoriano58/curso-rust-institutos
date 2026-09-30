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
        }

        // Reinicio del punto si la pelota cruza el límite izquierdo (Punto perdido)
        if pelota.x < 0.0 {
            pelota.x = screen_width() / 2.0;
            pelota.y = screen_height() / 2.0;
            pelota.vel_x = 4.0; // Restablece dirección inicial
        }

        // --------------------------------------------------------------------
        // FASE C: RENDERIZADO (Dibujo Gráfico)
        // --------------------------------------------------------------------
        clear_background(BLACK); // Borra el fotograma anterior aplicando fondo negro

        // Pintamos los elementos activos en la pantalla
        draw_rectangle(jugador.x, jugador.y, jugador.ancho, jugador.alto, WHITE);
        draw_circle(pelota.x, pelota.y, pelota.radio, YELLOW);

        // Mensaje instruccional estático para el alumno
        draw_text("Controles: FLECHA ARRIBA / FLECHA ABAJO", 20.0, 30.0, 20.0, GRAY);

        // --------------------------------------------------------------------
        // FASE D: SINCRONIZACIÓN ASÍNCRONA COOPERATIVA
        // --------------------------------------------------------------------
        // Pausamos la ejecución de este hilo temporalmente. El runtime interno 
        // de Macroquad toma el control para refrescar la ventana gráfica. 
        // Cuando el hardware está listo, el bucle despierta de forma inmediata.
        next_frame().await;
    }
}
    

