# 🚀 Documentation Globale : Plateforme DevOps & GitOps de Niveau Entreprise

Ce document offre une vue d'ensemble complète du projet, expliquant l'architecture, les choix technologiques et les flux de travail mis en œuvre. Il est conçu pour démontrer une expertise avancée en ingénierie DevOps.

---

## 💡 Vision du Projet
L'objectif est de transformer une application Full-Stack classique en une **plateforme résiliente, automatisée et auto-gérée**. Ce n'est pas seulement du code informatique, c'est une **infrastructure vivante** qui suit les principes du **GitOps**.

## 🏗️ 1. Architecture des 3 Piliers

Le projet repose sur trois couches fondamentales :

### A. L'Application (Le Cœur)
*   **Backend** : API REST développée en **Spring Boot 3**. Elle inclut des "Probes" (Liveness/Readiness) pour que Kubernetes sache si l'application est en bonne santé, et expose des métriques via **Micrometer/Prometheus**.
*   **Frontend** : Interface moderne en **Angular 17** avec un design Premium (Glassmorphism). Elle communique avec l'API de manière sécurisée.
*   **Base de données** : **PostgreSQL** gérée via des `PersistentVolumes` pour garantir que les données ne sont jamais perdues, même si le cluster redémarre.

### B. Le Pipeline CI (Continuous Integration)
Situé dans `.github/workflows/`, il s'exécute à chaque "Push" sur GitHub :
1.  **Test & build** : Compilation automatique du code.
2.  **Sécurité** : Scan des vulnérabilités.
3.  **Dockerization** : Création d'images Docker légères et sécurisées.
4.  **Distribution** : Push des images sur **Docker Hub**.
5.  **Mise à jour GitOps** : Le pipeline modifie automatiquement la version dans les manifests Kubernetes pour déclencher le déploiement.

### C. L'Infrastructure GitOps (Le Cerveau)
C'est ici que l'expertise DevOps brille vraiment :
*   **ArgoCD** : Outil de CD (Continuous Delivery) qui surveille le dépôt Git. Dès qu'une modification est détectée, il synchronise le cluster Kubernetes sans aucune intervention humaine.
*   **Kubernetes (Minikube)** : Orchestrateur qui fait tourner les conteneurs.

---

## 🎯 2. Fonctionnalités d'Excellence (Les "Wow" du projet)

### 📈 Auto-Scaling (HPA)
Le système est capable de "respirer". J'ai configuré un **Horizontal Pod Autoscaler** :
*   Si le trafic augmente et que le processeur dépasse **70%**, Kubernetes crée automatiquement de nouveaux Pods (jusqu'à 5). 
*   Quand le trafic baisse, il réduit la flotte à **3 Pods** pour économiser des ressources.

### 🎯 Canary Release (Progressive Delivery)
Contrairement aux déploiements classiques où tout change d'un coup, nous utilisons **Argo Rollouts** :
1.  Une nouvelle version est déployée à **40%**.
2.  Une **AnalysisTemplate** interroge Prometheus en temps réel.
3.  Si tout va bien, on passe à **80%** avec une nouvelle phase d'analyse.
4.  Si le taux d'erreur 500 est trop élevé, le déploiement est **automatiquement annulé** (Rollback).

---

## 📊 3. Observabilité & Pilotage

*   **Prometheus** : Collecte des milliers de données sur l'usage CPU, RAM, et le nombre de requêtes.
*   **Grafana** : Transforme ces données en graphiques visuels magnifiques.
*   **Cockpit (DEV_DASHBOARD.html)** : Une interface unique que j'ai créée pour centraliser tous les accès (ArgoCD, API, UI, Grafana) et permettre une démonstration fluide devant un jury.

---

## 🛠️ 4. Automatisation de la Récupération
Pour garantir que le projet est "démo-ready", j'ai conçu des scripts de secours (`RECOVERY_MASTER.ps1`) :
*   Vérifie l'état de Docker.
*   Réinstalle et configure tout le cluster en une commande.
*   Relance les tunnels réseau (port-forward) nécessaires.

---

## 🏁 Conclusion
Ce projet démontre une maîtrise complète du cycle de vie logiciel moderne : **depuis la première ligne de code jusqu'à la gestion automatisée d'une infrastructure résiliente en production.** 🏆🚀
