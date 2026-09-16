#import "config.typ": *

= 🎨  Tratamiento de imágenes con Rust
Has llegado a la última frontera del primer cuaderno. Hasta ahora, todos tus programas se ejecutaban en la Playground, que es una terminal de texto. En este capítulo vas a dar el salto al mundo visual: vamos a usar Rust para *abrir, leer y modificar* imágenes reales en tu disco duro.

== Creando tu primer proyecto con Cargo
En la Playground solo teníamos el contenido de un archivo volcado en su lado izquierdo. Ni siquiera teíamos un fichero físico. En el mundo profesional, un programa real se compone de varios archivos y herramientas. Para gestionarlos, Rust incluye un asistente en la terminal llamado Cargo. *La instalación que hicimos de Rust en el apatado anterior nos proporciona todas las herramientas del asistente Cargo.*

Para organizar nuestros proyectos crearemos una carpeta raiz de los mismos con el nombre *proyectos-rust*. Podemos ubicarla en cualquier parte de nuestro disco duro. Si has seguido los apartados anteriores de este cuaderno, seguramente ya tendrás creada esta carpeta.

*Creación del proyecto*

Abre la terminal de tu ordenador en la carpeta *proyectos-rust* y escribe la siguiente orden para crear tu primer proyecto Rust:

```bash
cargo new tratamiento_imagenes
```
La orden anterior creará la carpeta de proyecto *tratamiento_imagenes* dentro de la primera carpeta creada `proyectos-rust`.

⚠️ *El truco de las carpetas:*

Cargo es muy estricto y no te permite crear proyectos cuyo nombre empiece por un número (por ejemplo, `7_tratamiento_imagenes` daría error). El truco consiste en crear el proyecto tal y como hicimos arriba y, una vez creado, si lo deseas vas a tu gestor de archivos normal de Windows/Linux/Mac y renombras la carpeta añadiéndole el número delante. ¡Hecha la ley, hecha la trampa!

🛠️ *Cómo abrir el proyecto en Visual Studio Code:*
- Abre Visual Studio Code.
- Ve al menú superior y selecciona *Archivo -> Abrir carpeta* (Open Folder).
- Selecciona la carpeta *proyectos-rust* y dale a *Seleccionar* o *Abrir*. 

En la barra lateral izquierda verás la carpeta `proyectos-rust` y en su interior  la del proyecto creado anteriormente *tratamiento_imagenes.* Desplegando esta carpeta verás la estructura del proyecto:

- 📂 *src/:* La carpeta sagrada. Dentro está *main.rs*, que es donde escribirás tu código.
- 📄 *Cargo.toml:* El archivo de configuración. Abre este archivo y, debajo de donde dice [dependencies], añade la herramienta de imágenes escribiendo exactamente: *image = `"`0.24`"`* (o la versión actual) tal como se muestra a continuación:

```bash
[dependencies]
image = "0.24"
```
== 🎛️ El cuadro de mandos de Cargo
En primer lugar abre la terminal integrada de VS Code haciendo *click derecho* sobre la carpeta del proyecto y seleccionando *Open in integraded Ternminal.* (En español debe ser algo así como `Abrir en la terminal integrada`)

Para trabajar de forma profesional, solo necesitas memorizar estos comandos que escribirás en la terminal integrada de VS Code cuando corresponda:

Los comandos de Cargo empiezan con *cargo + una palabra más.*

#table(
  columns: (auto, 1fr),
  align: (left + horizon, left + horizon),
  stroke: 0.5pt + rgb("#767676"),
  
  // Encabezados de la tabla
  [*Comando*], [*¿Qué hace?*],
  
  // Filas de contenido
  [*cargo check*], [Escanea tu código rápido para ver si tienes errores en rojo sin llegar a compilarlo.],
  [*cargo build*], [Compila tu código y genera el programa ejecutable.],
  [*cargo run*], [Hace todo a la vez: compila el código y lo ejecuta de inmediato en tu pantalla.],
)

== ¿🎨 Qué es una imagen para un ordenador?
Para nosotros, una foto es un paisaje o una persona. Para el ordenador, una imagen es una *cuadrícula gigante de colores* (una matriz matemática). Cada cuadradito de esa cuadrícula se llama píxel. Cada rectángulo (debería ser cuadrado) que hemos representado abajo en la matriz representa un pixel de la imagen. Si la imagen fuera por ejemplo de 400x200 píxeles, la matriz que la representa tendrá una anchura de 400 píxeles y una altura de 200 píxeles. Esto equivale a tener 200 filas y 400 columnas.

