id: domain_public_repo_gitignore_and_privacy_2026_10_24
type: domain
area: workflow
perspective: user
created: 1792793295.145466
edges: [{"target_id": "domain_private_access_details_not_in_public_records_2026_10_27", "edge_type": "related"}]
cue: You are about to commit, dump device data, or write a record in this public repo and wonder what must stay out of it.
---

Decision: The whole project is a git repo, public on github.com/avataristvan/sm-t585-mainline. .gitignore excludes the ROM folder (incl. the invoice PDF), kernel/build and kernel/out, partition images, firmware blobs, device-dump/.unredacted/ (unredacted originals) and docs/records/general/user/ (personal user-profile records, local only). src/mainline is a submodule of the fork github.com/avataristvan/linux (branch gtaxllte, topic commits); src/downstream-lineage-21 is a submodule of the upstream repo. Records and tracked dumps must contain no personal details about the user (employer, background, household) and no device serial numbers or MAC addresses; personal content goes into docs/records/general/user/. Pushing needs gh credentials (`gh auth setup-git` not yet run; one-off: `git -c credential.helper='!gh auth git-credential' push`).
Why: the repo is public; personal data and unredacted device identifiers must not leak, while records stay versioned so the archivist can fix stale ones in place (this closed todo_records_under_git_2026_10_23).
Scope: this project, all commits and all records written here.
