# RPG

Flutter app (mobile and web) that shows Serbia’s RPG open data: registered and active agricultural holdings by municipality (opština). Same codebase for iOS, Android, and web; responsive layout. Data comes from [data.gov.rs](https://data.gov.rs/sr/datasets/rpg-broj-svikh-registrovanikh-poljoprivrednikh-gazdinstava-aktivna-gazdinstva/).

## Run

```bash
flutter pub get
flutter run
```

For a device or emulator, `flutter run` picks an available target. For web:

```bash
flutter run -d chrome
```

## Design and data

- Design and spec: [docs/DESIGN.md](docs/DESIGN.md)
- Dataset: [RPG na data.gov.rs](https://data.gov.rs/sr/datasets/rpg-broj-svikh-registrovanikh-poljoprivrednikh-gazdinstava-aktivna-gazdinstva/)
