#import "config.typ": *

= El mapa definitivo de la seguridad: Option y Result
Hasta ahora hemos ido utilizando la instrucción *match* básicamente en dos escenarios: cono instrucción de control de flujo y para desempaquetar una variable de tipo *Option*. Aunque este segundo caso está ligado a la seguridad del programa, el control eficiente de errores se consigue introduciendo también el enumerado *Result* y un conjunto de métodos como *unwrap()*, *unwrat_or()*, *expect(*), etc. como herramientas que de forma ocasional actúan como pequeños "salvavidas" en nuestro código para evitar que el programa explote (se congele). Pero va siendo hora de levantar el capó para entender en qué consiste realmente el tratamiento de errores de forma estructurada y por qué hacen a Rust un lenguaje tan único.

En Rust no existen los valores *null* o *nil* que en otros lenguajes causan tantos dolores de cabeza y cuelgues inesperados. En su lugar, el lenguaje utiliza dos *enumeraciones* (enums) ultra-potentes llamadas *Option* y *Result*. Como son tan fundamentales para la supervivencia de cualquier programa, Rust las incluye directamente en su prelude (su caja de herramientas básica). Esto significa que ya están definidas en el corazón del lenguaje y las podemos utilizar sin importar ni configurar nada.

Para entender cómo funcionan, tenemos que mirar su definición utilizando Genéricos, que en Rust representamos con letras mayúsculas como `<T>`, `<E>` o `<V>`. No dejes que la sintaxis te asuste: estas letras son simplemente "cajas vacías" o comodines que se sustituirán por tipos de datos reales cuando escribamos nuestro código.

== La caja de la presencia o ausencia: Option`<T>`
El tipo *Option* se utiliza cuando algo puede existir o puede no existir. Por ejemplo, buscar un usuario en una base de datos a través de su DNI o validar si una medida tiene sentido. ¿Si el DNI que proporcionamos no existe en la base de datos, ¿cual debe ser la respuesta del programa? O si introducimos una valor negativo o menor que el permitido, ¿Cual debe ser el volumen del cubo devuelto?.

Por debajo, el lenguaje lo define así:

```rust
enum Option<T> {
    Some(T), // Contiene un valor válido de tipo T
    None,    // No contiene nada
}
```
Esa *`<T>`* es el tipo genérico del valor que viaja dentro si las cosas van bien. En la práctica, cuando trabajamos con geometría o física, solemos usar *Option`<f64>`*, lo que significa que, si hay éxito, la variante Some envolverá un número decimal de 64 bits (*f64*), y si no, nos devolverá un rotundo None.

== La caja del éxito o el fracaso: Result`<T, E>`
El tipo *Result* va un paso más allá. No se pregunta si algo existe o no, sino si una operación ha salido bien o ha fallado, y en caso de fallo, nos explica el motivo. Su definición genérica utiliza dos comodines:

```rust
enum Result<T, E> {
    Ok(T),  // La operación fue un éxito y nos da un valor de tipo T
    Err(E), // Hubo un error y nos da un detalle del fallo de tipo E
}
```
Aquí la magia es doble: *`<T>`* representa el tipo de dato del resultado feliz, y *`<E>`* representa el tipo de dato del error.

En tus primeros programas verás a menudo combinaciones sencillas como *Result`<f64, String>`*. Esto significa que si todo va bien (Ok), obtenemos nuestro número f64, y si algo falla (Err), recibimos un texto explicativo (String) con los motivos del desastre.

*Perdiendo el miedo: Otros tipos de Result*

Aunque usar String para los errores es ideal para aprender y resolver problemas sencillos, Rust está lleno de variantes preparadas para el mundo real. Por ejemplo, cuando trabajamos leyendo archivos en el disco duro o gestionando sockets de red, el lenguaje sustituye la *E* por tipos específicos como *std::io::Error*.

Ver una firma como *Result`<String, std::io::Error>`* no debe darte ningún miedo: funciona exactamente igual que las demás. La única diferencia es que, en caso de fallo, en lugar de un texto plano, la variante Err nos entregará un objeto con información técnica precisa proporcionada por el propio sistema operativo.

== 🛠️ El Arsenal de Extracción: ¿Cómo destapamos las cajas?
Para desarrollar este apartado trabajaremos con las dos funciones que listamos a continuació:

```rust
fn volumen_cubo(lado: f64) -> Option<f64> {
    if lado < 5.0 {
        // no válido
        return None;
    }

    // resultado válido envuelto en Some()
    let volumen =  lado * lado * lado;
    Some(volumen)
}

fn superficie_cubo(lado: f64) -> Result<f64, String> {
    if lado < 5.0 {
        // El return es obligatorio para salir corriendo de la
        // función AQUÍ mismo
        return Err(format!("El lado ({}) es muy pequeño. Mínimo debe ser 5.0", lado));
    }

    // Como es la última línea, aquí NO se usa 'return' ni punto y coma
    let superficie = 6.0 * lado * lado;
    Ok(superficie)
}
```

- La función *`volumen_cubo()`* devuelve *None* si le pasamos un lado menor que 5.0 y el volumen del cubo envuelto en *Some* en caso contrario.

- La función *`superficie_cubo()`* devuelve un String envuelto en *Err* si le pasamos un lado menor que 5.0 y la superficie del cubo envuelta en un *Ok* en caso contrario.

=== El cirujano del código: La sentencia match
Es la forma más explícita y robusta. Te obliga a contemplar todos los escenarios posibles (el éxito y el fracaso). Si te dejas uno, el compilador no te dejará avanzar.

Mira cómo destapamos (desempaquetamos) el *Option* del volumen de nuestro cubo:

