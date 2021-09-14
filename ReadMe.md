# installation
wget -f https://raw.githubusercontent.com/Oxas95/AE2-Manager-on-OC/master/installer.lua  
ou  
pastebin run 7Uq7uTtB

# Utilisation

Requiert un signal redstone à droite (sides.left) pour fonctionner  
Modifiez le à votre convenance.  
Le fichier `config.cfg` contient la liste des crafts à automatiser  
Un exemple est déjà présent dans le fichier pour modèle  
Syntaxe :  
nom_item_1;comparateur;quantité_1;nom_item_2;quantité_2

- nom_item_1  : nom de l'item à regarder
- comparateur : opérateur de comparaison (==, !=, <, >, <=, >=)
- quantité_1  : quantité à comparer avec celle de nom_item_1
- nom_item_2  : nom de l'item à crafter si la condition est remplie
- quantité_2  : quantité de nom_item_2 à crafter si la condition est remplie, n = quantité de nom_item_1 stocké dans le système Applied

Exemple :
`minecraft:redstone;>;1000;minecraft:redstone_block;(n - 1000)/9` signifie :  
 Si dans le système Applied, il y une quantité de redstone > 1000, alors crafter la quantité de blocks de redstone suivante :  
 (En supposant qu'il y a 2000 redstones stockées)
- (n - 1000)/9
- (2000 - 1000)/9
- 1000/9
- 111.1111111111
- 112 
La valeur est arrondit à l'entier supérieur
