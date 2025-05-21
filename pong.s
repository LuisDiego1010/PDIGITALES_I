# ================================================================
# Inicializaci?n de la matriz y configuraci?n de colores
# ================================================================

li a0, LED_MATRIX_0_BASE     # Direcci?n base de la matriz LED
li a1, LED_MATRIX_0_WIDTH    # Ancho en columnas (ej. 34)
li a2, LED_MATRIX_0_HEIGHT   # Alto en filas (ej. 24)

# Configuraci?n inicial de las paletas (3 p?xeles de altura)
li t0, 0              # Coordenada X del jugador 1 (izquierda)
addi s0, a1, -1       # Coordenada X del jugador 2 (derecha: ancho - 1)
li t1, 12             # Coordenada Y CENTRAL inicial del jugador 1
li s1, 12             # Coordenada Y CENTRAL inicial del jugador 2
li t3, 0x00FFFFFF     # Color blanco
li s3, 0x0000FF       # Color azul

# Pelota libre
li s4, 17             # Coordenada X inicial (centro)
li s5, 10             # Coordenada Y inicial
li s6, 1              # dx (direcci?n X: 1 = derecha)
li s7, 1              # dy (direcci?n Y: 1 = abajo)
li s8, 0x00FFFF00     # Color amarillo
li t6, 0x00000000     # Color negro (borrado)

# ================================================================
# Bucle principal de ejecuci?n 
# ================================================================
main_loop:
    # Borrar paleta del Jugador 1 (3 p?xeles)
    li t4, -1
erase_p1:
    add t5, t1, t4
    blt t5, zero, erase_p1_next
    bge t5, a2, erase_p1_next
    mul t2, t5, a1        # Direcci?n = (Y * ancho) + X
    add t2, t2, t0
    slli t2, t2, 2        # Convertir a direcci?n de word (?4)
    add t2, t2, a0
    sw t6, 0(t2)          # Borrar pixel
erase_p1_next:
    addi t4, t4, 1
    li t5, 1
    ble t4, t5, erase_p1

    # Borrar paleta del Jugador 2 (3 p?xeles)
    li t4, -1
erase_p2:
    add t5, s1, t4
    blt t5, zero, erase_p2_next
    bge t5, a2, erase_p2_next
    mul t2, t5, a1        # Direcci?n = (Y * ancho) + X
    add t2, t2, s0
    slli t2, t2, 2
    add t2, t2, a0
    sw t6, 0(t2)          # Borrar pixel
erase_p2_next:
    addi t4, t4, 1
    li t5, 1
    ble t4, t5, erase_p2

    # Borrar pelota libre
    mul t2, s5, a1        # Direcci?n = (Y * ancho) + X
    add t2, t2, s4
    slli t2, t2, 2
    add t2, t2, a0
    sw t6, 0(t2)

    # Leer D-Pad y mover jugadores
    jal read_dpad

    # ============================================================
    # Mec?nica de colisi?n optimizada (detectar ANTES de la paleta)
    # ============================================================
   
    # Actualizar posici?n pelota libre

    add t4, s4, s6      # Nueva X
    add t5, s5, s7      # Nueva Y

    # Comprobar colisi?n con Jugador 1 (X=0)
    beq t4, zero, check_p1_collision
    
    # Comprobar colisi?n con Jugador 2 (X=ancho-1)
    addi t2, a1, -1
    beq t4, t2, check_p2_collision
    
    # Comprobar bordes laterales
    blt t4, zero, reset_ball_center    # X < 0
    bge t4, a1, reset_ball_center      # X >= ancho
    j check_y_collision

check_p1_collision:
    addi t2, t1, -1
    blt t5, t2, reset_ball_center      # Y < Y_central-1 ? reset
    addi t2, t1, 1
    bgt t5, t2, reset_ball_center      # Y > Y_central+1 ? reset
    neg s6, s6                        # dx = -dx (rebote)
    mv s4, t4                         # X = 0
    mv s5, t5                         # Y actualizado
    j check_y_collision

