#!/bin/bash

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p $folder/tmp
mkdir -p $folder/output
mkdir -p $folder/../output

# scarica le ultime notizie
feed="https://www.planetek.it/rss/feed/planetek.xml"
curl -kL "$feed" > "$folder"/tmp/feed.xml

# converte il feed in json
<"$folder"/tmp/feed.xml xq . > "$folder"/tmp/feed.json

if [ -f "$folder"/tmp/lista.xtab ]; then
  rm "$folder"/tmp/lista.xtab
fi

# Per ogni notizia estrai titolo, immagine e descrizione e crea archivio
<tmp/feed.json jq -r '.rss.channel.item[].link' | while read line; do
  echo "$line"
  curl -kL "$line" > "$folder"/tmp/page.html
  title=$(<"$folder"/tmp/page.html scrape -e "//meta[@property='og:title']/@content")
  description=$(<"$folder"/tmp/page.html scrape -e "//meta[@property='og:description']/@content")
  image=$(<"$folder"/tmp/page.html scrape -e "//meta[@property='og:image']/@content")
  rightimage=$(<"$folder"/tmp/page.html scrape -e "//link[@rel='image_src']/@href")
  date=$(<"$folder"/tmp/page.html scrape -e "//meta[@property='article:published_time']/@content")

  echo -e "title\t$title" >> "$folder"/tmp/lista.xtab
  echo -e "description\t$description" >> "$folder"/tmp/lista.xtab
  echo -e "image\t$rightimage" >> "$folder"/tmp/lista.xtab
  echo -e "link\t$line" >> "$folder"/tmp/lista.xtab
  echo -e "date\t$date" >> "$folder"/tmp/lista.xtab

  echo -e "\n" >> "$folder"/tmp/lista.xtab
done

# converti archivio in TSV e aggiungilo in append. Mantieni soltanto le ultime 20 notizie
mlrgo --ixtab --otsv --ips "\t" clean-whitespace then filter -x 'is_null($image)' "$folder"/tmp/lista.xtab | tail -n +2 >> "$folder"/output/lista_full.tsv
mlrgo -I -N --tsv uniq -a then sort -r 5 then head -n 20 "$folder"/output/lista_full.tsv

# conta numero righe
num_righe=$(wc -l < "$folder"/output/lista_full.tsv)

# Verifica se il numero di righe è inferiore a 5. Se sì, esci senza errori
if [ $num_righe -lt 5 ]; then
    echo "Il numero di righe è inferiore a 5. Uscita senza errori."
    exit 0
fi

# crea header slide
cat "$folder"/slide/risorse/header_02.txt >"$folder"/slide/slide_02.qmd

# Imposta il separatore di campo come TAB
IFS=$'\t'

# Leggi il file TSV linea per linea e crea le slide
while read -r -a line; do

cat << EOF >> "$folder"/slide/slide_02.qmd
## {.r-text-fit}

:::: {.columns}

::: {.column width="60%"}
[![](${line[2]})](${line[3]})
:::

::: {.column width="40%" .r-fit-text}
### ${line[0]}

${line[1]}
:::

::::

EOF
done < "$folder"/output/lista_full.tsv

# rinominare il file slide
mv "$folder"/slide/slide_02.qmd "$folder"/slide/slide.qmd

# cancella cartella slide_files se esiste
[ -d "$folder"/../output/slide_files ] && rm -r "$folder"/../output/slide_files

# converti qmd in html
quarto render "$folder"/slide/slide.qmd

# sposta il file html e la cartella slide_files nella cartella output
mv "$folder"/slide/slide.html "$folder"/../output/index.html
mv "$folder"/slide/slide_files "$folder"/../output/
