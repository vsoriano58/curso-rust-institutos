#import "config.typ": *

= El mapa definitivo de la seguridad: Option y Result
Hasta ahora hemos ido utilizando la instrucción *match* básicamente en dos escenarios: como instrucción de control de flujo y para desempaquetar una variable de tipo *Option*. Aunque este segundo caso está ligado a la seguridad del programa, el control eficiente de errores se consigue introduciendo también la enumeración *Result* y un conjunto de métodos como *unwrap()*, *unwrat_or()*, *expect(*), etc. como herramientas que de forma ocasional actúan como pequeños "salvavidas" en nuestro código para evitar que el programa se quede colgado (se congele). Pero va siendo hora de levantar el capó para entender en qué consiste realmente el tratamiento de errores de forma estructurada y por qué hacen a Rust un lenguaje tan único.

En Rust no existen los valores *null* o *nil* que en otros lenguajes causan tantos dolores de cabeza y cuelgues inesperados. En su lugar, el lenguaje utiliza dos *enumeraciones* llamadas *Option* y *Result*. Como son tan fundamentales para la supervivencia de cualquier programa, Rust las incluye directamente en su prelude (su caja de herramientas básica). Esto significa que ya están definidas en el corazón del lenguaje y las podemos utilizar sin importarlas ni configurar nada.

Para entender cómo funcionan, tenemos que mirar su definición utilizando Genéricos, que en Rust representamos con letras mayúsculas como `<T>`, `<E>` o `<V>`. No dejes que la sintaxis te asuste: estas letras son simplemente "cajas vacías" o comodines que se sustituirán por tipos de datos reales cuando escribamos nuestro código.

== La caja de la presencia o ausencia: Option`<T>`
Recordemos que el tipo *Option* se utiliza cuando algo puede existir o puede no existir. Por ejemplo, una función que busque un usuario en una base de datos a través de su DNI puede devolver un dato de tipo Option. En este caso devolvería el usuario encontrado envuelto en la variante Some o directamente None si no encontró el usuario. Esto puede ocurrir porque proporcionamos un DNI que no existe en la base de datos o porque en ese momento no se pudo realizar la conexión con la base de datos.

Como ya vimos, el lenguaje lo define así:

```rust
enum Option<T> {
    Some(T), // Contiene un valor válido de tipo T
    None,    // No contiene nada
}
```
Esa *`<T>`* es el tipo genérico del valor que viaja dentro de la variante Some si las cosas van bien. En la práctica, cuando trabajamos con geometría o física, solemos usar *Option`<f64>`*, lo que significa que, si hay éxito, la variante Some envolverá un número decimal de 64 bits (*f64*), y si no, nos devolverá un rotundo *None*.

== La caja del éxito o el fracaso: Result`<T, E>`
LLegó el momento de analizar la enumeración *Result*.

El tipo *Result* va un paso más allá. No se pregunta si algo existe o no, sino *si una operación ha salido bien o ha fallado*. En caso de éxito nos entrega el resultado en la variante *Ok* y en caso de fallo, nos explica el motivo en la variante *Err*. Su definición genérica utiliza dos comodines:

```rust
enum Result<T, E> {
    Ok(T),      // La operación fue un éxito y nos da un valor de tipo T
    Err(E),     // Hubo un error y nos da un detalle del fallo de tipo E
}
```
Aquí la magia es doble: *`<T>`* representa el tipo de dato del resultado feliz, y *`<E>`* representa el tipo de dato del error.

En tus primeros programas verás a menudo combinaciones sencillas como *Result`<f64, String>`*. Esto significa que si todo va bien, con Ok obtenemos nuestro número f64, y si algo falla, con Err recibimos un texto explicativo (String) con los motivos del desastre.

*Perdiendo el miedo: Otros tipos de Result*

Aunque usar String para los errores es ideal para aprender y resolver problemas sencillos, Rust está lleno de variantes preparadas para el mundo real. Por ejemplo, cuando trabajamos leyendo archivos en el disco duro o gestionando sockets de red, el lenguaje sustituye la *E* genérica por tipos específicos como *std::io::Error*.

Ver una firma como *Result`<String, std::io::Error>`* no debe darte ningún miedo: funciona exactamente igual que las demás. La única diferencia es que, en caso de fallo, en lugar de proporcionar un texto plano como un String, la variante Err nos entregará un objeto con información técnica precisa proporcionada por el propio sistema operativo. Obviamente, tendremos que saber manejar ese objeto para sacarle la información que almacena.

