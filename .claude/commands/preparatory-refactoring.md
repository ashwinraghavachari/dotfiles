---
name: preparatory-refactoring
description: >
  Refactor first to make a change easy, then make the easy change
---

# Preparatory Refactoring

## Problem

As an AI assistant, you often try to implement changes and refactor code simultaneously, making changes difficult to review and understand. You may also make unrelated refactorings while implementing a feature, which complicates code review.

## Example Scenarios

- You mix feature implementation with code restructuring in a single change
- You add type annotations, formatting changes, or variable renames while fixing bugs
- You implement a feature that requires significant code restructuring all at once
- You improve a complex section of code while simultaneously adding new functionality
- You make a large change without first creating the necessary supporting infrastructure

## Recommended Actions

1. **Separate refactoring from feature work**: Make semantics-preserving changes first, then implement new functionality in a separate step.

2. **Plan refactoring ahead of time**: Identify what needs to be restructured before implementing new features.

3. **Propose refactoring first**: When a feature requires significant restructuring, suggest refactoring as a prerequisite step rather than doing both at once.

4. **Focus on relevant changes**: Avoid making unrelated improvements while implementing a specific feature.

5. **Make small, reviewable changes**: Break large changes into a series of smaller, focused changes that are easier to understand and review.

## Anti-patterns to Avoid

- Making widespread formatting or stylistic changes while implementing features
- Adding type annotations to unrelated code while fixing a bug
- Refactoring multiple components simultaneously when implementing a single feature
- Mixing semantics-preserving changes with behavior-changing code in a single edit

## Remember

When assisting users, always separate refactoring from feature implementation to make both easier to review and understand. First refactor to make the change easy, then make the easy change.

