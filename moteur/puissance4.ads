with Liste_Generique, Participant;
with Participant;
with Ada.Text_IO;
use Participant;


generic
  largeur : Integer;
  hauteur : Integer;
  nbp : Integer;

package Puissance4 is



  type Etat is array(0..(largeur*hauteur-1)) of integer;

  type Coup is record
    Col : Integer;
    Player : Joueur;
  end record;

  procedure Initialiser(E : out Etat);

  function Jouer(E : in out Etat; C : Coup) return Etat;

  function Est_Gagnant(E : Etat; J : Joueur) return Boolean;

  function Est_Nul(E : Etat) return Boolean;

  procedure Affiche_Jeu(E : Etat);

  procedure Affiche_Coup(C : in Coup);

  function Demande_Coup_Joueur1(E : Etat) return Coup;

  function Demande_Coup_Joueur2(E : Etat) return Coup;

  package Liste_Coups is new Liste_Generique(Coup, Affiche_Coup);
  function Coups_Possibles(E : Etat; J : Joueur) return Liste_Coups.Liste;

  function Eval(E : Etat; J: Joueur) return Integer;

end Puissance4;
