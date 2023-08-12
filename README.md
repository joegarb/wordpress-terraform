# WordPress infrastructure as code

Complete production and staging infrastructure for a WordPress site on AWS using Terraform.

See instructions within each subfolder of `environments`.

Notably, staging environments here run on a completely different infrastructure setup than the production environment. This is a tradeoff made for cost savings, though ideally production and staging would match more closely to ensure realistic testing in staging.
