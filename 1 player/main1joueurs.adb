with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Puissance4;
with Participant;
with Partie;
with Liste_Generique;
with Moteur_Jeu;

use Ada.Text_IO;
use Ada.Integer_Text_IO;
use Participant;




procedure Main1Joueurs is
   package MyPuissance4 is new Puissance4(7,6,4);
   --package Liste_Coups is new Liste_Generique(MyPuissance4.Coup, MyPuissance4.Affiche_Coup);
   -- definition d'une partie entre un humain en Joueur 1 et un humain en Joueur 2
   --use Liste_Coups;


  package MyComputer is new Moteur_Jeu(
          MyPuissance4.Etat,
          MyPuissance4.Coup,
          MyPuissance4.Jouer,
          MyPuissance4.Est_Gagnant,
          MyPuissance4.Est_Nul,
          MyPuissance4.Affiche_Coup,
          MyPuissance4.Liste_Coups,
          MyPuissance4.Coups_Possibles,
          MyPuissance4.Eval,
          4,
          Joueur1
          );

  use MyComputer;

   package MyPartie is new Partie(MyPuissance4.Etat,
				  MyPuissance4.Coup,
				  "Pierre",
				  "Paul", -- Ajout dans Initialiser le choix des noms
				  MyPuissance4.Jouer,
				  MyPuissance4.Est_Gagnant,
				  MyPuissance4.Est_Nul,
				  MyPuissance4.Affiche_Jeu,
				  MyPuissance4.Affiche_Coup,
				  MyPuissance4.Demande_Coup_Joueur1,
				  MyComputer.Choix_Coup);
   use MyPartie;

   P: MyPuissance4.Etat;

begin
   MyPuissance4.Initialiser(P);
   Put_Line("Puissance 4");
   Put_Line("");
   Put_Line("Joueur 1 : X");
   Put_Line("Joueur 2 : O");
   Put_Line("");



   Joue_Partie(P, Joueur2);
end Main1Joueurs;
