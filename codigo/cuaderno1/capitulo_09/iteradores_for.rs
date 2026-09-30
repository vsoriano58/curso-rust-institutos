fn main() {
    // Definimos un vector de tres elementos
    let mut numeros = vec![10, 20, 30];
    
    // A) Préstamo inmutable
    for num in &numeros {           // num es &i32
        // num es una referencia pero println!() imprime
        // el valor almacenado en la referencia.
        println!("Varlor referenciado: {}", num);
        
        // También podemos imprimir el valor 
        // almacenado en la referencia con:
         println!("Valor: {}", *num);
    }
    
    // B) Préstamo mutable
    for num in &mut numeros {       // num es &mut i32
        *num += 1;  // Modificamos el valor desreferenciando
        println!("Elemento modificado: {}", num);
    }
    
    // C) Move (Consumo total)
    for num in numeros {            // num es i32
        println!("Elemento propio: {}", num); 
    }
    
    // ⬇️ ❌ -- ERROR: numeros ya no existe
    // println!("{:?}", numeros);
}
