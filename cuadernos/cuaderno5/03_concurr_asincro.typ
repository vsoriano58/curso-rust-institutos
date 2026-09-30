#import "config.typ": *

= Concurrencia Segura y Asincronía en Rust

Todos los programas que hemos diseñado en los cuadernos anteriores comparten una característica fundamental: son estrictamente síncronos y no aplican concurrencia. Esto se traduce en que, al ejecutarse, consumen un único hilo de la CPU (procesador). 

Sin embargo, la informática actual ha cambiado. La gran mayoría de los procesadores modernos disponen de varios núcleos de hardware, y los sistemas operativos son capaces de gestionar miles de hilos de forma simultánea. Para aprovechar este potencial, los lenguajes modernos incorporan recursos que permiten a los programas exprimir cada núcleo de la CPU.

Para entender los conceptos fundamentales de la concurrencia y la asincronía, haremos un símil entre lo que ocurre realmente en el interior del procesador y una Gran Oficina de Envío de Paquetes (estilo Amazon o Correos) estructurada en tres capas: Hardware, Sistema Operativo y Software (Virtual).

#nota("Con Software (Virtual) nos referimos a hacer que algo parezca real mediante software, aunque físicamente no exista como tal. Por ejemplo, veremos a continuación cómo mediante software podremos crear la ilusión de que estamos ejecutando más tareas simultáneas que núcleos tenemos en la CPU. El software es capaz de conmutar 1.000 tareas entre 8 núcleos y dar la sensación de que se están ejecutando todas a la vez.")

== La Analogía de la Oficina de Correos

Imagina que tu programa es una empresa que tiene que procesar millones de paquetes (instrucciones del código).

*1. Los Hilos de Hardware (Capa 1) = Las Cintas Transportadoras Físicas*
En el sótano de la oficina hay 8 cintas transportadoras físicas instaladas en el suelo. No puedes pulsar un botón mágico y hacer que aparezca una novena cinta de la nada; el edificio se construyó con ocho y punto.
- Esto representa el silicio de tu procesador (los núcleos o hilos de hardware). Es el único lugar donde físicamente se puede procesar una instrucción.

*2. Los Hilos del Sistema Operativo (Capa 2) = Los Operarios con Carretilla*
Para mover los paquetes hacia las 8 cintas, contratas a Operarios. Cada operario viene con una carretilla enorme, un uniforme pesado, un protocolo estricto y un salario alto fijo (un consumo de memoria de 1 a 8 MB por hilo). Puedes contratar a 100 operarios si quieres, pero recuerda: solo hay 8 cintas físicas disponibles en el hardware.
- *La Conmutación (Context Switch):* Como hay 100 operarios (Hilos del SO) pero solo 8 cintas (Hardware), el Jefe de Planta (el Sistema Operativo) hace sonar un silbato cada pocos milisegundos. Cuando suena, el operario que está en la cinta debe frenar en seco, apuntar exactamente en su libreta por dónde iba, apartar su pesada carretilla y dejar que entre otro operario a la cinta con sus paquetes. Este proceso de intercambio es lento y consume energía de la planta (pérdida de rendimiento en la CPU).

*3. Los Hilos de Software o Asincronía (Capa 3) = Los Mensajeros en Patinete*
Un buen día, te das cuenta de que la mayoría de tus operarios pesados pierden el tiempo parados en la cinta esperando a que el camión de reparto traiga nuevos paquetes de la calle (esperas de red o lecturas de disco duro). Así que decides cambiar de estrategia: te quedas solo con 8 operarios eficientes (uno fijo en cada cinta de hardware) y, para alimentarlos, contratas a 10.000 Mensajeros en Patinete (Tareas virtuales o Corrutinas). Son ligeros, no ocupan espacio y llevan los paquetes en una mochila pequeña (unos pocos Kilobytes).
- *La magia de la Asincronía:* Si el Mensajero A llega a la cinta y ve que su paquete necesita una firma que tardará en llegar, simplemente da un paso al lado y le dice al Mensajero B: "Oye, pasa tú mientras yo espero". Como son ligeros y no llevan carretilla, cambiar de un mensajero a otro es instantáneo. Los 8 operarios fijos de las cintas nunca paran, y el Jefe de Planta ya no tiene que tocar el silbato. Todo fluye desde dentro del propio programa.

#align(center)[
  #block(fill: luma(245), inset: 12pt, radius: 4pt, stroke: 0.5pt + luma(200))[
    *Resumen de Aplicación:* \
    Si tu tarea requiere *fuerza bruta* (cálculo matemático pesado): Necesitas *Operarios con Carretilla* (Concurrencia basada en hilos del SO). \
    Si tu tarea requiere *gestionar esperas* (consultas web o bases de datos): Necesitas *Mensajeros en Patinete* (Asincronía basada en hilos de software).
  ]
]

== Mecanismos de Ejecución en Rust

En el ecosistema de Rust, la concurrencia y la asincronía operan bajo filosofías y costes radicalmente diferentes:

