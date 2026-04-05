---
name: unpack
description: Use when the user asks to explain how something works -- code, a concept, an architecture, a system, an algorithm, or anything technical. Triggers on "explain", "how does X work", "walk me through", "what does this do", "teach me", "break down", or /unpack.
---

# Unpack

## Overview

Explain anything technical using **Layered Elaboration** -- start with intent, build a mental model, then walk through implementation. Based on Reigeluth's Elaboration Theory and Ausubel's Advance Organizers: scaffold understanding before details.

**Core rule:** Never start with the walkthrough. The most common explanation failure is jumping straight into implementation.

## Argument Parsing

Parse `$ARGUMENTS` in this order:

```dot
digraph parse {
  rankdir=TB;
  "Read $ARGUMENTS" [shape=box];
  "Is it a file path?" [shape=diamond];
  "Is it a directory?" [shape=diamond];
  "Contains function/class name?" [shape=diamond];
  "Is it text/concept?" [shape=diamond];
  "Empty?" [shape=diamond];
  "Read file, explain it" [shape=box];
  "Read key files, explain module" [shape=box];
  "Grep/Glob to locate, then explain" [shape=box];
  "Explain concept (no file needed)" [shape=box];
  "Use recent context" [shape=box];

  "Read $ARGUMENTS" -> "Is it a file path?";
  "Is it a file path?" -> "Read file, explain it" [label="yes"];
  "Is it a file path?" -> "Is it a directory?" [label="no"];
  "Is it a directory?" -> "Read key files, explain module" [label="yes"];
  "Is it a directory?" -> "Contains function/class name?" [label="no"];
  "Contains function/class name?" -> "Grep/Glob to locate, then explain" [label="yes"];
  "Contains function/class name?" -> "Is it text/concept?" [label="no"];
  "Is it text/concept?" -> "Explain concept (no file needed)" [label="yes"];
  "Is it text/concept?" -> "Empty?" [label="no"];
  "Empty?" -> "Use recent context" [label="yes"];
}
```

**Examples:**
- `/unpack src/auth/middleware.ts` -- file path
- `/unpack src/auth/` -- directory/module
- `/unpack "the retry logic in handleRequest"` -- concept in codebase
- `/unpack kubernetes ingress` -- general technical concept
- `/unpack` -- explain last code/topic in conversation

## Depth Control

Depth can be set via explicit flags OR inferred from natural language. Scan both `$ARGUMENTS` and the user's full message.

### Explicit Flags (in $ARGUMENTS)

| Flag | Layers |
|------|--------|
| `--brief` or `--tldr` | 1 only |
| `--shallow` | 1 + 2 |
| `--deep` | 1 + 2 + 3 + 4 (Layer 4 expanded) |
| *(none)* | 1 + 2 + 3 (Layer 4 offered) |

### Natural Language Inference

If no explicit flag, infer depth from the user's phrasing:

| User language | Inferred depth | Equivalent |
|---------------|----------------|------------|
| "briefly", "quick", "tldr", "tl;dr", "in a nutshell", "one-liner", "short version", "sum it up" | Layer 1 only | `--tldr` |
| "high level", "overview", "big picture", "gist", "broad strokes", "at a glance" | Layers 1 + 2 | `--shallow` |
| "in detail", "deep dive", "thoroughly", "everything", "all the nuances", "leave nothing out" | All 4 layers, Layer 4 expanded | `--deep` |
| "explain", "how does X work", "walk me through", "what does this do", "teach me", "break down" | Layers 1 + 2 + 3, Layer 4 offered | *(default)* |

When language conflicts with a flag, the explicit flag wins.

## Diagrams First

**Default to ASCII diagrams whenever they explain a concept, relationship, or flow better than prose.** This applies at every layer -- even TLDR. A 3-box diagram showing how components connect often says more than two sentences of prose.

Use diagrams for: data flow, component relationships, request lifecycles, state machines, layered architectures, pipelines, decision trees.

Skip diagrams for: single-purpose utilities, trivial configs, concepts that are purely sequential with no branching.

### Diagram detail scales with depth

| Layer | Diagram style |
|-------|---------------|
| 1 (TLDR) | High-level boxes and arrows -- major components and how they connect. Labels only, no internals. |
| 2 (Mental Model) | More detailed -- show subcomponents, data flow direction, key interfaces between parts. |
| 3 (Walkthrough) | Annotated diagrams alongside prose -- show the path through the system step by step, call out important decision points. |
| 4 (Edge Cases) | Diagrams showing failure paths, fallback flows, or alternate routes through the system. |

## The Four Layers

### Layer 1 -- Overview (TLDR)

What does this thing do, why does it exist, and how do its major parts connect?

**Prefer an ASCII diagram** showing the high-level components and their relationships over prose. A box-and-arrow diagram of 3-6 components with labeled connections is the ideal TLDR for anything with moving parts. Add 1-2 sentences of context only if the diagram doesn't stand alone.

**For code/files:** State where it fits in the broader system before anything else.

### Layer 2 -- Mental Model (detailed diagram)

Zoom into the diagram from Layer 1. Show subcomponents, data flow, key interfaces, and the important boundaries. Name the parts and show how data/control moves between them.

Use analogies or metaphors alongside the diagram when they genuinely clarify -- but the diagram is primary, not the metaphor.

### Layer 3 -- Walkthrough (the main explanation)

Step through the actual implementation or mechanism:
- **Trace a path through the Layer 2 diagram** -- walk through it step by step
- **Highlight** what's important vs what's incidental
- **For code:** show relevant code inline within the walkthrough, not as a separate block before the explanation
- Use concrete examples over abstract descriptions
- Add annotated diagrams for complex sub-flows (state transitions, retry logic, etc.)

### Layer 4 -- Edge Cases & Nuance (optional, offer to expand)

Failure modes, tradeoffs, gotchas, common misconceptions, performance characteristics. Don't dump this unless `--deep` is set or there's a critical gotcha the user must know. Use diagrams for failure/fallback paths when they involve branching logic.

## Complexity Assessment

Before starting, assess complexity:

- **Simple** (a utility function, a config file, a basic concept): Layers 1 + 3 may suffice. Don't force a mental model diagram onto something that doesn't need one.
- **Moderate** (a module, an algorithm, a protocol): All layers in order.
- **Complex** (a system, an architecture, cross-cutting concerns): All 4 layers, Layer 2 is critical. Consider multiple diagrams.

## Closing

Always end with: **"Want me to go deeper on any part of this?"**
