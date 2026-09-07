use image::{GenericImage, Rgb};

fn main() {
    // 1. Cargamos la imagen original abriendo la caja con permiso de mutación (mut)
    // Necesitamos 'mut' porque vamos a alterar sus píxeles.
    let mut imagen = image::open("lena.jpg")
        .expect("¡Error! No se encuentra el archivo lena.jpg");

    println!("🎨 Modificando la imagen... Dibujando zona de pruebas.");

    // El color rojo en formato RGB se compone de: Máximo Rojo (255), Cero Verde (0), Cero Azul (0)
    let color_rojo = Rgb([255, 0, 0]);

    // 2. Usamos dos bucles anidados para recorrer un área de 11x11 píxeles
    // El contador 'x' irá desde 95 hasta 105 (11 posiciones en total)
    for x in 95..=105 {
        // Por cada posición de 'x', el contador 'y' también se mueve de 95 a 105
        for y in 95..=105 {
            // Pintamos el píxel actual con nuestro color rojo
            imagen.put_pixel(x, y, image::Pixel::from_channels(255, 0, 0, 255));
        }
    }

    // 3. Guardamos el resultado en el disco duro con un nombre nuevo
    imagen.save("lena_modificada.png")
        .expect("No se pudo guardar la imagen modificada");

    println!("💾 ¡Éxito! Archivo 'lena_modificada.png' guardado en la carpeta de tu proyecto.");
}