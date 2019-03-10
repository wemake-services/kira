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

# ========
# Critical
# Comes after warnings to collect maximum number of messages

# ONLY ACCEPT MRS TO THE DEVELOP BRANCH.
failure "Please re-submit this MR to master branch" if
  gitlab.branch_for_merge != "master"

# ENSURE THERE IS A SUMMARY FOR A MR.
failure "Please provide a summary in the MR description" if
  gitlab.mr_body.length < 50

# ENSURE THAT EACH MERGE REQUEST CLOSES AT LEAST ONE ISSUE.
failure "MR does not close any issues. Should close at least one" if
  gitlab.mr_title.index /closes #\d+/i

# FAIL REALLY BIG DIFFS.
failure "We cannot handle the scale of this MR" if
  git.lines_of_code > 10000

# FAIL WHEN GIT HAS MERGE COMMITS.
if git.commits.any? { |c| c.message =~ /^Merge branch 'master'/ }
  failure "Please rebase to get rid of the merge commits in this MR"
end