- *Concurrencia (Orientada a la CPU):* El programa levanta hilos nativos del sistema operativo mediante `std::thread::spawn`. Es la herramienta ideal para dividir el trabajo pesado de cálculo. Cada hilo es independiente, síncrono en su interior, y si se queda esperando a que el disco duro lea un archivo, todo ese hilo del sistema operativo se congela por completo en ese instante. Su coste de conmutación es alto y lo gestiona el S.O.

- *Asincronía (Orientada a Entrada/Salida - I/O):* Basada en tareas virtuales (`Futures`). En lugar de bloquear un hilo entero del sistema operativo mientras esperas que internet o la base de datos respondan, el hilo real "suelta" la tarea bloqueada y se dedica a procesar otra inmediatamente, manteniéndose siempre activo al 100% de su eficiencia.

== La conexión entre Concurrencia y Asincronía: Múltiples tareas sobre pocos hilos

La asincronía en Rust es un modelo de concurrencia cooperativa. Te permite ejecutar miles o millones de tareas simultáneas (comportamiento concurrente) utilizando un número mínimo de hilos del sistema operativo (a menudo, tantos hilos como núcleos tenga tu CPU).

#table(
  columns: (auto, 1fr, 1fr),
  fill: none,
  stroke: (x, y) => if y == 0 { (bottom: 1.5pt + black) } else { (bottom: 0.5pt + gray.lighten(50%)) },
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
  
  // Cabecera de la tabla
  table.header(
    [*Característica*],
    [*Concurrencia Clásica \ (`std::thread`)*],
    [*Asincronía \ (`async/await`)*],
  ),

  // Filas de contenido
  [*Enfoque principal*], [Tareas intensivas de CPU (Cálculo).], [Tareas intensivas de I/O (Red, Discos).],
  [*Coste de memoria*], [Alto (Megabytes por hilo del S.O.).], [Prácticamente cero (Bytes por tarea).],
  [*Gestor*], [El Sistema Operativo (Planificador).], [Un _Runtime_ en espacio de usuario (ej. Tokio).],
  [*Bloqueo*], [Bloquea el hilo por completo.], [Pausa la tarea, el hilo sigue libre.],
)

Comentarios sobre la tabla anterior:

1. *Coste de memoria: ¿Por qué vemos en la tabla MB por hilo vs. Bytes por tarea? ¿No depende de la tarea a realizar?*
Sí depende de la tarea, pero la diferencia radical está en el peaje de entrada que te cobra el sistema operativo por el simple hecho de existir.

- *Concurrencia Clásica (std::thread):* Cuando le pides al sistema operativo que cree un hilo nativo, este tiene que reservarle obligatoriamente un bloque de memoria fijo llamado Stack (Pila). En la mayoría de sistemas operativos (como Linux o Windows), este tamaño por defecto suele ser de 2 Megabytes. Da igual si tu hilo solo va a sumar 2 + 2 (que ocupa unos pocos bytes); el sistema operativo ya le ha amputado 2 MB a la memoria RAM de tu ordenador solo para gestionar ese hilo. Si intentas crear 10.000 hilos a la vez, tu servidor colapsará porque necesitará unos 20 GB de RAM solo en "peajes de existencia".

- *Asincronía (async/await):* Las "tareas" asíncronas no son hilos del sistema operativo; son gestionadas por Rust como pequeñas estructuras de datos (máquinas de estados, como vimos antes). El peaje de entrada aquí es de unos pocos Bytes o Kilobytes (el espacio justo para guardar las variables locales de esa función asíncrona). Si la tarea necesita calcular algo muy grande en el Heap, gastará más, pero si la tarea es pequeña, ocupa casi nada. Por eso un solo hilo de ejecución asíncrono puede gestionar 100.000 tareas web simultáneas en una Raspberry Pi sin despeinarse.

2. *¿Qué significa `"`en espacio de usuario`"`?*

Un sistema operativo moderno divide la memoria del ordenador en dos zonas de seguridad totalmente aisladas:

- *Espacio de Núcleo (Kernel Space):* Es la zona VIP y ultra-protegida donde vive el corazón del Sistema Operativo. Solo el Kernel puede hablar directamente con la tarjeta de red, el disco duro o el procesador. Crear o destruir un hilo (std::thread) requiere que tu programa llame al Kernel, lo cual es lento porque exige un cambio de contexto de seguridad en la CPU.

- *Espacio de Usuario (User Space):* Es la zona donde se ejecutan tus programas normales (como tu navegador, tu juego o tu servidor de Rust).

 - Decir que el Runtime (como Tokio) gestiona la asincronía en "espacio de usuario" significa que es tu propio programa en Rust el que decide qué tarea va primero y cuál va después, mediante código normal y corriente de Rust. No tiene que pedirle permiso al Kernel del sistema operativo cada vez que cambia de una tarea a otra, lo que hace que cambiar entre miles de tareas asíncronas sea ridículamente rápido y eficiente.


El siguiente capítulo se dedica a la programación concurrente y a continuación tendremos un capítulo dedicado al la programación asíncrona.


#pagebreak()