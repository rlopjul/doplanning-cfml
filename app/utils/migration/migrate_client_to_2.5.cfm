

Nuevas tablas:

tables_fields_types
listas
tipologías
formularios
pubmeds
items_position

script que copie todos los position de las tablas de items (áreas web: entradas, eventos, noticias, ...) en items_position
Las entradas habría que migrarlas con un orden inverso, es decir la última se pone la primera, porque a las entradas se les aplicaba en la versión anterior un orden inverso que a las noticias
Antes sólo se ordenaban: las noticias y las entradas, pero con ordenes distintos.
Añadir campo area_id a la tabla files.

-Añadir columna link target a las tablas: entries, events, news, consultations, tasks

ALTER TABLE `dp_software7`.`software7_entries` ADD COLUMN `link_target` VARCHAR(45) NOT NULL AFTER `link`;
