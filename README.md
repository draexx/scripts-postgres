# Scripts PostgreSQL

## Descripción General

Este repositorio alberga una colección de scripts de PostgreSQL diseñados para asistir en diversas tareas de administración, migración y mantenimiento de bases de datos. Cada script está documentado individualmente a continuación, detallando su propósito, funcionamiento y modo de uso.

## Requisitos Previos Generales

- Acceso a una instancia de PostgreSQL con permisos suficientes para crear funciones, esquemas y modificar objetos de base de datos según sea necesario para cada script.
- Conocimiento básico de SQL y la administración de PostgreSQL.

## Scripts Disponibles

### `update_sequence()`

**Propósito:** Sincronizar las secuencias de PostgreSQL con el valor máximo actual de sus columnas asociadas.

**Descripción:**
Esta función itera sobre todas las claves primarias de todas las tablas en todos los esquemas. Para cada clave primaria que utiliza una secuencia, la función:
1. Obtiene el nombre de la secuencia asociada.
2. Determina el valor máximo actual de la columna de la clave primaria.
3. Actualiza la secuencia para que el próximo valor generado sea `valor máximo + 1`.
Esto es útil para evitar errores de "valor duplicado" después de importaciones de datos o restauraciones donde los valores de secuencia pueden no estar actualizados.

**Uso:**
```sql
SELECT public.update_sequence();
```

### `init_functions()`

**Propósito:** Definir una lista de funciones y vistas que deben ser clonadas por la función `clone_schema()`.

**Descripción:**
Esta función actúa como una tabla de configuración para `clone_schema()`. Devuelve una tabla con los nombres de las funciones y vistas (`functionname`), un orden de secuencia (`seq`) para la creación, y el tipo de objeto (`inittype` - 'func' o 'view').
Es **fundamental** modificar esta función para listar explícitamente todas las funciones y vistas que se desean replicar al clonar un esquema. Los nombres de ejemplo `'<Function Name>'` y `'<View Name>'` deben ser reemplazados por los nombres reales de los objetos de la base de datos.

**Uso:**
Esta función es utilizada internamente por `clone_schema()`. Se debe editar su contenido directamente para configurar el proceso de clonación.

### `clone_schema()`

**Propósito:** Crear una copia completa de un esquema existente en PostgreSQL, incluyendo tablas, datos, secuencias, índices, constraints, triggers, funciones y vistas (según lo definido en `init_functions()`).

**Descripción:**
Esta función automatiza el proceso de duplicar un esquema (`source_schema`) a un nuevo esquema (`dest_schema`). Realiza los siguientes pasos:
1. Crea el nuevo esquema de destino.
2. Crea todas las secuencias del esquema origen en el destino.
3. Crea todas las tablas del esquema origen en el destino, incluyendo constraints, índices y valores por defecto.
4. Ajusta los valores por defecto de las secuencias en las tablas clonadas para que apunten a las nuevas secuencias del esquema de destino.
5. Recrea los triggers de las tablas en el nuevo esquema.
6. Recrea las claves foráneas entre las tablas del nuevo esquema.
7. Clona las funciones especificadas en `init_functions()`, ajustando las referencias al esquema.
8. Clona las vistas especificadas en `init_functions()`, ajustando las referencias al esquema.
9. Mueve la extensión `"unaccent"` (si existe y está configurada para ello) al nuevo esquema.
10. Copia todos los datos de las tablas del esquema origen al esquema destino.

**Pre-requisitos:**
- La función `init_functions()` debe estar creada y configurada con las funciones y vistas a clonar.
- Opcionalmente, si se utiliza la extensión `"unaccent"` y se desea moverla, esta debe existir en el esquema origen.

**Uso:**
```sql
SELECT public.clone_schema('nombre_esquema_origen', 'nombre_esquema_destino');
```
Asegúrate de reemplazar `'nombre_esquema_origen'` y `'nombre_esquema_destino'` con los nombres reales de tus esquemas.

---

## Contribuciones

Las contribuciones son bienvenidas. Si tienes mejoras, correcciones o nuevos scripts que puedan ser útiles, por favor considera:
1. Hacer un fork del repositorio.
2. Crear una nueva rama para tus cambios (`git checkout -b feature/nueva-funcionalidad`).
3. Realizar tus cambios y hacer commit (`git commit -am 'Añade nueva funcionalidad'`).
4. Empujar tus cambios a la rama (`git push origin feature/nueva-funcionalidad`).
5. Abrir un Pull Request.

Por favor, asegúrate de que cualquier nuevo script esté debidamente documentado de manera similar a los existentes.
