# 🚀 Plateforme DevOps GitOps Complète

Ce projet est une implémentation complète d'un pipeline CI/CD GitOps moderne pour une application Full-Stack (Spring Boot + Angular).

## 🏗️ Architecture du Projet

- **Backend** : Spring Boot 3.x (Java 17) avec Actuator & Micrometer pour le monitoring Prometheus.
- **Frontend** : Angular 17 avec un design premium (Glassmorphism, Dark Mode).
- **CI Pipeline** : GitHub Actions (Build, Test, SAST Scan, Docker Push).
- **CD Pipeline** : ArgoCD (GitOps) pour le déploiement sur Kubernetes.
- **Infrastructure** : Helm Charts pour la gestion des manifests K8s.
- **Observabilité** : Stack Prometheus + Grafana intégrée.
- **Progressive Delivery** : Support pour Argo Rollouts (Canary Release).

## 📂 Structure des Répertoires

```
.
├── backend/                # API Spring Boot
├── frontend/               # UI Angular
├── k8s/                    # Helm Charts (Kubernetes)
├── argocd/                 # Manifests ArgoCD Application
├── monitoring/             # Config Prometheus & Grafana
├── .github/workflows/      # CI Pipeline GitHub Actions
└── docker-compose.yml      # Test local rapide
```

## 🚀 Comment Démarrer

### 1. Développement Local (Docker Compose)
Pour tester l'application rapidement sans Kubernetes :
```bash
docker-compose up --build
```
L'application sera accessible sur `http://localhost`.

### 2. Configuration GitOps (ArgoCD)
1. Poussez ce code sur votre propre dépôt GitHub.
2. Modifiez `argocd/application.yaml` pour pointer vers votre URL de dépôt.
3. Appliquez le manifest à votre cluster K8s :
   ```bash
   kubectl apply -f argocd/application.yaml
   ```

### 3. Pipeline CI/CD
Le pipeline est défini dans `.github/workflows/main.yml`. Vous devez configurer les secrets suivants dans votre dépôt GitHub :
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

## 📊 Observabilité
Le backend expose des métriques Prometheus sur `/actuator/prometheus`. 
Le dossier `monitoring/` contient les configurations de base pour déployer Prometheus dans votre cluster.

## 🌈 Design Aesthetics
Le frontend a été conçu avec une esthétique premium :
- **Glassmorphism** : Cartes semi-transparentes avec flou d'arrière-plan.
- **Dark Mode** : Palette de couleurs sombre et élégante.
- **Animations** : Transitions fluides et chargement dynamique.
- **Typographie** : Utilisation de la police 'Outfit' pour un look moderne.

---
Projet réalisé par **Antigravity** pour une démonstration d'expertise DevOps & GitOps.
