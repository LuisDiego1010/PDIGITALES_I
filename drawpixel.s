# ================================================================
# Inicializaci?n
# ================================================================

li a0, LED_MATRIX_0_BASE     # Direcci?n base de la matriz LED
li a1, LED_MATRIX_0_WIDTH    # Ancho (columnas)
li a2, LED_MATRIX_0_HEIGHT   # Alto (filas)

li t0, 0                     # x = 2 (posici?n inicial columna)
li t1, 12                     # y = 3 (posici?n inicial fila)

li t3, 0x00FFFFFF            # Color blanco
li t6, 0x00000000            # Color negro (para borrar el anterior)

main_loop:
    # ============================================================
    # Borrar LED anterior
    # ============================================================

    mul t2, t1, a1           # t2 = y * ancho
    add t2, t2, t0           # t2 = y * ancho + x
    slli t2, t2, 2           # t2 = ?ndice * 4 bytes
    add t2, t2, a0           # Direcci?n absoluta

    sw t6, 0(t2)             # Borrar LED (escribir negro)

    # ============================================================
    # Leer entradas del D-pad
    # ============================================================

read_dpad:
    li t4, 0xf0000db4        # LEFT
    lw t5, 0(t4)
    bnez t5, move_left

    li t4, 0xf0000db8        # RIGHT
    lw t5, 0(t4)
    bnez t5, move_right

    li t4, 0xf0000dac        # UP
    lw t5, 0(t4)
    bnez t5, move_up

    li t4, 0xf0000db0        # DOWN
    lw t5, 0(t4)
    bnez t5, move_down

# ================================================================
# Volver a dibujar LED despu?s de leer D-pad
# ================================================================

draw_led:
    mul t2, t1, a1           # t2 = y * ancho
    add t2, t2, t0           # t2 = y * ancho + x
    slli t2, t2, 2           # multiplicamos por 4
    add t2, t2, a0           # Direcci?n absoluta

    sw t3, 0(t2)             # Dibujar nuevo LED
    j main_loop              # Repetir

# ================================================================
# Movimiento con validaci?n de l?mites
# ================================================================

move_left:
    addi t5, t0, -1
    blt t5, zero, draw_led   # Si t5 < 0, no mover
    mv t0, t5
    j draw_led

move_right:
    addi t5, t0, 1
    bge t5, a1, draw_led     # Si t5 >= ancho, no mover
    mv t0, t5
    j draw_led

move_up:
    addi t5, t1, -1
    blt t5, zero, draw_led   # Si t5 < 0, no mover
    mv t1, t5
    j draw_led

move_down:
    addi t5, t1, 1
    bge t5, a2, draw_led     # Si t5 >= alto, no mover
    mv t1, t5
    j draw_led



