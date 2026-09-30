fn volumen_cubo(lado: f64) -> Option<f64> {
    if lado < 5.0 {
        // no válido
        return None;
    }

    // resultado válido envuelto en Some()
    let volumen =  lado * lado * lado;
    Some(volumen)
}

fn main(){
    let resultado_opt = volumen_cubo(6.0); // Devuelve Option<f64>

    match resultado_opt {
        Some(vol) => println!("¡Éxito! El volumen extraído es {} m³", vol),
        None => println!("Error: El lado indicado no era válido para calcular el volumen."),
    }
}