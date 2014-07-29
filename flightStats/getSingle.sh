#!/bin/sh
flightStatsByAirport $1 | python -m json.tool > data/$1.txt
