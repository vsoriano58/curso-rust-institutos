#import "config.typ": *

= 🔖 Introducción
¡Te damos la bienvenida al fascinante mundo de la programación!

Tienes en tus manos el primer cuaderno de una serie que iremos publicando paso a paso para acompañarte en esta aventura. No necesitas ninguna experiencia previa, ni saber de informática, ni ser un genio de las matemáticas. El único objetivo de este cuaderno es romper el miedo. Vamos a descubrir juntos cómo piensa un programador y cómo dar tus primeras órdenes a un ordenador. 

Para que no tengas que complicarte al comenzar instalando programas raros ni configurando pantallas difíciles, trabajaremos directamente desde una página web en Internet. Usaremos la aplicación web *Rust Playground* como si fuera un lienzo en blanco para pintar nuestras ideas, crear historias y diseñar nuestros propios juegos. ¡Empezamos!

== 📝Descripción de los capítulos
Para que no te pierdas en esta aventura, hemos dividido este cuaderno en varias etapas diseñadas para ir ganando "superpoderes" como programador poco a poco:

- *El Despegue (Capítulos 1 al 3)*: Aprenderemos cómo se comunica un programador con el ordenador, dónde guardamos la información y cómo usar la `Playground de Rust` desde el navegador sin instalar nada.

- *El Laboratorio de Pruebas (Capítulo 4)*: Nos remangaremos para experimentar con código real, aprenderemos a tomar decisiones con condiciones y a repetir tareas usando bucles en proyectos divertidos.

- *Profundizando en Rust (Capítulo 5)*: Viajaremos al interior de la memoria del ordenador para entender los tipos de datos y los operadores lógicos que hacen que la magia funcione.

- *El Entorno Profesional (Capítulos 6 y 7)*: Dejaremos atrás el navegador de internet para instalar `Rust` y `Visual Studio Code` en tu ordenador como tienen en realidad los ingenieros de software. ¡Terminaremos el cuaderno creando programas capaces de leer y aplicar filtros visuales a fotos reales!

== Qué es un repositorio y qué es Git
Cuando los programadores trabajan en un proyecto (como un videojuego o este curso de Rust), escriben decenas de archivos con código. Para que no se vuelva un caos de carpetas y archivos, con nombres como _*proyecto_final_version3_definitiva_ESTA_SI.rs*_, utilizamos una herramienta mágica llamada Git.

- *¿Qué es Git?*: Git es como una máquina del tiempo para tus archivos de código. Se encarga de vigilar tu proyecto y guardar "puntos de control" (como en los videojuegos). Si haces un cambio en tu código o el programa se rompe y no sabes qué ha pasado, puedes pulsar un botón y volver exactamente al momento en que todo funcionaba perfectamente. Sin embargo, nosotros no utilizaremos Git para realizar esta tarea, que se denomina control de versiones. Lo utilizaremos únicamente para descargarnos todo el material asociado al cuaderno1 y el propio cuaderno1 desde Internet hasta una carpeta que elijamos en nuestro ordenador personal. 

📂 Crea una carpeta denominada `proyectos-rust` en cualquier parte de tu disco duro, en donde almacenarás todos los archivos que vayamos escribiendo.

- *¿Qué es un Repositorio?*: Es el lugar donde se guardan todos los archivos de un proyecto junto con todo el historial de su "máquina del tiempo". Es decir, el repositorio guarda todas las versiones en el tiempo para cada archivo que almacena y su evolución desde que se creó el archivo en el repositorio hasta su estado actual en el mismo.

- *¿Qué es GitHub?*: `Git` funciona en tu propio ordenador, pero si quieres compartir tu caja fuerte digital de ficheros con el mundo, necesitas una nube. `GitHub` es como el "Instagram" o la red social de los programadores. Es una plataforma en Internet donde guardamos nuestros repositorios para que otras personas puedan ver nuestro código, descargarlo o colaborar con nosotros. Todo el material de este curso está guardado en un repositorio de GitHub llamado `curso-rust-institutos`. Luego explicaremos cómo puedes descargarlo a tu ordenador.

=== ⬇️ Instalación de Git en Linux
Si usas `Linux`, instalar Git es increíblemente rápido desde la terminal. Abre tu terminal favorita y escribe el comando según tu sistema:

- En *Ubuntu / Debian / Linux Mint*:
```bash
sudo apt update && sudo apt install git -y
```
- En *Fedora*:
```bash
sudo dnf install git -y
```
Para comprobar que se ha instalado bien, escribe el comando `git --version`. Si sale un número de versión, ¡ya lo tienes!

=== ⬇️ Instalación de Git en MacOs
En Mac, el propio sistema te lo pone muy fácil.

+ Abre la Terminal (búscala en el `Launchpad` o con `Spotlight` presionando `Cmd + Espacio`).
+ Escribe el siguiente comando y pulsa Enter:\
```bash
git --version
```
+ Si no lo tienes instalado, aparecerá una ventana emergente de Apple preguntándote si deseas instalar las Herramientas de línea de comandos de Xcode. Haz clic en Instalar y acepta las condiciones. ¡El sistema hará todo el trabajo por ti!

Para comprobar que se ha instalado bien, escribe el comando `git --version`. Si sale un número de versión, ¡ya lo tienes!

=== ⬇️ Instalación de Git en Windows
Para poner Git en Windows, seguiremos el método oficial:

+ Entra en la página web oficial: `git-scm.com` y descarga el instalador para Windows.

+ Ejecuta el archivo descargado. Te saldrá un asistente con muchas opciones de configuración. No te compliques: haz clic en "Next" (Siguiente) a todo dejando las opciones por defecto hasta que termine la instalación.

+ Al finalizar, tendrás un nuevo programa instalado llamado Git Bash. Esta es una terminal especial para Windows desde la cual podrás usar todos los comandos de Git exactamente igual que si estuvieras en Linux o Mac.

Existen varias formas de abrir la terminal Git Bash en Windows pero unas de las más sencillas son las siguientes:

- *Desde el menú Inicio*: Haz clic en el botón de Inicio de Windows, busca la carpeta Git en la lista de aplicaciones y haz clic sobre el icono de `Git Bash`.

- *Desde el Explorador de archivos (En cualquier carpeta)*: Haz clic derecho en una zona vacía de cualquier carpeta o en el Escritorio. En el menú contextual, selecciona `Git Bash Here` (o `Mostrar más opciones > Git Bash Here` en Windows 11). Esto abrirá la terminal directamente ubicada en esa ruta. 

Para comprobar que se ha instalado bien, escribe el comando `git --version`. Si sale un número de versión, ¡ya lo tienes!

== ⬇️ Descargar el material asociado al cuaderno con Git
Ahora que ya tienes la herramienta Git en tu ordenador, vas a utilizar tu primer comando de programación para traerte una copia exacta de toda nuestra caja fuerte del curso a tu equipo. A esto los programadores lo llamamos clonar un repositorio.

Abre tu terminal -en la carpeta `proyectos-rust` que hemos creado antes o en cualquier otra- (o Git Bash si estás en Windows) y escribe la siguiente orden mágica:

```bash
git clone https://github.com/vsoriano58/curso-rust-institutos.git
```
==  📂 Estructura del Repositorio (curso-rust-institutos)
(Esto lo completaremos al final)

#pagebreak()