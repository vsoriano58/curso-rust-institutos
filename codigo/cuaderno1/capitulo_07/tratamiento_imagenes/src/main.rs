use image::GenericImageView; // Importamos la herramienta para mirar imágenes

fn main() {
    // 1. Intentamos abrir la imagen de tu disco duro
    let imagen = image::open("entrada.jpg").expect("❌ ¡No encuentro el archivo entrada.jpg!");

    // 2. Le preguntamos sus dimensiones (Ancho y Alto)
    let (ancho, alto) = imagen.dimensions();
    println!("📸 Imagen cargada con éxito. Tamaño: {}x{} píxeles.", ancho, alto);

    // 3. Inspeccionamos las coordenadas de un píxel concreto (Fila 100, Columna 100)
    let pixel = imagen.get_pixel(100, 100);

    // 4. Mostramos sus componentes de color RGB
    println!("🎨 El píxel en (100,100) tiene los valores: RGBA -> {:?}", pixel);
}