```
        Columna 0   Columna 1   Columna 2   ...   Columna J
      +-----------+-----------+-----------+-----+-----------+
Fila 0|  Píxel    |  Píxel    |  Píxel    |     |  Píxel    |
      +-----------+-----------+-----------+-----+-----------+
Fila 1|  Píxel    |  Píxel    |  Píxel    |     |  Píxel    |
      +-----------+-----------+-----------+-----+-----------+
Fila 2|  Píxel    |  Píxel    |  Píxel    |     |  Píxel    |
      +-----------+-----------+-----------+-----+-----------+
...   |           |           |           |  ↘  |           |
Fila I|  Píxel    |  Píxel    |  Píxel    |     |Píxel(I,J) | 
      +-----------+-----------+-----------+-----+-----------+    
```
De forma general, al pixel que está situado en la fila I y columna J le llamamos Pixel(I, J)

Cada píxel guarda su color *mezclando tres colores básicos* (Formato RGB: Red, Green, Blue). Por tanto, cada píxel almacena 3 valores numéricos entre 0 y 255. Este rango de valores entre 0 y 255, ambos inclusive, es el que tienen las variables de tipo u8 (enteros sin signo de 8 bits). En ocasiones, se incorpora un cuarto valor al pixel denominado Alfa que representa la transparencia en imágenes que tienen esa propiedad.

Algunos ejemplos para valores de un pixel:

  - *[255, 0, 0]* es Rojo puro (rojo al máximo, cero para verde y cero para azul).
  - *[0, 255, 0]* es Verde puro.
  - *[0, 0, 255]* es Azul puro.
  - *[0, 0, 0]* es Negro (luces apagadas).
  - *[255, 255, 255]* es Blanco (luces a tope).

== Programa 1: Leyendo el color de un píxel
Para este experimento, busca una imagen en internet ---la famosa foto de prueba *lena.jpg* o cualquier otra; también tienes una carpeta de imágenes en el repositorio que te has descargado---, renómbrala como *entrada.jpg* y guárdala dentro de la carpeta principal de tu proyecto (al lado del fichero *Cargo.toml*).

#nota("Estamos trabajando en el proyecto *tratamiento_imagenes* que creamos en el apartado 7.1.")

💻  Escribe este código dentro de tu archivo *src/main.rs* borrando si existía algo previamente:

```rust
use image::GenericImageView; // Importamos la herramienta para mirar imágenes

fn main() {
    // 1. Intentamos abrir la imagen de tu disco duro
    let imagen = image::open("entrada.jpg").expect("❌ ¡No encuentro el archivo entrada.jpg!");

    // 2. Le preguntamos sus dimensiones (Ancho y Alto)
    let (ancho, alto) = imagen.dimensions();
    println!("📸 Imagen cargada con éxito. Tamaño: {}x{} píxeles.", ancho, alto);

    // 3. Inspeccionamos las coordenadas de un píxel concreto (Fila 100, Columna 100)
    let pixel = imagen.get_pixel(100, 100);

    // 4. Mostramos sus componentes de color RGB
    println!("🎨 El píxel en (100,100) tiene los valores: RGBA -> {:?}", pixel);
}
```
⚙️ *Explicación del programa*

*1. La instrucción:*

```rust
let imagen = image::open("entrada.jpg").expect("❌ ¡No encuentro el archivo entrada.jpg!");
```
Hará que el programa cargue en memoria la imagen *entrada.jpg* si la encuentra en el directorio adecuado (en el directorio principal, al lado de Cargo.toml) y el nombre se correspode con un fichero de imagen valido. Si no se cuemplen estas condiciones, evidentemente no se cargará nada en memoria y se mandará a la terminal el mensaje:

`❌ ¡No encuentro el archivo entrada.jpg!`

*2. La instrucción:*

```rust
let (ancho, alto) = imagen.dimensions();
```
Coloca el `ancho en pixeles de la imagen` en la variable *ancho* y el `alto en pixeles` en la variable *alto*.

*3. La instrucción:*

```rust
let pixel = imagen.get_pixel(100, 100);
```
Es bastante interesante. La parte que hay a la derecha del igual busca el pixel (100,100) de la imagen y copia sus 4 valores (3 valores de color y uno de transparencia). Los píxeles se cuentan partiendo de la posición (0, 0) en la esquina superior izquierda de la imagen y van aumentando cuando nos desplazamos a la derecha y hacia abajo.

Esos cuatro valores forman un dato compuesto y se asignan en un solo nombre a la variable *pixel*, a la izquierda del igual.

