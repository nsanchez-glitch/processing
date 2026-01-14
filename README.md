# Processing - Generación de Terreno 3D Aleatorio

Este proyecto implementa un generador de terreno 3D aleatorio en Processing con control de joystick.

## Características

- Generación procedural de terreno 3D usando ruido Perlin
- Regeneración aleatoria de terreno al presionar el botón R_LEFT del joystick (o tecla 'R')
- Cámara con posición y orientación aleatoria que apunta hacia el centro del terreno
- Visualización inmersiva del terreno con diferentes perspectivas en cada reinicio

## Archivos

- **terrain_3d.pde**: Versión completa con soporte de joystick usando JInput
- **terrain_3d_simple.pde**: Versión simplificada que usa solo el teclado (tecla 'R')

## Requisitos

- Processing 3.x o superior
- Para la versión con joystick: biblioteca JInput

## Instalación

### Versión Simple (Recomendada)

1. Abre Processing
2. Abre el archivo `terrain_3d_simple.pde`
3. Presiona el botón Run (▶)

### Versión con Joystick

1. Instala la biblioteca JInput para Processing
2. Abre el archivo `terrain_3d.pde`
3. Conecta tu joystick/gamepad
4. Presiona el botón Run (▶)

## Uso

### Controles

- **Tecla 'R'**: Genera un nuevo terreno aleatorio con cámara aleatoria (ambas versiones)
- **Botón R_LEFT del Joystick**: Genera un nuevo terreno aleatorio (solo versión con joystick)

### Comportamiento

Cada vez que presionas el botón configurado:

1. Se generan nuevas coordenadas de ruido aleatorias (noiseOffsetX, noiseOffsetY)
2. El terreno se regenera con diferentes picos, valles y montañas
3. La cámara cambia a una posición aleatoria alrededor del terreno
4. La orientación de la cámara se ajusta para apuntar hacia el centro del terreno
5. Cada vista es única e inmersiva

## Detalles Técnicos

### Generación de Terreno

- Utiliza ruido Perlin (`noise()`) para generar alturas del terreno
- Grid de 100x80 celdas con escala de 20 unidades
- Alturas mapeadas entre -100 y 100 unidades
- Colores varían según la altura (más claro = más alto)

### Posicionamiento de Cámara

- Distancia aleatoria del centro: 400-800 unidades
- Ángulo aleatorio: 0-360 grados alrededor del terreno
- Altura aleatoria: -200 a 200 unidades
- Rotación calculada para apuntar hacia el centro con variación artística

### Parámetros de Ruido

- `noiseOffsetX`: Offset horizontal del ruido (0-1000)
- `noiseOffsetY`: Offset vertical del ruido (0-1000)
- `flying`: Parámetro de animación para movimiento del terreno

## Modificación de Parámetros

Puedes ajustar los siguientes parámetros en el código:

```processing
int scl = 20;        // Escala de cada celda del terreno
int w = 2000;        // Ancho del terreno
int h = 1600;        // Alto del terreno
float distance = random(400, 800);  // Distancia de la cámara
float height = random(-200, 200);   // Altura de la cámara
```

## Autor

Sánchez Cuadra Nicolás Marcelo

## Licencia

Este proyecto está disponible bajo licencia MIT.