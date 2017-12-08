with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Puissance4;
with Participant;

use Ada.Text_IO;
use Ada.Integer_Text_IO;
use Participant;

package body partie is
-- procedure normal d'une partie de Puissance4
  procedure Joue_Partie(E : in out Etat; J : in Joueur) is
    C : Coup;
    Player : Joueur;
  begin
    Player := J;
    while Est_Nul(E) /= true loop -- on continue tant que y'a pas match nul
      Affiche_Jeu(E);
      if Player = Joueur1 then
        C := Demande_Coup_Joueur1(E);
      else
        C := Demande_Coup_Joueur2(E);
      end if;
      Affiche_Coup(C);
      E := Jouer(E,C);
      exit when Est_Gagnant(E,Player); -- on break la boucle si victoire
      Player := Adversaire(Player);
    end loop;
    Affiche_Jeu(E);
  end Joue_Partie;

end partie;
