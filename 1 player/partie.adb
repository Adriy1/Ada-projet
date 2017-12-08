with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Puissance4;
with Participant;
with Moteur_Jeu;

use Ada.Text_IO;
use Ada.Integer_Text_IO;
use Participant;

package body partie is

  procedure Joue_Partie(E : in out Etat; J : in Joueur) is
    C : Coup;
    Player : Joueur;
  begin
    Player := J;
    while Est_Nul(E) /= true loop
      Affiche_Jeu(E);
      if Player = Joueur1 then
        C := Demande_Coup_Joueur1(E);
      else
        C := Demande_Coup_Joueur2(E);
      end if;
      Affiche_Coup(C);
      E := Jouer(E,C);
      exit when Est_Gagnant(E,Player);
      Player := Adversaire(Player);
    end loop;
    if Est_Nul(E) /= true then
      if Player = Joueur1 then
        Put_Line("LE JOUEUR 1 A GAGNE !!");
      else
        Put_Line("L'ORDINATEUR A GAGNE !!");
      end if;
    else
      Put_Line("MATCH NUL");
    end if;
    Affiche_Jeu(E);

  end Joue_Partie;

end partie;
