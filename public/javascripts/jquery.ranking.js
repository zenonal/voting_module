Array.max = function( array ){
return Math.max.apply( Math, array );
};

jQuery.fn.ranking = function() {
	// Options par defaut
	var defaults = {};

	var options = defaults;

	initializeList();

	this.children().each(function(){
		

		var obj = $j(this).find("ul");
	
		// Empêcher la sélection des éléments à la sourirs (meilleure gestion du drag & drop)
		var _preventDefault = function(evt) { evt.preventDefault(); };
		$j("li").bind("dragstart", _preventDefault).bind("selectstart", _preventDefault);

		// Initialisation du composant "sortable"
		$j(obj).sortable({
			axis: "y", // Le sortable ne s'applique que sur l'axe vertical
			containment: ".ranking", // Le drag ne peut sortir de l'élément qui contient la liste
			distance: 10, // Le drag ne commence qu'à partir de 10px de distance de l'élément
			// Evenement appelé lorsque l'élément est relaché
			stop: function(event, ui){
				updateLists();
			}
		});

		$j(obj).droppable({
			// Lorsque l'on relache un élément sur la poubelle
			drop: function(event, ui){
				var drag_class = ui.draggable.parent().parent().attr("class"); 
				var drop_class = $j(obj).parent().attr("class");
				if (drag_class != drop_class) {
					original_count = ui.draggable.find(".original_count").text();
					href = ui.draggable.find("a").attr("href");
					img = ui.draggable.find("img").attr("src");
					$j(obj).append('<li>'+ui.draggable.find(".item").text()+"</li>");
					addControls($j(obj).find("li:last-child"),original_count,href,img);
					// On supprimer l'élément de la page, le setTimeout est un fix pour IE (http://dev.jqueryui.com/ticket/4088)
					setTimeout(function() { ui.draggable.remove(); }, 1);
					setTimeout(function() { updateLists();},1);
				}
			},
			// Lorsque l'on passe un élément au dessus de la poubelle
			over: function(event, ui){

			},
			// Lorsque l'on quitte la poubelle
			out: function(event, ui){

			}
		});



	});

	$j('.submit_ranking').live('click', function() {
		
		var original_indexes = 0;
		var indexes = [];
		$j(".ranking").find("li").each(function(){
			original_indexes = $j(this).find(".original_count").text();
			indexes[original_indexes-1] = $j(this).find(".count").text();
		});
		
		// to give a higher value to bills that have been ranked first
		var nIndexes = indexes.max();
		
		$j.each(
			indexes,
			function( intIndex, objValue ){
				if (objValue > 0) {
					indexes[intIndex] = parseInt(nIndexes)+1-objValue;
				};
			}
		);
		
		var data = JSON.stringify(indexes, null, 2);
		
		var current_url = window.location.pathname.split("/");
		var current_controller = current_url[1];
		var current_action = current_url[2];
		var current_id = current_url[3];
		var deleg = $j('#hiddenDelegated').text();
		
		$j.ajax({
			type: 'GET', 
			url: '/'+current_controller+"/ranking/"+current_id, 
			dataType: 'script',
			data: { 
					rankings: data,
					delegated: deleg
					 }
		});
		return false;
	});


	function addControls(elt,c,h,i)
	{
		original_count = c;

		// On ajoute en premier l'élément textuel
		$j(elt).html("<img size='15x15' src='"+i+"'><a href='"+h+"'><span class='item'>"+$j(elt).text()+"</span></a>");
		// Puis l'élément de position
		$j(elt).prepend('<span class="count">'+parseInt($j(elt).index()+1)+'</span>');
		$j(elt).prepend('<span class="original_count">'+original_count+'</span>');

	};


	function initializeList()
	{
		// Pour chaque élément trouvé dans la liste de départ
		$j(".neutral").find("li").each(function(){
			// On ajoute les contrôles
			href = $j(this).find("a").attr("href");
			img = $j(this).find("img").attr("src");
			
			addControls($j(this),parseInt($j(this).index()+1),href,img);
		});
	};

	function updateLists()
	{
		var index = 0;
		$j(".ranking").find("li").each(function(){
			index = parseInt($j(this).index()+1);
			// On la met à jour dans la page
			if ($j(this).parent().parent().attr("class") == "vote_against") {
				$j(this).find(".count").text(-index);
			}
			else {
				if ($j(this).parent().parent().attr("class") == "neutral") {
					$j(this).find(".count").text(0);
				}
			}
		});

	};

	// On continue le chainage JQuery
	return this;
};
