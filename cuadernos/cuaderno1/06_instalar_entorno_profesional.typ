#import "config.typ": *

= 🔖 Subiendo de nivel: Instalación de un Entorno de Desarrollo Profesional

*Objetivo:* Trabajo con imágenes

Si has llegado hasta aquí, ya has jugado con Rust en la Playground, has corregido errores en rojo y has creado tus primeros minijuegos. 

¡Felicidades! Pero la Playground tiene una limitación: vive en Internet y no puede tocar los archivos de tu ordenador.

¿Te imaginas programar un código en Rust que abra una foto tuya, la vuelva en blanco y negro, la pixelee o le dibuje figuras encima? Para trabajar con tratamiento de imágenes, necesitamos dar el salto al mundo profesional. 

Vamos a instalar el motor de Rust directamente en tu máquina.

== 🐧 Instalación en LINUX
Si usas *Linux*, juegas con ventaja: Rust se siente en casa en este sistema operativo y la instalación es limpísima.

- *Distribuciones soportadas (Lista veraz):*
 - Familia Debian: Ubuntu (versión 20.04 en adelante), Linux Mint, Pop!`_`OS, Zorin OS, Kubuntu, Xubuntu.
 - Familia Red Hat: Fedora, CentOS.
 - Familia Arch: Arch Linux, Manjaro.

- *Lista de programas a instalar:* 
 - *Herramientas de construcción* (build-essential): Rust necesita un *enlazador* (linker) para unir el código compilado.
 - *curl*: Programa auxiliar para instalar Rust.
 - *Rustup & Cargo:* El motor oficial y el gestor de paquetes de Rust.
 - *Visual Studio Code (VS Code):* Nuestro editor de código profesional.

🚀 *Instrucciones de instalación paso a paso en Linux:*

*Paso 1: Instalar los cimientos.* Abre tu terminal y escribe el comando para instalar las herramientas base (en Ubuntu/Debian):

```bash
sudo apt update && sudo apt install build-essential -y
```

*Paso 2: Instalar curl.* Abre tu terminal y ejecuta el siguiente comando:

```bash
sudo apt install curl -y
```

*Paso 3: Instalar Rust.* Copia y pega este comando oficial en la terminal para descargar e instalar Rust automáticamente:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Cuando te pregunte en la pantalla, pulsa la tecla 1 y luego ENTER para elegir la instalación por defecto.

*Paso 4: Activar el motor.* Cierra la terminal y vuélvela a abrir, o escribe este comando para que tu sistema sepa dónde está Rust:

```bash
source "$HOME/.cargo/env"
```

*Paso 5: El editor visual.* Instala Visual Studio Code desde la tienda de software de tu distribución o desde su web oficial.

== 🪟 Instalación en WINDOWS
Windows requiere un par de pasos extra porque, por defecto, no viene preparado de fábrica para compilar lenguajes de alto rendimiento como Rust.

- Versiones soportadas: Windows 10 y Windows 11 (de 64 bits).
- Lista de programas a instalar:
 - *Herramientas de C++ de Visual Studio (MSVC)*: Los cimientos que exige Rust en Windows. Hay que instalarlas en primer lugar.
 - *Rustup & Cargo* (Desde el instalador oficial de Rust para Windows).
 - *Visual Studio Code*. (Nuestro editor profesional)

🚀 *Instrucciones de instalación paso a paso en Windows:*

- *Paso 1: Los cimientos (¡Crucial!)*. Para que Rust funcione en Windows, necesita las *herramientas de compilación de Microsoft C++*. No te preocupes, no hace falta que instales todo el programa pesado de Visual Studio, solo utilizaremos una versión ligera.

+ Entra en la página oficial de #link("https://visualstudio.microsoft.com/es/downloads/")[Descargas de Visual Studio].
+ No le des al botón de descargar la versión Community que sale arriba del todo.
+ Baja por la página web hasta encontrar una sección desplegable llamada *Herramientas para Visual Studio* (o *Tools for Visual Studio*). 
+ Despliégala y encontrarás una subsección titulada *Herramientas de compilación para Visual Studio 2026* con un botón a la derecha para descargar. Haz clic en *Descargar*.
+ Al abrir el archivo descargado se iniciará el asistente. En la ventana de selección de componentes, asegúrate de marcar la casilla *Desarrollo para el escritorio con C++* en la esquina superior izquierda.
+ Pulsa en Instalar. (Aviso: tardará unos minutos porque, aunque es una versión reducida, sigue pesando bastante. ¡Paciencia!) 