*4. La instrucción:*

```rust
println!("🎨 El píxel en (100,100) tiene los valores: RGBA -> {:?}", pixel);
```
Muestra los cuatro valores de pixel. 

Observa que hemos utilizado el marcador *{:?}* para imprimir *pixel*. Esto es consecuencia de que pixel es una variable compuesta (4 valores) y con este marcador Rust sabe como imprimirla. El resultado de imprimir lo tienes en la línea de abajo que constituye la salida del programa:

El píxel en (100,100) tiene los valores: RGBA -> Rgba([139, 71, 60, 255])

🚀 *Ejecutar el programa*

Para compilar el programa necesitas activar una terminal integrada de VS Code apuntando al directorio de tu proyecto. La forma mas sencilla de consegirlo es haciendo click derecho sobre la carpeta del proyecto en el panel izquierdo de VS Code y seleccionar *Open in Integrated Terminal* (Abrir en la Terminal integrada).

Una vez hayas llegado aquí, ejecuta el comando *cargo run* en tu terminal. Verás cómo Rust descompone ese punto exacto de la foto en sus números de color y te entrega el resultado.

== Programa 2: Modificando píxeles y pintando un cuadrado rojo
Vamos a crear un segundo proyecto para modificar píxeles pintando un cuadrado rojo sobre la imagen.

Título del proyecto: *tratamiento_imagenes_2*

Hay varias formas de obtener este segundo proyecto:

+ *La aconsejada:* seguir los pasos indicados en el apartado *7.1 Creando tu primer proyecto con Cargo*

+ Hacer un clon (copiar y pegar) la carpeta de tu primer proyecto *tratamiento_imagenes* y cambiar el título de la carpeta a *tratamiento_imagenes_2*. 

Luego, en cualquiera de los dos casos, tendrás que editar el fichero *src/main.rs* y ponerle el código que te daremos más abajo.

En el proyecto del apartado anterior, si hubiéramos procedido a modificar un solo píxel en la foto digital de alta resolución, sería como cambiar un granito de arena en la playa: el ojo humano no se va a dar cuenta. Para comprobar que realmente tenemos el poder de *hackear* la imagen, vamos a hacer un experimento más visible.

Vamos a seleccionar el píxel (100, 100) de la imagen lena.jpg y, usando la potencia de los bucles que aprendiste en el laboratorio, pintaremos un cuadrado rojo de 11x11 píxeles a su alrededor. Luego, guardaremos el resultado en un archivo nuevo llamado *lena_modificada.png*.

#nota("Es posible que necesistes revisar el funcionamiento de los bucles for para entender los dos proyectos que siguen a continuación. En tal caso, revisa el apartado '4.4 El bucle for con rangos.'")

💻  Escribe este código dentro de tu archivo *src/main.rs* borrando primero cualquier código preexistente:

```rust
use image::{GenericImage, Rgb};

fn main() {
    // 1. Cargamos la imagen original abriendo la caja con permiso de mutación (mut)
    // Necesitamos 'mut' porque vamos a alterar sus píxeles.
    let mut imagen = image::open("lena.jpg")
        .expect("¡Error! No se encuentra el archivo lena.jpg");

    println!("🎨 Modificando la imagen... Dibujando zona de pruebas.");

    // El color rojo en formato RGB se compone de: Máximo Rojo (255), cero Verde (0) y cero Azul (0)
    let color_rojo = Rgb([255, 0, 0]);

    // 2. Usamos dos bucles anidados para recorrer un área de 11x11 píxeles
    // El contador 'x' irá desde 95 hasta 105 (11 posiciones en total)
    for x in 95..=105 {
        // Por cada posición de 'x', el contador 'y' también se mueve de 95 a 105
        for y in 95..=105 {
            // Pintamos el píxel actual con nuestro color rojo
            imagen.put_pixel(x, y, image::Pixel::from_channels(255, 0, 0, 255));
        }
    }

    // 3. Guardamos el resultado en el disco duro con un nombre nuevo
    imagen.save("lena_modificada.png")
        .expect("No se pudo guardar la imagen modificada");

    println!("💾 ¡Éxito! Archivo 'lena_modificada.png' guardado en la carpeta de tu proyecto.");
}
```
⚙️ *El análisis del detective: ¿Cómo se pinta un área?*

Vamos a destripar la lógica de este programa paso a paso:

- La herramienta *GenericImage:* Al principio del archivo verás que hemos importado GenericImage. En el lenguaje de Rust, esta herramienta le da a nuestra imagen el *poder* de ser modificada mediante la función *.put_pixel()*.

