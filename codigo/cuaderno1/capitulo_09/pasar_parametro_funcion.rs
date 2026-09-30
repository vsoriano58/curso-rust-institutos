fn solo_lectura(texto: &String) {
    println!("Leemos sin alterar: {}", texto);
}

fn modificacion(texto: &mut String) {
    texto.push_str(" modificado");
}

fn toma_propiedad(texto: String) {
    println!("Tengo la propiedad de: {}", texto);
} // <-- Aquí se hace drop de 'texto'

fn main() {
    let mut mi_cadena = String::from("Datos");

    // Préstamo inmutable (conservo propiedad de mi_cadena)
    solo_lectura(&mi_cadena);

    // Préstamo mutable (conservo propiedad y modifico mi_cadena)      
    modificacion(&mut mi_cadena);

    // Move o Transferencia de propiedad de mi_cadena a la función 
    // Después de esta instrucciñon mi_cadena ya no existe 
    toma_propiedad(mi_cadena);      

    // ⬇️  ❌ --- error: mi_cadena fue destruida en la función.
    // println!("{}", mi_cadena); 
}