# Skill: API Conventions

Standards for API design across all Alexandre's projects.
Read this before designing any new API surface.

## Style par projet

| Projet | Style | Lib validation |
|---|---|---|
| EDA | tRPC | Zod |
| Syplay | REST (Express) | Zod |
| NXIO MCP servers | MCP Protocol | Zod |
| NXIO Agent API | REST (FastAPI) | Pydantic |

## REST — Conventions communes

### Nommage des routes

```
# Pluriel pour les collections
GET  /users          ✅
GET  /user           ❌

# Kebab-case pour les mots composés
GET  /refresh-tokens  ✅
GET  /refreshTokens   ❌

# Verbes dans l'URL seulement pour les actions non-CRUD
POST /sessions/invalidate   ✅
POST /users/:id/ban         ✅
```

### Codes HTTP

| Situation | Code |
|---|---|
| Lecture réussie | `200 OK` |
| Création réussie | `201 Created` |
| Action sans body de retour | `204 No Content` |
| Validation échouée | `400 Bad Request` |
| Non authentifié | `401 Unauthorized` |
| Authentifié mais interdit | `403 Forbidden` |
| Ressource inexistante | `404 Not Found` |
| Conflit état / doublon | `409 Conflict` |
| Erreur serveur | `500 Internal Server Error` |

### Enveloppe de réponse

```typescript
// Success (liste)
{
  data: T[],
  meta: { total: number, page: number, limit: number }
}

// Success (objet unique)
{
  data: T
}

// Erreur
{
  error: {
    code: string,       // machine-readable: "INVALID_CREDENTIALS"
    message: string,    // human-readable en français si app FR
    details?: unknown   // validation errors, etc.
  }
}
```

### Pagination

Toujours paginer les listes qui peuvent dépasser 20 items :

```typescript
// Query params standard
GET /posts?page=1&limit=20&sort=createdAt&order=desc

// Response meta
{ data: [...], meta: { total: 143, page: 1, limit: 20, pages: 8 } }
```

### Auth header

```
Authorization: Bearer <jwt_token>
```

Jamais de token dans l'URL.

## tRPC — Conventions EDA

```typescript
// Naming: camelCase, verb + noun (action + resource)
// Queries: get, list, search, count
// Mutations: create, update, delete, run, trigger

appRouter
  .query('listSolvers', { ... })       ✅
  .query('getSolverById', { ... })     ✅
  .mutation('createSolver', { ... })   ✅
  .mutation('runSolver', { ... })      ✅

// Pas de "fetch", "retrieve", "remove" — rester cohérent
```

## MCP Protocol — Conventions NXIO

Pour les MCP servers (unreal-mcp, blender-mcp, everness) :

```typescript
// Tool names: snake_case, verb_noun
{
  name: "get_actor_list",        ✅
  name: "spawn_blueprint",       ✅
  name: "getActorList",          ❌ (pas camelCase)
  name: "actors",                ❌ (pas de verbe)
}

// Tool descriptions: toujours en anglais, précis
// Parameters: snake_case, avec description et type JSON Schema
```

## Validation — Règles absolues

1. **Valider à l'entrée, jamais seulement à la sortie**
2. **Zod/Pydantic au niveau de la route — pas dans le service**
3. **Types inférés depuis le schema — pas de duplication**
4. **Ne jamais `as any` pour passer une validation**

```typescript
// Pattern correct pour Express + Zod
const handler = async (req: Request, res: Response) => {
  const input = CreateUserSchema.parse(req.body)  // throws ZodError if invalid
  // input is now fully typed
  const user = await userService.create(input)
  res.status(201).json({ data: user })
}
```

## Erreurs — Codes métier

Définir des error codes constants, pas de strings ad-hoc :

```typescript
// errors.ts
export const ErrorCodes = {
  INVALID_CREDENTIALS: 'INVALID_CREDENTIALS',
  EMAIL_ALREADY_EXISTS: 'EMAIL_ALREADY_EXISTS',
  SESSION_EXPIRED: 'SESSION_EXPIRED',
  SOLVER_TIMEOUT: 'SOLVER_TIMEOUT',
} as const
```

## Versioning

- Pas de version dans les URLs tant que l'API est en développement actif
- `/v2/` seulement quand on maintient deux versions en parallèle
- tRPC : les breaking changes se gèrent par nouvelles procédures + déprécation

## Ce qu'on ne fait pas

- Verbes dans les routes REST CRUD (`/getUser`, `/deletePost`)
- Tokens JWT dans les query params URL
- `200 OK` pour les erreurs métier
- Exposer les stacktraces en production
- Retourner les IDs de base de données auto-incrémentés (préférer UUIDs)
- Réponses sans enveloppe pour les listes