== 🛠️ El Arsenal de Extracción: ¿Cómo destapamos las cajas?
Para desarrollar este apartado trabajaremos con dos funciones:

- la función: *fn volumen_cubo(lado: f64) -> Option`<f64>`*
 - Esta función tiene como parámetro el lado de un cubo y calcula su volumen. Para poder realizar nuestro ejercicio, hemos supuesto que si el lado que le proporcionamos a la función es menor que cinco, el cubo no existe (no tenemos cubos tan pequeños) y devolverá *None*. En caso contrario devolverá el volumen del cubo envuelto en un *Some*.

```rust
fn volumen_cubo(lado: f64) -> Option<f64> {
    if lado < 5.0 {
        // no existe
        return None;
    }

    // resultado válido envuelto en Some()
    let volumen =  lado * lado * lado;
    // Como es la última línea, aquí NO se usa 'return' ni punto y coma
    Some(volumen)
}
```
- la función: *fn superficie(lado: f64) -> Option`<f64>`*
 -  Esta función tiene también como parámetro el lado del cubo y calcula su superficie. Hemos supuesto también que si el lado que le proporcionamos a la función es menor que cinco, en este caso incurrimos en un error y entonces proporcionamos un mensaje explicativo del error envuelto en un *Err*. En caso contrario devolverá la superficie del cubo envuelto en un *Ok*.

```rust
fn superficie_cubo(lado: f64) -> Result<f64, String> {
    if lado < 5.0 {
        // El return es obligatorio para salir corriendo de la
        // función AQUÍ mismo
        return Err(format!("El lado ({}) es muy pequeño. Mínimo debe ser 5.0", lado));
    }
    
    let superficie = 6.0 * lado * lado;
    // Como es la última línea, aquí NO se usa 'return' ni punto y coma
    Ok(superficie)
}
```

*Resumiendo*

- La función *`volumen_cubo()`* devuelve un *Option*. Concretamente devuelve la variante *None* si le pasamos un lado menor que 5.0 y el volumen del cubo envuelto en la variante *Some* en caso contrario.

- La función *`superficie_cubo()`* devuelve un *Result*. Concretamente devuelve un String envuelto en la variante *Err* si le pasamos un lado menor que 5.0 y la superficie del cubo envuelta en la variante *Ok* en caso contrario.

=== El cirujano del código: La sentencia `match`
Es la forma más explícita y robusta. Te obliga a contemplar todos los escenarios posibles (el éxito y el fracaso). Si te dejas uno, el compilador no te dejará avanzar.

Recordemos cómo desempaquetar el *Option* que devuelve la función que calcula el volumen de nuestro cubo. Esto ya lo hemos hecho antes:

```rust
fn volumen_cubo(lado: f64) -> Option<f64> {
    if lado < 5.0 {
        // no existe
        return None;
    }

    // resultado válido envuelto en Some()
    let volumen =  lado * lado * lado;
    // Como es la última línea, aquí NO se usa 'return' ni punto y coma
    // para devolver Some(volumen)
    Some(volumen)
}

fn main(){
    let resultado_opt = volumen_cubo(6.0); // Devuelve Option<f64>

    match resultado_opt {
        Some(vol) => println!("¡Éxito! El volumen extraído es {} m³", vol),
        None => println!("Lo sentimos. No existen cubos tan pequeños"),
    }
}

```
- Si la variante es *Some*, el match extrae dinámicamente el volumen del cubo, lo coloca en la la variable *vol* del *Some* y ejecuta el println!.

- Si la variante es *None* simplemente ejecuta el println!

Podríamos decirlo también así: Si la caja es un Some, Rust extrae el número decimal, lo bautiza temporalmente como *vol* y ejecuta esa línea (el println!). Si la caja venía vacía (None), ejecuta la otra línea println!.

La salida del programa es:

```
¡Éxito! El volumen extraído es 216 m³
```
Veamos ahora cómo de forma totalmente análoga desempaquetamos el *Result* que devuelve la función superficie_cubo:
```rust
fn superficie_cubo(lado: f64) -> Result<f64, String> {
    if lado < 5.0 {
        // El return es obligatorio para salir corriendo de la
        // función AQUÍ mismo
        return Err(format!("El lado ({}) es muy pequeño. Mínimo debe ser 5.0", lado));
    }
    
    let superficie = 6.0 * lado * lado;
    // Como es la última línea, aquí NO se usa 'return' ni punto y coma
    // para devolver Some(superficie)
    Ok(superficie)
}

fn main() {
    let resultado_sup = superficie_cubo(4.0); // Devuelve Result<f64, String>
    match resultado_sup {
        Ok(sup) => println!("La superficie calculada es {} m²", sup),
        Err(mensaje_error) => println!("Fallo en el cálculo: {}", mensaje_error),
    }
}
```

