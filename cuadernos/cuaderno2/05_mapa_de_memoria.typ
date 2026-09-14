= 🗺️ El Mapa de la Memoria de tu Programa

En el Cuaderno 1 *Descubriendo la Programación y Filtros Digitales* diferenciamos entre el *código fuente* (archivo que nosotros escribimos y es entendible por un humano) y el *código ejecutable* compuestos por unos y ceros, fruto del proceso de compilación pero que es el que entiende el ordenador.

Como casi todos conocemos Windows podemos decir que cuando arrancamos un programa haciendo doble clic sobre un icono del escritorio, estamos cargando en la memoria RAM del ordenador el ejecutable de ese programa. ¿Qué almacenamos en la RAM?

Imagina la memoria RAM asignada a tu programa como un gran edificio de cuatro plantas:

*1. 📜 El Segmento de Código (Text Segment)*

Aquí es donde se guarda, literalmente, tu programa traducido a lenguaje de máquina (los ceros y unos que entiende el procesador).
Es de sólo lectura. El ordenador lee las instrucciones de una en una para saber qué hacer, pero tu programa no puede modificarse a sí mismo mientras corre. ¡Sería peligrosísimo!

*2. 🗿 El Segmento de Datos (Data Segment y BSS)*

En esta zona se guardan las cosas que nacen con el programa y mueren con él. Por ejemplo, las variables globales o las constantes que declaras arriba del todo de tu código. Todavía no las hemos utilizado pero puedes imaginarlas como variables que nacen en el momento que se carga el ejecutable en memoria y están disponibles hasta que el programa termina. Permanecen inmutables en el mismo sitio desde el segundo uno hasta que cierras la aplicación.

*3. 🥞 El Stack (La Pila)*

Imagina una pila de platos en un buffet de hotel. Cuando pones un plato nuevo, lo pones arriba del todo. Cuando coges un plato, coges también el de arriba. A esto los informáticos lo llaman estructura LIFO (Last In, First Out: el último que entra es el primero que sale).

En el *Stack* se guardan las variables locales de tus funciones (los números enteros, booleanos, etc.). Es un área ultraordenada, limpia y ridículamente rápida. No pueden guardarse en el Stack aquellas variables cuyo tamaño es desconocido cuando se compila el programa.

*4. 🌳 El Heap (El Montón)*

Imagina un gran almacén caótico. Cuando necesitas espacio para algo grande o que no sabes cuánto va a medir, le gritas al encargado del almacén: "¡Oye, necesito sitio para un texto largo!". El encargado busca un hueco libre que sirva, mete el dato ahí y te da una ficha con la dirección exacta (un puntero) para que sepas dónde encontrarlo. Es un área enorme y flexible, pero más lenta de gestionar. 

Los *vectores*, que pueden aumentar y disminuir el número de elementos mientras se ejecuta el programa, se almacenan en el *Heap*.

Los *String* se almacenan en el Heap pero los *&str* se almacenan en el Segmento de Código, apartado 1.

Cuando tenemos variables de tipos compuestos, por ejemplo un struct como vimos en el Cuaderno 1, generalmente los campos que son de tipos básicos (i32, 264, f32, bool,... ) se almacenan el el stack y si tienen, por ejemplo, campos de tipo String, estos se almacenan en el Heap. No obstante, el compilador es siempre libre de hacer optimizaciones y lo que hemos dicho es solo de caracter general.

⚔️ *El Gran Duelo: ¿Stack o Heap?*

Para entender por qué Rust es tan especial, necesitas comprender la diferencia radical entre estas dos áreas. Vamos a ponerlas cara a cara:

