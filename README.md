# Farafinah Instagram

Une application mobile Flutter qui reproduit fidèlement l'expérience utilisateur d'Instagram.

## Fonctionnalités

### 1. Authentification

- Interface identique à Instagram
- Gestion des cas suivants :
  - **muser1/mpassword1** → Connexion réussie
  - **muser2/mpassword2** → Connexion réussie
  - **muser3/mpassword3** → Message : « Ce compte a été bloqué. »
  - Autre combinaison → Message : « Informations de connexion invalides »
- Transitions et validations soignées
- Redirection automatique vers l'écran "Feed" après connexion

### 2. Feed utilisateur

- Intégration de l'API Unsplash
- Affichage des images sous forme de feed à la manière d'Instagram
- Implémentation d'infinite scroll pour le chargement progressif des photos
- Gestion élégante des états de chargement et des erreurs (shimmer, pull-to-refresh, etc.)

### 3. Système de "Like"

- Icône de like visible sous chaque image
- Visuel distinct pour les images déjà likées (cœur plein rouge)
- Stockage persistant des préférences de like entre les sessions

## Installation et configuration

1. **Cloner le projet** :
   ```bash
   git clone https://github.com/votre-compte/farafinah_insta.git
   cd farafinah_insta
   ```

2. **Obtenir les dépendances** :
   ```
   flutter pub get
   ```

3. **Configuration de l'API Unsplash** :
   - Créer un compte développeur sur [Unsplash](https://unsplash.com/developers)
   - Obtenir une clé d'API (Access Key)
   - Modifier le fichier `lib/config/api_config.dart` pour ajouter votre clé API :
     ```dart
     static const String accessKey = 'VOTRE_CLE_API_UNSPLASH';
     ```

4. **Lancer l'application** :
   ```
   flutter run
   ```

## Choix techniques

### Architecture

- **État global** : Provider pour la gestion de l'état de l'application (authentification, photos, likes)
- **Structure des dossiers** :
  - `models/` : Modèles de données
  - `screens/` : Écrans principaux de l'application
  - `widgets/` : Composants réutilisables
  - `services/` : Logique métier et appels API
  - `providers/` : Gestion de l'état
  - `utils/` : Utilitaires et constantes
  - `config/` : Configuration de l'application

### Dépendances externes

- **provider** : Gestion de l'état
- **http** : Appels réseau vers l'API Unsplash
- **cached_network_image** : Mise en cache et affichage optimisé des images
- **shared_preferences** : Stockage local des préférences de like
- **shimmer** : Effet de chargement élégant
- **flutter_staggered_grid_view** : Affichage en grille décalée (optionnel)

### UI/UX

- Interfaces fidèles au design d'Instagram
- Gestion des transitions et animations
- Indicateurs de chargement (shimmer, circular progress)
- Gestion des erreurs avec options de réessai
- Infinite scroll avec indicateur de chargement

## Identifiants de test

- **Connexion réussie** :
  - Utilisateur : `muser1` / Mot de passe : `mpassword1`
  - Utilisateur : `muser2` / Mot de passe : `mpassword2`

- **Compte bloqué** :
  - Utilisateur : `muser3` / Mot de passe : `mpassword3`
