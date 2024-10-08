-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : mar. 08 oct. 2024 à 08:45
-- Version du serveur : 10.4.28-MariaDB
-- Version de PHP : 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `stock`
--

-- --------------------------------------------------------

--
-- Structure de la table `affectation`
--

CREATE TABLE `affectation` (
  `ID_affectation` int(11) NOT NULL,
  `ID_utilisateur` int(11) DEFAULT NULL,
  `ID_materiel` int(11) DEFAULT NULL,
  `date_affectation` date DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déclencheurs `affectation`
--
DELIMITER $$
CREATE TRIGGER `historique_after_delete` AFTER DELETE ON `affectation` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `affectation_consomable`
--

CREATE TABLE `affectation_consomable` (
  `ID_affectation_consomable` int(11) NOT NULL,
  `ID_utilisateur` int(11) DEFAULT NULL,
  `ID_materiel_consomable` int(11) DEFAULT NULL,
  `quantite_affecter` int(11) NOT NULL DEFAULT 1,
  `date_affectation` date DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `affectation_consomable`
--

INSERT INTO `affectation_consomable` (`ID_affectation_consomable`, `ID_utilisateur`, `ID_materiel_consomable`, `quantite_affecter`, `date_affectation`) VALUES
(4, 1, 2, 1, '2024-10-08'),
(5, 9, 2, 1, '2024-10-08');

--
-- Déclencheurs `affectation_consomable`
--
DELIMITER $$
CREATE TRIGGER `decremente_quantite_consomable` BEFORE INSERT ON `affectation_consomable` FOR EACH ROW BEGIN
    DECLARE quantite_disponible INT;

    -- Vérifier la quantité disponible dans la table materiel_consomable
    SELECT quantite INTO quantite_disponible 
    FROM materiel_consomable 
    WHERE ID_materiel_consomable = NEW.ID_materiel_consomable;

    -- Si la quantité disponible est suffisante, on décrémente
    IF quantite_disponible >= NEW.quantite_affecter THEN
        UPDATE materiel_consomable 
        SET quantite = quantite - NEW.quantite_affecter
        WHERE ID_materiel_consomable = NEW.ID_materiel_consomable;
    ELSE
        -- Si la quantité disponible est insuffisante, on lève une erreur
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantité insuffisante pour l''affectation';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `categorie`
--

CREATE TABLE `categorie` (
  `ID_categorie` int(20) NOT NULL,
  `type` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `categorie`
--

INSERT INTO `categorie` (`ID_categorie`, `type`) VALUES
(1, 'Equipement et Réseaux'),
(2, 'Ordinateur et Périphérique'),
(3, 'Imprimantes et Scanners'),
(4, 'Équipements de Stockage'),
(5, 'Pièces Détachées et Accessoires'),
(6, 'Équipements Audio/Vidéo');

-- --------------------------------------------------------

--
-- Structure de la table `commande`
--

CREATE TABLE `commande` (
  `ID_commande` int(11) NOT NULL,
  `numero_serie` varchar(255) DEFAULT NULL,
  `bon_de_commande` varchar(255) DEFAULT NULL,
  `bon_de_livraison` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `commande`
--

INSERT INTO `commande` (`ID_commande`, `numero_serie`, `bon_de_commande`, `bon_de_livraison`) VALUES
(1, 'WTKU0CGC346P8', 'BC_DL7420', 'BL_DL7420');

-- --------------------------------------------------------

--
-- Structure de la table `etat`
--

CREATE TABLE `etat` (
  `ID_etat` int(20) NOT NULL,
  `description` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `etat`
--

INSERT INTO `etat` (`ID_etat`, `description`) VALUES
(1, 'Neuf'),
(2, 'Utilisable'),
(3, 'Réparable'),
(4, 'Irréparable');

-- --------------------------------------------------------

--
-- Structure de la table `fournisseur`
--

CREATE TABLE `fournisseur` (
  `ID_fournisseur` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `fournisseur`
--

INSERT INTO `fournisseur` (`ID_fournisseur`, `nom`) VALUES
(1, 'SERVEAST'),
(2, 'ICMM'),
(3, 'SUNRISE\'L'),
(4, 'QUBETA'),
(5, 'MYSTORE'),
(6, 'ZOOM GOLDEN'),
(7, 'ADT Consultant'),
(8, 'ICONE'),
(9, 'HAREL MALLAC'),
(10, 'COMPUTEK'),
(12, 'SUPREM CENTER'),
(13, 'Grossiste Andravohangy');

-- --------------------------------------------------------

--
-- Structure de la table `historique`
--

CREATE TABLE `historique` (
  `ID_historique` int(11) NOT NULL,
  `ID_affectation` int(11) DEFAULT NULL,
  `ID_utilisateur` int(11) DEFAULT NULL,
  `ID_materiel` int(11) DEFAULT NULL,
  `date_affectation` date DEFAULT NULL,
  `date_suppression` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `historique`
--

INSERT INTO `historique` (`ID_historique`, `ID_affectation`, `ID_utilisateur`, `ID_materiel`, `date_affectation`, `date_suppression`) VALUES
(36, 36, 7, 3, '2024-09-17', '2024-09-17 08:38:40'),
(37, 37, 7, 3, '2024-09-17', '2024-09-17 10:05:51'),
(38, 43, 1, 10, '2024-09-18', '2024-09-18 11:58:00'),
(39, 45, 1, 14, '2024-10-02', '2024-10-07 13:38:36');

-- --------------------------------------------------------

--
-- Structure de la table `lieux`
--

CREATE TABLE `lieux` (
  `ID_lieux` int(11) NOT NULL,
  `lieux` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `lieux`
--

INSERT INTO `lieux` (`ID_lieux`, `lieux`) VALUES
(1, 'Siège'),
(2, 'Analakely'),
(3, 'Behoririka'),
(4, 'Ankorondrano');

-- --------------------------------------------------------

--
-- Structure de la table `log_user`
--

CREATE TABLE `log_user` (
  `ID_logUser` int(11) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'simple',
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `log_user`
--

INSERT INTO `log_user` (`ID_logUser`, `type`, `email`, `password_hash`) VALUES
(1, 'admin', 'mandrantofit@gmail.com', '$2a$10$kZWr6acxDvWbYiM8evT1f.SdUG7kSejdsqGT4iBrLKaWqVzdzRTiC'),
(13, 'admin', 'fal_mahen@yahoo.fr', '$2a$10$0pp18OpDxRYSG6PCXsiMa.cejW7jIAB4rTWZQ3n.Zsqk5bgE29dOm'),
(14, 'user', 'yahrena30@gmail.com', '$2a$10$Gav09WNWhu2pzTQK/04BreaoQec/LKBQvlE03sN7yxh7mbOQkb53W');

-- --------------------------------------------------------

--
-- Structure de la table `materiel`
--

CREATE TABLE `materiel` (
  `ID_materiel` int(11) NOT NULL,
  `numero_inventaire` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `modele` varchar(255) NOT NULL,
  `marque` varchar(255) NOT NULL,
  `numero_serie` varchar(255) NOT NULL,
  `ID_categorie` int(11) DEFAULT NULL,
  `ID_etat` int(11) DEFAULT NULL,
  `ID_fournisseur` int(11) DEFAULT NULL,
  `bon_de_commande` varchar(255) DEFAULT NULL,
  `config` varchar(255) DEFAULT NULL,
  `bon_de_livraison` varchar(255) DEFAULT NULL,
  `attribution` varchar(20) NOT NULL DEFAULT 'non'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `materiel`
--

INSERT INTO `materiel` (`ID_materiel`, `numero_inventaire`, `code`, `modele`, `marque`, `numero_serie`, `ID_categorie`, `ID_etat`, `ID_fournisseur`, `bon_de_commande`, `config`, `bon_de_livraison`, `attribution`) VALUES
(14, '6423131', 'DL7420', 'Latitude 7420', 'DELL', 'WTKU0CGC346P8', 2, 2, 1, 'BC_DL7420', '16goMem , 256SSD', 'BL_DL7420', 'non');

-- --------------------------------------------------------

--
-- Structure de la table `materiel_consomable`
--

CREATE TABLE `materiel_consomable` (
  `ID_materiel_consomable` int(11) NOT NULL,
  `numero_inventaire` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `modele` varchar(255) NOT NULL,
  `marque` varchar(255) NOT NULL,
  `config` varchar(255) DEFAULT NULL,
  `ID_fournisseur` int(11) DEFAULT NULL,
  `bon_de_commande` varchar(255) DEFAULT NULL,
  `bon_de_livraison` varchar(255) DEFAULT NULL,
  `quantite` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `materiel_consomable`
--

INSERT INTO `materiel_consomable` (`ID_materiel_consomable`, `numero_inventaire`, `code`, `modele`, `marque`, `config`, `ID_fournisseur`, `bon_de_commande`, `bon_de_livraison`, `quantite`) VALUES
(2, 'INV-2024-002', 'DL_MK', 'Mouse / Keyboard', 'DELL', NULL, 12, 'BC-2024-AC123', 'BL-2024-AC123', 18);

-- --------------------------------------------------------

--
-- Structure de la table `possibilite_Materiel`
--

CREATE TABLE `possibilite_Materiel` (
  `ID_possibilite` int(11) NOT NULL,
  `possibilite_code` varchar(255) DEFAULT NULL,
  `possibilite_marque` varchar(255) DEFAULT NULL,
  `possibilite_modele` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `possibilite_Materiel`
--

INSERT INTO `possibilite_Materiel` (`ID_possibilite`, `possibilite_code`, `possibilite_marque`, `possibilite_modele`) VALUES
(1, 'DL7420', 'DELL', 'Latitude 7420'),
(2, 'DL6410', 'DELL', 'Latitude E6410'),
(3, 'HP640', 'HP', 'Probook 640 G2'),
(4, 'DL_MK', 'DELL', 'Mouse / Keyboard');

-- --------------------------------------------------------

--
-- Structure de la table `service`
--

CREATE TABLE `service` (
  `ID_service` int(20) NOT NULL,
  `Nom` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `service`
--

INSERT INTO `service` (`ID_service`, `Nom`) VALUES
(1, 'Système d\'Information'),
(2, 'Technique'),
(3, 'Logistique'),
(4, 'Commerce'),
(5, 'Communication et Marketing'),
(6, 'DG'),
(7, 'Finance'),
(8, 'Réabo'),
(9, 'DEC'),
(10, 'DOP'),
(11, 'Novegasy');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `ID_utilisateur` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `ID_service` int(11) DEFAULT NULL,
  `ID_lieux` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`ID_utilisateur`, `nom`, `ID_service`, `ID_lieux`) VALUES
(1, 'Faly', 1, 1),
(9, 'Eric', 1, 1);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `affectation`
--
ALTER TABLE `affectation`
  ADD PRIMARY KEY (`ID_affectation`),
  ADD KEY `ID_utilisateur` (`ID_utilisateur`),
  ADD KEY `ID_materiel` (`ID_materiel`);

--
-- Index pour la table `affectation_consomable`
--
ALTER TABLE `affectation_consomable`
  ADD PRIMARY KEY (`ID_affectation_consomable`),
  ADD KEY `ID_utilisateur` (`ID_utilisateur`),
  ADD KEY `affectation_consomable_ibfk_2` (`ID_materiel_consomable`);

--
-- Index pour la table `categorie`
--
ALTER TABLE `categorie`
  ADD PRIMARY KEY (`ID_categorie`);

--
-- Index pour la table `commande`
--
ALTER TABLE `commande`
  ADD PRIMARY KEY (`ID_commande`),
  ADD KEY `numero_serie` (`numero_serie`);

--
-- Index pour la table `etat`
--
ALTER TABLE `etat`
  ADD PRIMARY KEY (`ID_etat`);

--
-- Index pour la table `fournisseur`
--
ALTER TABLE `fournisseur`
  ADD PRIMARY KEY (`ID_fournisseur`);

--
-- Index pour la table `historique`
--
ALTER TABLE `historique`
  ADD PRIMARY KEY (`ID_historique`);

--
-- Index pour la table `lieux`
--
ALTER TABLE `lieux`
  ADD PRIMARY KEY (`ID_lieux`);

--
-- Index pour la table `log_user`
--
ALTER TABLE `log_user`
  ADD PRIMARY KEY (`ID_logUser`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `materiel`
--
ALTER TABLE `materiel`
  ADD PRIMARY KEY (`ID_materiel`),
  ADD UNIQUE KEY `numero_serie` (`numero_serie`),
  ADD KEY `ID_categorie` (`ID_categorie`),
  ADD KEY `ID_etat` (`ID_etat`),
  ADD KEY `ID_fournisseur` (`ID_fournisseur`);

--
-- Index pour la table `materiel_consomable`
--
ALTER TABLE `materiel_consomable`
  ADD PRIMARY KEY (`ID_materiel_consomable`),
  ADD KEY `materiel_consomable_ibfk_1` (`ID_fournisseur`);

--
-- Index pour la table `possibilite_Materiel`
--
ALTER TABLE `possibilite_Materiel`
  ADD PRIMARY KEY (`ID_possibilite`);

--
-- Index pour la table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`ID_service`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`ID_utilisateur`),
  ADD KEY `ID_service` (`ID_service`),
  ADD KEY `utilisateur_ibfk_2` (`ID_lieux`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `affectation`
--
ALTER TABLE `affectation`
  MODIFY `ID_affectation` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT pour la table `affectation_consomable`
--
ALTER TABLE `affectation_consomable`
  MODIFY `ID_affectation_consomable` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `categorie`
--
ALTER TABLE `categorie`
  MODIFY `ID_categorie` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `commande`
--
ALTER TABLE `commande`
  MODIFY `ID_commande` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `etat`
--
ALTER TABLE `etat`
  MODIFY `ID_etat` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `fournisseur`
--
ALTER TABLE `fournisseur`
  MODIFY `ID_fournisseur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `historique`
--
ALTER TABLE `historique`
  MODIFY `ID_historique` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT pour la table `lieux`
--
ALTER TABLE `lieux`
  MODIFY `ID_lieux` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `log_user`
--
ALTER TABLE `log_user`
  MODIFY `ID_logUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT pour la table `materiel`
--
ALTER TABLE `materiel`
  MODIFY `ID_materiel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT pour la table `materiel_consomable`
--
ALTER TABLE `materiel_consomable`
  MODIFY `ID_materiel_consomable` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `possibilite_Materiel`
--
ALTER TABLE `possibilite_Materiel`
  MODIFY `ID_possibilite` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `service`
--
ALTER TABLE `service`
  MODIFY `ID_service` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `ID_utilisateur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `affectation`
--
ALTER TABLE `affectation`
  ADD CONSTRAINT `affectation_ibfk_1` FOREIGN KEY (`ID_utilisateur`) REFERENCES `utilisateur` (`ID_utilisateur`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `affectation_ibfk_2` FOREIGN KEY (`ID_materiel`) REFERENCES `materiel` (`ID_materiel`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `affectation_consomable`
--
ALTER TABLE `affectation_consomable`
  ADD CONSTRAINT `affectation_consomable_ibfk_1` FOREIGN KEY (`ID_utilisateur`) REFERENCES `utilisateur` (`ID_utilisateur`),
  ADD CONSTRAINT `affectation_consomable_ibfk_2` FOREIGN KEY (`ID_materiel_consomable`) REFERENCES `materiel_consomable` (`ID_materiel_consomable`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `materiel`
--
ALTER TABLE `materiel`
  ADD CONSTRAINT `materiel_ibfk_1` FOREIGN KEY (`ID_categorie`) REFERENCES `categorie` (`ID_categorie`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `materiel_ibfk_2` FOREIGN KEY (`ID_etat`) REFERENCES `etat` (`ID_etat`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `materiel_ibfk_3` FOREIGN KEY (`ID_fournisseur`) REFERENCES `fournisseur` (`ID_fournisseur`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `materiel_consomable`
--
ALTER TABLE `materiel_consomable`
  ADD CONSTRAINT `materiel_consomable_ibfk_1` FOREIGN KEY (`ID_fournisseur`) REFERENCES `fournisseur` (`ID_fournisseur`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD CONSTRAINT `utilisateur_ibfk_1` FOREIGN KEY (`ID_service`) REFERENCES `service` (`ID_service`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `utilisateur_ibfk_2` FOREIGN KEY (`ID_lieux`) REFERENCES `lieux` (`ID_lieux`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
