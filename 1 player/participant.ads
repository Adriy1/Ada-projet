package Participant is

    type Joueur is (Joueur1, Joueur2);

    -- Retourne l'adversaire du joueur passé en paramètre
    function Adversaire(J : in  Joueur) return Joueur;

end Participant;
