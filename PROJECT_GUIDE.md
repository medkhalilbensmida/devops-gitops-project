# 🚀 Documentation Globale : Plateforme DevOps & GitOps de Niveau Entreprise

Ce document de référence détaille l'architecture, les choix technologiques et l'organisation de notre projet. Il est conçu pour démontrer l'expertise technique de chaque membre de l'équipe et la cohérence de notre approche "Cloud-Native".

---

## 💡 Vision du Projet : Une Infrastructure "Vivante"
Notre objectif n'était pas simplement de "déployer une app", mais de **construire une usine logicielle complète**.
Nous avons transformé une application Full-Stack classique en un système distribué, résilient et auto-géré.
*   **Infrastructure as Code (IaC)** : Tout est décrit dans des fichiers YAML standardisés (Helm).
*   **GitOps (Single Source of Truth)** : L'état du cluster Kubernetes est le miroir exact de notre dépôt Git.
*   **Sécurité (DevSecOps)** : La sécurité n'est pas une option, elle est intégrée dans le pipeline CI.

---

## 🏗️ 1. L'Application & Les Données (Fonctionnalités Métier)

Cette couche représente la valeur ajoutée pour l'utilisateur final. Elle est divisée en deux pôles d'expertise.

### A. Frontend & Expérience Utilisateur
**👤 Responsable : Fedi**

Fedi a conçu l'interface vitrine de notre projet. Son travail ne s'est pas limité au code Angular, mais a englobé toute la stratégie de distribution du contenu statique.
*   **Technologie** : Angular 17 (Framework SPA robuste).
*   **Architecture & Design** : Implémentation d'une interface "Glassmorphism" moderne avec des composants réactifs.
*   **Conteneurisation Avancée** :
    *   Utilisation de **NGINX** comme serveur web performant dans le conteneur.
    *   **Docker Multi-Stage Build** : Fedi a optimisé le Dockerfile pour compiler l'application dans une étape temporaire et ne garder que les fichiers compilés dans l'image finale, réduisant la taille de 500Mo à <20Mo.
*   **Sécurité** : Configuration des headers HTTP et gestion des appels API sécurisés via le cluster.

### B. Backend API & Persistance des Données
**👤 Responsable : Yasmine**

Yasmine a développé le "moteur" du système. Son défi était de rendre l'API stateless et observable pour Kubernetes.
*   **Moteur** : Spring Boot 3 (Java), choisi pour sa robustesse en entreprise.
*   **Cloud-Native Readiness** :
    *   Intégration de **Spring Boot Actuator** pour exposer les "entrailles" de l'application (santé, métriques JVM).
    *   Définition des endpoints de **Liveness** (Est-ce que je suis vivant ?) et **Readiness** (Est-ce que je peux recevoir du trafic ?) utilisés par Kubernetes.
*   **Base de Données** : **PostgreSQL**.
    *   Yasmine a configuré la persistance via des **PersistentVolumeClaims (PVC)**. Cela garantit que même si les pods de base de données sont redémarrés ou déplacés sur un autre nœud, les données clients sont conservées intactes.

---

## 🛡️ 2. La "Supply Chain" Logicielle (CI & Sécurité)

**👤 Responsable : Fedi**

Avant même d'arriver en production, le code doit traverser une série de contrôles draconiens. Fedi a mis en place un pipeline d'Intégration Continue (CI) automatisé sur **GitHub Actions**.

1.  **Build & Test Automatisés** : À chaque `git push`, le code est compilé et testé. Si une erreur survient, le pipeline s'arrête net.
2.  **DevSecOps (La Sécurité au Cœur)** :
    *   **Analyse Statique (SAST)** : Le pipeline scanne le code source pour détecter les mauvaises pratiques ou failles de sécurité.
    *   **Scan de Conteneurs (Trivy)** : Avant d'être déployée, l'image Docker est scannée pour vérifier qu'elle ne contient pas de vulnérabilités connues (CVE) dans ses librairies système.
3.  **Livraison (Registry)** : Les images validées sont taguées avec un SHA unique (traçabilité parfaite) et poussées sur Docker Hub.

*Fedi garantit ainsi que rien de "cassé" ou de "dangereux" n'arrive jusqu'au déploiement.*

---

## 🧠 3. Le Cerveau des Opérations (GitOps & CD)

**👤 Responsable : Khalil**

Une fois l'image validée par Fedi, Khalil prend le relais pour le déploiement et la gestion opérationnelle.

### 🔄 GitOps avec ArgoCD
Plus de commandes manuelles (`kubectl apply`) ! Khalil a déployé **ArgoCD**.
*   **Fonctionnement** : ArgoCD surveille le dépôt Git en permanence.
*   **Auto-Sync** : Si Fedi met à jour le code, ArgoCD détecte la nouvelle version de l'image et met à jour le cluster Kubernetes automatiquement.
*   **Self-Healing** : Si quelqu'un supprime un pod ou un service manuellement par erreur, ArgoCD le détecte et le recrée immédiatement pour coller à la "vérité" du Git.

### 📈 Scalabilité Automatique (HPA)
Khalil a rendu l'infrastructure **élastique** pour absorber les pics de charge :
*   Configuration du **Horizontal Pod Autoscaler (HPA)**.
*   Si le trafic explose (ex: Black Friday, ou notre démo "20 utilisateurs"), le système détecte la surcharge CPU.
*   **Réaction** : Kubernetes passe automatiquement de **3 à 5 Pods** Backend.
*   **Économie** : Une fois le calme revenu, il détruit les pods superflus après une fenêtre de stabilisation de 2 minutes.

### 🎯 Déploiement Progressif (Canary Release)
Pour éviter les crashs en production lors des mises à jour, Khalil a implémenté **Argo Rollouts** :
*   La nouvelle version n'est pas déployée chez tout le monde d'un coup.
*   Elle est d'abord servie à **40%** des utilisateurs.
*   Une "Intelligence Artificielle" (AnalysisTemplate) vérifie les taux d'erreur en temps réel. Si tout est vert, le déploiement continue. Sinon, retour en arrière automatique.

---

## 📊 4. L'Observabilité (Les Yeux du Système)

**👤 Responsable : Yasmine**

Une infrastructure complexe nécessite une visibilité totale. Yasmine a instrumenté le cluster pour que nous ne soyons jamais aveugles.

*   **Prometheus (La Mémoire)** : Ce serveur collecte des milliers de points de données par seconde (Usage CPU des conteneurs, mémoire RAM de la JVM Java, Latence du réseau...).
*   **Grafana (La Vue)** : Yasmine a créé des tableaux de bord interactifs qui permettent de visualiser l'état de santé du projet en un coup d'œil. C'est grâce à ses dashboards que nous pouvons prouver que l'Auto-Scaling de Khalil fonctionne réellement.

---

## 🏁 Synthèse de l'Équipe

Ce projet est le fruit d'une collaboration étroite où chaque expertise est critique :

*   **Fedi** construit un produit beau (Frontend) et sûr (CI/Secu).
*   **Yasmine** construit un moteur robuste (Backend/Data) et nous donne la vision (Monitoring).
*   **Khalil** construit l'autoroute (K8s/GitOps) qui permet de livrer ce produit à grande vitesse et sans accident.

🏆 **Projet DevOps "State-of-the-Art" validé.**
