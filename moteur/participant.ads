package Participant is

    type Joueur is (Joueur1, JoueurMoteur);

    -- Retourne l'adversaire du joueur passé en paramètre
    function Adversaire(J : in out Joueur) return Joueur;

end Participant;
