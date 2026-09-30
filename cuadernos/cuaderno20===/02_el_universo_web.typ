#import "config.typ": *

= El Universo Web
El desarrollo moderno de software no se puede entender sin su conexión con la red, y es aquí donde el protocolo HTTP se consolida como el idioma universal para la comunicación entre clientes y servidores. A lo largo de este capítulo, exploraremos los fundamentos de cómo funciona la Web y cómo viaja la información a través de la infraestructura global de internet. Analizaremos en detalle la anatomía de las peticiones (Requests) y respuestas (Responses) que componen cada interacción digital, para finalmente consolidar todo este conocimiento teórico en un proyecto práctico de ingeniería: la construcción y programación de un mini-servidor web desde cero utilizando Rust, aprovechando su velocidad y seguridad de memoria nativas.

== ¿Cómo funciona la Web? El protocolo HTTP
Estamos acostumbrados a viajar por la web de forma intuitiva colocando una dirección en el campo de URL del navegador o haciendo clic en los enlaces de las páginas web. Sin embargo, cada vez que entras en una página web, tu navegador (cliente) envía una Petición (Request) a un ordenador remoto (servidor). El servidor lee esa petición y devuelve una Respuesta (Response) que suele contener texto en formato HTML, imágenes o datos.

El protocolo HTTP es el idioma estándar en el que se comunican cliente y servidor. Una petición básica le dice al servidor: "Quiero obtener (GET) el archivo principal (https://www.google.com/)". El servidor responde con un código de estado (como 200 OK si todo fue bien, o el famoso 404 Not Found si no existe el archivo) seguido del contenido de la página.

== El Protocolo HTTP y Tu Primer Servidor
El protocolo HTTP (Hypertext Transfer Protocol) es la base de la comunicación en la World Wide Web, permitiendo que un cliente (como un navegador) y un servidor intercambien datos de forma estructurada. En el ecosistema de Rust, crear un primer servidor web implica abrir *un puerto TCP* para escuchar conexiones entrantes, *procesar los bytes recibidos* según las reglas de HTTP y *devolver una respuesta* adecuada. Para proyectos iniciales, esto se puede lograr utilizando la biblioteca estándar (*std::net::TcpListener*), lo que permite entender los fundamentos de la red antes de dar el salto a frameworks (marcos de trabajo) más avanzados del ecosistema como *Axum* o *Actix-web*.

== ¿Cómo viaja la información por la web?
La información en la web viaja empaquetada en mensajes de texto plano a través de la pila de protocolos TCP/IP, donde HTTP opera en la capa de aplicación para definir el formato de dichos mensajes. Cuando un usuario introduce una URL, el navegador realiza una resolución DNS para encontrar la dirección IP del servidor, establece una conexión segura mediante TLS/SSL (HTTPS) y transmite la información fragmentada en paquetes de red. Al ser HTTP un protocolo sin estado (stateless), cada interacción se trata de forma independiente, lo que significa que el servidor no recuerda las peticiones anteriores a menos que se utilicen mecanismos adicionales como cookies o tokens de sesión.

== Peticiones (Requests) y Respuestas (Responses)
Una petición (Request) HTTP es el mensaje que envía el cliente e incluye obligatoriamente un método o verbo de los siguientes (GET, POST, PUT, DELETE), una URL o ruta, la versión del protocolo, cabeceras (headers) con metadatos y, opcionalmente, un cuerpo (body) con datos. 

Por tanto, cuando escribes una dirección web en el navegador o pinchas sobre un enlace, estás mandando al servidor una petición (Request) similar a la siguiente:

```bash
GET /index.html HTTP/1.1
Host: ://mi-servidor-rust.com
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)
Accept: text/html
Connection: close
```
Hemos supuesto que mandas la petición al servidor: `mi-servidor-rust.com`

- Línea 1: Indica la acción (GET, para obtener datos), el archivo solicitado (/index.html) y la versión del protocolo (HTTP/1.1).

- Líneas 2-5: Son las cabeceras (metadatos). Le dicen al servidor a qué dominio se conecta (Host), qué navegador se usa (User-Agent) y qué tipo de archivo espera recibir (Accept).

Por otro lado, la respuesta (Response) es la contestación del servidor, la cual contiene un código de estado numérico (como 200 OK, 404 Not Found o 500 Internal Server Error), cabeceras que describen el contenido (como Content-Type) y el cuerpo que alberga el recurso solicitado (HTML, JSON, imágenes). En Rust, estos componentes se modelan mediante estructuras de datos y enums que garantizan un tipado seguro, evitando errores comunes al parsear o construir mensajes web.

En el caso de la petición anterior, la respuesta del servidor podría ser la siguiente:

```bash
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Content-Length: 114
Connection: close

<html>
  <body>
    <h1>¡Hola Mundo desde Rust!</h1>
    <p>Tu primer servidor funciona.</p>
  </body>
</html>
```
- Línea 1: La línea de estado. Confirma que todo ha ido bien devolviendo el código numérico 200 OK.

