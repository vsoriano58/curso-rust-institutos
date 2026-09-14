#import "config.typ": *

= 📦 Colecciones de Datos: Colecciones de datos: Arrays y Vectores
Hasta ahora, nuestras variables eran como cajas individuales donde guardábamos un solo dato: un número, un texto o un booleano. Pero en la vida real, los programas manejan listas de cosas: las puntuaciones de una partida, los nombres de los alumnos de clase o los artículos de un inventario.

Para gestionar estas listas, Rust nos ofrece dos herramientas fundamentales: los *Arrays* y los *Vectores*.

== 🥊 Semejanzas y Diferencias: ¿Quién es quién?
Antes de verlos en código, hagamos una comparativa rápida para saber en qué se parecen y en qué se diferencian:

- Semejanzas: Ambos son colecciones *homogéneas*. Esto significa que todos los elementos de la lista tienen que ser obligatoriamente del mismo tipo de dato (todo números enteros, todo textos, etc.). No puedes mezclarlos. Además, en ambos casos el primer elemento de la lista está en la *posición 0*.

- Diferencias: La diferencia clave está *en el tamaño durante el programa y en cómo se alojan en la memoria del ordenador*. 

 - Un Array tiene un *tamaño fijo* que se decide al escribir el código y nunca puede cambiar. Se guarda en el Stack (una zona de la memoria ultra rápida). 

 - Un Vector tiene un *tamaño dinámico*: puede crecer o encogerse mientras el programa se ejecuta. Se guarda en el Heap (una zona de memoria más flexible).

*¿Para qué sirve cada uno?*

- Usarás un *Array* cuando sepas de antemano el *número exacto de elementos* que va a tener y éste *nunca vaya a cambiar* (por ejemplo: los 7 días de la semana, las 4 estaciones o las coordenadas X e Y de un punto).

- Usarás un Vector cuando la *lista sea totalmente impredecible* (por ejemplo: los enemigos que aparecen en pantalla, los mensajes de un chat o la lista de la compra de un usuario).

== 🗂️ Arrays: Listas con tamaño grabado a fuego

=== Creación y métodos más importantes

Para crear un array, encerramos los valores entre corchetes []. Rust nos permite declarar su tipo y su tamaño fijo con la sintaxis [tipo; tamaño]:

Veamos un par de ejemplos:

```rust
// Un array de 4 números flotantes f32
let temperaturas: [f32; 4] = [15.5, 22.1, 30.4, 18.2];

// Truco: Crear un array de 500 elementos todos cero
// Como hemos indicado nada, por defecto serán i32
let contador_ceros = [0; 500];

```
Los métodos y operaciones más importantes de un array son:
- Acceso por índice: temperaturas[0] nos da el primer elemento (15.5).
- Conocer su tamaño: El método .len() nos dice cuántos elementos tiene.
- Comprobar si está vacío: El método .is_empty() devuelve true o false.

Veamos un sencillo ejemplo:
```rust
fn main() {
    let temperaturas: [f32; 4] = [15.5, 22.1, 30.4, 18.2];
    println!("Primera temperatura: {}", temperaturas[0]);
    println!("Longitud del array temperaturas: {}", temperaturas.len());
    println!("¿Está vacío el array temperaturas?: {}", temperaturas.is_empty()); 
}
```
Ejecutando el programa en la Playground obtendrás el resultado:

```
Primera temperatura: 15.5
Longitud del array temperaturas: 4
¿Está vacío el array temperaturas?: false
```

=== Propiedad (Ownership) en los Arrays

En Rust, los tipos de datos simples (como números enteros, decimales y booleanos) tienen el rasgo Copy. Esto significa que cuando creas un array de números, los datos se copian fácilmente. Si pasas el array a otra variable, ambas variables seguirán funcionando de forma independiente. El array original no se destruye ni se "mueve".

=== 💻 Ejemplo Completo con Arrays

Imagina que queremos registrar las notas de los 3 trimestres de un alumno:

```rust
fn main() {
    // Creamos un array fijo de 3 elementos
    let notas_trimestre: [f32; 3] = [8.5, 9.0, 7.5];

    println!("Has cursado {} trimestres.", notas_trimestre.len());
    println!("La nota del segundo trimestre fue: {}", notas_trimestre[1]);
}

```

Si iIntentas acceder a notas_trimestre[4] hará que el compilador te lanzará un error porque sabe perfectamente que el array solo llega hasta el índice 2. ¡Seguridad ante todo!

== 🛍️ Vectores: La lista elástica

=== Creación y métodos más importantes

Los vectores se representan como *Vec<T>* (donde la T significa el tipo de dato que guardará). La forma más común e intuitiva de crearlos es usando el "atajo" o macro *vec!*:

