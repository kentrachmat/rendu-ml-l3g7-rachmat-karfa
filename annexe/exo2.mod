/* Variables et parametres. */

/* Trans est un ensemble de transistor.*/
set TRANS;

/* E représente le nombre maximal de transistor à exclure.*/
param E >= 0;

/* 
 * MAXHFE représente la valeur maximale d'un coefficient d’amplification(gain) d'un transistor).
 * MAXVBE représente la tension maximale de base émetteur pour un transistor.
*/
param MAXHFE >= 0;
param MAXVBE >= 0;

/* 
 * hfe représente le coefficient d’amplification(gain) d'un transistor).
 * vbe représente la tension base émetteur pour un transistor.
 * les valeurs sont bornées par MAXHFE et MAXVBE et sont indicées par les transistors.
 * type représente le type d'un transistor.
*/
param hfe {TRANS} >= 0, <= MAXHFE;
param vbe {TRANS} >= 0, <= MAXVBE;
param type {TRANS} symbolic;

/* 
 * transistor_est_pris est un nombre binaire permettant de savoir si le transistor n'est pas exclu.
 * si transistor_est_pris = 1, le transistor n'est pas exclu.
 * si transistor_est_pris = 0, le transistor est exclu.
*/
var transistor_est_pris{ TRANS } binary;

/* 
 * max_hfe et min_hfe représentent la valeur maximale et minimale hfe de l'ensemble des transistors.
 * max_vbe et min_vbe représentent la valeur maximale et minimale vbe de l'ensemble des transistors.
*/
var max_hfe >= 0;
var max_vbe >= 0;
var min_hfe >= 0;
var min_vbe >= 0;

/* 
 * dispersion represente la dispersion de l'ensemble des transistors.
*/
var dispersion >= 0;

/* algorithme pour calculer dh */
var dh = max_hfe - min_hfe;

/* algorithme pour calculer dv */
var dv = max_vbe - min_vbe;

/* - Ces deux contraintes permettent :
 * - d'obtenir la plus grande valeur de hfe et vbe de l'ensemble des transistors.
 * - d'exclure des transistors.
*/
subject to contrainte_max_hfe {val in TRANS} :
    max_hfe >= transistor_est_pris[val] * hfe[val];

subject to contrainte_max_vbe {val in TRANS} :
    max_vbe >= transistor_est_pris[val] * vbe[val];

/* - Ces deux contraintes permettent : 
 * - d'obtenir la plus petite valeur de hfe et vbe de l'ensemble des transistors
 * - d'exclure des transistors.
*/
subject to contrainte_min_hfe {val in TRANS} :
    min_hfe <= transistor_est_pris[val] * hfe[val] + (1 - transistor_est_pris[val]) * MAXHFE;

subject to contrainte_min_vbe {val in TRANS} :
    min_vbe <= transistor_est_pris[val] * vbe[val] + (1 - transistor_est_pris[val]) * MAXVBE;

/* Ces deux contraintes permettent d'obtenir la plus grande dispersion entre vbe et hfe, cela définit la borne minimale  */
subject to contrainte_dispersion_hfe :
    dispersion >= dh/MAXHFE;

subject to contrainte_dispersion_vbe :
    dispersion >= dv/MAXVBE;

/* cette contrainte permet d'exclure au maximum E transistor */
subject to contrainte_nb_max_exclusion:
    sum {val in TRANS} (1 - transistor_est_pris[val]) <= E;

/* 
 * l'objectif est de calculer la dispersion.
 * la minimisation permet de minimiser la valeur de dispersion, cela permet donc d'avoir une borne supérieure.
*/
minimize dispersion_minimize : dispersion;

/* Voici les différentes commandes qui se lancent au chargement du modele */
option solver gurobi;
data exo2.dat;
solve;
display dispersion, transistor_est_pris;
