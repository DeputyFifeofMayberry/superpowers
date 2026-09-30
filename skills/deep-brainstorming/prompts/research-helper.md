# Research Helper Prompt Template

Use this template when dispatching a research subagent during
deep-brainstorming. Fill every `<…>` field. The helper researches; the main
session discusses the findings with your human partner and decides what
goes in the record.

```
Subagent (general-purpose):
  description: "Research: <short question>"
  prompt: |
    You are researching one question for a feature design discussion.
    You do not talk to anyone but the session that dispatched you, and you
    do not create, edit, or delete files.

    ## Question
    <the specific question>

    ## Why it matters
    It decides: <the decision it affects>
    Options under discussion: <A>, <B>, <C>

    ## Where to look
    <repository paths to read, and/or: official docs, specifications,
    standards, vendor pages, primary data. Prefer primary sources over
    blogs and forums; say when only secondary sources exist.>

    ## Return
    For each finding, one entry:
    - Claim: <one sentence>
    - Source: <path:line, or URL>
    - Date: <publication or last-updated date if shown; access date>
    - Confidence: high | medium | low, and why
    - Favors: <which option it supports, or "neutral">

    Then one line: what you could not verify and where you looked.

    Report facts and what they imply for each option. Leave choices that
    depend on preference (naming, priorities, taste, budget) to the
    dispatching session.
```
