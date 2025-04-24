# ================================
# Inicialización
# ================================

li a0, 0xf0000014        # Dirección base de la matriz LED
li a1, 35                # Ancho (columnas)
li a2, 25                # Alto (filas)

li t0, 2                 # x inicial
li t1, 3                 # y inicial

li t3, 0x00FFFFFF        # Color blanco
li t6, 0x00000000        # Color negro

li s0, 1                 # dx = +1
li s1, 1                 # dy = +1

# ================================
# Pintar LEDs blancos fijos en (0,10), (0,11), (0,12), (0,13)
# ================================
li s2, 0                 # x = 0
li s3, 10                # y inicial = 10

li s4, 0                 # contador = 0

fijos_loop:
    mul t2, s3, a1       # t2 = y * ancho
    add t2, t2, s2       # t2 = y * ancho + x
    slli t2, t2, 2
    add t2, t2, a0
    sw t3, 0(t2)         # Pintar LED blanco fijo

    addi s3, s3, 1       # y += 1
    addi s4, s4, 1       # contador += 1
    li t1, 4
    blt s4, t1, fijos_loop


# ================================
# Bucle principal
# ================================
main_loop:
    # ============================
    # Borrar LED anterior
    # ============================

    mul t2, t1, a1        # t2 = y * ancho
    add t2, t2, t0        # t2 = y * ancho + x
    slli t2, t2, 2
    add t2, t2, a0
    sw t6, 0(t2)          # Borrar LED (negro)

    # ============================
    # Calcular nueva posición
    # ============================

    add t4, t0, s0        # nueva_x = x + dx
    add t5, t1, s1        # nueva_y = y + dy

    # Rebotar horizontalmente
    blt t4, zero, reverse_dx
    bge t4, a1, reverse_dx

    # Rebotar verticalmente
    blt t5, zero, reverse_dy
    bge t5, a2, reverse_dy

    mv t0, t4             # Actualizar x
    mv t1, t5             # Actualizar y
    j draw_led

reverse_dx:
    neg s0, s0            # dx = -dx
    j main_loop

reverse_dy:
    neg s1, s1            # dy = -dy
    j main_loop

draw_led:
    mul t2, t1, a1
    add t2, t2, t0
    slli t2, t2, 2
    add t2, t2, a0
    sw t3, 0(t2)          # Pintar LED blanco

    # Delay breve
    li t6, 3
delay:
    addi t6, t6, -1
    bnez t6, delay

    j main_loop

