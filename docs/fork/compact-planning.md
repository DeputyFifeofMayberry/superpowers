# F03: enable compact planning

This branch adds an opt-in format to `superpowers:writing-plans`. In the project
where you use the plugin, create `.superpowers/fork-features.json`:

```json
{
  "vertical-slice-plans": true
}
```

The agent reads this profile when writing a plan. This is instruction-based
selection, not a hook or a programmatic runtime guarantee. You can instead ask
for a compact vertical-slice plan directly. Omit the file or set the value to
`false` for the original format. A string `"true"` does not enable it. Unknown
keys have no effect. The profile is not installed into any of your projects
automatically.

Compact tasks deliver capabilities across the necessary layers. They retain
Task N headings, exact paths, interfaces, test assertions, red/green commands,
regression checks, and commits. Design and implementation-plan review still
follow deep-brainstorming. Only the repeated microstep formatting changes.

Baseline evaluation found that the existing skill already makes capability-sized
tasks, but does not interpret this setting: without an explicit compact-format
request it retains five separate TDD microsteps. This small addition targets
that missing preference rather than importing the Rails skill wholesale.
