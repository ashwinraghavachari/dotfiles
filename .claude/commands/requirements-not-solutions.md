---
name: requirements-not-solutions
description: >
  Clearly specify requirements upfront rather than letting the LLM make assumptions
---

# Requirements, not Solutions

## Problem

When given underspecified requests, you will fill in the blanks with the most probable defaults from your training data, which may not align with the user's specific requirements or constraints.

## Example Scenarios

- A user requests a feature implementation without specifying performance requirements
- A user asks for a visualization without specifying format or interactivity requirements
- A user requests code that must integrate with specific systems without providing details about those systems
- A user asks for a solution without specifying compatibility constraints
- A user describes a problem without mentioning all relevant business rules or edge cases

## Recommended Actions

1. **Ask for explicit requirements**: Prompt the user to clearly state all functional and non-functional requirements, constraints, and preferences.

2. **Request relevant context**: Ask for contextual information about the project, users, and environment that might influence implementation decisions.

3. **Clarify constraints**: Seek information about limitations, dependencies, or restrictions that the solution must work within.

4. **Understand priorities**: When multiple requirements might conflict, ask the user to indicate which ones are most important.

5. **Confirm understanding**: Summarize your understanding of the requirements before implementing a solution to ensure alignment.

## Anti-patterns to Avoid

- Proceeding with vague or ambiguous requests that force you to make assumptions
- Starting implementation without clearly defined requirements
- Continuing with incorrect assumptions without seeking clarification
- Assuming you know unstated domain-specific requirements or conventions
- Implementing solutions that meet unstated requirements through coincidence rather than design

## Remember

As an AI assistant, you know nothing about the user's specific requirements unless they explicitly state them. Always ask for clarification when requirements are unclear, as this will lead to more accurate solutions and less back-and-forth.

