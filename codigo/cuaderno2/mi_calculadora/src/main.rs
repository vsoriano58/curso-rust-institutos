// src/main.rs

// 1. Declaramos el módulo externo para que Rust sepa que existe
mod operaciones;

// 2. Traemos las funciones al entorno actual para usarlas
use operaciones::{sumar, restar, calcular_potencia, calcular_factorial};

fn main() {
    println!("=== CALCULADORA CIENTÍFICA MODULAR ===");

    // Ejemplo 1: Probando la suma (f64 + f64)
    let a = 2.0;
    let b = 3.0;
    let suma = sumar(a, b);
    println!("La suma de {} y {} es {}", a, b, suma);

    // Ejemplo 2: Probando la resta (f64 - f64)
    let c = 20.0;
    let d = 5.0;
    let resta = restar(c, d);
    println!("La resta de {} menos {} es {}", c, d, resta);

    // Ejemplo 3: Probando la potencia (f64 elevado a i32)
    let base = 2.5;
    let exp = 3;
    let potencia = calcular_potencia(base, exp);
    println!("La potencia de {} elevado a {} es: {}", base, exp, potencia);

    // Ejemplo 4: Probando el factorial (u64)
    let numero = 5;
    let factorial = calcular_factorial(numero);
    println!("El factorial de {}! es: {}", numero, factorial);
}
