# ERP HMPA - Gestion Comptable

MVP Flutter (Android-first) pour gérer les achats, ventes et validations internes.

## Fonctionnalités
- Auth locale simulée (Boss/Employé)
- Dashboard récapitulatif (totaux, bénéfice, statuts)
- CRUD achats et ventes (édition/suppression limitées aux opérations en attente)
- Validation/rejet par le Boss avec commentaire
- Historique simple des actions
- Stockage local SQLite
- Recherche + filtre par statut sur achats/ventes

## Comptes de démonstration
- `admin@hmpa.com / admin123` (Boss)
- `employe@hmpa.com / employe123` (Employé)

## Dépendances
- `provider`
- `sqflite`
- `path`
- `intl`

## Arborescence principale
```text
lib/
  core/enums.dart
  models/
    user.dart
    purchase.dart
    sale.dart
    history_action.dart
  providers/
    auth_provider.dart
    erp_provider.dart
  services/
    auth_service.dart
    database_service.dart
    erp_repository.dart
  screens/
    auth/login_screen.dart
    common/splash_screen.dart
    common/operation_detail_screen.dart
    dashboard/dashboard_screen.dart
    home/home_screen.dart
    purchases/purchase_list_screen.dart
    purchases/purchase_form_screen.dart
    sales/sale_list_screen.dart
    sales/sale_form_screen.dart
    validations/validations_screen.dart
    history/history_screen.dart
    profile/profile_screen.dart
  widgets/
    app_formatters.dart
    status_chip.dart
  main.dart
```

## Lancement (Android Studio)
1. Ouvrir le dossier `erp_hmpa` dans Android Studio.
2. Vérifier Flutter SDK : **Settings > Languages & Frameworks > Flutter**.
3. Exécuter:
   ```bash
   flutter pub get
   flutter run
   ```
4. Choisir un émulateur Android ou un appareil physique.

## Évolution future
La séparation `models/services/providers/screens` facilite une migration vers Firebase ou API Laravel (remplacement du repository local par un repository distant).
