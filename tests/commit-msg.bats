#!/usr/bin/env bats
# Tests for .githooks/commit-msg. Run from the repo root: bats tests/

setup() {
  HOOK="$BATS_TEST_DIRNAME/../.githooks/commit-msg"
  MSG=$(mktemp)
}

teardown() {
  rm -f "$MSG"
}

check() {  # check "<message>": run the hook on a message file
  printf '%s\n' "$1" > "$MSG"
  run "$HOOK" "$MSG"
}

@test "accepts a plain conventional subject" {
  check "fix: make teardown fail loudly"
  [ "$status" -eq 0 ]
}

@test "accepts a scope and a breaking-change marker" {
  check "feat(pihole)!: bind DNS to the LAN address only"
  [ "$status" -eq 0 ]
}

@test "ignores git's comment lines and blank lines before the subject" {
  printf '\n# Please enter the commit message\ndocs: add network map\n\nBody text.\n' > "$MSG"
  run "$HOOK" "$MSG"
  [ "$status" -eq 0 ]
}

@test "rejects a subject without a type" {
  check "updated stuff"
  [ "$status" -eq 1 ]
  [[ "$output" == *"type(scope): summary"* ]]
}

@test "rejects an unknown type" {
  check "feature: add pihole"
  [ "$status" -eq 1 ]
}

@test "rejects a trailing full stop" {
  check "docs: add network map."
  [ "$status" -eq 1 ]
}

@test "rejects a subject longer than 72 characters" {
  check "docs: $(printf 'x%.0s' {1..70})"
  [ "$status" -eq 1 ]
  [[ "$output" == *"72 or fewer"* ]]
}

@test "rejects an empty message" {
  printf '# only comments\n' > "$MSG"
  run "$HOOK" "$MSG"
  [ "$status" -eq 1 ]
  [[ "$output" == *"empty"* ]]
}

@test "lets fixup! commits through for autosquash" {
  check "fixup! docs: add network map"
  [ "$status" -eq 0 ]
}
