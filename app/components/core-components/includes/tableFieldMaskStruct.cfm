<!---Este include no se debe usar directamente, se debe usar sólo el método getTableFieldFormats del componente FieldManager--->

<!---Decimal con puntos--->
<cfset structInsert(fieldMasksStruct, 1, {id=1, position=1, name="decimal_point", label="9999.99", description="Sólo puntos en los decimales y se muestran dos decimales", tablesorterd_data_mask="##.00", cf_data_mask=".__", cf_prefix="", cf_locale="en_US", cf_sufix="", decimal_delimiter="." })>

<!---Decimal con comas--->
<cfset structInsert(fieldMasksStruct, 2, {id=2, position=2, name="decimal_comma", label="9.999,99", description="Puntos en los miles, comas en los decimales y se muestran dos decimales", tablesorterd_data_mask="##.000,00", cf_data_mask=",.__", cf_locale="es_ES", cf_prefix="", cf_sufix="", decimal_delimiter="," })>

<!---Decimal moneda (€)--->
<cfset structInsert(fieldMasksStruct, 3, {id=3, position=3, name="decimal_euro", label="9.999,99 €", description="Moneda € con puntos en los miles, comas en los decimales y se muestran dos decimales", tablesorterd_data_mask="##.000,00 €", cf_data_mask=".,__", cf_locale="es_ES", cf_prefix="", cf_sufix=" €", decimal_delimiter="," })>

<!---Decimal moneda ($)--->
<cfset structInsert(fieldMasksStruct, 4, {id=4, position=4, name="decimal_dollar", label="$9,999.99", description="Moneda $ con comas en los miles, puntos en los decimales y se muestran dos decimales", tablesorterd_data_mask="$##,####0.00", cf_data_mask=",.__", cf_locale="en_US", cf_prefix="$", cf_sufix="", decimal_delimiter="." })>
