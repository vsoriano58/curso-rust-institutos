= Ejercicios resueltos

== ENUNCIADOS

=== Ejercicio 1: Expresiones vs. Sentencias

*Enunciado:* Crea una función llamada *calcular_area_rectangulo* que reciba la base y la altura del rectángulo(ambos de tipo f64) y devuelva el área. Aprovecha la característica de Rust de devolver el valor de la última línea como una expresión (sin usar la palabra clave return ni punto y coma). Luego, llámala desde el main.

=== Ejercicio 2: El peligro del Movimiento (Move) con Strings

*Enunciado:* Intenta pasar una variable de tipo String a una función que simplemente imprima su contenido. Después de llamar a la función, intenta imprimir la variable de nuevo en el main. Observa el error de compilación por la regla del propietario único y arréglalo haciendo que la función reciba una referencia (préstamo) en lugar de tomar el ownership.

=== Ejercicio 3: Préstamos Mutables (&mut)

*Enunciado:* Escribe una función llamada *duplicar_puntuacion* que reciba una referencia mutable a un número entero (*&mut i32*) e incremente su valor multiplicándolo por dos. Modifica el valor dentro de la función y muestra el resultado final desde el main.

=== Ejercicio 4: Inicialización y Lectura de Arrays

*Enunciado:* Crea un array de tamaño 5 que contenga las temperaturas de los últimos 5 días (valores f32). Escribe un programa que acceda e imprima la primera y la última temperatura de la lista de forma manual, y que muestre el tamaño total del array utilizando uno de sus métodos nativos.

=== Ejercicio 5: Trabajando con Vectores Dinámicos

*Enunciado:* Crea un vector vacío de números enteros. Añade dinámicamente los números del 10 al 30 (de 10 en 10) utilizando el método correspondiente. Finalmente, utiliza un bucle simple para recorrer el vector e imprimir cada elemento multiplicado por 100.

=== Ejercicio 6: Casting de tipos

*Enunciado*: Considera los vectores de enteros *let num = [10, 20, 30, 40, 50];* y *let den = [1, 2, 3, 4, 5];*. Calcula un vector de tipo [f32; 5] cuyo elemnto i sea el cociente entre el elemento i del vector *num* y el elemento i del vector *den.*

#pagebreak()

== SOLUCIONES
=== Ejercicio 1: Expresiones vs. Sentencias

```rust
fn calcular_area_rectangulo(base: f64, altura: f64) -> f64 {
    base * altura // Expresión: sin punto y coma para retornar el valor
}

fn main() {
    let b = 5.5;
    let a = 10.0;
    let area = calcular_area_rectangulo(b, a);
    println!("El área del rectángulo es: {}", area);
}
```
*Explicación:* Este ejercicio demuestra la diferencia fundamental entre una sentencia (que realiza una acción y termina en ;) y una expresión (que evalúa un valor). Al omitir el punto y coma en la última línea *base `*` altura*, Rust entiende automáticamente que ese es el valor que la función debe retornar a quien la llame.

=== Ejercicio 2: El peligro del Movimiento (Move) con Strings

*Código con error*

```rust
fn imprimir_mensaje(mensaje: String) {
    println!("El mensaje copiado es: {}", mensaje);
}

fn main() {
    // la variable texto es propietaria del dato "Hola, Rustaceo"
    let texto = String::from("Hola, Rustaceo");
    
    // Pasamos la variable texto a la función
    // La propiedad del dato se mueve a la función
    imprimir_mensaje(texto); 
    
    // ⬇️  ❌ --- error, no compilará, la variable texto ya no existe
    println!("El texto original sigue vivo: {}", texto);
}
```

*Código (Solución corregida):*

```rust
fn imprimir_mensaje(mensaje: &String) {
    println!("El mensaje copiado es: {}", mensaje);
}

fn main() {
    let texto = String::from("Hola, Rustaceo");
    
    // Pasamos una referencia (&) para prestar el dato sin perder la propiedad
    imprimir_mensaje(&texto); 
    
    // Como solo lo prestamos antes, todavía podemos usarlo aquí
    println!("El texto original sigue vivo: {}", texto);
}

```
*Explicación:* Si pasamos texto sin el ampersand (&), la función *imprimir_mensaje* se convertie en la dueña del String, destruyéndolo al terminar su ejecución. Al usar *&String*, realizamos un "préstamo" (borrowing), lo que permite al main retener la propiedad del dato y seguir usándolo después.