- Líneas 2-4: Las cabeceras de respuesta. Informan al navegador que lo que va a leer es un archivo web (text/html) y cuánto mide exactamente en bytes (Content-Length).

- Línea 5: Una línea en blanco obligatoria. Es el separador crítico que le dice al navegador: "Fin de los metadatos, empieza la página web".

- Bloque final: El cuerpo (Body). El código HTML puro que el navegador interpretará para pintarlo de forma visual en la pantalla del usuario.

== Proyecto Práctico: Creando un Mini-Servidor Web desde cero en Rust
Para entenderlo de forma nativa, utilizaremos la biblioteca estándar de Rust (std::net) para escuchar conexiones en nuestra máquina y responder con una página web real.Código de ejemplo (src/main.rs):

---

Para construir un mini-servidor web nativo en Rust sin dependencias externas (crates), lo que llamamos de forma nativa, se utiliza el módulo *std::net::TcpListener* para escuchar conexiones en nuestra máquina y responder con una página web real. También nos permitirá enlazar el programa a una dirección local y un puerto, como por ejemplo *127.0.0.1:8080*. 

El servidor se diseña mediante un bucle continuo que acepta *flujos de datos entrantes* (*TcpStream*), lee los bytes de la petición en un buffer de memoria y los procesa para identificar la ruta solicitada.

#nota("Un buffer de memoria es un espacio de almacenamiento temporal donde se guardan datos de forma provisional mientras se transfieren de un lugar a otro. Funciona como una sala de espera o `una caja de cartón` donde el programa va acumulando los bytes que llegan desde el exterior (como una petición web) hasta que tiene la cantidad suficiente para procesarlos todos juntos de forma eficiente.")

Finalmente, el código evalúa la solicitud y utiliza el método *stream.write_all* para enviar de vuelta una cadena de texto con formato analizable por el navegador, completando así el ciclo de vida de una transacción web con la máxima eficiencia y seguridad de memoria que caracteriza a Rust.


Código de ejemplo (src/main.rs):

```rust
use std::io::{prelude::*, BufReader};
use std::net::{TcpListener, TcpStream};

fn main() {
    // 1. Escuchamos en la dirección local (localhost) en el puerto 8080
    let listener = TcpListener::bind("127.0.0.1:8080").unwrap();
    println!("Servidor web iniciado en http://127.0.0.1:8080");

    // 2. Esperamos y procesamos las conexiones de los clientes
    for stream in listener.incoming() {
        let stream = stream.unwrap();
        gestionar_conexion(stream);
    }
}

fn gestionar_conexion(mut stream: TcpStream) {
    let buf_reader = BufReader::new(&mut stream);
    
    // Leemos la primera línea de la petición (ej. "GET / HTTP/1.1")
    let linea_peticion = buf_reader.lines().next().unwrap().unwrap();
    println!("Petición recibida: {}", linea_peticion);

    // Definimos la respuesta HTTP con código 200 OK y contenido HTML
    let contenido_html = r#"
        <!DOCTYPE html>
        <html lang="es">
        <head>
            <meta charset="UTF-8">
            <title>Mi Servidor en Rust</title>
            <style>
                body { font-family: sans-serif; background-color: #f4f4f9; text-align: center; padding-top: 50px; }
                h1 { color: #df4b32; }
            </style>
        </head>
        <body>
            <h1>¡Hola desde mi servidor Rust!</h1>
            <p>Este servidor ha sido programado desde cero en 2º de Bachillerato.</p>
        </body>
        </html>
    "#;

    let longitud = contenido_html.len();
    let respuesta = format!(
        "HTTP/1.1 200 OK\r\nContent-Length: {}\r\n\r\n{}",
        longitud, contenido_html
    );

    // Enviamos la respuesta de vuelta al navegador del usuario
    stream.write_all(respuesta.as_bytes()).unwrap();
}
```

*Explicación*

*1) En el main, la línea:*

```rust
// 1. Escuchamos en la dirección local (localhost) en el puerto 8080
let listener = TcpListener::bind("127.0.0.1:8080").unwrap();
```
Crea el servidor (listener) y queda escuchando en la dirección local del ordenador (127.0.0.1) y el puerto (8000). Habría sido equivalente escribir (localhost:8000). Solo podrás lanzar peticiones al servidor desde tu propio ordenador utilizando la dirección y puerto indicados anteriormente en cualquiera de las dos formas.

*2) El bucle for:*

```rust
// 2. Esperamos y procesamos las conexiones de los clientes
    for stream in listener.incoming() {
        let stream = stream.unwrap();
        gestionar_conexion(stream);
    }
```

¿Que es un stream?

Un stream (o flujo de datos) es como una tubería digital continua que conecta dos puntos (por ejemplo, tu navegador tu servidor en Rust) para transportar información de manera constante, bit a bit y en un orden estricto.

La analogía de *YouTube*: Cuando ves un vídeo en *streaming*, no esperas a que se descargue la película entera de 2 GB para empezar a verla; el vídeo te va llegando como un flujo constante de datos que reproduces en tiempo real mientras el resto sigue viajando por la red.

¿Qué resulta ser *listener.incoming()*?

