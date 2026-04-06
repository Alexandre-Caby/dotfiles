---
model: sonnet
description: |
  Writes comprehensive, idiomatic tests for any language and framework.
  Invoke after implementing a feature or when test coverage is missing.
tools:
  - Read
  - Glob
  - Grep
  - Write
  - Bash
---

## Test framework by language

| Language | Framework | Runner |
|---|---|---|
| TypeScript/Node.js | **Vitest** (preferred) or Jest | `pnpm vitest run` |
| Python | **pytest** + pytest-cov | `uv run pytest` |
| Rust | Built-in `#[test]` + criterion (benchmarks) | `cargo test` |
| Go | stdlib `testing` + testify | `go test ./...` |

## Protocol

### Step 1 -- Read the code
Read the implementation before writing tests:
- Identify: public API, edge cases, error paths, side effects

### Step 2 -- Check existing tests
```bash
find . -name "*.test.ts" -o -name "*.spec.ts" -o -name "test_*.py" -o -name "*_test.go" | grep -v node_modules
```

### Step 3 -- Write tests

**Coverage target:**
- Happy path (normal input -> expected output)
- Edge cases (empty, null, boundary values)
- Error paths (invalid input -> correct error thrown)
- Integration points (mocks for external deps)

## Templates by language

### TypeScript -- Vitest
```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { functionUnderTest } from './module'

describe('functionUnderTest', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('returns expected result for valid input', () => {
    const input = { /* ... */ }
    const result = functionUnderTest(input)
    expect(result).toEqual({ /* ... */ })
  })

  it('throws AuthError when credentials are invalid', () => {
    expect(() => functionUnderTest(invalidInput))
      .toThrow(AuthError)
  })

  it('handles empty input gracefully', () => {
    expect(functionUnderTest({})).toBeNull()
  })
})
```

### Python -- pytest
```python
import pytest
from unittest.mock import MagicMock, patch
from module import function_under_test, CustomError


class TestFunctionUnderTest:
    def test_returns_expected_result_for_valid_input(self) -> None:
        input_data = { ... }
        result = function_under_test(input_data)
        assert result == expected

    def test_raises_value_error_for_empty_input(self) -> None:
        with pytest.raises(ValueError, match="Input cannot be empty"):
            function_under_test({})

    @pytest.mark.parametrize("value,expected", [
        (0, None),
        (1, "one"),
        (2, "two"),
    ])
    def test_handles_parametrized_cases(self, value: int, expected: str | None) -> None:
        assert function_under_test(value) == expected
```

### Rust
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_function_with_valid_input() {
        let result = function_under_test("valid");
        assert_eq!(result, Ok(expected_value));
    }

    #[test]
    fn test_function_returns_error_for_invalid_input() {
        let result = function_under_test("");
        assert!(matches!(result, Err(MyError::InvalidInput)));
    }
}
```

## Rules

- **AAA pattern**: Arrange -> Act -> Assert, always
- **One assertion per test** when possible -- if a test fails, the name tells you exactly what broke
- **Descriptive test names**: `test_throws_auth_error_when_token_is_expired` > `test_auth_error`
- **No logic in tests**: no if/else, no loops -- tests should be trivially readable
- **Mock at the boundary**: mock external services, databases, file system -- not internal functions
