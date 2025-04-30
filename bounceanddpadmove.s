# ================================================================
# Inicialización de la matriz y configuración de colores
# ================================================================

li a0, LED_MATRIX_0_BASE     # Dirección base de la matriz LED
li a1, LED_MATRIX_0_WIDTH    # Ancho en columnas
li a2, LED_MATRIX_0_HEIGHT   # Alto en filas
# Configuración inicial de las paletas (7 píxeles de altura)
li t0, 0              # Coordenada X del jugador 1
li t1, 12             # Coordenada Y CENTRAL del jugador 1
li t3, 0x00FFFFFF     # Color blanco

li s0, 34             # Coordenada X del jugador 2
li s1, 12             # Coordenada Y CENTRAL del jugador 2
li s3, 0x0000FF       # Color azul

# Pelota libre
li s4, 17             # Coordenada X
li s5, 10             # Coordenada Y
li s6, 1              # dx
li s7, 1              # dy
li s8, 0x00FFFF00     # Color amarillo

li t6, 0x00000000     # Color negro (borrado)

# ================================================================
# Bucle principal de ejecución (OPTIMIZADO)
# ================================================================
main_loop:
    # Borrar paleta del Jugador 1 (7 píxeles)
    li t4, -3
erase_p1:
    add t5, t1, t4
    blt t5, zero, erase_p1_next
    bge t5, a2, erase_p1_next
    # Calcular dirección (X=0, Y=t5)
    mul t2, t5, a1
    add t2, t2, t0
    slli t2, t2, 2
    add t2, t2, a0
    sw t6, 0(t2)
erase_p1_next:
    addi t4, t4, 1
    li t5, 3
    ble t4, t5, erase_p1

    # Borrar paleta del Jugador 2 (7 píxeles)
    li t4, -3
erase_p2:
    add t5, s1, t4
    blt t5, zero, erase_p2_next
    bge t5, a2, erase_p2_next
    # Calcular dirección (X=34, Y=t5)
    mul t2, t5, a1
    add t2, t2, s0
    slli t2, t2, 2
    add t2, t2, a0
    sw t6, 0(t2)
erase_p2_next:
    addi t4, t4, 1
    li t5, 3
    ble t4, t5, erase_p2

    # Borrar pelota libre
    mul t2, s5, a1
    add t2, t2, s4
    slli t2, t2, 2
    add t2, t2, a0
    sw t6, 0(t2)

    # Leer D-Pad y mover jugadores
    jal read_dpad

    # Actualizar posición pelota libre
    add t4, s4, s6      # Nueva X
    add t5, s5, s7      # Nueva Y

    # Comprobar rebotes en X
    blt t4, zero, reverse_dx
    bge t4, a1, reverse_dx

    # Comprobar rebotes en Y
    blt t5, zero, reverse_dy
    bge t5, a2, reverse_dy

    mv s4, t4
    mv s5, t5
    j draw_section

reverse_dx:
    neg s6, s6
    j draw_section

reverse_dy:
    neg s7, s7

draw_section:
    # Dibujar paleta Jugador 1 (7 píxeles)
    li t4, -3
draw_p1:
    add t5, t1, t4
    blt t5, zero, draw_p1_next
    bge t5, a2, draw_p1_next
    mul t2, t5, a1
    add t2, t2, t0
    slli t2, t2, 2
    add t2, t2, a0
    sw t3, 0(t2)
draw_p1_next:
    addi t4, t4, 1
    li t5, 3
    ble t4, t5, draw_p1

    # Dibujar paleta Jugador 2 (7 píxeles)
    li t4, -3
draw_p2:
    add t5, s1, t4
    blt t5, zero, draw_p2_next
    bge t5, a2, draw_p2_next
    mul t2, t5, a1
    add t2, t2, s0
    slli t2, t2, 2
    add t2, t2, a0
    sw s3, 0(t2)
draw_p2_next:
    addi t4, t4, 1
    li t5, 3
    ble t4, t5, draw_p2

    # Dibujar pelota libre
    mul t2, s5, a1
    add t2, t2, s4
    slli t2, t2, 2
    add t2, t2, a0
    sw s8, 0(t2)

    # Retraso para controlar velocidad
    li s10, 1
delay:
    addi s10, s10, -1
    bnez s10, delay

    j main_loop

# ================================================================
# Leer D-Pad 
# ================================================================
read_dpad:
    # Jugador 1: Arriba (dirección 0xf0000dac en Ripes)
    li t4, 0xf0000000
    lw t5, 0(t4)
    bnez t5, move_up_j1

    # Jugador 1: Abajo (dirección 0xf0000db0)
    li t4, 0xf0000004
    lw t5, 0(t4)
    bnez t5, move_down_j1

    # Jugador 2: Arriba (dirección 0xf0000db4)
    li t4, 0xf0000008
    lw t5, 0(t4)
    bnez t5, move_up_j2

    # Jugador 2: Abajo (dirección 0xf0000db8)
    li t4, 0xf000000c
    lw t5, 0(t4)
    bnez t5, move_down_j2

    jr ra

# ================================================================
# Movimientos 
# ================================================================
move_up_j1:
    addi t5, t1, -3       # Mover 3 píxeles arriba
    li t6, 3              # Límite superior (Y >= 3)
    blt t5, t6, 1f
    mv t1, t5
1:  jr ra

move_down_j1:
    addi t5, t1, 3        # Mover 3 píxeles abajo
    addi t6, a2, -4       # Límite inferior (Y <= altura -4)
    bge t5, t6, 1f
    mv t1, t5
1:  jr ra

move_up_j2:
    addi t5, s1, -3
    li t6, 3
    blt t5, t6, 1f
    mv s1, t5
1:  jr ra

move_down_j2:
    addi t5, s1, 3
    addi t6, a2, -4
    bge t5, t6, 1f
    mv s1, t5
1:  jr ra