## ADDED Requirements

### Requirement: Checkout-ready image

The system SHALL include `git` and a `node` runtime in the published image,
so a consuming repo's `container:` job can run `actions/checkout` (or its
Forgejo equivalent) with no separate package-install step.

#### Scenario: Consumer runs actions/checkout inside the image

- **WHEN** a consuming repo's CI runs `container: ghcr.io/alrayyes/ltex-cli-plus:<version>`
  and then `actions/checkout`
- **THEN** the checkout step succeeds with no prior `apt-get install` step
  for `git` or `nodejs`
