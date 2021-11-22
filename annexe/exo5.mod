/* Variables et parametres.*/

/* Trans est un ensemble de transistor.*/
set TRANS;

/* valeur de dispersion maximale*/
param DISPERSION_MAX >= 0;

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
 * COUPLE représente le couple de transistor et les deux ne peuvent pas être du même type.
 */
set COUPLE := { p1 in TRANS, p2 in TRANS : type[p1] <> type[p2] };

/* 
 * max_hfe et min_hfe représentent la valeur maximale et minimale hfe pour chaque couple de transistors.
 * max_vbe et min_vbe représentent la valeur maximale et minimale vbe pour chaque couple de transistors.
*/
var max_hfe {COUPLE};
var max_vbe {COUPLE};
var min_hfe {COUPLE};
var min_vbe {COUPLE};

/* 
 * dispersion représente la dispersion de chaque couple de transistors.
*/
var dispersion {COUPLE} >= 0;
var pair {TRANS, COUPLE} binary;

/* - Ces deux contraintes permettent :
 * - d'obtenir la plus grande valeur de hfe et vbe pour chaque couple de transistors.
 * - de "séparer" les transistors en plusieurs couples.
*/
subject to contrainte_max_hfe {(p1,p2) in COUPLE, val in TRANS}  :
    max_hfe [p1,p2] >= pair[val,p1,p2] * hfe[val];

subject to contrainte_max_vbe {(p1,p2) in COUPLE, val in TRANS} :
    max_vbe [p1,p2] >= pair[val,p1,p2] * vbe[val];

/* - Ces deux contraintes permettent : 
 * - d'obtenir la plus petite valeur de hfe et vbe pour chaque couple de transistors.
 * - de "séparer" les transistors en plusieurs couples.
*/
subject to contrainte_min_hfe {(p1,p2) in COUPLE, val in TRANS} :
    min_hfe [p1,p2] <= pair[val,p1,p2] * hfe[val] + (1 - pair[val,p1,p2]) * MAXHFE;

subject to contrainte_min_vbe {(p1,p2) in COUPLE, val in TRANS} :
    min_vbe [p1,p2] <= pair[val,p1,p2] * vbe[val] + (1 - pair[val,p1,p2]) * MAXVBE;

/* Ces deux contraintes permettent d'obtenir la plus grande dispersion entre vbe et hfe pour chaque couple  */
subject to contrainte_dispersion_hfe {(p1,p2) in COUPLE}:
    dispersion [p1,p2]  >= (max_hfe[p1,p2] - min_hfe[p1,p2])/MAXHFE;

subject to contrainte_dispersion_vbe {(p1,p2) in COUPLE}:
    dispersion [p1,p2]  >= (max_vbe[p1,p2] - min_vbe[p1,p2])/MAXVBE;

/* Cette contrainte permet d'indiquer qu'un transistor ne peut être que dans un et un seul couple */
subject to contrainte_transistor_pair {val in TRANS} :
    sum {(p1,p2) in COUPLE} pair[val,p1,p2] = 1;

/* Cette contrainte permet de vérifier si la dispersion est inférieure au DISPERSION_MAX */
subject to contrainte_dispersion_max {(p1,p2) in COUPLE}:
    dispersion [p1,p2] <= DISPERSION_MAX;

/* 
 * dispersion_minimize represente la dispersion total (la somme de la dispersion pour chaque couple).
 * la minimisation permet de minimiser la valeur de dispersion, cela permet donc d'avoir une borne supérieure.
*/
minimize dispersion_minimize : 
    sum {(p1,p2) in COUPLE} dispersion[p1,p2];

/* Voici les différentes commandes qui se lancent au chargement du modele */
option solver gurobi;
data exo5.dat;
solve;
display dispersion;