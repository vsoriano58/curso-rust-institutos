#import "config.typ": *

= Ejercicios propuestos

== Ejercicio 1: El Control de Altitud (Práctica con Option`<T>`)

- *Objetivo:* Utilizar Option`<T>` para gestionar límites de seguridad físicos en un entorno de simulación aérea.

- *Enunciado:* Desarrolla un programa para un dron de reconocimiento. Crea una función llamada *verificar_altitud(metros: i32) -> Option`<i32>`*. El dron opera de forma segura únicamente entre los 10 metros y los 500 metros de altura. Si la altitud está en ese rango, devuelve el valor envuelto en Some. Si está por debajo (riesgo de colisión con árboles) o por encima (violación del espacio aéreo), debe devolver None. El programa debe empezar pidiendo la altura del dron. El usuario la introduce y el programa debe contestar con el mensaje adecuado y solicitar de nuevo la altura del dron.

- 💡 Pistas para el alumno:

 - Recuerda usar los operadores lógicos && para evaluar si el número está dentro del rango permitido.

 - En el main, evalúa el resultado de la función usando un bloque match para imprimir alertas personalizadas en caso de recibir None.

🧪 Prueba de fuego: Si el usuario introduce 5, el programa debe decir "Alerta: Dron fuera de rango seguro". Si introduce 150, debe confirmar "Altitud estable a 150 metros".

== Ejercicio 2: El Validador de Contraseñas del Sistema (Práctica con Result`<T, E>`) 

- *Objetivo:* Gestionar errores informativos personalizados utilizando las variantes Ok y Err.

- *Enunciado:* Diseña una función *validar_password(password: &str) -> Result<(), String>*. Las reglas de seguridad del sistema exigen que la contraseña tenga como mínimo 8 caracteres. Si cumple la regla, devuelve Ok(()). Si es más corta, devuelve un Err con el mensaje: "Seguridad insuficiente: la contraseña debe tener al menos 8 caracteres".

- 💡 Pistas para el alumno:

 - Puedes medir la longitud de un texto en Rust utilizando el método .len() sobre la cadena.

 - Como la función solo valida y no necesita transformar ningún dato, usa el tipo unidad () para la variante de éxito.

- 🧪 Prueba de fuego: Al probar con "12345", el programa no debe cerrarse con pánico; debe imprimir limpiamente el texto del error devuelto por la función.

== *Ejercicio 3: El Lector Defensivo de Archivos (Manejo de archivos y ?)*

- *Objetivo:* Aprender a capturar los errores del sistema operativo de manera controlada sin que el programa colapse (panic).

- *Enunciado:* Escribe un programa que intente leer el contenido de un archivo llamado *secreto.txt* e imprimirlo por pantalla. Si el archivo no existe en la carpeta del proyecto, el programa de Rust fallará por defecto. Tu misión es capturar ese error de *entrada/salida (std::io::Error)* usando el operador ? en una función y, en el main, mostrar un mensaje amigable que diga: `"`Aviso: El archivo 'secreto.txt' no se encuentra en el directorio actual. Por favor, créalo.`"`.

- 💡 *Pistas para el alumno:*
 - Estructura tu función para que devuelva un Result`<String, std::io::Error>`.
 - No crees el archivo secreto.txt al principio; el objetivo es que compruebes primero cómo reacciona tu código cuando el archivo no está.
- 🧪* Prueba de fuego:* Ejecuta el programa. Si se interrumpe bruscamente con un mensaje de panic, la gestión de errores está mal hecha. Debe terminar de forma limpia mostrando tu aviso personalizado.

== Ejercicio 4: El Procesador de Inventario (Parsing y operaciones matemáticas)

*Objetivo:* Extraer datos numéricos de un archivo de texto plano y procesarlos de forma matemática.

*Enunciado:* Imagina que tienes un archivo llamado *inventario.txt* donde cada línea contiene únicamente el stock de un producto (por ejemplo, la primera línea dice "45", la segunda "12", etc.). Escribe un programa que lea el archivo línea por línea, convierta (parsee) cada línea a un entero (u32) y calcule la suma total de artículos en el almacén.

- *💡 Pistas para el alumno:*
 - Puedes usar *std::fs::read_to_string* para obtener todo el texto y luego el método *.lines()* para separar el contenido fila por fila mediante un bucle *for*.
 - Recuerda que .parse::`<u32>()` devuelve un Result. Usa ? o un match para extraer el número de forma segura.

- *🧪 Prueba de fuego:* Crea un archivo *inventario.txt* con los números 10, 20 y 30 (uno por línea). El programa debe imprimir exactamente: "Total de artículos en inventario: 60".

== Ejercicio 5: El Diario Personal Orientado a Registros (Uso de `OpenOptions`)

- *Objetivo:* Trabajar con la persistencia de datos acumulativa (modo append) sin destruir la información existente.

- *Enunciado:* Escribe una herramienta interactiva para la terminal que funcione como un diario de notas rápido. El programa debe pedirle al usuario que escriba una línea de texto por consola (sus pensamientos del día). Al pulsar Enter, el programa debe guardar esa línea en un archivo llamado *diario.txt*. Cada vez que el alumno ejecute el programa, la nueva nota debe escribirse en una línea nueva al final del archivo, conservando todo lo que se escribió en los días anteriores.

- *💡 Pistas para el alumno:*
 - Investiga el uso de *std::fs::OpenOptions*. Necesitarás activar los métodos *.append(true)* y *.create(true)*.
 - Utiliza la macro writeln! (con una 'n' al final) en lugar de write! para asegurar que cada anotación del diario empiece en una línea limpia.

- 🧪 *Prueba de fuego:* Ejecuta el programa tres veces seguidas introduciendo textos diferentes. Al abrir el archivo diario.txt con cualquier editor de notas, deberías ver las tres frases guardadas perfectamente en tres líneas distintas.

#pagebreak()