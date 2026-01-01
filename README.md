# Projet de fin d'études Licence Informatique

Ce projet est une application mobile de messagerie sécurisée.
WhatSecure permet d'envoyer des messages texte ou des fichiers de façon sécurisée.
Les algorithmes de chiffrement AES et RSA sont utilisés afin de protéger les données.
La principale fonctionnalité de l'application, c'est l'activation de la vérification faciale.
Si elle est activée, l'application active la caméra en tâche de fond. En cas de détection d'un visage qui n'est pas le vôtre, il y a verrouillage de l'application.

Vous pouvez visionner la présentation du projet via ce [lien](https://www.canva.com/design/DAGJ1yqKEnk/AOHfPVVke0pdXABudRiKcQ/edit?utm_content=DAGJ1yqKEnk&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton).

# Organisation du code

## ml_vision

Ceci est une copie d'un dépôt GitHub qui nous a aidés à implémenter la détection et la vérification faciale.

## phone_auth

Dans phone_auth, vous trouverez le code Dart/Flutter de l'application mobile.

## whatsecure

Dans le répertoire whatsecure se trouve le code du backend. Ce code est minimaliste et peut être amélioré.
C'est l'implémentation d'une API REST pour gérer les utilisateurs de l'application mobile et d'un websocket pour la communication en temps réel en Java avec Spring Boot. 