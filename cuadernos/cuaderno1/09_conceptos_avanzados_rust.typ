#import "config.typ": *

= Conceptos avanzados en Rust

Hemos querido llegar hasta el final del Cuaderno 1 para introducir algunos conceptos que son fundamentales en Rust y que a su vez lo diferencian de otros lenguajes de programación.

Rust basa la seguridad en la memoria en el concepto de  *ownership / borrowing*, que podemos traducir como *propiedad / prestamo o referencia*.

El concepto de propiedad es una especie de simil que se aplica a variables que son propietarias del dato que contienen y el de préstamo o referencia a variables que toman prestado el dato. Como veremos a continuación, las consecuencias que se derivan en ambos casos son diferentes.

Las variables propietarias son las encargadas de liberar la memoria que ocupa su dato cuando éste ya no se necesita.

*Primera identificación visual*

En los programas veremos frecuentemente reprsentados estos tipos de variables como se muestra a continuación. Para crear una referencia se utilza el operador *`&`*:

🖥️ Ejecuta el siguiente programa en la Playground.

```rust
fn main() {
    // variable propietaria (variable normal)
    let nombre = String::from("Antonio");
    
    // préstamo o referencia a la variable 'nombre'
    let ref_nombre = &nombre;

    // Podemos acceder a la variale 'nombre' a través de una referencia
    println!("{}", ref_nombre);     // Antonio

    // <--- Aquí la variable 'nombre' sigue activa
}   // <--- Al llegar a la llave de cierre, 'nombre' es destruida por Rust
```
Cuando la ejecución del programa llega a la *llave de cierre del main*, la variable *nombre* es destruida por Rust y se *libera la memoria* que tenía reservada para almacenar el string. Decimos entonces que *nombre* sale de su contexto. El *contexto de nombre* abarca desde su definición hasta la siguiente llave de cierre.

Esta liberación de memoria es fundamental para que las posteriores operaciones sobre la memoria sean seguras.

Las *referencias* o *préstamos* mántienen siempre esa *dualidad conceptual*.

El *Concepto de préstamo* se fundamenta en que a través de *ref_nombre* en el programa anterior, podemos acceder a la variable original *nombre* pero la liberación de la memoria es siempre obra de la variable original. Por eso decimos que la referencia *ref_nombre* tiene un préstamo del dato.

El *Concepto de Referencia* (Dirección de Memoria y Desreferenciación)

Para explicar qué es una referencia, podemos combinar la idea del "préstamo" con la realidad física de la memoria.

Una *referencia* (`&`) suele definirse intuitivamente como un "préstamo" de datos, pero a nivel físico es algo más preciso: representa la *dirección inicial de memoria* donde reside una variable. 

Al crear una referencia, no duplicamos el contenido del dato, sino que apuntamos a su ubicación original. Para realizar el camino inverso y acceder directamente al valor contenido en esa dirección de memoria, utilizamos el operador de *desreferenciación* (`*`).

#box(fill: rgb("f0f4f8"), inset: 10pt, radius: 4pt, width: 100%)[
  *Idea clave:* Una referencia es una dirección de memoria que apunta a un dato. El operador `*` sigue esa dirección para leer o modificar el valor real.
]

🖥️ Ejecuta el siguiente programa en la Playground.

```rust
fn main() {
    // original es propietaria del dato 42
    let original = 42;

    // Guarda la dirección de memoria de 'original'  
    let referencia = &original; 

    // Para acceder al valor apuntado, usamos el operador de
    // desreferenciación (*)
    let valor_copiado = *referencia; 

    println!("Dirección apuntada (referencia): {:p}", referencia);
    println!("Valor desreferenciado: {}", valor_copiado);   // 42

    println!("Valor de referencia: {}", referencia);        // 42
}
```

