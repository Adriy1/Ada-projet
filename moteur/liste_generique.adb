
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Unchecked_Deallocation;

package body Liste_Generique is

	-- a partir de ce type on peut faire diverse hypotheses sur la facon
	-- dont la liste est representee, notamment en ce qui concerne la
	-- liste vide
	type Cellule is record
		Val: Element;
		Suiv: Liste;
	end record;

	type Iterateur_Interne is record
		L : Liste;
	end record;

	-- Procedure de liberation d'une Cellule (accedee par Liste)
	procedure Liberer is new Ada.Unchecked_Deallocation (Cellule, Liste);

	procedure LibererIt is new Ada.Unchecked_Deallocation (Iterateur_Interne,Iterateur);

	-- creation: init a null
	function Creer_Liste return Liste is
	begin
		return null;
	end Creer_Liste;

	-- liberation: vider et c'est tout...
	procedure Libere_Liste (L : in out Liste) is
    actu : Liste;
  begin
  	actu := L;
  	while (actu /= null) loop
  		Liberer(L);
  		L := actu.Suiv;
  		actu := actu.all.Suiv;
  	end loop;
 end Libere_Liste;


------------------------------------------------------------------------------
-- BLOC 1:

	-- true si liste vide, false sinon
	function Est_Vide (L: in Liste) return Boolean is
	begin
		if L=null then
			Put("Vide");New_Line;
			return true;
		end if;
		Put("Non Vide");New_Line;
		return false;
	end Est_Vide;


	-- insertion d'un element V en tete de liste
	procedure Insere_Tete (V: Element; L: in out Liste) is
	begin
				L := new Cellule'(V,L);

	end Insere_Tete;


	-- affichage de la liste, dans l'ordre de parcours
	procedure Affiche_Liste (L: in Liste) is
	actu : Liste;
	begin
		actu := L;
		while (actu /= null) loop
			Put(actu.all.Val); New_Line;
			actu := actu.all.Suiv;
		end loop;
	end Affiche_Liste;


	-- recherche sequentielle d'un element dans la liste
	function Est_Present (V: Element; L: Liste) return Boolean is
	actu : Liste;
	begin
		actu := L;
		while (actu /= null) loop
			if actu.all.Val = V then
				-- Put("trouvé");New_Line;
				return true;
			end if;
			actu := actu.all.Suiv;
		end loop;
		Put("pas trouvé");New_Line;
		return false;
	end Est_Present;


------------------------------------------------------------------------------
-- BLOC 2:

	-- Vide la liste
	procedure Vide (L: in out Liste) is
	actu : Liste;
	begin
		actu := L;
		while (actu /= null) loop
			Liberer(L);
			L := actu.Suiv;
			actu := actu.all.Suiv;
		end loop;

	end Vide;


	-- insertion d'un element V en queue de liste
	procedure Insere_Queue (V: Element; L: in out Liste) is
	newp : Liste;
	actu: Liste;
	begin
		newp := new Cellule'(V,null);
		actu := L;
		if Est_Vide(L) then
			Insere_Tete(V,L);
		end if;
		while (actu.Suiv /= null) loop
			actu := actu.Suiv;
		end loop;
		actu.Suiv := newp;
	end Insere_Queue;

	function Creer_Iterateur(L : Liste) return Iterateur is
    I : Iterateur;
  begin
    if(L = null) then
      return null;
    else
      I := new Iterateur_Interne;
      I.L := L;
      return I;
    end if;
  end Creer_Iterateur;

  procedure Libere_Iterateur(It : in out Iterateur) is

  begin
    if(It /= null) then
      LibererIt(It);
      It := null;
    end if;
  end Libere_Iterateur;

  procedure Suivant(It : in out Iterateur) is
     I : Iterateur;
  begin
    I := It;
    It := Creer_Iterateur(It.L.Suiv);
    Libere_Iterateur(I);
  end Suivant;

  function Element_Courant(It : Iterateur) return Element is
  begin
    if(It /= null and then It.L /= null) then
      return It.L.Val;
    end if;
    raise FinDeListe;
  end Element_Courant;

  function A_Suivant(It : Iterateur) return Boolean is

  begin
    if(It = null) then
      return False;
    end if;
    return It.L.Suiv /= null;
  end A_Suivant;


------------------------------------------------------------------------------
-- BLOC 3:

	-- suppression de l'element en tete de liste
	procedure Supprime_Tete (L: in out Liste; V: out Element) is
	actu: Liste;
	begin
		actu := L;
		V := actu.Val;
		L := L.Suiv;
		Liberer(actu);

	end Supprime_Tete;


	-- suppression l'element en queue de listes
	procedure Supprime_Queue (L: in out Liste; V: out Element) is
	last: Liste;
	actu: Liste;
	begin
		last := L;
		while (last.Suiv /= null) loop
			actu := last;
			last := last.Suiv;
		end loop;
		actu.Suiv := null;
		V := last.Val;
		Liberer(last);
	end Supprime_Queue;


	-- suppression de la premiere occurence de V dans la liste
	procedure Supprime_Premiere_Occurence (V: in Element; L: in out Liste) is
	prec: liste;
	actu: liste;
	X: Element;
	begin
		actu := L;
		if Est_Present(V,L) then
			if actu.Val = V then
				Supprime_Tete(L,X);
			else
				while (actu /= null) loop
					if actu.Suiv = null then
						Supprime_Queue(L,X);
					else
						prec := actu;
						actu := actu.Suiv;
							if actu.Val = V then
								prec.suiv := actu.suiv;
								Liberer(actu);
							end if;
					end if;
				end loop;
			end if;
		end if;


	end Supprime_Premiere_Occurence;


	-- suppression de toutes les occurences de V de la liste
	procedure Supprime (V: in Element; L: in out Liste) is
	begin
		while Est_Present(V,L) loop
			Supprime_Premiere_Occurence(V,L);
		end loop;

	end Supprime;


------------------------------------------------------------------------------
-- BLOC 4:

	-- inversion l'ordre des elements dans une liste
	-- (sans allocation et en temps lineaire)
	procedure Inverse (L: in out Liste) is
	actu : Liste;
	X : Element;
	begin
		if Est_Vide(L) = false then
		actu := L;
			if actu.suiv /= null then
				X := actu.Suiv.Val;
				while (actu.Suiv /= null) loop
					Supprime_Premiere_Occurence(X,actu.Suiv);
					Insere_Tete(X,L);
					if actu.Suiv /= null then
						X := actu.Suiv.Val;
					end if;
				end loop;
			end if;
		end if;
	end Inverse;

------------------------------------------------------------------------------

-- BLOC 5

-- tri par insertion









end Liste_Generique;
