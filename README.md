# Inception

![inception](https://raw.githubusercontent.com/ayogun/42-project-badges/main/badges/inceptionm.png)

## Description
Inception est un projet de l'École 42 visant à approfondir l'administration système en utilisant Docker.

## Objectif
Mettre en place une mini-infrastructure de différents services en utilisant Docker Compose.

## Fonctionnalités

- Configuration de conteneurs Docker pour :
  - NGINX avec TLSv1.2 ou TLSv1.3
  - WordPress + php-fpm
  - MariaDB
- Volumes pour la base de données WordPress et les fichiers du site
- Réseau Docker dédié
- Redémarrage automatique des conteneurs en cas de crash

## Compilation et Exécution
make
## Structure du projet

- `srcs/` : fichiers Docker et configurations
- `Makefile` : pour automatiser le build et le déploiement

## Prérequis

- Docker
- Docker Compose
