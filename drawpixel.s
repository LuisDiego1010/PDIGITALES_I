# ================================================================
# Inicialización
# ================================================================

li a0, LED_MATRIX_0_BASE     # Dirección base de la matriz LED
li a1, LED_MATRIX_0_WIDTH    # Ancho (columnas)
li a2, LED_MATRIX_0_HEIGHT   # Alto (filas)

# Pelota blanca (jugador 1)
li t0, 0                     # x = 0
li t1, 12                    # y = 12
li t3, 0x00FFFFFF            # Color blanco

# Pelota azul (jugador 2)
li s0, 34                    # x = 34 
li s1, 12                     # y = 12
li s3, 0x0000FF              # Color azul

li t6, 0x00000000            # Color negro

main_loop:
    # Borrar LED anterior de la blanca
    mul t2, t1, a1
    add t2, t2, t0
    slli t2, t2, 2
    add t2, t2, a0
    sw t6, 0(t2)

    # Borrar LED anterior de la azul
    mul t2, s1, a1
    add t2, t2, s0
    slli t2, t2, 2
    add t2, t2, a0
    sw t6, 0(t2)

# ================================================================
# Leer entradas del D-pad
# ================================================================

read_dpad:
    li t4, 0xf0000000        # UP (jugador blanco)
    lw t5, 0(t4)
    bnez t5, move_up

    li t4, 0xf0000004        # DOWN (jugador blanco)
    lw t5, 0(t4)
    bnez t5, move_down

    li t4, 0xf0000008        # LEFT (jugador azul - arriba)
    lw t5, 0(t4)
    bnez t5, move_up2

    li t4, 0xf000000c        # RIGHT (jugador azul - abajo)
    lw t5, 0(t4)
    bnez t5, move_down2

# ================================================================
# Volver a dibujar ambas pelotas
# ================================================================

draw_led:
    # Dibujar pelota blanca
    mul t2, t1, a1
    add t2, t2, t0
    slli t2, t2, 2
    add t2, t2, a0
    sw t3, 0(t2)

    # Dibujar pelota azul
    mul t2, s1, a1
    add t2, t2, s0
    slli t2, t2, 2
    add t2, t2, a0
    sw s3, 0(t2)

    j main_loop

# ================================================================
# Movimiento jugador 1 (blanco) con UP/DOWN
# ================================================================

move_up:
    addi t5, t1, -3
    blt t5, zero, draw_led
    mv t1, t5
    j draw_led

move_down:
    addi t5, t1, 3
    bge t5, a2, draw_led
    mv t1, t5
    j draw_led

# ================================================================
# Movimiento jugador 2 (azul) con LEFT/RIGHT
# ================================================================

move_up2:
    addi t5, s1, -3
    blt t5, zero, draw_led
    mv s1, t5
    j draw_led

move_down2:
    addi t5, s1, 3
    bge t5, a2, draw_led
    mv s1, t5
    j draw_led
