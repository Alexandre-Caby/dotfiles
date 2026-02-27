# Skill: Testing Philosophy

When to test what, how much, and with which tools.
The goal is confidence, not coverage metrics.

## Principe fondamental

> "Tests should give you confidence to ship, not slow you down."

En solo : tester la logique métier rigoureusement, tester les intégrations critiques,
ne pas obsessionnellement tester les wrappers CRUD évidents.

## Pyramide de tests

```
         /\
        /E2E\          → 5-10% des tests — lents, fragiles, haute valeur
       /------\
      / Intég. \       → 20-30% — tester les frontières (API, DB, externe)
     /----------\
    /    Unit    \     → 60-70% — logique métier, algorithmes, utils purs
   /--------------\
```

## Par langage

### TypeScript / Node.js

| Type | Framework | Runner |
|---|---|---|
| Unit | Vitest | `pnpm test` |
| Integration | Vitest + supertest | `pnpm test:integration` |
| E2E | Playwright | `pnpm test:e2e` |
| Component (React) | Vitest + React Testing Library | `pnpm test` |

```typescript
// Convention de nommage
describe('UserService', () => {
  describe('createUser', () => {
    it('creates a user with hashed password', async () => { ... })
    it('throws EmailAlreadyExistsError if email is taken', async () => { ... })
    it('assigns default role "user" when role is not specified', async () => { ... })
  })
})

// Pas de:
it('test user creation', ...)  // trop vague
it('should work', ...)         // inutile
```

**Pattern AAA (Arrange, Act, Assert) :**
```typescript
it('returns 401 when token is expired', async () => {
  // Arrange
  const expiredToken = generateToken({ expiresIn: '-1s' })

  // Act
  const response = await request(app)
    .get('/api/me')
    .set('Authorization', `Bearer ${expiredToken}`)

  // Assert
  expect(response.status).toBe(401)
  expect(response.body.error.code).toBe('SESSION_EXPIRED')
})
```

### Python

| Type | Framework |
|---|---|
| Unit | pytest |
| Integration | pytest + httpx/requests |
| ML | pytest + fixtures de datasets |

```python
# Naming: test_[unit]_[condition]_[expected_result]
def test_train_model_with_empty_dataset_raises_value_error():
    with pytest.raises(ValueError, match="Dataset cannot be empty"):
        train_model(dataset=[], epochs=10)

def test_parse_sensor_data_returns_float_array():
    raw = b'\x00\x01\x02\x03'
    result = parse_sensor_data(raw)
    assert isinstance(result, np.ndarray)
    assert result.dtype == np.float32
```

**Fixtures pour ML :**
```python
@pytest.fixture
def sample_dataset():
    """Minimal dataset for unit tests — not representative, just structurally valid."""
    return Dataset(features=np.random.rand(10, 4), labels=np.array([0, 1] * 5))
```

### Rust

```rust
// Tests unitaires dans le même fichier
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_config_returns_error_on_missing_file() {
        let result = parse_config(Path::new("/nonexistent/path.toml"));
        assert!(matches!(result, Err(ConfigError::NotFound)));
    }
}

// Benchmarks avec criterion
use criterion::{criterion_group, criterion_main, Criterion};

fn benchmark_solver(c: &mut Criterion) {
    c.bench_function("solve_small_instance", |b| {
        b.iter(|| solve(black_box(&SMALL_INSTANCE)))
    });
}
```

### Go

```go
// Table-driven tests (standard Go pattern)
func TestParseConfig(t *testing.T) {
    tests := []struct {
        name    string
        input   string
        want    Config
        wantErr bool
    }{
        {"valid config", `{"port": 8080}`, Config{Port: 8080}, false},
        {"missing port", `{}`, Config{}, true},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := ParseConfig([]byte(tt.input))
            if (err != nil) != tt.wantErr {
                t.Errorf("ParseConfig() error = %v, wantErr %v", err, tt.wantErr)
            }
            if !tt.wantErr && got != tt.want {
                t.Errorf("ParseConfig() = %v, want %v", got, tt.want)
            }
        })
    }
}
```

## Seuils de coverage

| Type de code | Coverage cible | Pourquoi |
|---|---|---|
| Logique métier (services, algorithmes) | **≥ 80%** | Haute valeur, testable |
| Routes CRUD simples | **≥ 50%** | Test d'intégration suffit |
| UI components | **≥ 40%** | Playwright pour le reste |
| Glue code / config | **non mesuré** | Trop fragile |
| ML inference | **≥ 70% unit** | Tester les cas limites |

> Le coverage à 100% est un anti-pattern pour les projets solo — optimiser pour la confiance, pas le chiffre.

## Mocking strategy

```typescript
// Mock les dépendances externes, PAS la logique métier
vi.mock('../lib/db')          // ✅ DB externe
vi.mock('../lib/email')       // ✅ Service email externe
vi.mock('../services/user')   // ❌ Ne pas mocker la logique qu'on teste
```

**Quand NE PAS mocker :**
- La DB en tests d'intégration — utiliser une DB de test réelle (SQLite en mémoire)
- Les fonctions pures — elles n'ont pas de side effects à isoler

## Tests de régression

Règle : **tout bug fixé = un test de régression.**

Format du test :
```typescript
// Regression test: GitHub #42 — user with apostrophe in name caused SQL error
it("creates user with apostrophe in name without throwing", async () => {
  await expect(createUser({ name: "O'Brien" })).resolves.toBeDefined()
})
```

## Ce qu'on ne fait pas

- Tests qui testent uniquement des getters/setters sans logique
- Tests qui reproduisent l'implémentation ligne par ligne
- Mocks imbriqués sur 3+ niveaux
- `expect(true).toBe(true)` pour "couvrir" une ligne
- E2E tests comme couverture principale (trop lents, trop fragiles)
- Ignorer les tests flakey — les fixer ou les supprimer
