fn main() {
    // 1. Como control de flujo general
    let numero = 2;
    match numero {
        1 => println!("Es uno"),
        2 | 3 => println!("Es dos o tres"),
        _ => println!("Es cualquier otro número"), // Es como el "else" 
    }

    // 2. Para desempaquetar un Option
    let opcional = Some(1);
    match opcional {
        Some(dato) => println!("El valor interno es: {}", dato),
        None => println!("No hay ningún valor"),
    }
}