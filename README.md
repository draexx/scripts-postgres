# scripts-postgres
update_secuence()
función para postgreSQL que actualiza las secuencias al ultimo indice en las tablas correspondientes de todos los esquemas.

init_functions()
función inicial donde se declara los nombre sde las funciones y las vistas que deseas que  se clonen en el nuevo esquema, esta función es necesaria para clone_schema()

clone_schema()
función para clonar un esquema especifico a otro nuevo incluyendo datos.
