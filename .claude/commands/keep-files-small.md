---
name: keep-files-small
description: >
  Maintain smaller code files to work effectively with LLM context limitations
---

# Keep Files Small

## Problem

As an AI assistant, you have difficulty processing large code files. They exceed your context window, cause difficulty in applying patches, and slow down your processing and analysis capabilities.

## Example Scenarios

- Files growing beyond 64KB (where patch application becomes slow)
- Files approaching 128KB or larger (which can exceed your 200k token context window)
- Files that contain multiple classes or responsibilities
- Auto-generated files that have grown excessively large
- Files that require multiple context windows to fully understand

## Recommended Actions

1. **Suggest single responsibility principle**: Recommend keeping each file focused on a single class, component, or functionality.

2. **Propose splitting large files**: Offer to break down files exceeding ~50KB into multiple smaller files with clear separation of concerns.

3. **Help with refactoring**: Offer to handle the tedious work of ensuring imports and references are properly managed during file splits.

4. **Alert about file growth**: Proactively mention when files are growing too large and suggest refactoring.

5. **Recommend modular architecture**: Suggest designing codebases with modularity in mind to naturally encourage smaller files.

## Anti-patterns to Avoid

- Creating single files containing multiple unrelated classes or components
- Allowing files to continue growing without suggesting refactoring
- Treating large files as acceptable just because they work functionally
- Adding new functionality to already large files instead of creating new ones

## Remember

You have context limitations. Files exceeding ~64KB will cause performance issues in your processing, and files approaching 128KB may exceed your context window entirely. Always advocate for smaller files, which not only work better with your capabilities but generally lead to more maintainable codebases.
