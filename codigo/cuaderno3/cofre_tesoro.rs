fn main() {
    let cofre_tesoro: Option<String> = Option::Some(String::from("Espada Excalibur"));
    
    if let Option::Some(arma) = cofre_tesoro {
        println!("🎁 ¡Has abierto un cofre y has encontrado una {}!", arma);
    } else {
        println!("💨 El cofre estaba completamente vacío.");
    }
}