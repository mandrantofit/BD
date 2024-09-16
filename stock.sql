-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : lun. 16 sep. 2024 à 15:42
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
-- Déchargement des données de la table `affectation`
--

INSERT INTO `affectation` (`ID_affectation`, `ID_utilisateur`, `ID_materiel`, `date_affectation`) VALUES
(25, 4, 8, '2024-09-11'),
(26, 4, 3, '2024-09-16'),
(28, 1, 6, '2024-09-16'),
(29, 1, 7, '2024-09-16');

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
(10, 'COMPUTEK');

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
(23, 23, 1, 7, '2024-09-11', '2024-09-11 05:46:54'),
(24, 24, 1, 3, '2024-09-11', '2024-09-11 08:41:19'),
(25, 27, 4, 7, '2024-09-16', '2024-09-16 06:41:28'),
(26, 30, 7, 2, '2024-09-16', '2024-09-16 13:24:15'),
(27, 31, 7, 1, '2024-09-16', '2024-09-16 13:26:46');

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
(1, 'Locaux'),
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
(8, 'user', 'test@gmail.com', '$2a$10$nwSEXE8u6P9IYxCkgAUXoup6ESUY0PvsJb0mMMt.qlFX.F//vXsWS');

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
(1, '523651', 'DL7420', 'Latitude 7420', 'Dell', '123456789', 2, 1, 4, 'BC12346', '16GB RAM, 512GB HDD', 'BL9876', 'non'),
(2, '585216', 'DL7420', 'Latitude 7420', 'Dell', '127556790', 2, 1, 2, 'OP12645', '8GB RAM, 256GB HDD', 'ML9676', 'non'),
(3, '852369', 'HP450', 'ProBook 450 G7', 'HP', '348239876', 2, 1, 2, 'OP12890', '16GB RAM, 512GB SSD', 'ML9832', 'oui'),
(4, '523687', 'DL6410', 'Latitude E6410', 'Dell', '123756789', 2, 2, 3, 'B12345', '16GB RAM, 512GB SSD', 'B9876', 'non'),
(5, '523145', 'DL6410', 'Latitude E6410', 'DELL', '10589652347', 2, 1, 4, '8569MP', 'SSD256 , 8RAM , 14\"', '65896LP', 'non'),
(6, '785632', 'BB21', 'BB 2.1', 'BLACKBERRY', '25632417', 2, 2, 3, '587412OL', 'BB v2 , 2RAM', '523471OK', 'oui'),
(7, '745215', 'CR45', 'RJ45', 'Câble resaux', '45878932', 1, 1, 4, '5698OU', '5m', '85623UJ', 'oui'),
(8, '5642135', 'SS02', 'Schneider', 'Stylo', '1235875', 5, 1, 8, '4541ST', 'à encre', '3215JU', 'oui');

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
(4, 'test', 5, 1),
(7, 'test', 4, 3);

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
-- Index pour la table `categorie`
--
ALTER TABLE `categorie`
  ADD PRIMARY KEY (`ID_categorie`);

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
  MODIFY `ID_affectation` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT pour la table `categorie`
--
ALTER TABLE `categorie`
  MODIFY `ID_categorie` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `etat`
--
ALTER TABLE `etat`
  MODIFY `ID_etat` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `fournisseur`
--
ALTER TABLE `fournisseur`
  MODIFY `ID_fournisseur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `historique`
--
ALTER TABLE `historique`
  MODIFY `ID_historique` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT pour la table `lieux`
--
ALTER TABLE `lieux`
  MODIFY `ID_lieux` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `log_user`
--
ALTER TABLE `log_user`
  MODIFY `ID_logUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `materiel`
--
ALTER TABLE `materiel`
  MODIFY `ID_materiel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `service`
--
ALTER TABLE `service`
  MODIFY `ID_service` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `ID_utilisateur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
-- Contraintes pour la table `materiel`
--
ALTER TABLE `materiel`
  ADD CONSTRAINT `materiel_ibfk_1` FOREIGN KEY (`ID_categorie`) REFERENCES `categorie` (`ID_categorie`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `materiel_ibfk_2` FOREIGN KEY (`ID_etat`) REFERENCES `etat` (`ID_etat`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `materiel_ibfk_3` FOREIGN KEY (`ID_fournisseur`) REFERENCES `fournisseur` (`ID_fournisseur`) ON DELETE CASCADE ON UPDATE CASCADE;

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
