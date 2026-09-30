#import "config.typ": *

Para entender los programas de este cuaderno tenemos que añadir algunas aclaraciones teóricas:

- Closures, Lambdas, funciones anónimas, callbacks
- async / await

```rust

// Aclarar:

thread::spawn(|| {
        datos.push(4); 
});
```

#nota[*negrita*"]


Opción A: == Destapando la caja con seguridad (La sentencia #raw("match"))
Opción B: == El control de flujo con #raw("if let") `<subtitulo: Abriendo cajas sin miedo>`