```rust
// Un vector mutable de textos dinámicos
let mut mochila = vec![String::from("Linterna"), String::from("Cuerda")];

```
Como los vectores pueden cambiar de tamaño, tienen métodos específicos muy potentes:

- .push(valor): Añade un elemento al final de la lista.
- .pop(): Quita el último elemento de la lista y te lo devuelve.
- .insert(índice, elemento): Mete un elemento en la posición exacta (índice) que tú quieras, desplazando los demás.
- .remove(índice): Borra el elemento de esa posición (índice).
- [posicion]: Te permite cotillear qué hay en una posición concreta. (Recuerda: ¡En informática siempre empezamos a contar desde la posición 0!)

=== Propiedad (Ownership) en los Vectores

Aquí es donde Rust se pone serio. Un vector es dueño de los datos que contiene. Si tu vector guarda elementos complejos (como String), no puedes simplemente sacar un elemento asignándolo a otra variable, porque estarías intentando "mover" la propiedad de una parte interna del vector, y Rust no lo permite.

Para leer datos de un vector sin romper el programa, casi siempre utilizaremos referencias (&) (préstamos para mirar).

=== 💻 Ejemplo Completo con Vectores

Vamos a simular el inventario de un jugador en un videojuego de rol (RPG):

```rust
fn main() {
    // 1. Inicializamos la mochila con dos ítems. Debe ser mutable (mut) para añadir cosas
    let mut inventario = vec![String::from("Poción de vida"), String::from("Escudo de madera")];

    // 2. El jugador encuentra un objeto y lo guarda
    inventario.push(String::from("Espada de hierro"));

    // 3. Queremos mirar qué hay en la primera posición. 
    // ¡Usamos "&" para pedirlo prestado! Si no ponemos "&", Rust dará error.
    let primer_objeto = &inventario[0];
    println!("El primer objeto de tu inventario es: {}", primer_objeto);

    // 4. El jugador usa el último objeto que recogió (la espada)
    let objeto_usado = inventario.pop(); 
    // .pop() saca el elemento del vector, reduciendo su tamaño a 2.
    println!("Has usado: {:?}", objeto_usado); 

    println!("Artículos restantes en la mochila: {:?}", inventario);
}

```

=== Recorriendo el vector con bucles for
Ya sabes guardar datos en un vector y cómo extraer elementos sueltos. Pero el verdadero potencial de las colecciones aparece cuando quieres procesar toda la lista de golpe: aplicar un filtro, calcular una media o imprimir un listado de alumnos.

Para hacer esto de forma automática, sin escribir código fila por fila, usamos el bucle *for* combinado con un préstamo (*&*). Al poner el & antes del vector, le estamos diciendo a Rust: "Déjame mirar uno a uno los elementos de la lista, pero no destruyas el vector al terminar".

Mira qué limpio queda el código para pasar lista en clase:

```rust
fn main() {
  let alumnos = vec![
      String::from("Lucía"), 
      String::from("Marcos"), 
      String::from("Sofía")
  ];

  println!("--- CONTROL DE ASISTENCIA ---");
  // "alumno" es una variable temporal que tomará el valor de cada elemento en cada vuelta
  for alumno in &alumnos {
      println!("👤 Presente: {}", alumno);
  }
  
  // Como usamos "&alumnos", la lista sigue existiendo aquí perfectamente
  println!("Total de alumnos registrados: {}", alumnos.len());
}
```
💡 *¿Y si queremos modificar los elementos del vector mientras lo recorremos?*

¡Fácil! Usamos un préstamo mutable tanto en el bucle como en el vector (&mut). Por ejemplo, si quisiéramos sumarle un punto de bonificación a una lista de notas por buen comportamiento:

```rust
fn main() {
  let mut notas = vec![4.5, 6.0, 8.5];

  // Usamos &mut para tener permiso de escritura en cada nota
  // Ahora nota es una referncia por haber utilizado &mut
  for nota in &mut notas {
  
  // El asterisco (*) sirve para entrar "dentro" de la referencia
  // y cambiar el valor
  *nota += 1.0; 
  }

  // Imprime: [5.5, 7.0, 9.5]
  println!("Notas con el punto extra: {:?}", notas);
}
```

=== 🎮 Proyecto Intermedio: El Sistema de Puntuaciones de un Videojuego

Vamos a construir el motor de puntuaciones para un juego arcade. Nuestra misión es diseñar un programa que registre las puntuaciones de las partidas, calcule estadísticas y determine si un jugador ha superado el récord histórico.
Este proyecto te servirá para consolidar el uso de vectores, bucles, condicionales y funciones con referencias (préstamos).

🛠️ *El Reto Práctico*

Debes implementar un código en Rust que cumpla con los siguientes requisitos:

- Almacenar una lista dinámica con los puntos de las últimas partidas.
- Añadir nuevas puntuaciones a la lista simulando que se acaban de jugar esas partidas.
- Crear una función que calcule la puntuación media obtenida por el jugador.
- Crear una función que busque la puntuación más alta (el récord de la máquina).

