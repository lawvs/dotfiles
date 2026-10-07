---
name: react-practices
description: React design principles and review heuristics. Use this skill when writing, reviewing, refactoring, or debugging React code, especially components, hooks, state flow, data fetching, effect usage, rendering performance, and bundle optimization.
metadata:
  authors: whitewater
  version: "1.0"
---

# React Practices

Apply this skill to React work by starting from render purity and data flow. Favor solutions that keep components predictable, reusable, and easy to reason about before reaching for effects, refs, or memoization.

## Core Principles

- Treat the React app as a functional system. A component should produce the same result for the same inputs on every render, avoiding side effects and non-determinism.
- Prefer deriving values during render instead of synchronizing duplicate state.
- Prefer event-driven state changes. State transitions should usually happen in response to explicit user actions, async completions, or external store updates, not render-following synchronization.
- Avoid using `useEffect` if possible. Keep an effect only when synchronizing React with an external system such as subscriptions, timers, network lifecycle, imperative browser APIs, or non-React widgets.
- Keep user-triggered logic in event handlers rather than effects.
- Only use `useRef` when involving DOM manipulation, imperative integration, or mutable values that must not trigger re-renders.
- Do not ignore or disable the ESLint `exhaustive-deps` rule. If dependencies are awkward, change the structure instead of silencing the lint rule.
- Prefer `useSyncExternalStore` when reading from mutable external state instead of hand-rolled subscription effects.
- Accept repeated renders when rendering is pure and performance is acceptable. Reach for memoization only after identifying a real render or identity problem; do not add `memo`, `useMemo`, or `useCallback` by default.

## Component Design Checklist

- Design reusable, modular components with a clear public API and precise props.
- Keep each React component under 200 lines when practical. If logic grows beyond that boundary, extract file-local custom hooks or child components before expanding the component further.
- Prefer splitting by responsibility, not by file count. If a component is short, tightly coupled to a single page, and not reused, it can stay in the same file as a file-local component instead of being moved to a separate file.
- Prefer composition over prop explosion.
- Keep business logic and view logic decoupled where that improves reuse, testing, or readability.
- Make loading, empty, error, and async states explicit in the component contract.
- Keep components configurable, but avoid optional props that create unclear behavior branches.
- Provide a short usage example when the component API is not obvious.
- Prioritize readability, extensibility, and ease of integration across different projects.

## Refactor And Review Workflow

1. Map the data flow first: props, derived values, local state, external state, and side effects.
2. Remove redundant state and any effect that only recomputes render-time data.
3. Prefer event-driven updates and move event-specific work into event handlers or external actions.
4. If the solution appears to require a new `useEffect`, stop and ask the user before implementing it.
5. Check whether every ref is genuinely imperative or DOM-related.
6. Review the component API for naming, ownership boundaries, configurability, and reuse.
7. If a component is growing too large, split long logic into file-local custom hooks or extracted components. Move code into separate files only when that improves reuse, readability, or ownership boundaries.
8. For performance or bundle work, optimize boundaries and loading strategy before micro-optimizing hooks.

## Stop And Ask

An "unable to handle" situation means the correct React design cannot be determined from the code alone without making a product or architecture decision on the user's behalf. In those cases, stop and ask the user instead of guessing.

You must stop and ask when:

- The state owner is ambiguous and it is unclear whether the source of truth should live in a parent component, local state, URL state, or an external store.
- The change appears to require a new `useEffect`. Do not introduce the effect first. Explain why render logic, derived state, event handlers, refs, or external-store patterns are insufficient, then ask for direction.
- A proposed `useRef` is carrying behavior that should instead be modeled as state, props, or events.
- The requirement mixes product decisions with technical implementation, such as persistence rules, cross-tab synchronization, polling strategy, or reset behavior.
- Interaction requirements, performance targets, and maintainability constraints conflict and there is no clear priority from the user.

When stopping, provide:

- The reason the situation is ambiguous.
- A short data-flow analysis of the current design.
- The specific tradeoffs between the available options.
- A recommended direction if one is clearly safer.

## References

- [You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect)
- [A Complete Guide to useEffect](https://overreacted.io/a-complete-guide-to-useeffect/)
- [useSyncExternalStore](https://react.dev/reference/react/useSyncExternalStore)