- *Paso 2: El instalador de Rust*. Ve a la web oficial #link("https://rustup.rs/")[rustup.rs], pulsa sobre el enlace *display all supported installers.* y descarga el archivo ejecutable *rustup-init.exe*. Haz doble clic en él. Se abrirá una pantalla negra de consola. Pulsa la tecla 1 y luego ENTER. ¡Rust ya está en tu sistema!

Para que se reconozca la instalación, cierra la terminal que has estado utilizando y vuelve a abrir otra terminal.

- *Paso 3: El editor visual*. Descarga e instala *Visual Studio Code* desde su #link("https://code.visualstudio.com/Download?_exp_download=fb315fc982")[página oficial.]

== 🚀 Instrucciones en macOS
- *Paso 1: Activar las herramientas de Apple.* Abre la aplicación *Terminal* (búscala en tu Spotlight con *Cmd + Espacio*) y escribe este comando:
```bash
xcode-select --install
```
Si no están instaladas, te aparecerá una ventana emergente en tu Mac. Dale a *Instalar* y acepta los términos.

Si ya estan instaladas no tienes que hacer nada.

- *Paso 2: Descargar Rust.* En esa misma terminal, pega el comando universal de instalación:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
Pulsa 1 y luego ENTER cuando te lo pida la pantalla.

- *Paso 3: El editor visual.* Descarga Visual Studio Code para Mac desde la web oficial, arrástralo a tu carpeta de Aplicaciones y ábrelo.

== 🛠️ Configuración de Visual Studio Code (Para todos los sistemas)
Una vez instalado VS Code en tu ordenador, tenemos que tunearlo para que entienda Rust a la perfección. Abre VS Code, haz clic en el icono de Extensiones en la barra lateral izquierda (parecen 4 cuadraditos flotantes como se muestra abajo en la segunda imagen) e instala las tres extensiones que te indicamos después de leer estas instrucciones:

Fíjate en estos dos botones en la barra lateral izquierda de VS Code:

#figure(
  image("img2.png"),
  caption: [
    Botón de ficheros. Para visualizar los ficheros de nuestro directorio (cuando lo tengamos) en el panel izquierdo de VS Code.
  ],
)

#figure(
  image("img3.png"),
  caption: [
    Botón de extensiones. Para visualizar las extensiones y el cuadro de búsqueda en el panel izquierdo.
  ],
)

#figure(
  image("img4.png", width: 70%),
  caption: [
    Cuadro de búsqueda de extensiones.
  ],
)


*El botón Extensiones:*
#image("img2.png")

Cuando pulses sobre dicho botón te aparecerá en la parte superior izquierda del editot un campo que permite buscar extensiones introduciendo su nombre. Una vez encontrada la extensión te la presentará en la parte de arriba de la la lista de extensiones. Haz click sobre ella y te aparecerá la información correspondiente a la derecha con un botón *install* para instalarla. Al pulsar sobre install te aparece una ventana como la de abajo:

#figure(
  image("img5.png", width: 70%),
  caption: [
    Ventana para aceptar la instalación.
  ],
)

Pulsa sobre *Trust Publisher & Install* para decir que confías en la extensión y se instalará.

Estas son las tres extensiones que tienes que instalar.

+ *Rust Analyzer:* Es el cerebro. Te coloreará el código, te auto-completará palabras y te avisará de los errores en rojo antes de que compiles. (¡Ojo! No instales la que se llama solo `Rust`, esa es antigua; busca *Rust Analyzer*).

+ *Even Better TOML:* Sirve para que tu ordenador entienda los archivos de configuración de tus proyectos de Rust (los archivos *.toml* donde añadiremos la herramienta *craque* de imágenes).

+ *CodeLLDB:* Es la lupa del detective. Te permitirá pausar tu programa línea a línea si algo falla para ver qué hay dentro de la memoria.

== 🦀 La Gran Comprobación: ¿Funciona todo?
Para asegurarnos de que la instalación ha sido un éxito rotundo, abre una nueva terminal (en Windows puedes usar *Símbolo del sistema* o *PowerShell*; en Linux y Mac, la *Terminal* normal) y escribe estos comandos uno a uno:

```bash
rustc --version
cargo --version
```
Si todo ha ido bien, la pantalla no te dará ningún error; te devolverá una línea de texto por cada comando con la versión exacta de Rust que tienes instalada (por ejemplo: rustc 1.85.0 ...).

¡Enhorabuena! Has roto la barrera y ya tienes un entorno de desarrollo profesional en tu ordenador. Estás listo para crear magia con código real y manipular píxeles.

#pagebreak()