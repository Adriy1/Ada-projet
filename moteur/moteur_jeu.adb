with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;
with Puissance4;
with Participant;
with Liste_Generique;


use Ada.Text_IO;
use Ada.Integer_Text_IO;
use Participant;




package body Moteur_Jeu is

  type Valeurs is range 1 .. 2;
      package Rand is new Ada.Numerics.Discrete_Random(Valeurs);
      use Rand;



    function Eval_Min_Max(E : Etat; P : Natural; C : Coup; J : Joueur) return Integer is
      val,valMax,Mult : Integer;
      L : Liste_Coups.Liste;
      Iter : Liste_Coups.Iterateur;
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
      end if;
      if Est_Gagnant(Next,Adversaire(JoueurMoteur)) then
        return -100;
      end if;
      if Est_Nul(Next) then
        return 0;
      end if;
      if P = 0 then
        return Mult * Eval(Next);
      else
        L := Coups_Possibles(Next,Adversaire(J));
        Iter := Liste_Coups.Creer_Iterateur(L);
        val := Eval_Min_Max(Next,P-1,Liste_Coups.Element_Courant(Iter),Adversaire(J));
        Liste_Coups.Suivant(Iter);
        while(Liste_Coups.A_Suivant(Iter)) loop
        valMax := Eval_Min_Max(Next,P-1,Liste_Coups.Element_Courant(Iter),Adversaire(J));
        if(JoueurMoteur = J) then
          if(val>valMax) then
            val := valMax;
          end if;
        else
          if(val<valMax) then
            val := valMax;
          end if;
        end if;
        Liste_Coups.Suivant(Iter);
      end loop;
      return val;
    end if;
  end Eval_Min_Max;

  function Choix_Coup(E : Etat) return Coup is
    C : Coup;
    L : Liste_Coups.Liste;
    val,valMax : Integer;
    Iter : Liste_Coups.Iterateur;
    Gen : Generator;
  begin
    Reset(Gen);
    L := Coups_Possibles(E,JoueurMoteur);
    Iter := Liste_Coups.Creer_Iterateur(L);
    C := Liste_Coups.Element_Courant(Iter);
    val := Eval_Min_Max(E,P-1,Liste_Coups.Element_Courant(Iter),JoueurMoteur);
    while(Liste_Coups.A_Suivant(Iter)) loop
        Liste_Coups.Suivant(Iter);
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
