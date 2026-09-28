# 🎮 El Archipielago

> **Nuestro proyecto data de un juego modo historia en el que deberás adentrarte en un mundo silencioso lleno de mar e islas.**

[![Godot](https://img.shields.io/badge/Engine-Godot-478CBF?logo=godot-engine\&logoColor=white)](https://godotengine.org/)
[![Version](https://img.shields.io/badge/Alpha-v1.8-blue)](#-historial-de-versiones)

## 👥 Integrantes

|  **Thiago Campobello**  |
| :----------: |
| **Joaquin Espinar** |
| **Pia Machado** |
| **Carolina Occhiato** |

---

## 🛠️ Tecnologías

| Tecnología      | Uso                        |
| --------------- | -------------------------- |
| 🎮 **Godot**    | Motor del proyecto         |
| 📜 **GDScript** | Lenguaje de programación   |
| 🔀 **Git**      | Control de versiones       |
| ☁️ **GitHub**   | Repositorio y colaboración |
| ☁️**NotebookLM** | Documentacion de proceso  |

---

## 📸 Capturas

> Próximamente...

---

## 📋 Historial de versiones

|   Versión  |    Fecha   |     Estado    | Cambios                  |
| :--------: | :--------: | :-----------: | ------------------------ |
| **Alpha v1.0** | 03/09/2026 | 🟡 Desarrollo | Inicio del proyecto      |
| **Alpha v1.1** | 08/09/2026 | 🟡 Desarrollo | Agrega arma y sistema de vida    |
| **Alpha v1.3** | 09/09/2026 | 🟡 Desarrollo | Mejora arma, agrega menú    |
| **Alpha v1.4** | 10/09/2026 | 🟡 Desarrollo | Mejoras en el enemigo y arma    |
| **Alpha v1.5** | 16/09/2026 | 🟡 Desarrollo | Intensificación en el hud y mapa    |
| **Alpha v1.6** | 19/09/2026 | 🟡 Desarrollo | Se añade inventario al hud, correr y menu opciones   |
| **Alpha v1.7** | 26/09/2026 | 🟡 Desarrollo | Logos, bloom, dropear y agarrar objetos  |
| **Alpha v1.8** | 27/09/2026 | 🟡 Desarrollo | Isla,Terrain3D,  |

## 📝 Changelog

### 🟡 Alpha v1.0
Añadimos un sistema de movilidad básico, basado en el que ya había en Godot, se diseñó el sistema de camara, limitada en el eje Y. Mantuvimos la gravedad de Godot, impulsada por una variable propia, y programamos el sistema para pausar, y desbloquear el mouse

**Fecha:** 03/09/2026

### 🟡 Alpha v1.1 
Se añade el sistema del enemigo, el de vida, este todavía no tiene IA, pero con el fin de poder programar el arma, calcular colisiones, logrado con un RayTrace3D, que detecta cuando choca con un Area3D y diferencia de haber disparado a la cabeza y al cuerpo, a solucionar para la siguiente versión: movilidad en eje Y del arma.

**Fecha:** 08/09/2026

### 🟡 Alpha v1.3
Se modifico el arma, ahora tiene cooldown, cargador y cantidad de balas, se le agrego la movilidad en eje Y, el prototipo de enemigo ahora tiene gravedad y colisiones. Se agregó menú 2d funcional al presionar esc. 

**Fecha:** 09/09/2026

### 🟡 Alpha v1.4
Se agrega arma automatica, agregamos IA del enemigo, este se mueve buscando acercarse al jugador, se le añadió una barra de vida, se agrandó el mapa para probar el movimiento del enemigo, se añadió escena de bala, para que cuando dispares se vea esta moverse. Se le añadió retroceso al arma

**Fecha:** 10/09/2026
### 🟡 Alpha v1.5
Se agrega un mapa de prueba como base de isla, se añade 3ra persona, se añade un fondo y sol para la iluminación, se añadió diseño del enemigo y de el arma automática, se añade HUD con la vida del jugador y las balas que tengas en cargador y en el arma, que el enemigo saque vida cuerpo a cuerpo, animación del arma del enemigo. Ahora el enemigo deambula por el mapa hasta detectar al jugador y no lo detecta todo el tiempo

**Fecha:** 16/09/2026
### 🟡 Alpha v1.6
Se agregó un sistema de inventario, con aplicacion en el hud, ademas de que se movieron un par de cosas del mismo para mejor visibilidad, se añade el input y funcion para correr, un menu de opciones de controles en la pausa, el cual es funcional, solo le falta que se marquen los conflictos de tecla, si es que otra tecla está usando la misma

**Fecha:** 19/09/2026
### 🟡 Alpha v1.7
Se arreglaron bugs, se añadieron logos en el hud para mas decoracion, bloom (puntero de disparo) el cual fue programado para que solo aparezca en primera persona, en cuanto a que el arma apunte exactamente a donde esté el puntero, esta es calculada en todo momento y se modifica la posicion del lugar objetivo del raycast cada vez, para que este siempre esté apuntando al bloom. Se hizo un sistema el cual hace que puedas tirar armas al piso, con un mensaje de interactuar cuando apuntas a una arma en el piso, por ahora con algunos bugs

**Fecha:** 26/09/2026
### 🟡 Alpha v1.8
Se agrega el addon Terrain3D de godot para poder diseñar el terreno de la isla, se añadieron 3 texturas, una para el pasto, otra para las rocas y otra para la arena se hizo la base principal de la isla, la cual puede terminar teniendo mas o menos altura en algunos lados, pero esto sería la base principal, se añadió un mesh para el agua, con reflección y un efecto de transparencia y se arreglaron algunos bugs lumínicos con el terreno

**Fecha:** 27/09/2026
## 📊 Estado del proyecto

**Versión actual:** `Alpha v1.8`

```text
████░░░░░░░░░░░░░░░░ 22%
```

> El porcentaje es aproximado y representa el estado general del desarrollo.

<div align="center">

## 🎮 EL ARCHIPIELAGO

</div>