- Si la variante es *Ok* el match extrae dinámicamente la superficie del cubo, la coloca en la variable *sup* del *Ok* y ejecuta el println.

- Si la variante es *Err* el match extrae dinámicamente el mensaje de error, lo colca en la variable  *mensaje_error* del *Err* e imprime el otro println!.

La salida del programa es la siguiente:

Fallo en el cálculo: El lado (4) es muy pequeño. Mínimo debe ser 5.0

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Tienes los dos ejemplos anteriores en un solo programa.

Fichero: *match_cubo.rs*

```rust
fn volumen_cubo(lado: f64) -> Option<f64> {
    if lado < 5.0 {
        // no existe
        return None;
    }

    // resultado válido envuelto en Some()
    let volumen = lado * lado * lado;
    // Como es la última línea, aquí NO se usa 'return' ni punto y coma
    Some(volumen)
}

fn superficie_cubo(lado: f64) -> Result<f64, String> {
    if lado < 5.0 {
        // El return es obligatorio para salir corriendo de la
        // función AQUÍ mismo
        return Err(format!(
            "El lado ({}) es muy pequeño. Mínimo debe ser 5.0",
            lado
        ));
    }

    let superficie = 6.0 * lado * lado;
    // Como es la última línea, aquí NO se usa 'return' ni punto y coma
    Ok(superficie)
}

fn main() {
    let resultado_vol = volumen_cubo(6.0); // Devuelve Option<f64>
    match resultado_vol {
        Some(vol) => println!("¡Éxito! El volumen extraído es {} m³", vol),
        None => println!("Error: El lado indicado no era válido para calcular el volumen."),
    }
  
    let resultado_sup = superficie_cubo(4.0); // Devuelve Result<f64, String>
    match resultado_sup {
        Ok(sup) => println!("La superficie calculada es {} m²", sup),
        Err(mensaje_error) => println!("Fallo en el cálculo: {}", mensaje_error),
    }
}
```
#nota[

En la función main() anterior, el pimer bloque puede escribirse también de la siguiente forma equivalente:

```rust
fn main() {
    // Al usar format!, el match devuelve siempre el String
    let resultado_opt = match volumen_cubo(6.0) {
        Some(vol) => format!("¡Éxito! El volumen extraído es {} m³", vol),
        None => format!("Error: El lado indicado no era válido para calcular el volumen."),
    };
    
    // Para comprobación
    println!("{}", resultado_opt);
}
```
Al retornar format! en las dos ramas del match, este siempre devuelve un string que se almacena en resultado_opt. Si en lugar de format! utilizamos println! entonces no devolvemos nada y la versión anterior no funcionaría.
]

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
¿Qué pasa si el lado mide menos de 5.0 y la función devuelve None en el primer caso o Err en el segundo? Absolutamente nada. El programa simplemente ignora el bloque entre llaves y continúa su camino de forma 100% segura sin colgarse.

== El plan B: El método `unwrap_or()`
¿Y si queremos extraer el valor, pero si algo sale mal preferimos asignar un valor por defecto en lugar de romper el programa? Para eso existe el comodín *unwrap_or()*.

```rust
// Si el volumen falla (None), nos asigna automáticamente un 0.0 de rescate
let mi_volumen = volumen_cubo(3.0).unwrap_or(0.0);
println!("Volumen final: {}", mi_volumen); // Imprimirá: Volumen final: 0.0

```
== Los botones de autodestrucción: `unwrap()` y `expect()`
Son los métodos más rápidos, pero requieren que estés completamente seguro de lo que haces. Son actos de fe ciega.

*`.unwrap()`*: Le dice a Rust: "Saca el valor. Si está vacío o es un error, haz que termine el programa".

*`.expect("Mensaje de pánico")`*: Hace exactamente lo mismo, pero te permite personalizar el mensaje que saldrá en la consola cuando el programa sufra el pánico. Es muy útil para rastrear en qué línea exacta murió tu aplicación.

Ejemplos:

```rust
let vol = volumen_cubo(10.0).unwrap(); // Seguro, porque 10.0 es mayor que 5.0

// ¡PÁNICO! El programa muere aquí porque 2.0 es inválido, mostrando el mensaje
// personalizado que le pasamos al expect().
let sup = superficie_cubo(2.0).expect("Error fatal al calcular la superficie del cuaderno"); 

```
== El pase de oro para profesionales: El operador de propagación `?`
Imagina que estás escribiendo una función que hace varios cálculos seguidos y no quieres llenar tu código de infinitos *match* o *if let* anidados. Rust inventó el operador *?* para actuar como un cobrador automático de errores.