- Las variables *mut* de verdad: Fíjate en la línea *let mut imagen = ....* Si hubiéramos olvidado poner la palabra mut, Rust habría bloqueado el programa en seco al llegar a la orden de pintar. Rust protege la imagen original a menos que le digas explícitamente con *mut* que la vas a alterar.

- El escáner del bucle (*for x in 95..=105*): La sintaxis *95..=105* en Rust significa `recorre todos los números desde el 95 hasta el 105, ambos incluidos`. Al meter un bucle dentro de otro, el ordenador funciona como una máquina de coser: se posiciona en la *columna x = 95* y recorre *todas las filas de esa columna* pintando de rojo, luego pasa a *x = 96* y repite. Así hasta rellenar el cuadrado perfecto de 11x11.

🎮 *¡Tu momento de comprobar el laboratorio!*

1. Abre tu terminal integrada en VS Code sobre el directorio del proyecto y escribe tu comando sagrado:

```bash
cargo run
```
2. Al terminar, fíjate en la barra lateral izquierda de VS Code (donde están los archivos de tu proyecto). ¡Magia! Ha aparecido un archivo nuevo llamado *lena_modificada.png*.

3. Haz clic sobre él dentro de VS Code para abrirlo. Busca con la mirada la zona superior izquierda, coordenadas (100, 100). Verás un pequeño y perfecto cuadrado de color rojo brillante flotando sobre la imagen. ¡Has alterado con éxito los píxeles usando tu propio código!

🎨 *El resultado que debes obtener*

#figure(
  image("lena_cuadrado.png", width: 70%),
  caption: [
    Imagen de Lena con el cuadrado rojo superpuesto
  ],
)

== Programa 3: Recorriendo la matriz completa (El filtro Negativo)

Ya sabemos localizar un píxel y sabemos pintar un cuadrado. Ahora vamos a hacer magia a lo grande: vamos a aplicar un filtro de colores invertidos (efecto negativo) a toda la fotografía.

#nota("Crearemos un nuevo proyecto llamado 'tratamiento_imagenes_3'  siguiendo los mismos pasos que en el apartado anterior.")

Para lograrlo, le diremos a Rust que averigüe el *ancho* y el *alto* exactos de la imagen y que pase un escáner píxel por píxel, desde la esquina superior izquierda hasta la esquina inferior derecha. 

La regla matemática para invertir un color es muy sencilla: *restamos el valor actual de cada canal (Rojo, Verde y Azul) al número máximo posible, que es 255*.

👾 _Tu primer superpoder de edición: ¡El Filtro Negativo! ¿Sabías que los filtros de Instagram o de TikTok son en realidad pequeños programas matemáticos que modifican los píxeles uno a uno? En este experimento vamos a crear nuestro propio filtro._

_Un ordenador ve los colores combinando Rojo (Red), Verde (Green) y Azul (Blue) con valores de 0 a 255. Para hacer el negativo, solo tenemos que restarle a 255 el valor actual de cada color._

_Si un píxel es muy rojo (255), tras la resta pasará a ser 0 (nada de rojo). ¡Mira el resultado (al final del apartado) de aplicar este bucle matemático a nuestra imagen de prueba! ¿A que parece sacada de una película de ciencia ficción?_

💻  *Escribe este código dentro de tu archivo src/main.rs*:

```rust
use image::{GenericImage, GenericImageView, Pixel};

fn main() {
    // 1. Cargamos la imagen original con permiso para modificarla (mut)
    let mut imagen = image::open("lena.jpg")
        .expect("¡Error! No se encuentra el archivo lena.jpg");

    // 2. Le preguntamos a Rust cuáles son las dimensiones de la foto
    let (ancho, alto) = imagen.dimensions();
    println!("📸 Imagen cargada correctamente (Tamaño: {} x {} píxeles).", ancho, alto);
    println!("⏳ Aplicando filtro negativo a toda la imagen... Esto puede tardar un par de segundos.");

    // 3. El gran escáner: recorremos todas las columnas (x) y todas las filas (y)
    for x in 0..ancho {
        for y in 0..alto {
            // Capturamos el píxel actual en esa coordenada
            let pixel_original = imagen.get_pixel(x, y);
            
            // Extraemos sus canales de color en formato de lista (Rojo, Verde, Azul, Alfa)
            let canales = pixel_original.to_rgba();
            
            // Calculamos el color invertido restando cada componente a 255
            let nuevo_rojo = 255 - canales[0];
            let nuevo_verde = 255 - canales[1];
            let nuevo_azul = 255 - canales[2];
            let alfa = canales[3]; // La transparencia la dejamos exactamente igual

            // Fabricamos el nuevo píxel con los colores calculados
            let nuevo_pixel = Pixel::from_channels(nuevo_rojo, nuevo_verde, nuevo_azul, alfa);

            // Inyectamos el nuevo píxel de vuelta en la imagen tapando el viejo
            imagen.put_pixel(x, y, nuevo_pixel);
        }
    }

    // 4. Guardamos la nueva obra de arte
    imagen.save("lena_negativo.png")
        .expect("No se pudo guardar la imagen modificada");

    println!("💾 ¡Filtro completado! Revisa el archivo 'lena_negativo.png'.");
}
```
⚙️ *El análisis del detective: ¿Cómo escaneamos miles o millones de píxeles?*

