#!/bin/bash

arquivo=$1
nome_arquivo=$(basename $arquivo )
dir=$(dirname $arquivo)
extensao=$(echo "${nome_arquivo##*.}")
legenda="$(basename $nome_arquivo .$extensao)".srt
arquivo_legenda="$dir"/"$legenda"
head -c 65536 $arquivo > /tmp/arquivo_hash
tail -c 65536 $arquivo >> /tmp/arquivo_hash
hash=$(md5sum /tmp/arquivo_hash | awk '{print $1}')

achou=$(echo $hash  | xargs -i  curl -s -A "SubDB/1.0 (curl)" 'http://api.thesubdb.com/?action=search&hash={}&language=pt')
echo $achou

if [ s"$achou" != "s" ]; then
	echo  $hash | xargs -i curl -s -A "SubDB/1.0 (curl)" 'http://api.thesubdb.com/?action=download&hash={}&language=pt' \
	> "$arquivo_legenda"
	echo "$arquivo_legenda" baixado.
else
	echo "Não achou"
fi

rm /tmp/arquivo_hash
