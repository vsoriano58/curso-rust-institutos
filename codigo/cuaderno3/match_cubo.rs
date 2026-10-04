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

fn main() {
    let resultado_vol = volumen_cubo(6.0); // Devuelve Option<f64>
    match resultado_vol {
        Some(vol) => println!("¡Éxito! El volumen extraído es {} m³", vol),
        None => println!("Error: El lado indicado no era válido para calcular el volumen."),
    }
  
    let resultado_sup = superficie_cubo(4.0); // Devuelve Result<f64, String>
    match resultado_sup {
        Ok(sup) => println!("La superficie calculada es {} m²", sup),
        Err(mensaje_error) => println!("Fallo en el cálculo: {}", mensaje_error),
    }
}
