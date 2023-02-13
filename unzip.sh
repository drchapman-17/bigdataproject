for f in data/dati-simc.arpae.it/opendata/eraclito/timeseries/*/*.zip; do

  unzip -d data/unzipped "$f"
  
done