- Decimos que la variable *referencia* toma prestado el dato 42.
- Utilizamos el marcador *{:p}* para imprimir una dirección de memoria.
- Obtenemos el valor de la variable *original* mediante el operador *`*`*:
```rust
let valor_copiado = *referencia; 
```
Sie embargo, la siguiente instrucción imprime el valor de la variable original sin utilizar el operador *`*`*:
```rust
println!("Valor de referencia: {}", referencia);        // 42
```
Esto es consecuencia de que la macro *println!()* interpreta por defecto que cuando le pasamos una dirección, lo que queremos en realidad es que imprima el contenido de esa dirección. Para imprimir la dirección tenemos que utilizar el marcador *.{:p}* como hemos hecho antes.

==  Ámbito (Scope) y la Destrucción de Datos (drop)

A diferencia de otros lenguajes con recolector de basura (Garbage Collector) o gestión manual, Rust utiliza un sistema basado en el *ámbito* (las llaves `{ }`). 

La regla de oro del Ownership es simple: una variable es la dueña exclusiva de su dato. En el instante exacto en que esa variable sale de su ámbito (es decir, el flujo del programa llega al cierre de la llave `}`), Rust invoca automáticamente una función especial llamada `drop`. Esta función devuelve inmediatamente la memoria asignada al sistema operativo, garantizando la seguridad sin penalizaciones en tiempo de ejecución.

#nota[El siguiente programa utiliza un tipo de dato *struct Recurso* que todavía no hemos estudiado. Si quieres saber cómo funciona está explicado en el apartado "9.7 El struct Persona y los superpoderes automáticos"]

💻 Copia este código y ejecútalo en tu Playground

```rust
struct Recurso {
    nombre: String,
}

// Implementamos Drop para "ver" cuándo se destruye
impl Drop for Recurso {
    fn drop(&mut self) {
        println!("¡Liberando memoria de {}!", self.nombre);
    }
}

fn main() {
    println!("Inicio del main");
    {
        let _mi_recurso = Recurso { nombre: String::from("Cuaderno 1") };
        // _mi_recurso está vivo aquí
    } // <-- Aquí se cierra el ámbito. Rust llama automáticamente a drop()
    
    println!("Fin del main (el recurso ya no existe)");
}
```
Salida del programa:
```
Inicio del main
¡Liberando memoria de Cuaderno 1!
Fin del main (el recurso ya no existe)
```
Para entender este programa vamos a tener que hacer un pequeño acto de fe.

- Con el bloque *impl*:

```rust
impl Drop for Recurso {
    fn drop(&mut self) {
        println!("¡Liberando memoria de {}!", self.nombre);
    }
}
```
Definimos el método *drop* (similar a una función) para el *struct Recurso*. Este método *drop* es el que llama Rust cuando va a destruir una variable de tipo Recurso, aparte por supuesto de destruir la variable liberando la memoria asociada.

Entonces, cuando se destruya la variable `_mi_recurso` se imprimirá también el mensaje:

```
¡Liberando memoria de Cuaderno 1!
```
#nota[el guión bajo inicial en la variable `_mi_recurso` es simplemente para que el compilador no te muestre el mensaje de que no utilizas la variable después de su declaración. Si lo quitas funcionará igual pero tendrás el mensaje de aviso del compilador.]

- Empezando por la primera instrucción de la función main, sigue el flujo del programa para obtener los mensajes de la salida del programa.

== Conflicto: Préstamo Mutable e Intento de Lectura Posterior

Rust prohíbe en tiempo de compilación usar la variable original mientras exista un préstamo mutable activo, evitando carreras de datos: cuando dos variables intentan acceder simultáneamente al mismo dato (por supuesto, en tiempo de ejecución).

*Préstamo mutable*

Al principio de este capítulo hemos definido el concepto de referencia o préstamo y como se obtiene a partir de la variable original. A partir de una referencia podemos acceder al valor de la variable original como se muestra a continuación.

