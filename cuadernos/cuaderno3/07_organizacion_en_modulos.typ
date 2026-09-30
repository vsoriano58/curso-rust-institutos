#import "config.typ": *

=  Limpieza y Orden: Organización en Módulos (`mod`)
Hasta ahora hemos escrito todo nuestro código (estructuras, enumerados, métodos y la función main) dentro de un único archivo de texto. Para proyectos educativos pequeños funciona bien. Sin embargo, en el mundo real, los programas comerciales tienen miles o millones de líneas de código. Dejarlo todo en un único fichero sería una pesadilla ilegible.

Rust soluciona esto dividiendo el código en carpetas y archivos independientes a través de su sistema de módulos (`mod`).

== ¿Por qué un solo archivo `main.rs` ya no basta?
Trabajar en un único archivo tiene tres problemas principales:

- *Dificultad de lectura:* Buscar una línea concreta entre miles de líneas es ineficiente.

- *Conflictos de equipo:* Si varios programadores modifican el mismo archivo a la vez, se generan errores al fusionar el trabajo.

- *Mantenimiento:* Mezclar la lógica del motor del juego con la interfaz de usuario hace que arreglar un fallo sea arriesgado.

Organizar el código en módulos nos permite encapsular la información, aislar los problemas y reutilizar componentes fácilmente.

Una forma frecuente de trabajar es dividir el programa total en diversos ficheros, cada uno de los cuales es un módulo. Por ejemplo, podríamos tener en un caso sencillo solo dos archivos, uno con la definición de funciones denominado *funciones.rs* y el archivo principal *main.rs*. Dentro del archivo main.rs, la primera instrucción podría ser *mod funciones*, para incluir el archivo funciones.rs en el archivo principal. Dentro del archivo funciones.rs, las funciones se calificarían con la palabra *pub* para que sean visibles desde el main.rs. Por ejemplo *pub fn sumar(a:i32, b:i32)*.

No obstante y con objeto de simplificar, en el siguiente apartado supondremos que creamos módulos dentro de un mismo fichero.

== Creación de módulos locales y la palabra clave `pub`
Por defecto, *todo en Rust es privado*. Si creas una estructura o una función dentro de un módulo, las partes externas del programa no podrán verla ni usarla a menos que la marques explícitamente como pública utilizando la palabra clave *pub*.

Imagina que organizamos nuestro código creando una "caja fuerte" interna (un módulo) dentro del mismo archivo para simular este aislamiento:

💻 Copia el siguiente código en la Playground y ejecútalo con [RUN]

Fichero: *modulo.rs*

```rust
// Definimos un módulo interno llamado 'sistema_seguridad'
mod sistema_seguridad {
    // Esta estructura es PÚBLICA porque lleva 'pub'
    pub struct TarjetaAcceso {
        pub codigo: u32,
        secreto_interno: u32, // Este campo es PRIVADO (no lleva pub)
    }

    impl TarjetaAcceso {
        // Constructor público
        pub fn new(codigo: u32, secreto: u32) -> TarjetaAcceso {
            TarjetaAcceso { codigo, secreto_interno: secreto }
        }

        // Método público para validar
        pub fn verificar(&self) -> bool {
            // Un método del módulo sí puede leer sus propios campos privados
            self.secreto_interno > 1000 
        }
    }
}

fn main() {
    // Para acceder al contenido del módulo usamos la ruta con los cuatro puntos (::)
    let tarjeta = sistema_seguridad::TarjetaAcceso::new(101, 5555);

    // Esto funciona porque el campo 'codigo' es público:
    println!("Leyendo tarjeta número: {}", tarjeta.codigo);

    // ❌ ERROR DE COMPILACIÓN: Si descomentas la siguiente línea, Rust fallará:
    // println!("El secreto es: {}", tarjeta.secreto_interno); 
    
    if tarjeta.verificar() {
        println!("🔓 Acceso concedido al servidor central.");
    }
}
```
== Estructura multi-archivo: Separando la lógica en ficheros independientes
El verdadero poder llega cuando extraemos el módulo a su propio fichero físico en el disco duro. En las versiones modernas de Rust, esto es sorprendentemente limpio.

Imagina que en tu proyecto tienes dos archivos dentro de la carpeta src/:

+ *src/autenticacion.rs* (El archivo donde guardaremos la lógica de validación).

+ *src/main.rs* (El archivo principal que coordina la aplicación).

*Fichero 1: src/autenticacion.rs*

En este archivo no ponemos la palabra clave mod. Escribimos directamente las estructuras y funciones que queremos empaquetar, asegurándonos de usar *pub*.

```rust
// src/autenticacion.rs

pub struct Usuario {
    pub nombre_usuario: String,
    email: String, // Privado: controlamos su acceso
}

impl Usuario {
    pub fn new(nombre: &str, correo: &str) -> Usuario {
        Usuario {
            nombre_usuario: String::from(nombre),
            email: String::from(correo),
        }
    }

    // Método público para verificar si el correo es institucional: contiene la @ y termina en .com
    pub fn tiene_email_valido(&self) -> bool {
        self.email.contains('@') && self.email.ends_with(".com")
    }
}
```
*Fichero 2: src/main.rs*

