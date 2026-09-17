// src/operaciones.rs

// Devuelve la suma de dos números flotantes
pub fn sumar(a: f64, b: f64) -> f64 {
    a + b // Expresión: devuelve el resultado directamente
}

/// Devuelve la resta de dos números flotantes
pub fn restar(a: f64, b: f64) -> f64 {
    a - b
}

/// Calcula la potencia de una base elevada a un exponente entero.
pub fn calcular_potencia(base: f64, exponente: i32) -> f64 {
    base.powi(exponente)
}

/// Calcula el factorial de un número entero de forma iterativa.
pub fn calcular_factorial(n: u64) -> u64 {
    let mut resultado = 1;
    for i in 1..=n {
        resultado *= i;
    }
    resultado
}