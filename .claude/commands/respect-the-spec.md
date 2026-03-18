---
name: respect-the-spec
description: >
  Understand and respect existing constraints and specifications when making changes
---

# Respect the Spec

## Problem

As an AI assistant, you often attempt to change parts of a system that should remain constant or conform to existing specifications. You may prioritize making a task easier over maintaining backward compatibility or respecting external constraints.

## Example Scenarios

- You make backward-incompatible changes to module interfaces and public APIs
- You modify code to call non-existent methods on external systems
- You delete or fundamentally change tests to make them pass
- You rename public data fields or properties for convenience
- You change behavior that clients may depend on
- You ignore documented constraints or requirements

## Recommended Actions

1. **Identify immutable boundaries**: Before making changes, explicitly identify which parts of the system must not change (public APIs, module interfaces, external integrations, etc.).

2. **Ask about constraints**: Request information about constraints and specifications you need to respect when approaching a task.

3. **Verify your solutions**: Double-check that your proposed code respects all boundaries and specifications before presenting it to the user.

4. **Suggest alternatives within constraints**: If current constraints make a solution difficult, propose alternatives that respect the constraints rather than changing them.

5. **Highlight necessary specification changes**: If changing a specification is actually necessary, explicitly mark it as a breaking change that requires careful consideration.

## Anti-patterns to Avoid

- Deleting tests rather than fixing the underlying code
- Making API changes that break backward compatibility
- Ignoring integration requirements with external systems
- Implementing code that depends on non-existent or differently-named functions/methods
- Silently modifying behavior that might be relied upon by clients

## Remember

While occasionally the right solution involves changing a specification, most day-to-day coding should respect existing constraints. Always review your generated code to ensure it doesn't breach these boundaries before presenting it to the user.