check_p2_collision:
    addi t2, s1, -1
    blt t5, t2, reset_ball_center      # Y < Y_central-1 ? reset
    addi t2, s1, 1
    bgt t5, t2, reset_ball_center      # Y > Y_central+1 ? reset
    neg s6, s6                        # dx = -dx (rebote)
    mv s4, t4                         # X = ancho-1
    mv s5, t5                         # Y actualizado
    j check_y_collision

check_y_collision:
    blt t5, zero, reverse_dy
    bge t5, a2, reverse_dy
    mv s4, t4
    mv s5, t5
    j draw_section

reverse_dy:
    neg s7, s7                    # Invertir direcci?n Y
    mv s4, t4                     # Actualizar X
    mv s5, t5                     # Actualizar Y
    j draw_section

reset_ball_center:
    li s4, 17                      # X central
    li s5, 12                      # Y central
    neg s6, s6                     # Invertir direcci?n X
    li s7, 1                       # Direcci?n Y inicial

draw_section:
    # Dibujar paleta Jugador 1 (3 p?xeles)
    li t4, -1
draw_p1:
    add t5, t1, t4
    blt t5, zero, draw_p1_next
    bge t5, a2, draw_p1_next
    mul t2, t5, a1        # Direcci?n = (Y * ancho) + X
    add t2, t2, t0
    slli t2, t2, 2
    add t2, t2, a0
    sw t3, 0(t2)          # Dibujar pixel
draw_p1_next:
    addi t4, t4, 1
    li t5, 1
    ble t4, t5, draw_p1

    # Dibujar paleta Jugador 2 (3 p?xeles)
    li t4, -1
draw_p2:
    add t5, s1, t4
    blt t5, zero, draw_p2_next
    bge t5, a2, draw_p2_next
    mul t2, t5, a1        # Direcci?n = (Y * ancho) + X
    add t2, t2, s0
    slli t2, t2, 2
    add t2, t2, a0
    sw s3, 0(t2)          # Dibujar pixel
draw_p2_next:
    addi t4, t4, 1
    li t5, 1
    ble t4, t5, draw_p2

    # Dibujar pelota libre
    mul t2, s5, a1        # Direcci?n = (Y * ancho) + X
    add t2, t2, s4
    slli t2, t2, 2
    add t2, t2, a0
    sw s8, 0(t2)

    # Retraso para controlar velocidad
    li s10, 1         # Ajusta este valor para cambiar la velocidad
delay:
    addi s10, s10, -1
    bnez s10, delay

    j main_loop

# ================================================================
# Leer D-Pad 
# ================================================================
read_dpad:
    # Jugador 1: Arriba (0xf0000dac)
    li t4, 0xf0000db0
    lw t5, 0(t4)
    bnez t5, move_up_j1

    # Jugador 1: Abajo (0xf0000db0)
    li t4, 0xf0000db4
    lw t5, 0(t4)
    bnez t5, move_down_j1

    # Jugador 2: Arriba (0xf0000db8)
    li t4, 0xf0000db4
    lw t5, 0(t4)
    bnez t5, move_up_j2

    # Jugador 2: Abajo (0xf0000dbc)
    li t4, 0xf0000db8
    lw t5, 0(t4)
    bnez t5, move_down_j2

    jr ra

# ================================================================
# Movimientos (l?mites corregidos para 3 p?xeles)
# ================================================================
move_up_j1:
    addi t5, t1, -1         # Mover 1 p?xel arriba
    li t6, 1                # L?mite superior: Y_central >= 1
    blt t5, t6, 1f
    mv t1, t5
1:  jr ra

move_down_j1:
    addi t5, t1, 1          # Mover 1 p?xel abajo
    addi t6, a2, -2         # L?mite inferior: Y_central <= altura-2
    bge t5, t6, 1f
    mv t1, t5
1:  jr ra

move_up_j2:
    addi t5, s1, -1
    li t6, 1                # L?mite superior
    blt t5, t6, 1f
    mv s1, t5
1:  jr ra

move_down_j2:
    addi t5, s1, 1
    addi t6, a2, -2         # L?mite inferior
    bge t5, t6, 1f
    mv s1, t5
1:  jr ra