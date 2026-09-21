#import "config.typ": *

= Gestión de Errores Profesional en Rust
Como hemos avanzado en la introducción existen muchas causas que pueden provocar un funcionamiento erróneo de un programa. Ya que  eliminar esas causas no está entre las facultades del programador, lo que debe hacer es anticiparse y preever un comportamiento seguro del programa para el máximo número de situaciones.

Clasificamos los distintos errores que pueden ocurrir.

== Errores recuperables vs. Irrecuperables

En la programación real, las cosas fallan: un archivo que intentamos abrir resulta que no existe, la red se cae cuando nuestro programa intenta acceder a ella o un usuario introduce letras en un campo de entrada en lugar de números... Rust clasifica los errores en dos categorías:

- *Errores irrecuperables* (panic!): Problemas graves de los que el programa no puede recuperarse (ej. acceder a un índice fuera de los límites de un vector). El programa se detiene inmediatamente.

- *Errores recuperables*: Situaciones que podemos anticipar y solucionar (ej. si intentamos abrir un archivo y resulta que no existe, podemos pedirle al usuario que introduzca otra ruta o incluso, crear el archivo si eso elimina el error).

== El tipo Option`<T>`
Rust no tiene el valor *null* presente en otros lenguajes, evitando así los famosos errores de "puntero nulo". Cuando un valor puede estar presente o ausente, lo representamos con la enumeración *Option`<T>`*, que tiene dos variantes:

- Some(valor): Contiene el dato y es valor.
- None: Indica la ausencia de valor.

Para ir fijando las ideas podemos suponer que ese valor que decimos que puede estar presente o ausente, es el valor devuelto por una función y que se asigna a una variable. 

En lenguaje simbólico podríamos reflejar la situación de la siguiente forma:

```rust
fn mi_funcion(parametros)-> Option<T> {instrucciones} 

let mi_variable = funcion(argumentos);
```
Según el esquema anterior, *mi_variable* será de tipo *Option`<T>`*. Este enumerado tiene como hemos mencionado antes dos variantes y *mi_funcion* asignará una de las dos a *mi_variable*. Si le asigna  *Some*, dentro del Some está el valor que buscamos y si es *None*, sencillamente el valor no existe. En cada caso, T será un tipo de dato que se ajuste a nuestras necesidades.

En el siguiente ejemplo ---ver código completo más abajo---, la función *buscar_usuario(id: u32)* simula buscar un usuario a partir del *id* del mismo. Hemos simplificado para que solo exista un usuario que se obtiene con el id = 10. La función devuelve un *`Option<String>`*. Veamos los dos casos posibles:

- Si le proporcionamoes un id = 10 ---ver listado del programa---, la función devuelve *Some(String::from("Alicia"))*, es decir, devuelve un String con el resultado correcto envuelto en un Some. Luego aprenderemos a desempaquetar el resultado del Some en la función main.

- Si le proporcionamos cualquier otro id devuelve *None* que interpretamos como ausencia de valor. Esta ausencia de valor no genera ningún problema con las sentencias println! que muestran el resultado.

- Observa la instrucción *match* del main:

```rust
match buscar_usuario(usuario_id) {
        Some(nombre) => println!("Usuario encontrado: {}", nombre),
        None => println!("Error: El usuario no existe en la base de datos."),
    }
```

El *match* chequea los dos posibles valores que puede tomar la función en base al *usuario_id* que le pasemos y establece el código a ejecutar en cada rama.

En la línea: 

```rust
Some(nombre) => println!("Usuario encontrado: {}", nombre)
```
La variable *nombre* atrapa el valor oculto en el Some y podemos utilizarla luego en el println! a la derecha.

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *buscar_usuario.rs*

```rust
// Ejemplo sencillo de Option
fn buscar_usuario(id: u32) -> Option<String> {
    if id == 10 {
        Some(String::from("Alicia"))
    } else {
        None
    }
}

fn main() {
    let usuario_id = 10;
    
    match buscar_usuario(usuario_id) {
        Some(nombre) => println!("Usuario encontrado: {}", nombre),
        None => println!("Error: El usuario no existe en la base de datos."),
    }
}
```
Cambia el valor de la variable *let usuario_id = 10;* y observa los mensajes de salida.

== El tipo *Result`<T, E>`*
Para operaciones que pueden fallar por factores externos en las que podemos capturar el error, Rust utiliza *Result`<T, E>`*. 

Sus variantes son:

- Ok(T): La operación fue un éxito y devuelve el resultado de tipo T en la variante Ok.
- Err(E): La operación falló y devuelve el error de tipo E en la variante Err.