```rust
fn main() {
    // original es propietaria del dato 42
    let original = 42;

    // Guarda la dirección de memoria de 'original'  
    let referencia: &i32 = &original; 

    // Para acceder al valor apuntado, usamos el operador de
    // desreferenciación (*)
    let valor_copiado = *referencia; 

    println!("Valor desreferenciado: {}", valor_copiado);
}
```

A partir de `*referencia` podemos leer el valor original. Sin embargo no podemos modificarlo.

Para poder modificarlo tenemos que obtener una referencia mutable *`&mut`* como en el siguiente programa:

```rust
fn main() {
    let mut original = 42;
    
    // Referencia mutable
    let referencia = &mut original; 

    *referencia +=100; 

    println!("Valor original: {}", original);   // Valor original: 142
}
```
- Como vamos a modificarla, la variable *original* debe ser *mutable* (*mut*).
- Como podemos comprobar, a través de la referencia mutable hemos cambiado el valor de la variable original de 42 a 142.

*Regla del compilador*

El compilador de Rust (mediante el *Borrow Checker*) aplica una regla matemática estricta para evitar carreras de datos en memoria:

- Puedes tener tantos préstamos inmutables (*`&T`*) como quieras al mismo tiempo.
- *O bien* puedes tener *un único* préstamo mutable (*`&mut T`*) a la vez.

#nota[T representa un tipo de dato cualquiera]

Si intentas leer o usar la variable original mientras un préstamo mutable esté activo y en uso, el compilador detendrá la ejecución inmediatamente. La variable original queda "bloqueada" hasta que el préstamo mutable termine por completo su ciclo de vida.

💻 Copia este código y ejecútalo en tu Playground

```rust
fn main() {
    let mut texto = String::from("Hola");

    let prestamo_mutable = &mut texto; // Se crea el préstamo mutable
    prestamo_mutable.push_str(" Rust");

    // ERROR DE COMPILACIÓN: No podemos usar 'texto' aquí porque 
    // 'prestamo_mutable' todavía está activo en la línea siguiente
    //  ⬇️  ❌ --- error, no compilará
    // println!("{}", texto); // <--- DESCOMENTAR

    // Si usamos el préstamo mutable primero:
    println!("Modificado: {}", prestamo_mutable); 

    // Aquí el préstamo mutable termina su ciclo de vida.
    // Ya no se utiliza más hasta el final del programa.
    // Ahora sí podemos volver a usar la variable original de forma segura:
    println!("Original liberada: {}", texto); 
}
```
Cuando el compilador va a compilar una línea, no mira solo las líneas anteriores para ver si puede compilar sino que mira también las líneas hasta el final de la siguiente llave.

Si descomentamos la línea: *println!(`"`{}`"`, texto);*, el compilador ve que hay una línea posterior: *println!(`"`Modificado: {}`"`, prestamo_mutable); * en la que estamos utilizando prestamo_mutable y eso está prohibido. No compilará. Es la regla del compilador que hemos visto antes: no pdemos utilizar la variable propietaria *texto* si después utilizamos *préstamo_mutable* por ejemplo para imprimirlo.

Cuando en la última línea utilizamos la variable *texto* ya no hay problema porque después ya no utilizamos *prestamo_mutable*.

== Pasar Variables a Funciones (&, &mut y Move)

Cuando enviamos una variable como argumento a una función, el comportamiento varía drásticamente según la firma del método:

#nota[T representa un tipo de dato cualquiera]

Supongamos que desde la función main llamamos a otra función de un solo parámetro según los casos que se discuten a continuación. Como argumento para ese parámetro le pasaremos una variable de nuestra función main:

- *Por referencia inmutable:* 
  - Tipo del parámetro: (`var: &T`)
  Prestamos la variable solo para lectura. La función no puede modificarla y nosotros conservamos la propiedad al terminar la función.

- *Por referencia mutable:* 
 - Tipo del parámetro: (`var: &mut T`)
 Prestamos la variable con permisos de escritura. La función puede alterarla directamente en memoria y nosotros conservamos el control de la variable modificada al terminar la función.

