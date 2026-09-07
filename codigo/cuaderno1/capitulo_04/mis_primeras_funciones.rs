// 1. Fabricamos nuestra primera función propia
// Esta función no necesita datos, solo ejecuta una acción visual
fn saludar_alumno() {
    println!("👋 ¡Hola, Alumno de Rust!");
    println!("🚀 Bienvenido a tu zona de entrenamiento.");
}

// 2. Fabricamos una función que hace un cálculo matemático
// Le pedimos que nos multiplique un número por 2
fn duplicar_numero(numero: i32) {
    let resultado = numero * 2;
    println!("🔢 El doble de {} es: {}", numero, resultado);
}
// 3. Una función con DOS ingredientes para sumar
fn sumar_numeros(a: i32, b: i32) {
    let resultado = a + b;
    println!("➕ La suma de {} + {} es: {}", a, b, resultado);
}

fn main() {
    println!("🏁 El programa principal (main) se ha iniciado.\n");

    // 💡 LLAMADA A LAS FUNCIONES: Aquí despertamos a nuestras recetas
    saludar_alumno(); // El ordenador salta al código de la función
    
    println!("\n--- Haciendo cálculos en el laboratorio ---");
    
    duplicar_numero(10); // Le pasamos el número 10 como ingrediente
    duplicar_numero(50); // Reutilizamos la misma función con otro dato
    
    println!("\n🔚 El programa principal va a terminar.");
    sumar_numeros(3, 4); // Pasamos los ingredientes correctos
    
        // ❌ Error provocado para el laboratorio:
        // sumar_numeros(3.2, 4); 
}