Para poder usar el *?*, la función donde lo aplicamos debe devolver el mismo tipo de error (None o Err) que la función que hace de padre. Su comportamiento es mágico: intenta desempaquetar el valor; si lo logra, te da el número limpio directamente; pero si detecta un error (un None o un Err), detiene la función en ese mismo instante y "lanza" el error hacia la función padre, delegando en ella la responsabilidad de tratar el error.

Vamos a ver un ejemplo paso a paso.

Definimos abajo una función *informe_cubo()* que en su interior utiliza las dos funciones con las que hemos trabajado anteriormente: *superficie_cubo()* y *volumen_cubo()*.

*informe_cubo()* es la función padre de la que hablamos antes puesto que las dos llamadas con *?* están en su interior.

- En la primera utilización del *?* en *let sup = superficie_cubo(lado)?;*, si lado es menor que 5 la función devolverá un Err(String) y el operador *?* lo pasará directamente a *informe_cubo()* para que lo trate ya que *informe_cubo()* también devuelve un Err(String) y por ello son compatibles. Esta compatibilidad es necesaria para que funcione el *?*.

- En la segunda utilización del *?* en *let vol = volumen_cubo(lado).ok_or(`"`No se pudo calcular el volumen`"`)?; * si lado es menor que 5 la función devuelve None, por eso hemos añadido  *ok_or(`"`No se pudo calcular el volumen`"`)* para que devuelva un String en lugar de None y sea compatible con la función padre.

```rust
// Una función que calcula ambas cosas y devuelve un Result combinado
fn informe_cubo(lado: f64) -> Result<String, String> {

    // El '?' extrae el f64 de Ok() si va bien. Si da Err, la función 
    // muere AQUÍ y devuelve ese Err.
    let sup = superficie_cubo(lado)?; 
    let vol = volumen_cubo(lado).ok_or("No se pudo calcular el volumen")?; 

    Ok(format!("Cubo de lado {}: Superficie de {} m² y Volumen de {} m³", lado, sup, vol))
}
```
Para entender completamente el operador ? es conveniente que revises el ejercicio que hemos estado comentado pero con la versión entera, incluida la función main.

Fichero: *interrogante.rs*

```rust
fn volumen_cubo(lado: f64) -> Option<f64> {
    if lado < 5.0 {
        // no existe
        return None;
    }

    // resultado válido envuelto en Some()
    let volumen = lado * lado * lado;
    // Como es la última línea, aquí NO se usa 'return' ni punto y coma
    Some(volumen)
}

fn superficie_cubo(lado: f64) -> Result<f64, String> {
    if lado < 5.0 {
        // El return es obligatorio para salir corriendo de la
        // función AQUÍ mismo
        return Err(format!(
            "El lado ({}) es muy pequeño. Mínimo debe ser 5.0",
            lado
        ));
    }

    let superficie = 6.0 * lado * lado;
    // Como es la última línea, aquí NO se usa 'return' ni punto y coma
    Ok(superficie)
}

fn informe_cubo(lado: f64) -> Result<String, String> {
    // El '?' de la línea de abajo extrae el f64 del Ok() de la función superficie_cubo, si va bien. 
    // Si da Err, la función muere AQUÍ y devuelve ese Err de superficie_cubo.
    let sup = superficie_cubo(lado)?; 
    let vol = volumen_cubo(lado).ok_or("No se pudo calcular el volumen")?; 

    Ok(format!("Cubo de lado {}: Superficie de {} m² y Volumen de {} m³", lado, sup, vol))
}

fn main() {
    match informe_cubo(3.0){
        Ok(mensaje) => println!("{mensaje}"),
        Err(error) => println!("{error}")
    }
}
```

Cambia el argumento pasado a *informe_cubo*, valores mayores y menores que 5 y observa los resultados.

== Resumen para llevar en la mochila:
- Usa match cuando necesites controlar el éxito y el fracaso al mismo nivel.
- Usa if let si solo te importa el camino feliz.
- Usa unwrap_or si tienes un plan B numérico o un valor por defecto.
- Usa ? en tus funciones complejas para encadenar operaciones sin ensuciar el código.
- Evita unwrap en código de producción, pero aprovéchalo en tus primeros bocetos y pruebas caseras.


#pagebreak()