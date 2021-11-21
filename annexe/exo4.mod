/* Variables et parametres.*/

/* Trans est un ensemble de transistor.*/
set TRANS;

/* P représente le nombre de paquet de transistor*/
param P >= 0;

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
param hfe {TRANS} >= 0 , <= MAXHFE;
param vbe {TRANS} >= 0 , <= MAXVBE;
param type {TRANS} symbolic;

/* 
 * cardinalTransistor représente le nombre de transistors total.
*/
param cardinalTransistor = card(TRANS);

/* 
 * GROUP représente l'ensemble des groupes de transistors.
*/
set GROUP = 1 .. P;

/* 
 * gtransistor est un nombre binaire indiquant si un transistor T et dans un groupe P.
 * si gtransistor = 1 , le transistor est dans le groupe.
 * si gtransistor = 0 , le transistor n'est pas dans le groupe.
*/
var gtransistor {GROUP, TRANS} binary;

/* 
 * max_hfe et min_hfe représentent la valeur maximale et minimale hfe pour chaque groupe de transistors.
 * max_vbe et min_vbe représentent la valeur maximale et minimale vbe pour chaque groupe de transistors.
*/
var max_hfe {g in GROUP};
var max_vbe {g in GROUP};
var min_hfe {g in GROUP};
var min_vbe {g in GROUP};

/* 
 * dispersion représente la dispersion de chaque groupe de transistors.
*/
var dispersion {g in GROUP} >= 0;

/* - Ces deux contraintes permettent :
 * - d'obtenir la plus grande valeur de hfe et vbe pour chaque groupe de transistors.
 * - de "séparer" les transistors en plusieurs groupes.
*/
subject to contrainte_max_hfe {g in GROUP, val in TRANS}  :
    max_hfe [g] >= gtransistor[g,val] * hfe[val];

subject to contrainte_max_vbe {g in GROUP, val in TRANS} :
    max_vbe [g] >= gtransistor[g,val] * vbe[val];

/* - Ces deux contraintes permettent : 
 * - d'obtenir la plus petite valeur de hfe et vbe pour chaque groupe de transistors.
 * - de "séparer" les transistors en plusieurs groupes.
*/
subject to contrainte_min_hfe {g in GROUP, val in TRANS} :
    min_hfe [g] <= gtransistor[g,val] * hfe[val] + (1 - gtransistor[g,val]) * MAXHFE;

subject to contrainte_min_vbe {g in GROUP, val in TRANS} :
    min_vbe [g] <= gtransistor[g,val] * vbe[val] + (1 - gtransistor[g,val]) * MAXVBE;

/* Ces deux contraintes permettent d'obtenir la plus grande dispersion entre vbe et hfe pour chaque groupe  */
subject to contrainte_dispersion_hfe {g in GROUP}:
    dispersion[g] >= (max_hfe[g] - min_hfe[g])/MAXHFE;

subject to contrainte_dispersion_vbe {g in GROUP}:
    dispersion[g] >= (max_vbe[g] - min_vbe[g])/MAXVBE;

/* Cette contrainte permet d'indiquer qu'un transistor ne peut être que dans un et un seul groupe */
subject to contrainte_transistor_group {val in TRANS} :
    sum {g in GROUP} gtransistor[g,val] == 1;

/* Cette contrainte permet de diviser équitablement le nombre de transistors dans un groupe, à un transistor près */
subject to contrainte_group_equitable {g in GROUP} :
    sum {val in TRANS} gtransistor[g,val] <= (cardinalTransistor/P) + 1;

/* 
 * dispersion_minimize represente la dispersion total (la somme de la dispersion pour chaque groupe).
 * la minimisation permet de minimiser la valeur de dispersion, cela permet donc d'avoir une borne supérieure.
*/
minimize dispersion_minimize : 
    sum {g in GROUP} dispersion[g];

/* Voici les différentes commandes qui se lancent au chargement du modele */
option solver gurobi;
data exo4.dat;
solve;
display dispersion, gtransistor;