# Code review automation
# https://github.com/danger/danger
#
# Policy:
# 1. Use `warn` for all thnigs that are important, but not related to code.
#   So it will be possible to fix these issues without creating new commits
# 2. Use `failure` for all things that are important and are related to code.
#   So people will have to create new commits to address these issues.
# 3. Use `sticky: true` for things that
#   show attempts for potentially risky behaviour:
#   like secrets or config modification, too big submissions, etc.
# 4. Place `failure`s after all `warn` rules
#   to collect maximum amount of issues in a code review comment


# WARN WHEN AN MR IS CLASSED AS WORK IN PROGRESS.
warn "MR is classed as Work in Progress" if
  gitlab.mr_title.include? "WIP:"

# HIGHLIGHT WITH A CLICKABLE LINK IF IMPORTANT FILES ARE CHANGED.
important_files = [
  "Dangerfile",
  ".gitlab-ci.yml",
  "mix.exs"
]

important_files.each do |item|
  warn "#{gitlab.html_link(item)} was edited.", sticky: true if
    git.modified_files.include? item
end

# CODE CHANGES MUST ALSO BRING TEST CHANGES.
has_app_changes = !git.modified_files.grep(/lib/).empty?
tests_updated = !git.modified_files.grep(/test/).empty?
if has_app_changes && !tests_updated
  warn("The library files were changed, but the tests remained unmodified.
  Consider updating or adding to the tests to match the library changes.")
end

# ENSURE THERE IS A SUMMARY FOR A MR.
warn "Please provide a summary in the MR description, at least 50 chars" if
  gitlab.mr_body.length < 50

# ENSURE THAT EACH MERGE REQUEST CLOSES AT LEAST ONE ISSUE.
warn "MR does not close any issues. Should close at least one" if
  not gitlab.mr_title.index /closes #\d+/i

# MAKE SURE THAT BRANCH WILL BE REMOVED.
warn "Please make sure to auto-remove source branch" if
  not gitlab.mr_json["should_remove_source_branch"]

# MAKE SURE THAT MR WILL BE AUTO MERGED.
warn "Please make sure to mark this MR to be auto-merged on CI success" if
  not gitlab.mr_json["merge_when_pipeline_succeeds"]

# MAKE SURE THAT MR CAN BE MERGED VIA UI.
warn "This MR cannot be merged, you will need to rebase it or assign Kira" if
  gitlab.mr_json["merge_status"] != "can_be_merged"

# MAKE SURE THAT WE TRACK ALL NEW TODOS.
todoist.message = "Things to do later, consider creating task chains"
todoist.warn_for_todos
todoist.print_todos_table

# ========
# Critical
# Comes after warnings to collect maximum number of messages

# ONLY ACCEPT MRS TO THE DEVELOP BRANCH.
failure "Please re-submit this MR to master branch" if
  gitlab.branch_for_merge != "master"

# FAIL REALLY BIG DIFFS.
failure "We cannot handle the scale of this MR", sticky: true if
  git.lines_of_code > 10000

# FAIL WHEN GIT HAS MERGE COMMITS.
if git.commits.any? { |c| c.message =~ /^Merge branch 'master'/ }
  failure "Please rebase to get rid of the merge commits in this MR"
end
