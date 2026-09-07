fn main() {
    // Al añadir la palabra 'mut', le ponemos una etiqueta de "permitido cambiar" a la caja.
    let mut vidas = 3;
    println!("Empiezas la partida con {} vidas.", vidas);

    // Como la caja tiene el permiso 'mut', ahora sí podemos modificar su contenido:
    vidas = 2; 
    println!("¡Te ha tocado un enemigo! Ahora te quedan {} vidas.", vidas);

    // ⚠️ ¡Cuidado! Puedes cambiar el valor, pero NO el tipo de dato que guarda la caja:
    vidas = "cero"; // ❌ <--- error, no funcionará

    // Explicación: La caja 'vidas' se creó para guardar números enteros. 
    // No puedes meter texto dentro de una caja de números.
}