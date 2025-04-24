# ================================
# Inicialización
# ================================

li a0, LED_MATRIX_0_BASE     # Dirección base de la matriz LED
li a1, LED_MATRIX_0_WIDTH    # Ancho (columnas)
li a2, LED_MATRIX_0_HEIGHT   # Alto (filas)

#Coordenadas iniciales de la pelota
li t0, 2                 # x inicial
li t1, 3                 # y inicial

#Definir colores
li t3, 0x00FFFFFF        # Color blanco
li t6, 0x00000000        # Color negro

#Definimos cuanto queremos que se sume para hacer el movimiento de la pelota
li s0, 1                 # dx = +1
li s1, 1                 # dy = +1

main_loop:
    # ============================
    # Borrar LED anterior
    # ============================
    #t2 dirección de la pelota
    mul t2, t1, a1        # t2 = y * ancho
    add t2, t2, t0        # t2 = y * ancho + x
    slli t2, t2, 2        # Calcula la dirección del led al que se quiere acceder
    add t2, t2, a0        # Sumar el desplazamiento, para que t2 contenga la dirección x,y del LED
    sw t6, 0(t2)          # Borrar LED (camibarle el color a negro)

    # ============================
    # Calcular nueva posición
    # ============================

    add t4, t0, s0        # nueva_x = x + dx
    add t5, t1, s1        # nueva_y = y + dy

    # Rebotar horizontalmente
    # Si x < 0 o x >= ancho, rebotar horizontalmente, invirtiendo la dirección dx
    blt t4, zero, reverse_dx 
    bge t4, a1, reverse_dx

    # Rebotar verticalmente
    #Si y < 0 o y >= alto, rebotar verticalmente, invirtiendo la dirección dy
    blt t5, zero, reverse_dy
    bge t5, a2, reverse_dy

    mv t0, t4             # Actualizar x, si no rebotó
    mv t1, t5             # Actualizar y, si no rebotó 
    j draw_led            # Dibujar la nueva posición

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

    # Delay
    li t6, 3
delay: 
    addi t6, t6, -1
    bnez t6, delay

    j main_loop