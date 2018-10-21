---
theme : "white"
highlightTheme: "darkula"
---

# Slide in HTML

### Ovvero come inserire infografiche interattive in una presentazione

<small> by [aborruso](https://twitter.com/aborruso)</small>

---

## Ciao mondo

[**reveal.js**](https://revealjs.com/) è la libreria javascript che consente di creare presentazioni HTML interattive. Questa è un esempio.

---

## Markdown e HTML

Le slide si scrivono in Markdown e HTML. 

Quindi se scrivo `**ciao**` ottengo il grassetto (**ciao**).

Ma l'ottengo anche con `<b>ciao</b>`, che mi da sempre <b>ciao</b>.

---

## Separatori

Le slide hanno due tipi di separatori:

- `---` è il separatore standard;
- `--` per separare slide in verticale.

---

## Slide verticali

Una (o più) slide può essere figlia di un'altra; per vederla scorrere verso il basso.

Si crea inserendo `--` a fine slide.

--

## infografiche interattive

Qui riduco la possibilità a quei casi in cui è possibile generare/ricavare un codice di _embedding_ dell'infografica interattiva.

--

### Mappa uMap

Da [questa mappa](http://umap.openstreetmap.fr/it/map/carte-sans-nom_246174) è possibile ricavare il codice di embedding.

```html
<iframe width="100%" height="300px" frameBorder="0" allowfullscreen 
src="http://umap.openstreetmap.fr/it/map/carte-sans-nom_246174?scaleControl=false&miniMap=false&scrollWheelZoom=false&zoomControl=true&allowEdit=false&moreControl=false&searchControl=null&tilelayersControl=null&embedControl=null&datalayersControl=true&onLoadPanel=undefined&captionBar=false#7/32.296/-4.373">
</iframe>
<p><a 
href="http://umap.openstreetmap.fr/it/map/carte-sans-nom_246174">
Visualizza a schermo intero
</a></p>
```

--

### Mappa uMap interattiva

<iframe width="100%" height="300px" frameBorder="0" allowfullscreen 
src="http://umap.openstreetmap.fr/it/map/carte-sans-nom_246174?scaleControl=false&miniMap=false&scrollWheelZoom=false&zoomControl=true&allowEdit=false&moreControl=false&searchControl=null&tilelayersControl=null&embedControl=null&datalayersControl=true&onLoadPanel=undefined&captionBar=false#7/32.296/-4.373">
</iframe>
<p><a 
href="http://umap.openstreetmap.fr/it/map/carte-sans-nom_246174">
Visualizza a schermo intero
</a></p>

--

### Grafico datawrapper

<iframe src="//datawrapper.dwcdn.net/UVhoZ/1/" scrolling="no" frameborder="0" allowtransparency="true" width="748" height="650"></iframe>

---

## Note

- l'_embedding_ alle volte è impossibile per ragioni di "sicurezza";
- questi sono degli esempi di base. Per adattare per bene le slide agli obiettivi visuali è necessario studiare più a fondo come funziona revealjs;
- c'è un _editor_ nel _cloud_ con cui creare slide basate su revaljs [https://slides.com/]();
- queste le ho create con Visual Studio Code e una sua [estensione](https://marketplace.visualstudio.com/items?itemName=evilz.vscode-reveal).