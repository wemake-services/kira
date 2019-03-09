# WARN WHEN AN MR IS CLASSED AS WORK IN PROGRESS.
warn "MR is classed as Work in Progress" if gitlab.mr_title.include? "[WIP]"

# HIGHLIGHT WITH A CLICKABLE LINK IF IMPORTANT FILES ARE CHANGED.
important_files = [
  "Dangerfile",
  ".gitlab-ci.yml",
  "mix.exs"
]

important_files.each do |item|
  warn "#{gitlab.html_link(item)} was edited."
    if git.modified_files.include? item
end

# ========
# Critical
# Comes after warnings to collect maximum number of messages

# ENSURE THERE IS A SUMMARY FOR A MR.
failure "Please provide a summary in the Merge Request description"
  if gitlab.mr_body.length < 5

# TODO: make sure that `mr_body` contains:
# 1. closes #issue-number

# ONLY ACCEPT MRS TO THE DEVELOP BRANCH.
failure "Please re-submit this MR to master branch"
  if gitlab.branch_for_merge != "master"

# FAIL REALLY BIG DIFFS.
failure "We cannot handle the scale of this PR" if git.lines_of_code > 10000

# FAIL WHEN GIT HAS MERGE COMMITS.
if git.commits.any? { |c| c.message =~ /^Merge branch 'master'/ }
  failure "Please rebase to get rid of the merge commits in this PR"
end