- *Por valor:* 
 - Tipo del parámetro: (`var: T`) 
 Ocurre un *Move* (movmiento de la propiedad). Transferimos por completo la propiedad de la variable a la función. Al acabar la función, la variable original se destruye (`drop`) y no podremos volver a usarla en nuestro código principal.

Este triple ejemplo es perfecto para contrastar las diferencias en las tres formas de pasar los argumentos:

💻 Copia este código y ejecútalo en tu Playground

Fichero: *pasar_parametro_funcion.rs*

```rust
fn solo_lectura(texto: &String) {
    println!("Leemos sin alterar: {}", texto);
}

fn modificacion(texto: &mut String) {
    texto.push_str(" modificado");
}

fn toma_propiedad(texto: String) {
    println!("Tengo la propiedad de: {}", texto);
} // <-- Aquí se hace drop de 'texto'

fn main() {
    let mut mi_cadena = String::from("Datos");

    // Préstamo inmutable (conservo propiedad de mi_cadena)
    solo_lectura(&mi_cadena);

    // Préstamo mutable (conservo propiedad y modifico mi_cadena)      
    modificacion(&mut mi_cadena);

    // Move o Transferencia de propiedad de mi_cadena a la función 
    // Después de esta instrucciñon mi_cadena ya no existe 
    toma_propiedad(mi_cadena);      

    // ⬇️  ❌ --- error: mi_cadena fue destruida en la función.
    // println!("{}", mi_cadena); 
}
```

== El Comportamiento en los Bucles for (Iteradores)

Con el bucle for iteramos entre los distintos elementos de una colección: un array, un vector, etc.

Dependiendo de cómo le pasemos la colección, el bucle alterará la propiedad o los permisos de los elementos:

*A) Préstamo Inmutable* 
- *`for elemento in &coleccion`*
 - Extrae en cada `elemento` una referencia de lectura (`&T`). La colección original sigue intacta y usable tras el bucle for.
 - Equivale a llamar a .iter().

*B) Préstamo Mutable*
- *`for elemento in &mut coleccion`*
 - Extrae en cada `elemento` una referencia mutable (`&mut T`). Permite modificar los elementos dentro del bucle. La colección se conserva después del bucle.
 - Equivale a llamar a .iter_mut().

*C) Consumo / Move*
- *`for elemento in coleccion`*
 - Consume los elementos por valor (`T`), transfiriendo la propiedad al bucle. No podemos modificar los elementos. Al terminar, la colección original queda destruida y ya no existe; ya no puedes usarla.
 - quivale a .into_iter().

*D) Consumo / Move* (con posibilidad de modificar los elementos)
- *`for mut elemento in coleccion`*
 - Consume los elementos por valor (`T`), transfiriendo la propiedad al bucle. Podemos modificar los elementos. Al terminar, la colección original queda destruida y ya no existe; ya no puedes usarla.
 - quivale también a .into_iter().

💻 Copia este código y ejecútalo en tu Playground

Fichero: *iteradores_for.rs*

```rust
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
```

== Iteradores que devuelven referencias (Ejemplo Extra)

A veces usamos métodos como .iter() o .find() fuera de un bucle for. Es útil mostrar cómo estos métodos devuelven referencias y cómo tratarlas.

💻 Copia este código y ejecútalo en tu Playground

Fichero: *iter.rs*

```rust
fn main() {
    let nombres = vec![String::from("Halcón"), String::from("Rust")];

    // .iter() devuelve referencias (&String)
    let mut iterador = nombres.iter();

    if let Some(nombre_ref) = iterador.next() {
        // nombre_ref es un &String. No podemos moverlo, solo leerlo.
        println!("Encontrado: {}", nombre_ref);     // Halcón
    }
    
    if let Some(nombre_ref) = iterador.next() {
        // nombre_ref es un &String. No podemos moverlo, solo leerlo.
        println!("Encontrado: {}", nombre_ref);     // Rust
    }
    
    // La lista 'nombres' sigue perfectamente accesible aquí.
    println!("Lista completa: {:?}", nombres);
}
```