💻 *Código Comentado*

Vamos a proporcionarte un código comentado que cumple con los requisitos del *Reto Práctico* propuesto.

Abre una terminal integrada en tu directorio de proyectos Rust y crea un proyecto nuevo con la orden:

```
cargo new puntuaciones_videojuego
```
Copia el código del listado que te damos a continuación en el fichero *src/main.rs*.

*Nota*: En el siguiente apartado titulado *Proyecto Final: La Agenda de Contactos por Terminal* se aplican conceptos muy similares a los que aplicaremos aquí y puede que estén explicados con mayor detalle. Así que si tienes alguna dificultad en este *Proyecto Intermedio*, investiga primero el siguiente apartado que es más complejo y luego vuelve aquí para entender éste.

 ⚙️ *Explicaciones sobre el listado*

Antes de inspeccionar el listado completo del programa, analicemos algunos fragmentos interesantes. 

- Veamos la función *calcular_media*:

```rust
// Función que recibe un préstamo del vector (solo lectura)
// y devuelve la media (f32)
fn calcular_media(puntuaciones: &Vec<i32>) -> f32 {
    if puntuaciones.is_empty() {
        return 0.0; // Si no hay partidas, la media es cero
    }
    
    let mut suma_total = 0;
    for puntos in puntuaciones {
        suma_total += puntos; // Sumamos los puntos de cada partida
    }
    
    // Convertimos a f32 para poder calcular decimales en la división
    suma_total as f32 / puntuaciones.len() as f32
}
```

Esta función recibe el argumento *puntuaciones* cuyo tipo debe ser &Vec<i32>, es decir, un préstamo inmutable de vector de elementos enteros. Al recibir un préstamo inmutable *&* solo podrá leer los elemtos del vector pero no modificarlos. No obstante, para calcular la media no necesita nada más. La función devuelve un f32.

Si el vector *puntuaciones* no tiene ningún valor, entonces *puntuaciones.is_empty()* devuelve true, el primer if se cumple y el *programa termina* con el return devolviendo 0.0 (un f32) 

El siguiente bloque de la función calcula *la suma de todos los elementos del vector puntuaciones*; ya veremos cuando llamemos la función qué argumento que le pasamos al parámetro puntuaciones. 

Veamos cómo funciona el bucle *for*:

```rust
let mut suma_total = 0;
for puntos in puntuaciones {
    suma_total += puntos; // Sumamos los puntos de cada partida
}
```

- Supongamos que el vector *puntuaciones* tiene tres valores: 200, 100 y 300.
- Antes de entrar al bucle for le hemos dado a la variable *suma_total* el valor 0.
- la priemra vez que la ejecución del programa entre en el for, *puntos* valdrá 200 y entonces:

suma_total = 0 + 200 = 200

- la segunda vez que entre en el for, *puntos* valdrá 100 y entonces:

suma_total = 200 + 100 = 300

- la tercera vez que entre en el for, *puntos* valdrá 300 y entonces:

 suma_total = 300 + 300 = 600, que representa la suma de los tres elementos.

Después del bucle for, la función calcula la *media de las puntuaciones* asignándole un tipo *f32*, que es lo que tiene que devolver la función. El código es este:

```rust
// Convertimos a f32 para poder calcular decimales en la división
suma_total as f32 / puntuaciones.len() as f32
```

Como *suma_total* es un entero y *puntuaciones.len()* es el número de elementos que tiene el vector es otro entero, si los dividimos tal cual obtendremos otro entero, es decir, se desprecian los decimales al hacer la división. Sin embargo, hemos dicho en la cabecera de la división que tenemos que devolver un *f32*

Las palabrsa *as f32* permite en ambos casos convertir en ambos casos las variables al tipo f32 y así efectuamos la división y obtenemos un f32 que es lo que tenemos que devolver.

Finalmente, como la última linea no termina en punto y coma, el resultado de evaluarla que no es más que la media de las puntuaciones es lo que devuelve la función.

- La función *obtener_record*:

Esta función se puede entender con las explicaciones dadas el la función *calcular_media* y las anotaciones en el cuerpo de la misma como vemos a continuación:

```rust
// Función que busca el récord del jugador
fn obtener_record(puntuaciones: &Vec<i32>) -> i32 {
    if puntuaciones.is_empty() {
        return 0;
    }

    // Empezamos asumiendo que la primera puntuación es la mayor
    let mut maximo = puntuaciones[0]; 

    // Si encontramos algún valor en puntuaciones que sea mayor
    // cambiaremos el valor anterior
    for puntos in puntuaciones {
        // El asterisco en *puntos es necesario para leer el valor de puntos
        // porque el vector puntuaciones es un préstamo &
        if *puntos > maximo {
            // Si encontramos una mayor, actualizamos el récord
            maximo = *puntos; 
        }
    }
    // Devolvemos el máximo encontrado
    maximo
}
```

