# scripts-postgres

## Utils
Directorio que contiene scripts que pueden ser de utilidad en algunos momentos de migraciones

### update_secuence()

Función para postgreSQL que actualiza las secuencias al ultimo indice en las tablas correspondientes de todos los esquemas.

### init_functions()

Función inicial donde se declara los nombre sde las funciones y las vistas que deseas que  se clonen en el nuevo esquema, esta función es necesaria para clone_schema()

### clone_schema()

Función para clonar un esquema especifico a otro nuevo incluyendo datos.