Este programa utiliza *Some* que todavía no hemos estudiado. 

Para entender la parte del iterador no es imprescindile entender Some. 

Hemos construido un *iterador* a partir del vector *nombres* mediante la instrucción:

```rust
let mut iterador = nombres.iter();
```
Mediante las siguientes instrucciones:

```rust
if let Some(nombre_ref) = iterador.next() {
    // nombre_ref es un &String. No podemos moverlo, solo leerlo.
    println!("Encontrado: {}", nombre_ref);
}
```
*iterator.next()* proporciona una referencia *&String* al elemento correspondiente del vector *nombres*. La primera vez al primer elemento `"`Halcón`"` y la segunda vez que las utilizamos al segudo elemento `"`Rust`"`

Esa referencia se coloca en la variable *nombre_ref* que va cambiando su contenido y la imprimimos.

== El struct Persona y los "superpoderes" automáticos
A lo largo de este viaje has aprendido que en Rust existen cajas fijas para guardar números enteros (i32), números decimales (f64) o cadenas de texto (&str). Pero, ¿qué pasa si queremos crear nuestra propia *caja personalizada*?

Imagina que estamos programando una utilidad para el instituto o un videojuego de rol, y necesitamos guardar los datos de los usuarios. En lugar de tener tres variables sueltas por el código para el *nombre*, la *edad* y la *profesion*, Rust nos permite inventar nuestro propio tipo de dato usando la palabra mágica *struct* (abreviatura de estructura).

💻  *Escribe este código dentro de tu archivo src/main.rs:*

Limpia tu archivo *main.rs* en VS Code y escribe este último programa de nivel avanzado:

```rust
// 💡 la etiqueta #[derive(Debug)] le da al struct el "superpoder" 
// de poder imprimirse en pantalla (es un dato compuesto)

// Definimos la estructura
#[derive(Debug)] 
struct Persona {
    nombre: String,
    edad: i32,
    profesion: String,
}

fn main() {
    println!("🗂️  CREANDO FICHA DE PERSONA EN LA MEMORIA 🗂️\n");

    // 1. Rellenamos la ficha creando un objeto con nuestra estructura
    // personalizada, la que hemos creado arriba
    let usuario = Persona {
        nombre: String::from("Halcón68"),
        edad: 14,
        profesion: String::from("Programador de Rust"),
    };

    // 2. Método 1: Leer e imprimir los campos uno por uno
    // (usando el punto '.')
    println!("👤 Nombre del usuario: {}", usuario.nombre);
    println!("🎂 Edad actual: {} años", usuario.edad);
    println!("💼 Profesión: {}", usuario.profesion);
    
    println!("\n------------------------------------------------\n");

    // 3. Método 2: Imprimir la estructura COMPLETA de golpe
    // ⚠️ ¡Ojo! Para imprimir un struct entero usamos el marcador
    // especial {:?} y tenemos que haberle dado superpoderes antes con:
    // #[derive(Debug)]
    println!("📸 Radiografía completa del objeto en memoria:\n {:?}", usuario);
}
```

⚙️ *El análisis del detective: Perdiendo el miedo a internet*

Si buscas códigos de Rust en foros o tutoriales de internet, te vas a cruzar constantemente con líneas raras que llevan un signo de almohadilla y corchetes, como `#[derive(Debug)]`. Vamos a quitarles la máscara para que veas que no muerden:

- *¿Qué es un struct?:* Piensa en él como el diseño en papel de una ficha de estudiante. No es un dato real todavía, es solo la plantilla que dice: "Cualquier Persona que creemos con esta estructura tendrá obligatoriamente un *nombre*, una *edad* y una *profesión*". Estas tres variables se denominan campos y cuando diseñamos el *struct* especificamos de que tipo deben ser.

