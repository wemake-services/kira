# Cron-like jobs

## Decision

We will use `quantum`.

Because it is easy to start with and easy to scale.
There were no other significant alternatives.

All `cron` tasks must be idempotent.
