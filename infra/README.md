# infra

- `modules/` reusable, versioned modules with `terraform test`.
- `live/` Terragrunt config per environment (`dev`, `prod`). State in S3 with native lockfile.

```bash
cd infra/live/dev/vpc && terragrunt plan
cd infra/live/dev && terragrunt run --all plan
```

Cost guard: always run `terragrunt run --all destroy` after a lab and keep an AWS Budget alert (see `modules/budget`).
