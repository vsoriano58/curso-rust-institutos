fn volumen_cubo(lado: f64) -> Option<f64> {
    if lado < 5.0 {
        // no existe
        return None;
    }

    // resultado válido envuelto en Some()
    let volumen = lado * lado * lado;
    // Como es la última línea, aquí NO se usa 'return' ni punto y coma
    Some(volumen)
}

fn superficie_cubo(lado: f64) -> Result<f64, String> {
    if lado < 5.0 {
        // El return es obligatorio para salir corriendo de la
        // función AQUÍ mismo
        return Err(format!(
            "El lado ({}) es muy pequeño. Mínimo debe ser 5.0",
            lado
        ));
    }

    let superficie = 6.0 * lado * lado;
    // Como es la última línea, aquí NO se usa 'return' ni punto y coma
    Ok(superficie)
}

fn informe_cubo(lado: f64) -> Result<String, String> {
    // El '?' de la línea de abajo extrae el f64 del Ok() de la función superficie_cubo, si va bien. 
    // Si da Err, la función muere AQUÍ y devuelve ese Err de superficie_cubo.
    let sup = superficie_cubo(lado)?; 
    let vol = volumen_cubo(lado).ok_or("No se pudo calcular el volumen")?; 

    Ok(format!("Cubo de lado {}: Superficie de {} m² y Volumen de {} m³", lado, sup, vol))
}

fn main() {
    match informe_cubo(3.0){
        Ok(mensaje) => println!("{mensaje}"),
        Err(error) => println!("{error}")
    }
}
