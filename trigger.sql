DELIMITER //

CREATE TRIGGER historique_after_delete
AFTER DELETE ON affectation
FOR EACH ROW
BEGIN
  INSERT INTO historique (
    ID_affectation,
    ID_utilisateur,
    ID_materiel,
    date_affectation
  )
  VALUES (
    OLD.ID_affectation,
    OLD.ID_utilisateur,
    OLD.ID_materiel,
    OLD.date_affectation
  );
END;

//

DELIMITER ;
