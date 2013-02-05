constituency-map
================

Clickable choropleth map of UK constituencies - currently displaying the Coalition for Equal Marriage MP data.

This is a messy bodge, and could do with a lot of cleaning up. Works in current Chrome, Firefox, and IE9.

 * wmc.pl - update constituency boundaries from mysociety. They'll be put in the 'data' directory, but only if the file doesn't exist. 
 * combine-all.pl - merge geojson files in data directory with mp-table data from c4em.
