# DM Les transistors d’Ornicar

[Le sujet 2021](https://www.fil.univ-lille1.fr/~lemairef/ML/td/dm-transistors-26oct.pdf)

# Equipe

Ce travail est à réaliser en équipe dont les membres sont (**groupe 7 du S5 Licence 3 Informatique**) :

- BENEDICTUS KENT **RACHMAT**
- HICHEM **KARFA**

# Organisation du fichier

Le DM se répartir de la façon suivante :

- Un dossier `annexe` contenant les fichiers `.mod` et `.dat` correspondent aux modélisations sur AMPL numérotés par question.

- Le fichier `Rapport-KARFA-RACHMAT.pdf` est notre compte rendu de ce DM ([lien](https://gitlab-etu.fil.univ-lille1.fr/karfa/ml-dm-karfa-rachmat/-/blob/main/Rapport-KARFA-RACHMAT.md)).

# Ligne de Commande

Tout d'abord on doit lancer le programme ampl pour exécuter notre code :

```bash
$ > ampl
```

Àpres, le préfixe se transformera en `ampl :` et nous tapons notre commande d'ampl à l'intérieur.
Pour charger le modèle utilisez cette commande et mettez le nom du fichier en paramètre :

```bash
$ ampl: model {NOM DU FICHIER};
```

Pour afficher les variables utilisez cette commande et mettez le nom du variable en paramètre :

```bash
$ ampl: display {NOM DU VARIABLE};
```

Et enfin pour réinitialiser le code/pour lancer une autre modélisation il faut faire un reset :

```bash
$ ampl: reset;
```

# EXERCICES

## EXO 1

Pour exécuter le premier exercice, veuillez utiliser cette commande ci-dessous :

```bash
$ ampl : model annexe/exo1.mod;
```

et pour afficher une variable par exemple, on peut utiliser `display hfe;`, etc.

## EXO 2

Pour exécuter le deuxieme exercice, veuillez utiliser cette commande ci-dessous :

```bash
$ ampl : model annexe/exo2.mod;
```

et pour afficher une variable par exemple, on peut utiliser `display hfe;`, etc.

## EXO 3

Il n'y a pas de code ampl à faire.

## EXO 4

Pour exécuter le quatrième exercice, veuillez utiliser cette commande ci-dessous :

```bash
$ ampl : model annexe/exo4.mod;
```

et pour afficher une variable par exemple, on peut utiliser `display hfe;`, etc.

## EXO 5

Pour la 5ème question nous ne l'avons pas encore fini
