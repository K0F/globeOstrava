#!/bin/sh
for i in `cat airports_open_filtered.txt | head -n 5000` ; do ls data/ | grep -qi "$i".txt || flightStatsByAirport $i | python -m json.tool > data/$i.txt ; done

