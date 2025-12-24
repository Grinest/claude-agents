# Estrategia de Testing para Claude Agents

## Filosofía de Testing

Para archivos de agentes (prompts en Markdown), **NO necesitas testing exhaustivo como en código tradicional**. Sin embargo, es valioso tener **validación estructural** para mantener calidad y consistencia.

## Niveles de Testing

### 1. Testing Estructural (Implementado ✅)

**Qué se valida:**
- ✅ Formato YAML frontmatter correcto
- ✅ Campos requeridos presentes (`name`, `description`, `model`, `color`)
- ✅ Valores válidos en campos enumerados
- ✅ Convenciones de nombres (kebab-case)
- ✅ Encoding UTF-8
- ✅ Line endings (Unix LF)
- ✅ Longitud apropiada de contenido
- ✅ Estructura markdown básica

**Por qué es importante:**
- Previene errores de formato que rompen la carga de agentes
- Mantiene consistencia entre agentes
- Detecta problemas antes del commit

**Cómo ejecutar:**
```bash
./scripts/validate-agents.sh
```

### 2. Testing de Calidad (Opcional)

**Qué se podría validar:**
- Claridad del lenguaje
- Gramática y ortografía
- Estructura lógica del prompt
- Completitud de instrucciones

**Por qué es opcional:**
- Requiere análisis de lenguaje natural (complejo)
- Subjetivo y difícil de automatizar
- Mejor manejado con code review manual

**Herramientas posibles:**
```bash
# Spell checking (ejemplo)
aspell check agents/architect.md

# Markdown linting
markdownlint agents/*.md

# Grammar checking (requiere herramientas externas)
```

### 3. Testing Funcional (NO Recomendado)

**Qué sería:**
- Probar que el agente realmente funciona como se espera
- Verificar calidad de respuestas
- Validar comportamiento del agente

**Por qué NO se recomienda:**
- Extremadamente complejo y costoso (requiere llamadas a API)
- Difícil de automatizar de forma confiable
- Mejor validado manualmente durante desarrollo

## Estrategia Recomendada

### Para este proyecto:

```
┌─────────────────────────────────────────────┐
│  1. Validación Estructural (Automatizada)  │
│     • Pre-commit hook                       │
│     • CI/CD en GitHub Actions               │
│     • ./scripts/validate-agents.sh          │
├─────────────────────────────────────────────┤
│  2. Code Review Manual                      │
│     • Revisar claridad del prompt           │
│     • Validar instrucciones completas       │
│     • Verificar ejemplos útiles             │
├─────────────────────────────────────────────┤
│  3. Testing Manual Ad-Hoc                   │
│     • Probar agente en proyectos reales     │
│     • Iterar basado en feedback             │
│     • Documentar casos de uso               │
└─────────────────────────────────────────────┘
```

## Uso del Script de Validación

### Ejecución Manual

```bash
# Validar todos los agentes
./scripts/validate-agents.sh

# Ver ayuda (si se implementa)
./scripts/validate-agents.sh --help
```

### Output Esperado

```
╔═══════════════════════════════════════════════╗
║        Agent Validation Test Suite           ║
╚═══════════════════════════════════════════════╝

✓ Agents directory exists
✓ Found 3 agent file(s)

Testing agent: architect
────────────────────────────────────────────────
✓ File is not empty
✓ Has YAML frontmatter delimiter
✓ YAML frontmatter closes correctly
✓ Has 'name' field: architect
✓ Name follows kebab-case convention
...

╔═══════════════════════════════════════════════╗
║              Validation Summary               ║
╠═══════════════════════════════════════════════╣
║  Passed:  44
║  Failed:  0
║  Warnings: 0
║  Total:   44
╚═══════════════════════════════════════════════╝

✓ All validation tests passed!
```

## Integración con Git

### Pre-commit Hook (Recomendado)

Crea `.git/hooks/pre-commit`:

```bash
#!/bin/bash

echo "Running agent validation..."
./scripts/validate-agents.sh

if [ $? -ne 0 ]; then
    echo "❌ Agent validation failed. Fix the issues before committing."
    exit 1
fi

echo "✅ Agent validation passed"
```

```bash
# Hacer ejecutable
chmod +x .git/hooks/pre-commit
```

### GitHub Actions (CI/CD)

Ver `.github/workflows/validate-agents.yml` para configuración completa.

## Tests Específicos

### Test 1: Estructura YAML
```bash
# Verifica que el frontmatter sea válido
✓ Has YAML frontmatter delimiter
✓ YAML frontmatter closes correctly
```