A partir del *struct Persona* hemos creado una variable *usuario* que será de tipo *Persona*, pasando valores a los campos del struct con unos tipos que coinciden con los especificados en el struct Persona.

- *El operador punto (usuario.nombre):* Para acceder a los campos guardados dentro de nuestra estructura, usamos un punto. Es la forma de decirle a Rust: `Ve a la caja llamada usuario y, por ejemplo, sácame únicamente lo que haya en su cajón nombre`.

- *Las directivas o "Superpoderes"* `#[derive(Debug)]`: Por defecto, Rust es tan estricto con la eficiencia que no sabe cómo imprimir una estructura completa en pantalla con un *println!()* normal. Si intentas poner solo el marcador *{}*, el compilador te dará un error rojo gigante. Al escribir `#[derive(Debug)]` justo encima del *struct*, le estamos inyectando un superpoder automático para que Rust aprenda a hacerle una `radiografía visual` a toda la estructura cuando usemos el marcador especial *{:?}* y así pueda imprimirlo.

🎮 *¡Haz la prueba técnica!*

Abre una terminal integrada para tu proyecto y ejecútalo con  el comando que ya te sabes de memoria:

```bash
cargo run
```

Verás cómo la terminal imprime primero los datos limpios uno por uno, y al final te muestra la radiografía exacta del objeto tal y como vive dentro de la memoria de tu ordenador: 

```rust
Persona { nombre: "Halcón68", edad: 14, profesion: "Programador de Rust" }.
```

== ¿Qué son los traits?

Un Trait (que significa *rasgo o característica* en inglés) es simplemente una lista de tareas o habilidades que un tipo de datos promete saber hacer. En otros lenguajes de programación se le conoce como una Interfaz.

Decimos que un tipo de datos implementa un trait cuando posee todas las habilidades que componen el trait. El trait se implementa mediante código.

Veamos un ejemplo muy sencillo. Definimos el trait *Hablador* con un solo método, *hacer_sonido(&self)*. Los traits pueden contener cualquier número de métodos. Cuando se definen los métodos en el trait solo se pone su cabecera. Los tipos que implementen el trait tienen que dar código a esos metodos cuya cabecera heredan del trait.

En el ejemplo, los *struct* *Perro* y *Pato* implementan (con la instrucción *impl*) el trait *Hablador* y dan código cada uno por su cuenta al método *`hacer_sonido()`*. Podemos ver en el main como se instancian los objetos *perro* y *pato* y llaman a su própio método *`hacer_sonido()`*.

💻  Copia el siguiente listado en la Playground y ejecútalo.

Fichero: *traits.rs*

```rust
/* 
    --- Este es el contrato ---
    Cualquier tipo (de dato) que sea un "Hablador" 
    debe saber hacer_sonido
*/

// Definimos el trait Hablador
trait Hablador {
    fn hacer_sonido(&self);
}

// Estructura del objeto perro
struct Perro {
    nombre: String,
}

// Estructura del objeto pato
struct Pato {
    nombre: String,
}

// El Perro firma el contrato "Hablador"
impl Hablador for Perro {
    fn hacer_sonido(&self) {
        println!("¡Guau! Soy el perro {}", self.nombre);
    }
}

// El Pato firma el contrato "Hablador"
impl Hablador for Pato {
    fn hacer_sonido(&self) {
        println!("¡Cuaic! Soy el pato {}", self.nombre);
    }
}

fn main() {
    let perro = Perro {
        nombre: String::from("Jerry"),
    };
    
    let pato = Pato {
        nombre: String::from("Lucas"),
    };

    perro.hacer_sonido();
    pato.hacer_sonido();
}
```

*self* significa el propio objeto que ejecuta el método. 

Por ejemplo, en la instrucción:

- perro.hacer_sonido();

Como el método *`.hacer_sonido(&self);`* recibe una referencia (*&self*) al objeto *perro*, puede acceder a su nombre mediante *self.nombre*.