- La función *main*
Aquí es donde realizamos, entre otras cosas, las llamadas a las funciones que hemos explicado antes. La vamos a explicar tambíen sobre el código comentado:

```rust
fn main() {
    // Creamos la tabla de puntuaciones vacía del jugador
    // Vec::new() es un vector que no tiene elementos todavía
    let mut mis_partidas: Vec<i32> = Vec::new();

    // Simulamos que el jugador termina 3 partidas en la máquina arcade
    // la instrucción:  mis_partidas.push(2500); introduce elvalor 2500
    // en el vector mis_partidas. Las siguientes instrucciones .push(valor)
    // añaden más elementos al vector.
    mis_partidas.push(2500);
    mis_partidas.push(4200);
    mis_partidas.push(1800);

    // Imprimimos el estado actual
    println!("🎮 Puntuaciones de la sesión: {:?}", mis_partidas);
    
    // Calculamos estadísticas llamando a nuestras funciones especializadas

    // Ejecutamos la función calcular_media y le pasamos como argumento
    // &mis_partidas, es decir, un préstamo del vector mis_partidas. Por tanto
    // la función calculará y devolverá la media de los valores que hemos
    // introducido antes en mis_partidas.
    let media = calcular_media(&mis_partidas);

    // Haz un razonamiento similar al anterior pero esta vez la función
    // calcula y devuelve el record de las puntuaciones 
    let record = obtener_record(&mis_partidas);

    println!("📊 Estadísticas del Jugador:");
    println!("   -> Puntuación Media: {:.2} puntos", media);
    println!("   -> Récord Actual: 🔥 {} puntos", record);

    // Simulamos una última partida espectacular
    let nueva_partida = 5000;
    println!("\n🚀 ¡Nueva partida terminada! Consigues {} puntos.", nueva_partida);
    
    if nueva_partida > record {
        println!("🎉 ¡BRUTAL! Has batido tu propio récord histórico.");
    }
    
    mis_partidas.push(nueva_partida);
}
```

📄 *Listado completo del programa*

*El Sistema de Puntuaciones de un Videojuego*

```rust
// Función que recibe un préstamo del vector (solo lectura) 
// de elementos enteros de 32 bits y devuelve la media (f32)
// que es un valor decimal de 32 bits
fn calcular_media(puntuaciones: &Vec<i32>) -> f32 {
    if puntuaciones.is_empty() {
        return 0.0; // Si no hay partidas, la media es cero
    }
    
    let mut suma_total = 0;
    for puntos in puntuaciones {
        suma_total += puntos; // Sumamos los puntos de cada partida
    }
    
    // Convertimos a f32 para poder calcular decimales en la división
    suma_total as f32 / puntuaciones.len() as f32
}

// Función que busca el récord del jugador
fn obtener_record(puntuaciones: &Vec<i32>) -> i32 {
    if puntuaciones.is_empty() {
        return 0;
    }

    // Empezamos asumiendo que la primera es la mayor
    let mut maximo = puntuaciones[0]; 

    // Si encontramos algún valor en puntuaciones que sea mayor
    // cambiaremos el valor anterior
    for puntos in puntuaciones {
        // El asterisco en *puntos es necesario para leer el valor de puntos
        // porque el vector puntuaciones es un préstamo &
        if *puntos > maximo {
            // Si encontramos una mayor, actualizamos el récord
            maximo = *puntos; 
        }
    }
    // Devolvemos el máximo encontrado
    maximo
}

fn main() {
    // Creamos la tabla de puntuaciones vacía del jugador
    let mut mis_partidas: Vec<i32> = Vec::new();

    // Simulamos que el jugador termina 3 partidas en la máquina arcade
    mis_partidas.push(2500);
    mis_partidas.push(4200);
    mis_partidas.push(1800);

    // Imprimimos el estado actual
    println!("🎮 Puntuaciones de la sesión: {:?}", mis_partidas);
    
    // Calculamos estadísticas llamando a nuestras funciones especializadas
    let media = calcular_media(&mis_partidas);
    let record = obtener_record(&mis_partidas);

    println!("📊 Estadísticas del Jugador:");
    println!("   -> Puntuación Media: {:.2} puntos", media);
    println!("   -> Récord Actual: 🔥 {} puntos", record);

    // Simulamos una última partida espectacular
    let nueva_partida = 5000;
    println!("\n🚀 ¡Nueva partida terminada! Consigues {} puntos.", nueva_partida);
    
    if nueva_partida > record {
        println!("🎉 ¡BRUTAL! Has batido tu propio récord histórico.");
    }
    
    mis_partidas.push(nueva_partida);
}
```

