// Nota: Requiere la dependencia 'csv = "1.3"' en Cargo.toml
use std::error::Error;
use std::fs::File;

fn calcular_promedio_csv() -> Result<f64, Box<dyn Error>> {
    // Abrimos el archivo de datos
    let archivo = File::open("datos.csv")?;
    
    // Inicializamos el lector de la librería externa 'csv'
    let mut lector = csv::Reader::from_reader(archivo);
    
    let mut suma = 0.0;
    let mut total_elementos = 0;

    // Iteramos por cada registro/fila del archivo de manera segura
    for resultado in lector.records() {
        let registro = resultado?;
        // Tomamos el primer valor de la fila (columna 0)
        if let Some(valor_texto) = registro.get(0) {
            let valor: f64 = valor_texto.trim().parse()?;
            suma += valor;
            total_elementos += 1;
        }
    }

    if total_elementos == 0 {
        return Ok(0.0);
    }

    Ok(suma / total_elementos as f64)
}

fn main() {
    match calcular_promedio_csv() {
        Ok(promedio) => println!("--- ANALIZADOR ESTADÍSTICO ---\nEl promedio del archivo es: {:.2}", promedio),
        Err(e) => println!("Error procesando el archivo CSV: {}", e),
    }
}

