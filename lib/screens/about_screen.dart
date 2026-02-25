// ABOUTME: About screen: attribution (data.gov.rs, publisher, license), disclaimer, dataset link.
// ABOUTME: Uses url_launcher Link for canonical dataset URL.

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

/// Canonical RPG dataset URL (data.gov.rs).
const String datasetUrl =
    'https://data.gov.rs/sr/datasets/rpg-broj-svikh-registrovanikh-poljoprivrednikh-gazdinstava-aktivna-gazdinstva/';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('O aplikaciji')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Izvor podataka',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Podaci dolaze sa data.gov.rs. Izdavač: Uprava za agrarna plaćanja. Licenca: Javni podaci.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Link(
              uri: Uri.parse(datasetUrl),
              builder: (context, followLink) => TextButton(
                onPressed: followLink,
                child: const Text('RPG dataset na data.gov.rs'),
              ),
            ),
            const SizedBox(height: 24),
            Text('Napomena', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Ova aplikacija je rad nezavisnog programera koji nije povezan sa vladom niti bilo kojim državnim telom. '
              'Projekat učenja i zajednice koji koristi otvorene podatke.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
