var map;
var ajaxRequest;
var plotlist;
var plotlayers=[];

function initmap() {
	// set up AJAX request
	ajaxRequest=getXmlHttpObject();
	if (ajaxRequest==null) {
		alert ("This browser does not support HTTP Request");
	return;
	}
	
	// set up the map
	map = new L.Map('map');

	// create the tile layer with correct attribution
	var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
	var osmAttrib='Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors';
	var osm = new L.TileLayer(osmUrl, {minZoom: 8, maxZoom: 19, attribution: osmAttrib});		

//piazza marconi
	var marker = L.marker([38.13879, 14.96697]).addTo(map);
	marker.bindPopup("<b>piazza Marconi</b><br>raduno e punto di partenza delle visite guidate<br>Palazzo del Turismo <br>Servizio Turistico di Messina - Unità Operativa di Patti e Tindari <br>MACC - Museo di arte ceramica contemporanea 'Umberto Caleca' <br>Collezione 'Artisti nel Piatto' <br>Fondo Librario ed Archivistico 'Nino Falcone'<br>Monumento ai caduti").openPopup();

//caffè galante 
	var marker = L.marker([38.13812, 14.96636]).addTo(map);
	marker.bindPopup("<a href='http://caffegalante.wordpress.com' target='_blank'><b>Caffè Galante</b></a><br>caffè storico in stile Liberty (1929)<br>luogo di ritrovo degli intellettuali dell'epoca, tra cui il premio Nobel Salvatore Quasimodo<br>(arredi originali dell'epoca)").openPopup();
	
//san nicola
	var marker = L.marker([38.13769, 14.96572]).addTo(map);
	marker.bindPopup("<b>San Nicola</b><br>Chiesa di San Nicolò di Bari<br>Fontana del Calice<br>Chiesa di Santa Maria del Tindari<br>ex piazza Mercato").openPopup();

//vecchio carcere
	var marker = L.marker([38.13703, 14.96573]).addTo(map);
	marker.bindPopup("<b>Convento di Santa Maria di Gesù (1478)</b>").openPopup();

//municipio
	var marker = L.marker([38.13973, 14.96407]).addTo(map);
	marker.bindPopup("<b>piazza Scaffidi</b><br>Municipio<br>Libro Rosso").openPopup();

//casa nachera
	var marker = L.marker([38.13892, 14.96446]).addTo(map);
	marker.bindPopup("<b>Casa Nachera</b><br>affreschi di Francesco Nachera (1815-1881)").openPopup();

//casa saggio
	var marker = L.marker([38.13742, 14.96413]).addTo(map);
	marker.bindPopup("<b>Casa Saggio</b><br>luogo di ritrovo degli amici della lieve brigata di 'Vento a Tindari', oggi B&B Rubes").openPopup();

//villa comunale
	var marker = L.marker([38.13674, 14.96433]).addTo(map);
	marker.bindPopup("<b>Villa Umberto I° (1875)</b>").openPopup();


	
	// start the map in Patti olt town centre
	//map.setView(new L.LatLng(38.1390, 14.9645),17);

	var southWest = L.latLng(38.13674,14.96407),
	northEast = L.latLng(38.13973,14.96697),
	bounds = L.latLngBounds(southWest, northEast);

	map.addLayer(osm); 
	
	askForPlots();
	map.on('moveend', onMapMove);
}

function onMapMove(e) {
	askForPlots();
}
	
function getXmlHttpObject() {
	if (window.XMLHttpRequest) { return new XMLHttpRequest(); }
	if (window.ActiveXObject)  { return new ActiveXObject("Microsoft.XMLHTTP"); }
	return null;
}

function askForPlots() {
	// request the marker info with AJAX for the current bounds
	var bounds=map.getBounds();
	var minll=bounds.getSouthWest();
	var maxll=bounds.getNorthEast();
	var msg='http://www.plotbrowser.com/leaflet/findbybbox.cgi?format=leaflet&bbox='+minll.lng+','+minll.lat+','+maxll.lng+','+maxll.lat;
	ajaxRequest.onreadystatechange = stateChanged;
	ajaxRequest.open('GET', msg, true);
	ajaxRequest.send(null);
}

function stateChanged() {
	// if AJAX returned a list of markers, add them to the map
	if (ajaxRequest.readyState==4) {
		//use the info here that was returned
		if (ajaxRequest.status==200) {
			plotlist=eval("(" + ajaxRequest.responseText + ")");
			removeMarkers();
			for (i=0;i<plotlist.length;i++) {
				var plotll = new L.LatLng(plotlist[i].lat,plotlist[i].lon, true);
				var plotmark = new L.Marker(plotll);
				plotmark.data=plotlist[i];
				map.addLayer(plotmark);
				plotmark.bindPopup("<h3>"+plotlist[i].name+"</h3>"+plotlist[i].details);
				plotlayers.push(plotmark);
			}
		}
	}
}

function removeMarkers() {
	for (i=0;i<plotlayers.length;i++) {
		map.removeLayer(plotlayers[i]);
	}
	plotlayers=[];
}

function onMapClick(e) {
    alert("You clicked the map at " + e.latlng);
}


// add a title
	var legend = L.control({position: 'topright'});  
	    legend.onAdd = function (map) {

	    var div = L.DomUtil.create('div', 'info legend'),
	        grades = [50, 100, 150, 200, 250, 300],
	        labels = ['<strong> Centro Storico di Patti: Notte per la Cultura 2014, V^ Edizione #npc14 </strong>'],
	        from, to;

	    for (var i = 0; i < grades.length; i++) {
	        from = grades [i];
	        to = grades[i+1]-1;

    labels.push(
        '<i style="background:' + getColor(from + 1) + '"></i> ' +
        from + (to ? '&ndash;' + to : '+'));
        }
        div.innerHTML = labels.join('<br>');
        return div;

        };