Supongamos una función que pide al usuario que introduzca el numerador y denominador para calcular un cociente y devuelva el resultado. El problema es, ¿qué pasa si el usuario introduce un cero para el denominador?

Si la función devuelve exactamente el cociente se producirá un error en el programa y se abortará su ejecución porque no se puede dividir por cero.

La solución de Rust a este problema es, por ejemplo, que la función devuelva un tipo *Result`<f64, String>`*. Dentro de la función, cuando el denominador no es cero se devuelve la variante *Ok(resultado)*, resultado será de tipo f64, y si es cero devolvemos por ejemplo *Err(String::from(`"`No se puede dividir por cero`"`))*

Un caso muy parecido salvo que los valores del numerador y denominador los elegimos nosotros en el código es el del siguiente listado:

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *result_division.rs*

```rust
// Ejemplo de división segura
fn dividir(dividendo: f64, divisor: f64) -> Result<f64, String> {
    if divisor == 0.0 {
        Err(String::from("No se puede dividir por cero."))
    } else {
        Ok(dividendo / divisor)
    }
}

fn main() {
    match dividir(10.0, 2.0) {
        Ok(resultado) => println!("Resultado: {}", resultado),
        Err(error) => println!("Ocurrió un error: {}", error),
    }
}
```
De nuevo utilizamos la instrucción match para desempaquetar el Result que devuelve la función dividir. 

- La variable *resultado* en Ok(resultado) recibe el valor *dividendo / divisor* que se le pasa al Ok en la función.

- La variable *error* en Err(error) recibe el *String* que se le pasa a Err en la función.

Como el Result tiene dos variantes, Ok y Err, tenemos que tener las dos en cuenta en el match ya que de otra forma el programa no podría ser compilado.

== El tipo de dato unidad
No hemos hablado hasta el momento en los cuadernos del tipo de dato *unidad* porque esperábamos a tener un contexto adecuado para hacerlo.

En Rust, todas las funciones devuelven algo. Bien con una sentencia return o bien mediante una expresion en su ultima línea que no termina con punto y coma. En ambos casos el tipo devuelto se indica en la cabecera de la función.

Si la función no retorna nada de forma explícita, entonces retorna un tipo de dato denominado unidad. El símbolo del tipo de dato unidad es () y solo existe un valor de este tipo de dato que se escribe de la misma forma y se denomina también unidad ().

La sentencia Result que hemos visto antes, *Result`<T, E>`*, algunas veces se utiliza de la siguiente forma *Result`<(), String>`*. Entonces, las dos variantes se escriben:

```rust
Ok(())
Err("String::from"(Cualquier error que pueda ocurrir."))
```

En estos casos, cuando se da la variante OK no estamos interesados en recoger ningún resultado. Simplemente notificamos que la operación, sea la que sea, ha ido bien.

Veremos un ejemplo con este planteamiento un poco más adelante.

== El operador de propagación `?`
Para evitar encadenar demasiados bloques match, Rust ofrece el operador *?*. Lo podemos ver aplicado en la siguiente instrucción perteneciente al listado *interrogacion.rs* más abajo:

 ```rust
let resultado = dividir(10.0, 10.0)?;
 ```
Si el resultado de la función *dividir* es Ok, el operador *?* extrae el valor y lo asigna a la variable resultado; si es Err, detiene la función actual, en este caso dividir, y devuelve ("propaga") el error automáticamente a la función que la llamó. En el listado más abajo podemos ver que la función que llama a dividir es main.

Para que esto funcione, la función que llama a dividir, main, debe devolver un Result con una variante Err del mismo tipo que la función dividir, en este caso String. De esta forma, cuando se produce un Err en dividir, esta lo lanza hacia arriba, hacia main y esta que admite el mismo tipo de Err lo imprime.

La variante OK(()) del Result que devuelv main es de tipo unidad y, su valor es la unidad. Es consecuencia de que no deseamos hacer nada en main cuando todo haya ido bien ya que imprimimos el resultado en la línea anterior.

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *interrogacion.rs*

```rust
// Ejemplo de división segura
fn dividir(dividendo: f64, divisor: f64) -> Result<f64, String> {
    if divisor == 0.0 {
        Err(String::from("No se puede dividir por cero."))
    } else {
        Ok(dividendo / divisor)
    }
}

fn main() -> Result<(), String>{
   let resultado = dividir(10.0, 10.0)?;
   println!("El resultado es: {resultado}");
   Ok(())
}
```
Introduce en el código un valor 0.0 como divisor para obtener el error en la terminal.




#pagebreak()