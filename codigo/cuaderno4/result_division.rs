// Ejemplo de división segura
fn dividir(dividendo: f64, divisor: f64) -> Result<f64, String> {
    if divisor == 0.0 {
        Err(String::from("No se puede dividir por cero."))
    } else {
        Ok(dividendo / divisor)
    }
}

fn main() {
    match dividir(10.0, 2.0) {
        Ok(resultado) => println!("Resultado: {}", resultado),
        Err(error) => println!("Ocurrió un error: {}", error),
    }
}