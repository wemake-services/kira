# How to express issue chains in the database

Author: @rsolovjov
Date: 16.08.2019

## Decision
We will use Materialized Path with [PostgresSQL ltree](https://www.postgresql.org/docs/9.2/ltree.html)

## Reasoning
Candidates:
1. Adjacency List
2. Nested Set
3. Materialized Path

Materialized Path has advantages:
1. The ltree implements a **materialized path,** which very quick for INSERT/UPDATE/DELETE and pretty quick for SELECT operations
2. It will be generally faster than using a recursive CTE or recursive function that constantly needs to recalculate the branching
4. As built-in query syntax and operators specifically designed for querying and navigating trees
5. Using a GiST index with ltree operators allows Postgres to search efficiently across an entire tree

Some libraries implementing Materialized Path exists:
- [**ecto_materialized_path**](https://github.com/asiniy/ecto_materialized_path)
- [**hierarch**](https://github.com/Byzanteam-Labs/hierarch)
- [**ecto_ltree**](https://hexdocs.pm/ecto_ltree/0.2.0/readme.html)

But they have limitations, for example, **hierarch** and **ecto_materialized_path** functions work only when path consists of **id** fields, i.e. we can't use any other fields like **iid**. Аnd anyway you have to use **fragment** to use the built-in query syntax and operators.
And better just define your own Ecto LTree type without any libraries.

## Implementation

1. Define Ecto LTree type
https://hostiledeveloper.com/2017/06/17/ltrees-in-phoenix.html

2. Add "path" field to "issues" table and create a new table for implementing "after" feature.
```
alter table(:issues) do
  add :path, :ltree
end

create table(:issue_after) do
  add(:after_id, references(:issues))
  add(:issue_id, references(:issues))
end
```
3. Using the fragment function to get our [ltree search](https://www.postgresql.org/docs/9.2/ltree.html) working. For example:
```
def get_descendants(root_issue) do
  from(issue in Issue,
    where: fragment("? <@ ?", issue.path, ^root_issue.path))
  |> Repo.all()
end
```
