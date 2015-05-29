<div class="btn-toolbar" style="background-color:#FFFFFF;">

	<div class="btn-group">
		<div class="input-group input-group-sm" style="width:260px;" >
			<input type="text" name="text" id="searchText" value="" class="form-control" placeholder="Búsqueda de área" lang="es"/>
			<span class="input-group-btn">
				<button onClick="searchTextInTree()" class="btn btn-default" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
			</span>
		</div>
	</div>

	<div class="btn-group btn-group-sm">
		<a onClick="expandTree();" class="btn btn-default" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
		<a onClick="collapseTree();" class="btn btn-default" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>
	</div>

</div>