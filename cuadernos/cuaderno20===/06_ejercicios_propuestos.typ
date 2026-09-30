= Ejercicios propuestos
Para evaluar la asimilación del contenido, se le propone al estudiante modificar el código base añadiendo alguna de estas características:

- Incremento de dificultad: Hacer que la velocidad de la pelota aumente gradualmente cada vez que golpee la barra.

- Integración Web/Concurrente (Opcional): Usar hilos para guardar la puntuación más alta en un archivo en segundo plano sin congelar los gráficos del juego.

= Desafíos propuestos para el alumno (Personalización e integración)
Una vez que el motor base funciona de forma estable, el alumno debe aplicar los conceptos avanzados estudiados a lo largo de los cuadernos de Rust para expandir las capacidades del videojuego.

Se proponen los siguientes tres desafíos individuales:

- Sistema de Marcador Estático: Crea una variable mutable o estructura para llevar el conteo de los puntos. Utiliza draw_text para mostrar la puntuación en la parte superior de la pantalla y aumenta el contador cada vez que la pelota rebote con éxito en la pala del jugador.

- Enemigo Automatizado (IA Simple): Añade una segunda pala en el extremo derecho de la pantalla controlado por el juego. Puedes programar una lógica básica que compare la coordenada y de la pelota con la coordenada y de la pala enemiga para que esta se desplace hacia arriba o hacia abajo intentando interceptarla.

- Concurrencia para Efectos de Sonido o Logs (Opcional Avanzado): Utiliza los conceptos de canales (mpsc) aprendidos en los módulos previos para enviar mensajes desde el bucle principal hacia un hilo secundario de logs cada vez que ocurra una colisión o se marque un punto, evitando que las operaciones de entrada/salida bloqueen el flujo gráfico principal.

```rust
// Pista para el alumno (Estructura del marcador)
struct Marcador {
    puntos_jugador: u32,
    puntos_ia: u32,
}

// Ejemplo de cómo pintar el texto en el bucle principal:
// draw_text(&format!("Puntos: {}", marcador.puntos_jugador), 40.0, 40.0, 30.0, WHITE);
```

¿Deseas que preparemos la plantilla de soluciones detalladas para alguno de los desafíos propuestos (como la IA del rival o el sistema de puntuación), o prefieres dar por cerrado el temario del Cuaderno 5?