Para enlazar el archivo externo, usamos la palabra clave *mod* al principio de nuestro archivo principal. Rust buscará automáticamente un fichero que se llame igual que el módulo.

```rust
// src/main.rs

// 1. Le decimos a Rust que busque y cargue el archivo 'autenticacion.rs'
mod autenticacion; 

// Opcional: usamos 'use' para crear un atajo y no escribir la ruta completa cada vez
use autenticacion::Usuario;

fn main() {
    println!("=== 🛡️ SISTEMA DE ALTA DE USUARIOS ===");

    // 2. Instanciamos el objeto usando el módulo externo
    let nuevo_perfil = Usuario::new("Halcón_Retro", "halcon68@correo.com");

    // 3. Ejecutamos la lógica aislada
    if nuevo_perfil.tiene_email_valido() {
        println!("✅ Registro completado. Bienvenido, {}.", nuevo_perfil.nombre_usuario);
    } else {
        println!("❌ Error: El correo electrónico no cumple con los requisitos.");
    }
}
```
💻 Vamos a escribir los archivos anteriores en un proyecto Rust con Cargo. 

+ Abre una terminal integrada de Visual Studio Code en la carpeta *proyectos-rust* que creaste al principio o en cualquier otra. Ejecuta la orden *cargo new mod_autenticacion*. Se creará la carpeta de proyecto `mod_autenticacion` con una distribución de ficheros y el directorio *src*. En dicho directorio se encuentra el fichero *main.rs*. Haz clic derecho sobre la carpeta del directorio *src* y agrega un nuevo fichero al directorio con el nombre *autenticacion.rs*. Justo arriba de este texto tienes indicado el código que tienes que añadir a ambos ficheros, `autenticacion.r`s y `main.rs`.

+ Abre una terminal en la carpeta del proyecto y ejecuta la orden *cargo run* para compilar y ejecutar el programa.

== Proyecto Práctico III: Validador robusto de datos de usuario en producción
Para consolidar este cuaderno, deberás simular un sistema profesional dividiendo el código. Crearemos una estructura que valide las credenciales de un registro de usuario utilizando módulos, devolviendo resultados controlados mediante enumerados Option.

Si juntáramos la arquitectura multi-archivo en un bloque lógico simulado (para entender su interacción completa), el motor de registro luciría así:

```rust
// Simulación del módulo 'validador' que estaría en otro archivo
mod validador {
    pub struct Registro {
        usuario: String,
        clave: String,
    }

    impl Registro {
        pub fn new(usuario: &str, clave: &str) -> Registro {
            Registro {
                usuario: String::from(usuario),
                clave: String::from(clave),
            }
        }

        // Analiza las reglas del sistema y devuelve un Option
        // Si hay un error, devuelve Some(Mensaje). Si todo está limpio, devuelve None.
        pub fn procesar_seguridad(&self) -> Option<String> {
            if self.usuario.len() < 4 {
                return Option::Some(String::from("El nombre de usuario debe tener al menos 4 caracteres."));
            }
            if self.clave.len() < 6 {
                return Option::Some(String::from("La contraseña es demasiado corta e insegura (mínimo 6)."));
            }
            if self.clave == self.usuario {
                return Option::Some(String::from("La contraseña no puede ser idéntica al nombre de usuario."));
            }
            
            // Mandamos None para indicar que no hay mensajes de error: Todo perfecto
            Option::None
        }
    }
}

fn main() {
    println!("--- FORMULARIO DE INSCRIPCIÓN ---");

    // Caso de prueba 1: Intento de registro erróneo
    let intento_uno = validador::Registro::new("H68", "123");
    
    // Evaluamos el resultado usando el control de flujo match sobre el Option
    match intento_uno.procesar_seguridad() {
        Option::Some(error) => println!("❌ Registro denegado: {}", error),
        Option::None => println!("🎉 ¡Cuenta creada con éxito!"),
    }

    // Caso de prueba 2: Intento de registro correcto
    let intento_dos = validador::Registro::new("FalconRustaceo", "ClaveSegura2026");
    
    match intento_dos.procesar_seguridad() {
        Option::Some(error) => println!("❌ Registro denegado: {}", error),
        Option::None => println!("🎉 ¡Cuenta creada con éxito! El sistema está listo."),
    }
}
```

#nota("Ten en cuenta que la función `.procesar_seguridad` devuelve un Option<string>. En el main, desempaquetamos el Option con un match y según lo que tenga dentro imprimimos un mensaje u otro.")

💻 1. Crea un proyecto de Rust igual que hemos hecho en el apartado anterior. Utiliza la orden *cargo new validador*.

2. En la carpeta *src* crea el fichero* validador.rs* al lado del fichero existente *main.rs*.

3. Distribuye convenientemente el codigo que tienes arriba entre los dos ficheros, utilizando correctamente la palabra mod. La solución la tienes en el *codigo* del repositorio correspondiente al *cuaderno3* con el nombre de proyecto *validador*.




#pagebreak()