```rust
let resultado_opt = volumen_cubo(6.0); // Devuelve Option<f64>

match resultado_opt {
    Some(vol) => println!("¡Éxito! El volumen extraído es {} m³", vol),
    None => println!("Error: El lado indicado no era válido para calcular el volumen."),
}

```

#nota[Si quieres ejecutar los trozos de código que vienen a continuación en la Playground de Rust, tienes que construirte un programa completo que incluya la función que utilizamos y un método main con las instrucciones a probar.

Por ejemplo, para probar el bloque anterior debes construirte el siguiente programa:]

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *match_volumen.rs*

```rust
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
```

La función main() anterior puede escribirse también de esta forma equivalente:

```rust
fn main() {
    // Al usar format!, le match devuelve siempre el String
    let resultado_opt = match volumen_cubo(6.0) {
        Some(vol) => format!("¡Éxito! El volumen extraído es {} m³", vol),
        None => format!("Error: El lado indicado no era válido para calcular el volumen."),
    };
    
    // Para comprobación
    println!("{}", resultado_opt);
}
```

_¿Qué ocurre aquí?_ Si la caja es un Some, Rust extrae el número decimal, lo bautiza temporalmente como *vol* y ejecuta esa línea (el println!). Si la caja venía vacía (None), ejecuta la otra línea println!.

Ahora, mira cómo se comporta con el *Result* de la superficie:

```rust
let resultado_res = superficie_cubo(4.0); // Devuelve Result<f64, String>

match resultado_res {
    Ok(sup) => println!("La superficie calculada es {} m²", sup),
    Err(mensaje_error) => println!("Fallo en el cálculo: {}", mensaje_error),
}
```

La mecánica es idéntica, pero con una ventaja: en la rama *Err*(mensaje_error), el match no solo detecta el fallo, sino que extrae el String dinámico que creamos con format! dentro de la función y nos lo entrega listo para imprimir.

== El filtro rápido: La estructura `if let`
A veces no te importan los dos lados de la moneda; solo quieres hacer algo si la operación fue bien, ignorando el resto. Para no escribir un match engorroso con ramas vacías, usamos este atajo:

```rust
// Con Option
if let Some(vol) = volumen_cubo(7.0) {
    println!("El volumen es: {}", vol);
}

// Con Result
if let Ok(sup) = superficie_cubo(8.0) {
    println!("La superficie es: {}", sup);
}
```
¿Qué pasa si el lado mide menos de 5.0 y la función devuelve un error? Absolutamente nada. Como vimos anteriormente, el programa simplemente ignora el bloque entre llaves y continúa su camino de forma 100% segura sin colgarse.

== 3. El plan B: El método `unwrap_or()`
¿Y si queremos extraer el valor, pero si algo sale mal preferimos asignar un valor por defecto en lugar de romper el programa? Para eso existe el comodín unwrap_or().

```rust
// Si el volumen falla (None), nos asigna automáticamente un 0.0 de rescate
let mi_volumen = volumen_cubo(3.0).unwrap_or(0.0);
println!("Volumen final: {}", mi_volumen); // Imprimirá: 0.0

```
== Los botones de autodestrucción: `unwrap()` y `expect()`
Son los métodos más rápidos, pero requieren que estés completamente seguro de lo que haces. Son actos de fe ciega.

*`.unwrap()`*: Le dice a Rust: "Saca el valor. Si está vacío o es un error, haz termina el programa".

*`.expect("Mensaje de pánico")`*: Hace exactamente lo mismo, pero te permite personalizar el mensaje que saldrá en la consola cuando el programa sufra el pánico. Es muy útil para rastrear en qué línea exacta murió tu aplicación.

```rust
let vol = volumen_cubo(10.0).unwrap(); // Seguro, porque 10.0 es mayor que 5.0

let sup = superficie_cubo(2.0).expect("Error fatal al calcular la superficie del cuaderno"); 
// ¡PÁNICO! El programa muere aquí porque 2.0 es inválido, mostrando nuestro mensaje personalizado.

```
== El pase de oro para profesionales: El operador de propagación `?`
Imagina que estás escribiendo una función que hace varios cálculos seguidos y no quieres llenar tu código de infinitos match o if let anidados. Rust inventó el operador *?* para actuar como un cobrador automático de errores.

Para poder usar el *?*, la función donde lo metas debe devolver también un Result o un Option. Su comportamiento es mágico: intenta desempaquetar el valor; si lo logra, te da el número limpio directamente; pero si detecta un error, detiene la función en ese mismo instante y "lanza" el error hacia arriba, delegando la responsabilidad a quien haya llamado a la función.

```rust
// Una función que calcula ambas cosas y devuelve un Result combinado
fn informe_cubo(lado: f64) -> Result<String, String> {
    // El '?' extrae el f64 de Ok() si va bien. Si da Err, la función muere AQUÍ y devuelve ese Err.
    let sup = superficie_cubo(lado)?; 
    let vol = volumen_cubo(lado).ok_or("No se pudo calcular el volumen")?; 

    Ok(format!("Cubo de lado {}: Superficie de {} m² y Volumen de {} m³", lado, sup, vol))
}
```
(Nota de ingeniería: Como volumen_cubo devuelve un Option y nuestra función necesita devolver un Result, usamos el truco .ok_or() para transformar el None en un texto de error antes de aplicarle el ?).

== Resumen para llevar en la mochila:
- Usa match cuando necesites controlar el éxito y el fracaso al mismo nivel.
- Usa if let si solo te importa el camino feliz.
- Usa unwrap_or si tienes un plan B numérico o un valor por defecto.
- Usa ? en tus funciones complejas para encadenar operaciones sin ensuciar el código.
- Evita unwrap en código de producción, pero aprovéchalo en tus primeros bocetos y pruebas caseras.






#pagebreak()