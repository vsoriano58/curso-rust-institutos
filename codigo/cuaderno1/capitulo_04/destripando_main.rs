fn main() {
    // En Rust, la orden para mostrar texto en pantalla lleva un signo de exclamación: println!()
    println!("Esto funciona perfectamente");

    // ¿Qué pasa si olvidamos el punto y coma al terminar la orden?
    println!("Esto dará un fallo")  // ❌ <--- error, no funcionará
    
    // ¿Qué pasa si escribimos mal el nombre de la función?
    print_pantalla!("Hola");        // ❌ <--- error, no funcionará
}