#block(
  inset: 15pt,
  radius: 4pt,
  table(
    columns: (1.2fr, 2fr, 2fr),
    stroke: (x, y) => if y == 0 { none } else { (top: 1pt + rgb("33333b")) },
    fill: none,
    align: (col, row) => if col == 0 { left + horizon } else { left + top },
    
    // Encabezados
    table.header(
      [*Característica*], [🥞 *El Stack (La Pila)*], [🌳 *El Heap (El Montón)*]
    ),

    // Fila 1
    [*Tamaño del dato*],
    [Debe ser *conocido y fijo* antes de compilar.],
    [Puede ser *dinámico* y cambiar sobre la marcha.],

    // Fila 2
    [*Organización*],
    [Perfecta y secuencial (un plato encima de otro).],
    [Desparramada por el espacio libre disponible.],

    // Fila 3
    [*Velocidad*],
    [*Velocidad de vértigo*. El procesador sabe exactamente dónde está todo.],
    [*Más lento*. Hay que buscar sitio libre y seguir "pistas".],

    // Fila 4
    [*¿Cuándo se limpia?*],
    [Automáticamente cuando la función termina (el plato se retira).],
    [Hay que liberar el espacio a mano (o dejar que Rust lo haga por ti).]
  )
)

⚡ *Tiempo de Compilación vs. Tiempo de Ejecución: El Secreto del Tamaño*

Aquí está la clave de todo. Tu ordenador necesita saber cuánta memoria reservar para cada variable.

- Datos de *tamaño conocido* (Van al Stack): Si escribes *let edad: i32 = 16;*, el compilador sabe, antes de que nadie ejecute el programa, que un i32 ocupa exactamente 32 bits (4 bytes). Como el tamaño está grabado a fuego, Rust lo mete en el Stack. Es seguro, rápido y directo.

- Datos de *tamaño dinámico* (Van al Heap): Imagina que creas un programa para que el usuario escriba su nombre por teclado. ¿Mide igual lo que escribe si se llama "Ana" que si se llama "Alejandro"? ¡No! Como el tamaño no se conoce en tiempo de compilación (se conocerá cuando se ejecute el programa y el usuario entre el dato), Rust no puede meterlo en el Stack. En su lugar, pide espacio en el Heap en tiempo de ejecución, guardando allí el texto dinámico (String), mientras que en el Stack solo se queda una pequeña ficha de propiedad indicando dónde está ese montón de texto.

🕵️‍♂️ *El misterio de los &str y la Memoria de Sólo Lectura.*

¿Te acuerdas de que en el tema anterior dijimos que los &str eran como carteles tallados en piedra? ¡Ahora vas a entender por qué de verdad!

Cuando escribes en tu código algo como:

```rust
let saludo = "Hola, chicos";
```
Ese texto "Hola, chicos" se incrusta directamente dentro del Segmento de Código (nuestra planta 1 del edificio, la de sólo lectura) en el momento de compilar.

La variable saludo no contiene el texto en sí. Es simplemente una referencia (&); una flecha mágica que apunta a esa zona de solo lectura. Por eso jamás puedes modificar un &str: ¡porque intentarías escribir en la zona prohibida de la memoria! Si necesitas cambiar el texto, estás obligado a usar un String para que el ordenador cree una copia moldeable en el Heap.

🔮 *Conclusión: ¿Por qué os hacemos aprender esto si parece "magia"?*

Admitámoslo: hoy en día los ordenadores son tan potentes que devoran gigabytes de memoria sin pestañear. Podríamos dejar que el compilador maneje la memoria como le dé la gana y olvidarnos de este rollo. Sin embargo, entender esto es vital por una gran razón: El *Ownership de Rust* (su sitema de propiedad) se diseñó exclusivamente para gestionar el Stack y el Heap sin fallos.

Cuando entiendes que:

- Una variable en el Stack es dueña de un espacio en el Heap.
- Si esa variable desaparece (sale de su función), el plato del Stack se quita.
- Al quitarse el plato, el espacio asignado en el Heap se limpia al instante...

... en ese preciso momento, los errores del compilador de Rust dejan de parecer un castigo y se convierten en tu mapa del tesoro. Dejas de pelear contra la "magia" y empiezas a diseñar software rápido, seguro y profesional.