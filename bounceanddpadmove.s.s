# ================================================================
# Inicialización de la matriz y configuración de colores
# ================================================================

li a0, LED_MATRIX_0_BASE     # Dirección base de la matriz LED
li a1, LED_MATRIX_0_WIDTH    # Ancho en columnas
li a2, LED_MATRIX_0_HEIGHT   # Alto en filas

# Configuración inicial de las pelotas

# Pelota controlada por el Jugador 1 (color blanco)
li t0, 0                     # Coordenada X del jugador 1
li t1, 12                    # Coordenada Y del jugador 1
li t3, 0x00FFFFFF             # Color blanco

# Pelota controlada por el Jugador 2 (color azul)
li s0, 34                    # Coordenada X del jugador 2
li s1, 12                    # Coordenada Y del jugador 2
li s3, 0x0000FF               # Color azul

# Pelota que rebota automáticamente
li s4, 17                    # Coordenada X de la pelota libre
li s5, 10                    # Coordenada Y de la pelota libre
li s6, 1                     # Dirección X inicial (dx)
li s7, 1                     # Dirección Y inicial (dy)

# Color amarillo para la pelota libre
li s8, 0x00FFFF00             # Color amarillo

# Color negro para borrar píxeles
li t6, 0x00000000             # Color negro

# ================================================================
# Bucle principal de ejecución
# ================================================================
main_loop:
    # Borrar la posición anterior de la pelota del Jugador 1
    mul t2, t1, a1
    add t2, t2, t0
    slli t2, t2, 2
    add t2, t2, a0
    sw t6, 0(t2)

    # Borrar la posición anterior de la pelota del Jugador 2
    mul t2, s1, a1
    add t2, t2, s0
    slli t2, t2, 2
    add t2, t2, a0
    sw t6, 0(t2)

    # Borrar la posición anterior de la pelota libre
    mul t2, s5, a1
    add t2, t2, s4
    slli t2, t2, 2
    add t2, t2, a0
    sw t6, 0(t2)

    # Leer el estado del D-Pad
    jal read_dpad

    # Calcular la nueva posición de la pelota libre
    add t4, s4, s6         # Nueva coordenada X
    add t5, s5, s7         # Nueva coordenada Y

    # Comprobar rebote en los bordes laterales
    blt t4, zero, reverse_dx
    bge t4, a1, reverse_dx

    # Comprobar rebote en los bordes superior e inferior
    blt t5, zero, reverse_dy
    bge t5, a2, reverse_dy

    # Actualizar coordenadas de la pelota libre
    mv s4, t4
    mv s5, t5

    # Dibujar las pelotas en sus nuevas posiciones
    jal draw_leds

reverse_dx:
    neg s6, s6             # Invertir dirección en X
    j main_loop

reverse_dy:
    neg s7, s7             # Invertir dirección en Y
    j main_loop

# ================================================================
# Dibujar las pelotas en pantalla
# ================================================================
draw_leds:
    # Dibujar la pelota del Jugador 1
    mul t2, t1, a1
    add t2, t2, t0
    slli t2, t2, 2
    add t2, t2, a0
    sw t3, 0(t2)

    # Dibujar la pelota del Jugador 2
    mul t2, s1, a1
    add t2, t2, s0
    slli t2, t2, 2
    add t2, t2, a0
    sw s3, 0(t2)

    # Dibujar la pelota libre
    mul t2, s5, a1
    add t2, t2, s4
    slli t2, t2, 2
    add t2, t2, a0
    sw s8, 0(t2)

    # Pequeño retraso para controlar la velocidad de la animación
    li t6, 3
delay_loop:
    addi t6, t6, -1
    bnez t6, delay_loop

    j main_loop

# ================================================================
# Leer entradas del D-Pad
# ================================================================
read_dpad:
    # Jugador 1 mueve hacia arriba
    li t4, 0xf0000db0
    lw t5, 0(t4)
    bnez t5, move_up_j1

    # Jugador 1 mueve hacia abajo
    li t4, 0xf0000db4
    lw t5, 0(t4)
    bnez t5, move_down_j1

    # Jugador 2 mueve hacia arriba
    li t4, 0xf0000db8
    lw t5, 0(t4)
    bnez t5, move_up_j2

    # Jugador 2 mueve hacia abajo
    li t4, 0xf0000dbc
    lw t5, 0(t4)
    bnez t5, move_down_j2

    jr ra

# ================================================================
# Movimientos de las pelotas controladas por los jugadores
# ================================================================
move_up_j1:
    addi t5, t1, -3
    blt t5, zero, draw_leds
    mv t1, t5
    j draw_leds

move_down_j1:
    addi t5, t1, 3
    bge t5, a2, draw_leds
    mv t1, t5
    j draw_leds

move_up_j2:
    addi t5, s1, -3
    blt t5, zero, draw_leds
    mv s1, t5
    j draw_leds

move_down_j2:
    addi t5, s1, 3
    bge t5, a2, draw_leds
    mv s1, t5
    j draw_leds
