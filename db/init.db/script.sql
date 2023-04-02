CREATE DATABASE users;

\c users;

CREATE TABLE USERS (
    EMAIL VARCHAR(60) NOT NULL,
    USER_PASSWORD VARCHAR(200) NOT NULL,
    USER_STATUS VARCHAR(14) NOT NULL DEFAULT 'Student',
    POINTS INT DEFAULT 800,
    CONSTRAINT USERS_PK PRIMARY KEY (EMAIL),
    CONSTRAINT USER_EMAIL_CHECK CHECK (EMAIL LIKE '%@etu.univ-amu.fr' or EMAIL LIKE '%@univ-amu.fr'),
    CONSTRAINT USER_STATUS_CHECK CHECK (USER_STATUS IN ('Student', 'Teacher', 'Admin'))
);

CREATE TABLE RETRIEVE_PASSWORDS (
    EMAIL VARCHAR(60) references USERS(email),
    token INT NOT NULL,
    expiration_date TIMESTAMP NOT NULL,
    CONSTRAINT RETRIEVE_PASSWORDS_PK PRIMARY KEY (EMAIL)
);

CREATE TABLE USERSNOTVERIFIED (
    EMAIL VARCHAR(60) NOT NULL,
    USER_PASSWORD VARCHAR(200) NOT NULL,
    token INT NOT NULL,
    expiration_date TIMESTAMP NOT NULL,
    CONSTRAINT USERS_NOT_VERIFIED_PK PRIMARY KEY (EMAIL)
);

CREATE OR REPLACE FUNCTION BEFORE_INSERT_USERS()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.email LIKE '%@etu.univ-amu.fr' THEN
        NEW.user_status = 'Student';
    ELSEIF NEW.email LIKE '%@univ-amu.fr' THEN
        NEW.user_status = 'Teacher';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRIGGER_BEFORE_INSERT_USERS
BEFORE INSERT ON USERS
FOR EACH ROW 
EXECUTE FUNCTION BEFORE_INSERT_USERS();

INSERT INTO USERS (EMAIL, USER_PASSWORD) VALUES ('lenny.gonzales@etu.univ-amu.fr', 'b9d38d92d629d3b3cbedaec45b9e592f985a30f8ab959cb92a1722656df62d32e040bc6cb31b09f08bd033dd5b5993a94fb07ad73bad1f86c5f1cc853183c073');

CREATE DATABASE stories;

\c stories;

CREATE TABLE QUESTIONS (
    ID SERIAL,
    MODULE VARCHAR(40),
    DESCRIPTION VARCHAR(1000),
    QUESTION VARCHAR(300),
    NBANSWERS INT DEFAULT 0,
    NBCORRECTANSWERS INT DEFAULT 0,
    CONSTRAINT PK_QUESTIONS PRIMARY KEY (ID)
);

CREATE TABLE MULTIPLECHOICEQUESTIONS (
    TRUE_ANSWER INT,
    ANSWER_1 VARCHAR(300),
    ANSWER_2 VARCHAR(300),
    ANSWER_3 VARCHAR(300),
    CONSTRAINT PK_MULTIPLECHOICE PRIMARY KEY (ID)
) INHERITS (QUESTIONS);

