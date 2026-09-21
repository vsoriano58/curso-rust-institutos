// Ejemplo de división segura
fn dividir(dividendo: f64, divisor: f64) -> Result<f64, String> {
    if divisor == 0.0 {
        Err(String::from("No se puede dividir por cero."))
    } else {
        Ok(dividendo / divisor)
    }
}

fn main() -> Result<(), String>{
   let resultado = dividir(10.0, 10.0)?;
   println!("El resultado es: {resultado}");
   Ok(())
}