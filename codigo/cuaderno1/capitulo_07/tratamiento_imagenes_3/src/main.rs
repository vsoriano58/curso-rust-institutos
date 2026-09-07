use image::{GenericImage, GenericImageView, Pixel};

fn main() {
    // 1. Cargamos la imagen original con permiso para modificarla (mut)
    let mut imagen = image::open("lena.jpg")
        .expect("¡Error! No se encuentra el archivo lena.jpg");

    // 2. Le preguntamos a Rust cuáles son las dimensiones de la foto
    let (ancho, alto) = imagen.dimensions();
    println!("📸 Imagen cargada correctamente (Tamaño: {} x {} píxeles).", ancho, alto);
    println!("⏳ Aplicando filtro negativo a toda la imagen... Esto puede tardar un par de segundos.");

    // 3. El gran escáner: recorremos todas las columnas (x) y todas las filas (y)
    for x in 0..ancho {
        for y in 0..alto {
            // Capturamos el píxel actual en esa coordenada
            let pixel_original = imagen.get_pixel(x, y);
            
            // Extraemos sus canales de color en formato de lista (Rojo, Verde, Azul, Alfa)
            let canales = pixel_original.to_rgba();
            
            // Calculamos el color invertido restando cada componente a 255
            let nuevo_rojo = 255 - canales[0];
            let nuevo_verde = 255 - canales[1];
            let nuevo_azul = 255 - canales[2];
            let alfa = canales[3]; // La transparencia la dejamos exactamente igual

            // Fabricamos el nuevo píxel con los colores calculados
            let nuevo_pixel = Pixel::from_channels(nuevo_rojo, nuevo_verde, nuevo_azul, alfa);

            // Inyectamos el nuevo píxel de vuelta en la imagen tapando el viejo
            imagen.put_pixel(x, y, nuevo_pixel);
        }
    }

    // 4. Guardamos la nueva obra de arte
    imagen.save("lena_negativo.png")
        .expect("No se pudo guardar la imagen modificada");

    println!("💾 ¡Filtro completado! Revisa el archivo 'lena_negativo.png'.");
}