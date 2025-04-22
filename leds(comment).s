# ================================================================
# Configuración inicial de la matriz LED
# ================================================================

li a0, LED_MATRIX_0_BASE    # Carga la dirección base de la matriz LED en a0
li a1, LED_MATRIX_0_WIDTH   # Carga el ancho de la matriz (columnas) en a1
li a2, LED_MATRIX_0_HEIGHT  # Carga la altura de la matriz (filas) en a2

# ================================================================
# Bucle principal de animación
# ================================================================
loop:
        addi    sp, sp, -16         # Reserva espacio en el stack (16 bytes)
        sw      s0, 12(sp)          # Guarda registro s0 en el stack
        sw      s1, 8(sp)           # Guarda registro s1 en el stack
        mv      t6, zero            # Inicializa contador de tiempo/frame (t6 = 0)
        add     t3, a2, a1          # t3 = altura + ancho (suma dimensiones)
        slli    a6, a1, 2           # a6 = ancho * 4 (bytes por fila)
        lui     a3, 16              # Carga máscara para componente rojo (0x000F0000)
        addi    a7, a3, -256        # Ajusta máscara a 0x00000F00 (rojo en bits 8-11)
        lui     t0, 4080            # Carga máscara para componente verde (0x0FF00000)

# ================================================================
# Inicialización de parámetros de frame
# ================================================================
init:
        mv      t4, zero            # Inicializa contador vertical (t4 = 0)
        mv      t1, zero            # Inicializa contador de filas (t1 = 0)
        mv      t2, a0              # t2 = dirección base actual de la matriz

# ================================================================
# Procesamiento de filas
# ================================================================
nextRow:
        mv      a4, zero            # Inicializa contador horizontal (a4 = 0)
        slli    a3, t1, 8           # (t1 << 8) = t1 * 256
        sub     a3, a3, t1          # a3 = t1*255 (para cálculo de posición vertical)
        divu    a3, a3, a2          # a3 = (t1*255) / altura (normalización posición Y)
        add     a3, a3, t6          # Agrega desplazamiento temporal para animación
        slli    a3, a3, 8           # Desplaza a posición de componente rojo (bits 8-15)
        and     t5, a3, a7          # Aplica máscara del componente rojo (0x00000F00)
        mv      a5, t2              # a5 = dirección actual de la fila
        mv      a3, a1              # a3 = contador de columnas (usando el ancho)

# ================================================================
# Procesamiento de píxeles (columnas)
# ================================================================
nextPixel:
        divu    s0, a4, a1          # s0 = posición horizontal / ancho (normalización X)
        add     s0, s0, t6           # Agrega desplazamiento temporal para animación
        add     s1, t4, a4           # s1 = posición vertical + posición horizontal
        divu    s1, s1, t3           # s1 = (t4 + a4)/(ancho+altura) (diagonales)
        add     s1, s1, t6           # Agrega desplazamiento temporal para animación
        slli    s0, s0, 16           # Desplaza a posición de componente verde (bits 16-23)
        and     s0, s0, t0           # Aplica máscara del componente verde (0x00FF0000)
        or      s0, t5, s0           # Combina componentes rojo y verde
        andi    s1, s1, 255          # Aplica máscara para componente azul (bits 0-7)
        or      s0, s0, s1           # Combina todos los componentes (RGB)
        sw      s0, 0(a5)            # Escribe el color en la memoria de la matriz LED
        
        addi    a3, a3, -1           # Decrementa contador de columnas
        addi    a5, a5, 4            # Mueve a siguiente píxel en memoria (+4 bytes)
        addi    a4, a4, 255          # Incrementa posición horizontal (con overflow controlado)
        bnez    a3, nextPixel         # Repite si quedan columnas por procesar

# ================================================================
# Preparación siguiente fila
# ================================================================
        addi    t6, t6, 1            # Incrementa contador de tiempo/frame
        addi    t1, t1, 1            # Incrementa contador de filas
        add     t2, t2, a6            # Mueve dirección base a siguiente fila
        addi    t4, t4, 255           # Incrementa posición vertical (con overflow controlado)
        bne     t1, a2, nextRow       # Repite si quedan filas por procesar
        j       init                  # Reinicia el proceso para nuevo frame