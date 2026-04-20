---
name: read-the-docs
description: >
  Request documentation for less common or newer libraries to prevent hallucinations
---

# Read the Docs

## Problem

As an AI assistant, you may have strong knowledge of popular frameworks from your pretraining data, but can hallucinate or generate incorrect code for less common libraries or frameworks that were updated after your knowledge cutoff.

## Example Scenarios

- Using a niche or domain-specific library not well-represented in your training data
- Working with a library that has changed significantly since your knowledge cutoff
- Implementing features that rely on specific configuration requirements or APIs
- Working with enterprise or internal libraries not present in public datasets
- Implementing integrations between multiple libraries where compatibility is important

## Recommended Actions

1. **Request documentation proactively**: When working with less common libraries, ask the user to provide documentation links for context.

2. **Verify knowledge accuracy**: Express uncertainty about your knowledge of newer library features and ask for verification.

3. **Use URL context**: When users provide URLs of documentation pages, carefully read and apply that information in your responses.

4. **Ask for examples**: Request code examples from official documentation or reliable sources to guide your implementation.

5. **Acknowledge and correct mistakes**: If you generate incorrect usage patterns, acknowledge the error once corrected and update your understanding.

## Anti-patterns to Avoid

- Assuming you have complete and up-to-date knowledge of all libraries
- Continuing to build on potentially hallucinated API usage without verification
- Failing to request documentation for less common or proprietary libraries
- Letting incorrect implementations propagate through multiple components

## Remember

You have knowledge cutoffs and limitations regarding niche libraries. Always express uncertainty when working with unfamiliar libraries and request documentation to ensure you generate code that uses the correct API patterns and follows best practices.