- El radar automático *imagen.dimensions()*: Gracias a la herramienta *GenericImageView*, no necesitamos adivinar el tamaño de la foto. Rust lee el archivo y nos devuelve dos números enteros: el *ancho* y el *alto*.

- La lista de canales (*canales[0], canales[1], canales[2], canales[3]*): Un píxel guarda sus cuatro valores como si fuera una lista de elementos en un estante. En programación, siempre empezamos a contar desde el cero:

```bash
canales[0] es el Rojo
canales[1] es el Verde
canales[2] es el Azul
canales[3] es la Transparencia
```
- La ilusión de la velocidad: Aunque parezca que el ordenador hace un trabajo titánico recorriendo miles de píxeles uno a uno, gracias al espectacular rendimiento de Rust, el bucle procesará toda la matriz en menos de lo que tardas en parpadear.

🎮 *¡Comprueba tu filtro profesional!*

+ Crea una terminal integrada de VS Code sobre la carpeta del proyecto.
+ Ejecuta tu comando en la terminal:

```bash
cargo run
```
3. Abre el nuevo archivo generado *lena_negativo.png*. ¡Verás la mítica foto transformada por completo en una película de terror o un negativo fotográfico antiguo! Los rostros claros ahora son oscuros, y los colores han cambiado por sus opuestos exactos.

🎨 *El resultado que debes obtener*

#figure(
  image("lena_negativo.png", width: 70%),
  caption: [
    Imagen de Lena con un filtro negativo
  ],
)

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

    // 1. Rellenamos la ficha creando un objeto con nuestra estructura personalizada,
    // la que hemos creado arriba
    let usuario = Persona {
        nombre: String::from("Halcón68"),
        edad: 14,
        profesion: String::from("Programador de Rust"),
    };

    // 2. Método 1: Leer e imprimir los campos uno por uno (usando el punto '.')
    println!("👤 Nombre del usuario: {}", usuario.nombre);
    println!("🎂 Edad actual: {} años", usuario.edad);
    println!("💼 Profesión: {}", usuario.profesion);
    
    println!("\n------------------------------------------------\n");

    // 3. Método 2: Imprimir la estructura COMPLETA de golpe
    // ⚠️ ¡Ojo! Para imprimir un struct entero usamos el marcador especial {:?} y
    // tenemos que haberle dado superpoderes antes: #[derive(Debug)]
    println!("📸 Radiografía completa del objeto en memoria:\n {:?}", usuario);
}
```

⚙️ *El análisis del detective: Perdiendo el miedo a internet*

Si buscas códigos de Rust en foros o tutoriales de internet, te vas a cruzar constantemente con líneas raras que llevan un signo de almohadilla y corchetes, como `#[derive(Debug)]`. Vamos a quitarles la máscara para que veas que no muerden:

- *¿Qué es un struct?:* Piensa en él como el diseño en papel de una ficha de estudiante. No es un dato real todavía, es solo la plantilla que dice: "Cualquier Persona que creemos con esta estructura tendrá obligatoriamente un *nombre*, una *edad* y una *profesión*". Estas tres variables se denominan campos y cuando diseñamos el *struct* especificamos de que tipo deben ser.

A partir del *struct Persona* hemos creado una variable *usuario* que será de tipo *Persona*, pasando valores a los campos del struct con unos tipos que coinciden con los especificados en el struct Persona.

- *El operador punto (usuario.nombre):* Para acceder a los campos guardados dentro de nuestra estructura, usamos un punto .. Es la forma de decirle a Rust: `Ve a la caja llamada usuario y, por ejemplo, sácame únicamente lo que haya en su cajón nombre`.

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

#pagebreak()