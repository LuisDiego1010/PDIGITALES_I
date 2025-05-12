# 🎮 Pong: RISC-V Edition

> Un clásico de los videojuegos, reconstruido en lenguaje ensamblador sobre la arquitectura RISC-V usando Ripes.

---

## 🕹️ Descripción del juego

**Pong: RISC-V Edition** es una recreación del mítico juego Pong, desarrollado en lenguaje ensamblador y ejecutado sobre el simulador educativo **Ripes**. El juego se representa gráficamente en una **matriz de LEDs**, donde dos jugadores compiten controlando paletas para evitar que una pelota atraviese su lado de la pantalla.


## ⚙️ Mecánica de juego

- La pelota se mueve automáticamente por la pantalla.
- Cada jugador puede mover su paleta de *3* píxeles de alto** hacia arriba o abajo.
- Si la pelota **colisiona con una paleta**, rebota.
- Si la pelota toca el borde derecho o izquierdo, el jugador contrario pierde el punto.

---

## 🎯 Objetivo

Mantener la pelota en juego el mayor tiempo posible evitando que atraviese tu lado. Gana quien defienda mejor.

---

## 💡 Elementos del juego

| Elemento     | Color (hex)   | Función                     |
|--------------|---------------|-----------------------------|
| Jugador 1    | `#FFFFFF`     | Paleta blanca a la izquierda |
| Jugador 2    | `#0000FF`     | Paleta azul a la derecha     |
| Pelota       | `#FFFF00`     | Se mueve de manera aleatoria |
| Matriz       | `#000000`     | Área de juego                |

---

## 🎮 Controles
los jugadores utilizan el Dpad para mover sus respectivas paletas.

### Jugador 1 (Izquierda)
- **Subir:** Tecla arriba Dpad
- **Bajar:** Tecla abajo Dpad

### Jugador 2 (Derecha)
- **Subir:** Tecla izquierda Dpad
- **Bajar:** Tecla derecha Dpad
---

## 🚀 Cómo ejecutar el juego en Ripes

1. Abre **Ripes**.
2. Carga el archivo `pong.s` desde el menú de archivos.
3. Conecta la **LED Matrix** desde el panel de periféricos.
4. Agrega 4 botones como entradas en el panel I/O y mapea las direcciones de control.
5. Haz clic en `Assemble & Run`.
6. Usa los botones o teclas mapeadas para controlar a los jugadores.

---

## 📜 Créditos
- Luis Diego García Rojas
- Eduardo Tencio Solano
- Daniel Chavarría García
- Josue Campos Herrera

**Plataforma:** Ripes  
**Lenguaje:** Ensamblador RISC-V  
**Licencia:** https://github.com/mortbopet/Ripes