### Test 2: Campos Requeridos
```bash
# Verifica campos obligatorios
✓ Has 'name' field
✓ Has 'description' field
✓ Has 'model' field
✓ Has 'color' field
```

### Test 3: Validez de Valores
```bash
# Verifica valores válidos
✓ Name follows kebab-case convention
✓ Description length is appropriate
✓ Has valid 'model' field: inherit
✓ Has valid 'color' field: blue
```

### Test 4: Calidad del Contenido
```bash
# Verifica contenido suficiente
✓ Has substantial content: 1230 lines
✓ Has H1 heading(s): 3
```

### Test 5: Formato de Archivo
```bash
# Verifica formato técnico
✓ Has Unix line endings (LF)
✓ File encoding is UTF-8
✓ No excessively long lines
```

## Casos de Fallo Comunes

### 1. Frontmatter Malformado

**Error:**
```
✗ YAML frontmatter not closed properly
```

**Solución:**
```markdown
---
name: agent-name
description: Description here
model: inherit
color: blue
---

# Content starts here
```

### 2. Campo Faltante

**Error:**
```
✗ Missing 'description' field in frontmatter
```

**Solución:**
Agregar el campo faltante en el frontmatter.

### 3. Valor Inválido

**Error:**
```
✗ Invalid 'model' value: gpt-4 (should be: inherit, sonnet, opus, or haiku)
```

**Solución:**
Usar valores permitidos: `inherit`, `sonnet`, `opus`, `haiku`.

### 4. Nombre Incorrecto

**Error:**
```
⚠ Name should be in kebab-case (lowercase with hyphens)
```

**Solución:**
```
# ❌ Incorrecto
name: MyAgent
name: my_agent

# ✅ Correcto
name: my-agent
name: backend-py
```

## Métricas de Calidad

### Cobertura de Validación

- **100%** de agentes validados estructuralmente
- **12 validaciones** por agente
- **0 falsos positivos** aceptables

### Criterios de Éxito

```bash
# Un agente pasa validación si:
- Tiene estructura YAML correcta
- Contiene todos los campos requeridos
- Usa valores válidos
- Sigue convenciones de nombres
- Tiene contenido sustancial (>10 líneas)
- Usa encoding UTF-8 y line endings Unix
```

## Mantenimiento del Script

### Agregar Nueva Validación

1. Edita `scripts/validate-agents.sh`
2. Agrega nuevo test siguiendo el patrón:

```bash
# Test N: Descripción del test
resultado=$(comando_de_validacion)
if [ condición_exitosa ]; then
    print_pass "Mensaje de éxito"
else
    print_fail "Mensaje de error"
fi
```

3. Prueba con `./scripts/validate-agents.sh`
4. Actualiza esta documentación

### Campos Validados

| Campo | Requerido | Valores Válidos |
|-------|-----------|-----------------|
| `name` | ✅ | kebab-case string |
| `description` | ✅ | 20-200 caracteres |
| `model` | ✅ | inherit, sonnet, opus, haiku |
| `color` | ✅ | blue, green, yellow, red, purple, cyan |

## Comparación: Testing de Agentes vs Código

| Aspecto | Código Tradicional | Agentes (Prompts) |
|---------|-------------------|-------------------|
| **Tests Unitarios** | ✅ Crítico | ❌ No aplicable |
| **Tests Integración** | ✅ Importante | ❌ Muy complejo |
| **Validación Estructura** | ⚠️ Básico | ✅ Suficiente |
| **Code Review** | ✅ Importante | ✅ Crítico |
| **Testing Manual** | ⚠️ Complemento | ✅ Principal |

## Recomendaciones Finales

### ✅ SÍ hacer:
- Validación estructural automatizada
- Pre-commit hooks
- CI/CD en GitHub Actions
- Code review de cambios
- Testing manual de agentes

### ❌ NO hacer:
- Tests unitarios tradicionales
- Testing funcional automatizado complejo
- Gastar tiempo en tests de IA costosos
- Over-engineering de validaciones

### 💡 Equilibrio Ideal:

```
10% - Automatización (validación estructural)
30% - Code Review (calidad del prompt)
60% - Testing Manual (uso real del agente)
```

## Conclusión

Para archivos de agentes:
1. **Validación estructural automatizada** es suficiente y necesaria
2. **Code review manual** es crítico para calidad
3. **Testing funcional** es mejor hacerlo manualmente

Esta estrategia balancea calidad, eficiencia y pragmatismo.