# Kira

Kira is an issue management framework with deep philosophy underneath.

It is implemented as a set of independent Gitlab bots.
This project is all about assigning users to the tasks.
And making sure that users are doing well with this task.

Read more about [`rsdp`](https://wemake.services/meta/) before starting.

## Key principles

1. One user = one active task at a time, there should be no context switches
2. All tasks are micro-tasks: from 15 minutes to 2 hours
3. All tasks form chains: some tasks can be executed in parallel,
   while some are blocked by other tasks
4. Tasks end when merge requests closes it,
   or when task is marked invalid and should not be done
5. Users can reject any task with no consequences
6. Users cannot choose tasks on their own
7. Users can set their status: working or not-working

## How does the process look like?

1. We select the most important and the easiest unblocked task
2. We select a random working user that has no other tasks to do
3. We assign this user to the task
4. User has to agree to work on this task by saying `@kira-bot take`
   or to decline this task by unassigning himself
5. User then send a merge request with the solution
6. When the automatic check passes we find
   the most knowledgeable codeowner to review this code

## Progress check

We have several points when user might get stuck
or just not receive our interaction.

So we must track these points in the process:
1. User might not accept nor decline the task,
   so we have to assume that user is away from keyboard
   for some reason and reassign the task in a period of time
2. User might not submit the solution in the estimated time gap,
   so we have to notify this user several times and then reassign the task
3. User might submit the solution but fail to fix the CI
4. User might not review other user's code, so we have to find another reviewer