CREATE TABLE WRITTENRESPONSEQUESTIONS (
    TRUE_ANSWER VARCHAR(300),
    CONSTRAINT PK_WRITTENRESPONSE PRIMARY KEY (ID)
) INHERITS (QUESTIONS);

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Introduction aux réseaux', 'Mohammed a pour passe-temps de regarder des vidéos sur YouTube, il en dévore tous les soirs, il adore regarder Dr Eyeman, Doc 8 et de nombreuses vidéos sur le piratage et la sécurité. Il a beaucoup étudié les vidéos mais n''a encore jamais pratiqué. L''une des premières questions qu''il se pose c''est comment fonctionne son réseau et avec quel équipement.' ,'De quoi est composé le réseau de Mohammed ?', 2, 'De périphériques entrants et finaux', 'De périphériques finaux et intermédiaires', 'De périphériques intermédiaires et sortants');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Introduction aux réseaux','Mohammed cherche à savoir comment son ordinateur reçoit la connexion nécessaire pour naviguer sur le web envoyé par sa box Internet.','Quel est le type de support réseau utilisé lorsqu''il y a un codage par modulation de fréquence d''ondes électromagnétiques ?', 3, 'Fibres optiques', 'Câbles avec fils métalliques', 'Transmission sans fil');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Introduction aux réseaux','Grâce à toi, Mohammed sait comment son réseau fonctionne chez lui. Mais lorsqu''il se rend au lycée, il constate que le réseau utilisé est différent du sien car il y a plusieurs machines et ordinateurs dans un même endroit.','Quel est le type de réseau utilisé par son lycée ?', 'WAN');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Introduction aux réseaux','Il se rend sur l''un des ordinateurs de son lycée et effectue une recherche afin d''en apprendre davantage sur le réseau.','En effectuant sa recherche, Mohammed se demande quel type de réseau (net) utilise l’ordinateur du lycée pour accéder à sa recherche ?', 'Extranet');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Introduction aux réseaux','Durant l''un de ses cours, son professeur passe derrière lui et voit qu''il est très intéressé par le réseau, il vient donc vers lui et lui pose la question suivante :','Sais-tu comment deux équipements réseaux communiquent entre eux ?', 1, 'Selon certaines règles définies par un protocole', 'Selon certaines règles définies par un masque de sous réseau','Selon les règles de l''établissement');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Introduction aux réseaux','Son professeur est impressionné par les nouvelles connaissances de Mohammed et décide de l''aider dans sa quête du savoir.','Il apprend que lorsque des nouvelles informations sont ajoutées à chaque couche dans la pile TCP/IP cela s''appelle :', 'Encapsulation');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Introduction aux réseaux','Quelques jours avant les examens, le professeur pose une question à Mohammed qui parlait avec son voisin.','La question est : "À la réception, les données remontent dans la pile TCP/IP et les entêtes de protocoles sont supprimés au fur et à mesure, c’est :"', 'Désencapsulation');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Ethernet','Notre mascotte Gibo le robot est composé de plein de choses différentes, c''est à vous de nous aider à comprendre comment il fonctionne !','Quel est le rôle d''une carte d''interface réseau ?', 3, 'Convertir les signaux analogiques en signaux numériques', 'Fournir une connectivité Internet haut débit','Permet à un périphérique de se connecter à un réseau');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Ethernet','Des câbles se situe sur le dos de notre robot et il aimerait en savoir davantage sur lui.','Donnez lui les trois types de câbles dans Ethernet.', 1, 'Câble coaxial, Câble à paires torsadées, Fibre optique', 'Câble coaxial, Câble à triples torsades, Fibre optique','Câble biaxial, Câble à triples torsades, Fibre optique');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Ethernet','De temps en temps les connexions dans notre robot sont difficiles, cherchons d''où cela provient.','Quel câble devient obsolète de nos jours ?', 1, 'Câble coaxial', 'Câble à paires torsadées','Fibre optique');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Ethernet','Nous avons trouvé un certain sigle sur le robot, nous pensons que c''est ARP.','Que signifie ARP ?', 'Address Resolution Protocol');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Ethernet','Plusieurs domaines de diffusions sont dans notre robot, mais comment c''est possible ...','Qu''est-ce qui permet de segmenter logiquement un domaine de diffusion en plusieurs domaines de diffusion plus petits ?', 'VLAN');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Ethernet','Après quelques recherches, nous savons que notre robot utilise un VLAN de niveau 1 mais il ne comprend pas clairement son fonctionnement. Il faut que vous aidiez le robot !','Selon quoi un VLAN de niveau 1 regroupe des équipements ?', 'Une adresse MAC');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Ethernet','Voici une trame Ethernet capturée dans notre robot, c''est vraiment complexe, il faut que vous l’aidiez à la comprendre : 00 23 89 57 5e a3 84 2b 2b a0 56 f8 08 00 45 00 00 40 32 5f 00 00 80 11 00 00 8b 7c bb 1d 8b 7c 01 02 ec e8 00 35 00 2c d3 55 c6 b8 01 00 00 01 00 00 00 00 00 00 03 77 77 77 0a 72 66 63 2d 65 64 69 74 6f 72 03 6f 72 67 00 00 01 00 01','Quel est le type de paquet encapsulé dans la trame ?', 'ipv4');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Tous les modules','Bravo, grâce à votre incroyable talent et expertise dans le domaine du hacking et de l''espionnage, vous venez d’aider un espion de la SIA qui est en fait placé sous surveillance par l''État et devinez quoi ? Johnny vient d’obtenir des informations très critiques sur la maison grise, vous êtes dans de beaux draps … Par conséquent, l''État vous reconnaît coupable du vol des documents, vous êtes donc arrêté et retenu en détention provisoire. Il existe des failles dans le système où vous êtes enfermé et vous les connaissez, c''est le moment pour vous de les exploiter ! Voici 4 adresses : 12.45.25.63 - 192.168.1.254 - 80.10.10.81 - 172.32.0.1','Vous devez déterminer parmi ces adresses laquelle est privée.', '192.168.1.254');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Tous les modules','Oh non ! L''adresse que vous venez de récupérer à partir d''une faille de sécurité a changée, heureusement vous êtes déjà dans le système et vous récupérez un hôte dont voici les caractéristiques : adresse IP : 10.246.235.210, Masque : 255.255.252.0','Déterminez l’adresse de diffusion.', '10.246.235.255');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Couche physique','Sandra est une grande joueuse de jeu vidéo, elle joue 2 à 3 heures par jour quand elle ne travaille pas. Comme tout joueur, son plus grand fardeau est la mise à jour.','Qu''est-ce que le débit binaire d''une ligne ?', 2, 'Le rapport entre 2 puissances', 'Le nombre de bits transmis par seconde','La vitesse du signal électrique');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Couche physique','Hier elle a dû installer la mise à jour de son jeu préféré, Rocket League, cela lui a pris environ 20 minutes.','Comment calcule-t-on le débit binaire D d’une ligne ? Les opérateurs seront à écrire de cette manière */-+', 'R * V');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Couche physique','Sandra est une grande créatrice de robots miniatures intelligents et autonomes, depuis longtemps elle étudie les tensions électriques.','Qu''est ce qui est représenté par une tension positive ou négative en codage bipolaire ?', '1');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Couche physique','Sandra a enfin terminé son examen, elle est confiante et pense avoir réussi. Lorsqu''elle rentre chez elle, elle décide d''allumer son jeu vidéo préféré, mais mauvaise surprise pour elle, une mise à jour est disponible et sans elle, Sandra ne pourra pas jouer. Elle souhaite télécharger sa mise à jour du jeu vidéo qui fait 1.4 Go. Elle est disposée d’une connexion ADSL qui a pour débit 15 Mbit/s.','Combien de temps va-t-elle mettre pour télécharger la mise à jour ? Donnez le résultat en secondes sous cette forme : 1000 secondes', '747 secondes');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Couche physique','Sandra se dit que cela va prendre trop de temps pour télécharger la mise à jour de 1.4Go de son jeu vidéo favori et décide donc de se rendre chez sa cousine Julia qui possède une connexion fibrée de 1Gbit/s.','Combien de temps va-t-elle mettre pour télécharger la mise à jour chez Julia ? Donnez le résultat en seconde sous cette forme : 1000.0 secondes', 3, '1.12 secondes', '10.7 secondes',' 11.2 secondes');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Couche physique','Sandra utilise régulièrement des modems dans son travail.','Un modem utilise une modulation de phase avec 8 phases différentes. Quelle est sa valence ?', '3');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Couche physique','Sandra a l''habitude de faire ce genre de calcul mais là c’est à vous de l''aider.','Quelle est la rapidité de modulation si le débit d''un modem est de 45.4 Kbit/s ?', 1, '15.13 bauds', '4.54 bauds', '56.75 bauds');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Couche physique','Dans le métier que Sandra exerce elle rencontre souvent des paires torsadées, on vous rappelle qu''une paire torsadée a pour but principal de limiter la sensibilité aux interférences.','Une paire torsadée a une bande passante de 150 MHz. En l''absence de bruit, et en utilisant 2 valeurs différentes du signal électrique, quel est le débit que l''on peut atteindre en MHz ?', '300');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Couche physique','Sandra avait effectué un stage dans une radio il y a 2 ans, ce qui suit lui rappelle de vague souvenir sur la rapidité de modulation.','En quelle unité exprime-t-on la rapidité de modulation ?', 'Bauds');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Couche physique','Sandra doit rendre un travail assez détaillez, aidez-la dans ses recherches.','Qu''est-ce que la valence ?', 1, 'Nombre de bits transmis à chaque intervalle élémentaire', 'Puissance du signal transmis à chaque intervalle élémentaire','C’est la capitale de l''Espagne');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Couche physique','Sandra sait qu''il existe trois grandes catégories de modulation, elle a appris cela durant ces études.','Citez les trois grandes catégories de modulation :', 1, 'D''amplitude, de phase, de fréquence', 'D''amplitude, de phase, d''impulsion', 'De phase, d''impulsion, de fréquence');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Ethernet', 'Notre mascotte Gibo le robot est composé de plein de choses différentes, c''est à vous de nous aider à comprendre comment il fonctionne !','Combien d''adresse MAC possède une carte réseaux ?', 2, '2', '1', '4');

INSERT INTO WRITTENRESPONSEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER) VALUES ('Ethernet', 'Notre robot est aussi composé d’une trame Ethernet.','Quelle est la taille minimale d’une trame Ethernet en octets ? Donnez la réponse sous ce format : 1000 octets', '64 octets');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Ethernet', 'Nous aimerions mettre notre robot à jour vers des VLAN de niveau 2.','Selon quoi un VLAN de niveau 2 regroupe des équipements ?', 1, 'Ports', 'Adresse IP', 'Adresse MAC');

INSERT INTO MULTIPLECHOICEQUESTIONS (MODULE, DESCRIPTION, QUESTION, TRUE_ANSWER, ANSWER_1, ANSWER_2, ANSWER_3) VALUES ('Tous les modules','Johnny Weekend est un agent secret très haut placé dans la SIA, il a été envoyé en mission pour récupérer des documents très confidentiels, malheureusement il n''a même pas connaissance du lieu sur lequel il doit opérer, grâce à des écouteurs ultras puissants il intercepte un message sur une paire torsadée qui a une bande passante de 600 Hz.','Quelle est sa capacité de transmission maximale avec un rapport signal sur bruit de 20 dB ?', 2, '3501.4 bits', '3501.4 bits', '3968.4 bits')









