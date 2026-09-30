# Research artifacts and packaging

The large CSV and screening report are research exports, not runtime plugin
features. They are linked from [the audit](fork-audit.md) at their original
archive commit `8059c940f90b5ca690dcfb36dbe75bb21debf0da` and excluded from the current checkout. The smaller
audit and source catalog remain here. Git history still contains the large files;
this change reduces files shipped in a current checkout, not repository history.
Codex packaging already excludes docs; a Claude Code Git checkout contains the
current source tree.

Commit `a8bf812` stripped trailing whitespace from CSV descriptions and screening
error lines. Those normalized copies were not byte-identical to the exported
evidence; the earlier documentation did not disclose that transformation. The
links now select the pre-normalization archive, not the altered versions.
Git normalizes line endings in these archived text files; they are not promised
to match the Windows export byte for byte. Parsed metadata and report text before
the trailing-space edit are preserved. Local comparison found nine description
values changed by the trim; identifiers and the 26,385-row count were unchanged.

The CSV is an export of selected repository metadata fields, not a raw GitHub
API response. The audit script flattens line breaks in descriptions when writing
that CSV. Census counts and identifiers are unaffected by description whitespace.
The screening report likewise summarizes recorded API comparison results.

The manifest's **Audit recommendation** column preserves Optional, Experiment,
Supplemental lead and other source-audit judgments separately from implementation
status. Planned means considered for future selection, not recommended for every
project or already installed.
