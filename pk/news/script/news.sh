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

  echo -e "title\t$title" >> "$folder"/tmp/lista.xtab
  echo -e "description\t$description" >> "$folder"/tmp/lista.xtab
  echo -e "image\t$rightimage" >> "$folder"/tmp/lista.xtab
  echo -e "link\t$line" >> "$folder"/tmp/lista.xtab

  echo -e "\n" >> "$folder"/tmp/lista.xtab
done

# converti archivio in TSV
mlrgo --ixtab --otsv --ips "\t" clean-whitespace then filter -x 'is_null($image)' "$folder"/tmp/lista.xtab | tail -n +2 > "$folder"/output/lista_full.tsv

# crea header slide
cat "$folder"/slide/risorse/header_02.txt >"$folder"/slide/slide_02.qmd

#!/bin/bash

# Imposta il separatore di campo come TAB
IFS=$'\t'

# Leggi il file TSV linea per linea
while read -r -a line; do
  # Verifica che ci siano almeno due colonne nella riga
  echo "${line[0]}"
cat << EOF >> "$folder"/slide/slide_02.qmd
## {.r-text-fit}

:::: {.columns}

::: {.column width="60%"}
![](${line[2]})
:::

::: {.column width="40%" .r-fit-text}
### ${line[0]}

${line[1]}
:::

::::

EOF
done < "$folder"/output/lista_full.tsv

mv "$folder"/slide/slide_02.qmd "$folder"/slide/slide.qmd

[ -d "$folder"/../output/slide_files ] && rm -r "$folder"/../output/slide_files

quarto render "$folder"/slide/slide.qmd

mv "$folder"/slide/slide.html "$folder"/../output/index.html
mv "$folder"/slide/slide_files "$folder"/../output/