listener.incoming() es un iterador (una secuencia infinita) que se queda "escuchando" el puerto de red. Cada vez que un cliente (como un navegador) intenta conectarse a nuestro servidor, este iterador atrapa esa conexión y nos da acceso a ella.

- Cómo funciona en la práctica: Imagínalo como una cinta transportadora en una fábrica. El bucle for se detiene y se queda esperando. En el momento en que alguien entra en la web, la cinta se mueve y nos entrega un nuevo paquete con la conexión.

- El truco de Rust: Este iterador nunca termina por sí solo. Mantiene el servidor vivo y funcionando en un bucle continuo para recibir visitas una detrás de otra.

¿En qué se traduce *let stream = stream.unwrap()*?

Esta línea realiza dos acciones fundamentales de Rust: desempaquetar el resultado seguro y redifinir la variable.

A. El desempaquetado con .unwrap()

En Rust, una conexión de red puede fallar en el último milisegundo (por ejemplo, si el cliente pierde la conexión justo cuando el servidor la estaba aceptando). Por eso, el iterador no te da la conexión directamente, sino que te da un envoltorio de seguridad llamado Result`<TcpStream, Error>`.

_.unwrap() significa: "Confío en que la conexión está bien. Abre el envoltorio, dame el flujo de datos real (TcpStream) para que pueda trabajar con él y, si hubo un error crítico, detén el programa"._

Es decir, si realmente ha habido un error en la conexión, tal como lo tenemos programado nosotros el programa fallaría y dari un (panic!), el programa se colgaría.

B. La redefinición (let stream = ...)

Esto se conoce en Rust como Variable Shadowing (Sombreado de variables). Permite reutilizar el mismo nombre (stream) de una variable para crear otra nueva variable.

- El primer stream (el del for) es el envoltorio con el posible error.

- El segundo stream (el del let) es la conexión limpia, extraída y lista para usar en la función gestionar_conexion.

*La función gestionar_conexion*

La función gestionar_conexion es el cerebro operativo de nuestro servidor. Es la encargada de recibir la "tubería" (stream) que abrió el cliente, leer lo que nos están pidiendo, y escribir la respuesta HTTP de vuelta para que el navegador pueda pintar la página web.

Aquí tienes el código típico de esta función en Rust explicado paso a paso:

```rust
use std::io::prelude::*; // Importa los traits Read y Write para poder usar leer y escribir en el stream
use std::net::TcpStream;

fn gestionar_conexion(mut stream: TcpStream) {
    // 1. Creamos el buffer de memoria (la sala de espera temporal)
    // Una matriz de 1024 bytes llenos de ceros
    let mut buffer = [0; 1024];

    // 2. Leemos los bytes que viajan por el stream y los metemos en el buffer
    stream.read(&mut buffer).unwrap();

    // 3. Preparamos la respuesta HTTP correcta (Línea de estado + Cabecera + Cuerpo)
    let contenido = "<html><body><h1>¡Servidor Rust Funciona!</h1></body></html>";
    let respuesta = format!(
        "HTTP/1.1 200 OK\r\nContent-Length: {}\r\n\r\n{}",
        contenido.len(),
        contenido
    );

    // 4. Enviamos la respuesta de vuelta por la tubería convirtiendo el texto en bytes
    stream.write_all(respuesta.as_bytes()).unwrap();
    
    // 5. Aseguramos que todos los bytes salgan de la memoria hacia la red
    stream.flush().unwrap();
} // <-- Aquí la variable 'stream' se destruye automáticamente y la conexión se cierra de forma segura
```

Explicación del paso a paso para la clase:

+ mut stream: TcpStream: La variable debe ser mutable (mut) porque leer y escribir datos altera el estado interno de la tubería (los bytes entran y salen, modificando su posición).

+ El Buffer ([0; 1024]): Creamos una "caja" vacía con capacidad exacta para 1024 bytes. Es el espacio temporal donde volcaremos el texto de la petición del cliente.

+ stream.read(...): El servidor mete la mano en la tubería, saca los bytes que envió el navegador y los deposita en nuestro buffer.

+ La construcción de respuesta: Creamos un String con la estructura exacta que exige el protocolo HTTP (que vimos en los apartados anteriores). Usamos \r\n\r\n (las dos líneas en blanco obligatorias) para separar los metadatos del código HTML real.

+ stream.write_all(...): Transforma nuestro texto a bytes binarios (.as_bytes()) y los empuja a través de la tubería de regreso al navegador del usuario.

+ stream.flush(...): Fuerza al sistema operativo a enviar inmediatamente cualquier byte rezagado que haya quedado esperando en la memoria intermedia de la tarjeta de red.

Al llegar al cierre de la llave }, se aplica la magia del Ownership (Propiedad) de Rust: la variable stream sale de su ámbito (scope), el compilador libera el recurso y la conexión de red se cierra automáticamente sin riesgo de fugas de memoria.

Al ejecutar este programa y abrir http://127.0.0.1:8080 en cualquier navegador, verás tu página web. El servidor lee la petición, monta el mensaje HTTP correcto y lo envía de vuelta.


 


#pagebreak()