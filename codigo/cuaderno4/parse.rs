fn main() {
    let texto_numero = String::from("42");
    
    // El compilador infiere que queremos un i32 gracias
    // a la anotación de tipo
    let numero: Result<i32, _> = texto_numero.parse();
    
    match numero {
        Ok(n) => println!("El número {} multiplicado por 2 es: {}", n, n * 2),
        Err(_) => println!("No se pudo convertir la cadena a número."),
    }
}