with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;
with Puissance4;
with Participant;
with Liste_Generique;

use Liste_Generique;
use Ada.Text_IO;
use Ada.Integer_Text_IO;
use Participant;


type Valeurs is range 1 .. 2;
    package Rand is new Ada.Numerics.Discrete_Random(Valeurs);
    use Rand;

package body Moteur_Jeu is

    function Eval_Min_Max(E : Etat; P : Natural; C : Coup; J : Joueur) return Integer is
      Integer: Mult,val,valMax;
      L : Liste_Coups.Liste;
      Iter : Liste_Coups.Liste;
      Next : Etat;
    begin
      Next := Etat_Suivant(E,C);
      if J = JoueurMoteur then
        Mult := 1;
      else
        Mult := -1;
      end if;
      if Est_Gagnant(Next,JoueurMoteur) then
        return 100;
      else if Est_Gagnant(Next,Adversaire(JoueurMoteur)) then
        return -100;
      end if;
      else if Est_Nul(Next) then
        return 0;
      end if;
      end if;
      if P = 0 then
        return Mult * Eval(Next);
      else
        L := Coups_Possibles(Next,Adversaire(J));
        I := Liste_Coups.Creer_Iterateur(L);
        val := Eval_Min_Max(Next,P-1,Liste_Coups.Element_Courant(I),Adversaire(J));
        Liste_Coups.Suivant(I);
        while(Liste_Coups.A_Suivant(I)) loop
        valMax := Eval_Min_Max(Next,P-1,Liste_Coups.Element_Courant(I),Adversaire(J));
        if(JoueurMoteur = J) then
          if(val>valMax) then
            val := valMax;
          end if;
        else
          if(val<valMax) then
            val := valMax;
          end if;
        end if;
        Liste_Coups.Suivant(I);
      end loop;
      return val;
    end if;
  end Eval_Min_Max;

  function Choix_Coup(E : Etat) return Coup is
    C : Coup;
    L : Liste_Coups.Liste;
    val,valMax, : Integer;
    Iter : Liste_Coups.Iterateur;
    Gen : Generator;
  begin
    Reset(Gen);
    L := Coups_Possibles(E,JoueurMoteur);
    Iter := Liste_Coups.Creer_Iterateur(L);
    C := Liste_Coups.Element_Courant(Iter);
    val := Eval_Min_Max(E,P-1,Liste_Coups.Element_Courant(Iter),JoueurMoteur);
    while(Liste_Coups.A_Suivant(I)) loop
        Liste_Coups.Suivant(I);
        valMax := Eval_Min_Max(E,P-1,Liste_Coups.Element_Courant(Iter),JoueurMoteur);
        if (valMax>val) then
          C := Liste_Coups.Element_Courant(Iter);
          val := valMax;
        else
          if(valMax = val and Random(Gen)>1) then
            C := Liste_Coups.Element_Courant(Iter);
          end if;
        end if;
    end loop;
    return C;
  end Choix_Coup;

end Moteur_Jeu;





    end;