=== Ejercicio 3: Préstamos Mutables (&mut)

```rust
fn duplicar_puntuacion(puntuacion: &mut i32) {
    // Usamos el asterisco (*) para desreferenciar y modificar el valor real
    *puntuacion *= 2;   // *puntuacion = *puntuacion * 2
}

fn main() {
    let mut record = 150;   // La variable original DEBE ser mutable
    
    duplicar_puntuacion(&mut record);   // Pasamos la referencia mutable
    
    println!("El nuevo récord es: {}", record);
}

```

*Explicación:* Para poder modificar un dato del main con una función y que la modificación sea visible desde el main, necesitamos pasar a la función una referencia o préstamo mutable (&mut) del dato. Dentro de la función, utilizamos el operador de desreferenciación (`*`) para acceder directamente al valor guardado (`*`puntuacion) en la dirección de memoria apuntada por la referencia y poder modificarlo.

Como pasamos un préstamo, después de la llamada a la función el dato 'record'no se destruye, podemos acceder a él e imprimirlo.

=== Ejercicio 4: Inicialización y Lectura de Arrays

```rust
fn main() {
    // Array con tamaño grabado a fuego (5 elementos)
    let temperaturas: [f32; 5] = [18.5, 19.2, 21.0, 17.8, 16.4];
    
    let primera = temperaturas[0];

    // [temperaturas.len() nos da la longitud
    let ultima = temperaturas[temperaturas.len() - 1]; 
    
    println!("Primera temperatura: {}°C", primera);
    println!("Última temperatura: {}°C", ultima);
    println!("Se han registrado un total de {} días.", temperaturas.len());
}

```

*Explicación:* Los arrays en Rust tienen una longitud fija que se conoce en tiempo de compilación. En este ejercicio vemos cómo acceder a sus elementos mediante *índices* (empezando desde 0) y cómo utilizar el método nativo *.len()* para obtener dinámicamente la cantidad de elementos almacenados.

=== Ejercicio 5: Trabajando con Vectores Dinámicos

```rust
fn main() {
    // Creamos un vector mutable vacío
    let mut puntuaciones = Vec::new();
    
    // Añadimos elementos dinámicamente
    // (durante la ejecución del programaa)
    puntuaciones.push(10);
    puntuaciones.push(20);
    puntuaciones.push(30);
    
    // Recorremos el vector con un préstamo del vector en el bucle for
    for valor in &puntuaciones {
        println!("Valor amplificado: {}", valor * 100);
    }

    println!("El vector 'puntuaciones' sigue activo: {:?}", puntuaciones)
}
```

*Explicación:* A diferencia de los arrays, los vectores (Vec) pueden crecer o encogerse en tiempo de ejecución. El método *.push(*) añade elementos al final de la colección. En el bucle for, usamos *&puntuaciones* para recorrer los elementos mediante préstamos, evitando así que el bucle consuma (destruya) el vector.

Podemos conprobar al final que el vector *puntuaciones* sigue activo y lo podemos imprimir. Utilizamos el marcador *{:?}* porque el vector es un dato compuesto y no podemos imprimirlo con *{}*.

=== Ejercicio 6: Casting de tipos

```rust
fn main() {
    let num = [10, 20, 30, 40, 50];
    let den = [1, 2, 3, 4, 5];
    
    let mut resultados = [0f32; 5];
    
    for i in 0..5 {
        resultados[i] = num[i] as f32 / den[i] as f32;
    }
    
    println!("El resumtado es: {:?}", resultados)
}
```

*Explicación:* Inicializamos el vector *resultados* con todos sus elementos a cero y de tipo f32. Como los vectores *num* y *den* son de numeros enteros, por defecto i32, tenemos que convertirlos mediante *as f32* al realizar las divisiones para que los cocientes sean también de tipo f32.