/* Variables et parametres */

/* l'ensemble des transistors*/
set TRANS;

param MAXHFE >= 0;
param MAXVBE >= 0;

/* 
 * hfe représente le coefficient d’amplification(gain) d'un transistor) 
 * vbe représente la tension base émetteur pour un transistor
 * les valeurs sont bornées par MAXHFE et MAXVBE et sont indicées par les transistors
 * type représente le type d'un transistor
*/
param hfe {TRANS} >= 0, <= MAXHFE;
param vbe {TRANS} >= 0, <= MAXVBE;
param type {TRANS} symbolic;

/* 
 * max_hfe et min_hfe représentent la valeur maximale et minimale hfe de l'ensemble des transistors.
 * max_vbe et min_vbe représentent la valeur maximale et minimale vbe de l'ensemble des transistors.
*/
var max_hfe >= 0;
var max_vbe >= 0;
var min_hfe >= 0;
var min_vbe >= 0;

/* 
 * dispersion_max represente la dispersion de l'ensemble des transistors.
*/
var dispersion_max >= 0;


/* algorithme pour calculer dh et dv*/
var dh = max_hfe - min_hfe;

var dv = max_vbe - min_vbe;

/* 
 * l'objectif est de calculer la dispersion.
 * la minimisation permet de minimiser la valeur de dipersion_max, cela permet donc d'avoir une borne supérieure.
*/
minimize dispersion: dispersion_max;

/* Ces deux contraintes permettent d'obtenir la plus grande dispersion entre vbe et hfe, cela définit la borne minimale  */
subject to contrainte_dispersion_max_hfe {val in TRANS} :
    dispersion_max >= dh/MAXHFE;

subject to contrainte_dispersion_max_vbe {val in TRANS} :
    dispersion_max >= dv/MAXVBE;

/* Ces deux contraintes permettent d'obtenir la plus grande valeur de hfe et vbe de l'ensemble des transistors */
subject to contrainte_max_hfe {val in TRANS} :
    max_hfe >= hfe[val];

subject to contrainte_max_vbe {val in TRANS} :
    max_vbe >= vbe[val];


/* Ces deux contraintes permettent d'obtenir la plus petite valeur de hfe et vbe de l'ensemble des transistors */
subject to contrainte_min_hfe {val in TRANS} :
    min_hfe <= hfe[val];

subject to contrainte_min_vbe {val in TRANS} :
    min_vbe <= vbe[val];

/* Voici les différentes commandes qui se lancent au chargement du modele */
option solver minos;
data exo1.dat;
solve;
display dispersion;