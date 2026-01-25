# 👥 Répartition Stratégique DevOps : "Qui fait quoi ?"

Ce projet n'est **PAS** un projet de développement web. C'est un projet d'**Ingénierie DevOps**.
L'application (Spring/Angular) n'est qu'un prétexte pour démontrer votre maîtrise de la chaîne CI/CD.

Voici la répartition des compétences DevOps exigées par l'énoncé :

---

## 🚀 1. Khalil : Lead GitOps & CD (Le Chef d'Orchestre)
**Ta Mission :** Le déploiement continu et l'intelligence du cluster.
**Ce que tu défends :** "J'ai géré le **CD (Continuous Delivery)** et l'orchestration Kubernetes."

### 🔧 Tes Responsabilités Clés :
1.  **GitOps avec ArgoCD :**
    *   Tu as installé et configuré ArgoCD pour qu'il soit la "source de vérité".
    *   Sync automatique : Git -> Cluster (plus de `kubectl apply` manuel).
2.  **Stratégies de Déploiement Avancées (Bonus) :**
    *   **Argo Rollouts** : Mise en place du **Canary Release** (Progressive Delivery).
    *   **HPA (Auto-Scaling)** : Configuration de l'élasticité (3 -> 5 pods sous charge).
3.  **Templating Helm :**
    *   Tu as créé les Charts génériques pour ne pas dupliquer le code YAML.

**🗣️ Punchline :** *"Mon rôle était de garantir que la mise en production soit un non-événement : automatisée, auditable et résiliente grâce au GitOps."*

---

## 🛡️ 2. Fedi : Lead CI & Sécurité (Le Gardien)
**Ta Mission :** L'intégration continue et la qualité du code avant déploiement.
**Ce que tu défends :** "J'ai géré le **CI (Continuous Integration)** et la sécurité (DevSecOps)."

### 🔧 Tes Responsabilités Clés :
1.  **Pipeline GitHub Actions :**
    *   Automatisation complète : Checkout -> Setup Java/Node -> Build.
    *   Tests automatisés : S'assurer que le code ne casse rien.
2.  **DevSecOps (Sécurité) :**
    *   **SAST** : Analyse statique du code pour trouver les failles.
    *   **Container Scan (Trivy)** : Scan des images Docker pour éviter les vulnérabilités CVE.
3.  **Gestion des Artifacts :**
    *   Push sécurisé des images vers Docker Hub avec un tag unique (Versioning).

**🗣️ Punchline :** *"J'ai construit la 'Supply Chain' logicielle. Mon objectif était qu'aucun code vulnérable ou cassé ne puisse atteindre le stade du déploiement."*

---

## 👁️ 3. Yasmine : Lead Observabilité & Conteneurisation
**Ta Mission :** La visibilité et l'empaquetage standardisé.
**Ce que tu défends :** "J'ai géré la **Conteneurisation** et le **Monitoring**."

### 🔧 Tes Responsabilités Clés :
1.  **Docker & Optimisation :**
    *   Création des **Dockerfiles** (Multi-stage build) pour réduire la taille des images (Backend & Frontend).
    *   Standardisation de l'environnement d'exécution (Plus besoin de "ça marche chez moi").
2.  **Monitoring (Prometheus) :**
    *   Configuration du scraping des métriques (CPU, RAM, Requêtes HTTP).
    *   Exposition des endpoints `/metrics` (Actuator).
3.  **Visualisation (Grafana) :**
    *   Création des Dashboards pour visualiser la santé du cluster en temps réel.
    *   C'est grâce à ça qu'on prouve que le HPA fonctionne.

**🗣️ Punchline :** *"J'ai apporté la visibilité totale sur le système. Grâce aux conteneurs optimisés et aux tableaux de bord, on sait exactement ce qui se passe dans le cluster à la milliseconde près."*

---

## 🎯 Résumé pour le Jury
*   **Fedi** valide et empaquette le code (CI).
*   **Khalil** déploie et scale le code (CD/GitOps).
*   **Yasmine** surveille si tout va bien (Observabilité).

C'est une chaîne DevOps complète et cohérente. 🔗✨
