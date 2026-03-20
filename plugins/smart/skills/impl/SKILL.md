---
name: impl
description: >
  Implement a feature unit with TDD and Korean pseudocode comments for easy human review.
  Reads IMPL_PLAN documents, writes tests first, then implements with Korean pseudocode as inline comments.
  Use this skill whenever the user says "구현 시작", "구현해줘", "코드 작성", "implement", "start coding",
  "build this", "개발 시작", "코딩 시작", or wants to begin implementing a planned feature.
  Always use this skill when the user wants to start coding after planning is complete.
version: 1.0.0
---

# Impl — TDD Implementation

Implement features based on IMPL_PLAN documents: write tests first, then implement with Korean pseudocode comments.

## Core Philosophy: Reviewability

Every line of code this skill produces must be **easy for a human to review**.

Pseudocode comments express **intent (WHAT)**, code expresses **mechanism (HOW)**.
The reviewer reads the comment to understand intent, reads the code to verify the mechanism matches.
Mismatches between intent and mechanism are immediately visible — this is the core value of this workflow.

## When to Apply

- IMPL_PLAN documents are ready and user wants to start coding
- User invokes `/impl`

## Process

### Step 1: Identify Implementation Target

1. Read `docs/FEATURE_PLAN.md` to understand overall feature structure
2. List available `docs/IMPL_PLAN_*.md` files
3. If user specified a unit, use that
4. Otherwise, suggest the next unit based on dependency ordering in FEATURE_PLAN.md
5. Read the target IMPL_PLAN document

### Step 2: Verify Prerequisites

- Check if dependent units (listed in IMPL_PLAN's 의존성 section) are already implemented
- If not, warn the user and suggest implementing dependencies first

### Step 3: Write Tests First (TDD Red)

Based on the IMPL_PLAN's 테스트 시나리오 section:
1. Create test file(s) following the project's test conventions
2. Write test cases for each listed scenario
3. Include edge case tests from the 예상 엣지케이스 section
4. Run tests to confirm they all fail (Red phase)

Tell the user: **"테스트를 작성했습니다. 현재 모두 실패 상태입니다 (Red). 구현을 시작합니다."**

### Step 4: Implement with Korean Pseudocode Comments (TDD Green)

For each class/struct/function in the IMPL_PLAN:
1. Place the Korean pseudocode from the plan as a comment block **above** the implementation
2. Write code that fulfills the pseudocode's intent directly below
3. Maintain 1:1 mapping between comment blocks and code sections

Language-specific examples:

**Python:**
```python
# 사용자 입력을 받아서 유효성을 검증한다
# 유효하지 않으면 에러 메시지와 함께 400을 반환한다
def validate_input(data: dict) -> None:
    if not data.get("name"):
        raise ValidationError("name is required", status=400)
```

**Go:**
```go
// 사용자 입력을 받아서 유효성을 검증한다
// 유효하지 않으면 에러 메시지와 함께 400을 반환한다
func validateInput(data *Request) error {
    if data.Name == "" {
        return NewValidationError("name is required", 400)
    }
    return nil
}
```

**TypeScript:**
```typescript
// 사용자 입력을 받아서 유효성을 검증한다
// 유효하지 않으면 에러 메시지와 함께 400을 반환한다
function validateInput(data: Record<string, unknown>): void {
  if (!data.name) {
    throw new ValidationError('name is required', 400);
  }
}
```

Comments are NOT redundant — they express **intent** while code expresses **mechanism**.
The reviewer verifies that the two match.

### Step 5: Verify Tests Pass (TDD Green)

1. Run all tests for this unit
2. If any fail, fix the **implementation** (not the tests, unless the test itself has a bug)
3. Confirm all tests pass

### Step 6: Request Review

Show the user:
- List of created/modified files
- Test result summary (all pass)
- Recommended commit message from the IMPL_PLAN document

Then ask: **"구현이 완료되었습니다. 리뷰해 주세요. 수정 사항이 있으면 말씀해 주세요. 다음 유닛으로 진행할까요?"**

**Do not proceed to the next unit until user confirms.**
If user requests changes, apply them and request review again.

## Quality Rules

- Never implement without an IMPL_PLAN — if missing, direct user to `/plan` first
- Never skip tests — TDD is not optional in this workflow
- Korean pseudocode comments must come from the IMPL_PLAN, not invented during implementation. If the plan's pseudocode is insufficient, suggest updating the plan first.
- One unit at a time — never batch multiple units
- Do not add features or code not in the IMPL_PLAN. If something is missing, flag it to the user and suggest a plan update.
