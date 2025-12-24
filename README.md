# Claude Agents Repository

Repositorio centralizado de agentes personalizados para Claude Code. Facilita la instalación y sincronización de agentes especializados en diferentes proyectos de desarrollo.

## Descripción

Este repositorio proporciona una colección de agentes de Claude especializados y un script de sincronización que permite instalarlos fácilmente en cualquier proyecto local. Los agentes están diseñados para tareas específicas de desarrollo, desde arquitectura de software hasta testing y QA.

## Agentes Disponibles

### 1. Architect Agent (`architect.md`)
**Especialista en Arquitectura de Software**

Agente enfocado en análisis, evaluación y recomendación de soluciones arquitectónicas sin escribir código de implementación.

**Capacidades:**
- Análisis profundo de arquitectura de proyectos
- Evaluación de patrones de diseño (Clean Architecture, Hexagonal, etc.)
- Recomendaciones de arquitectura con pros/cons
- Planificación detallada de desarrollo por fases
- Generación de diagramas (Mermaid)
- Estimaciones de tiempo y recursos
- Documentación técnica completa (ADRs)

**Cuándo usar:**
- Diseño de nuevas funcionalidades
- Refactorización de sistemas existentes
- Evaluación de opciones técnicas
- Planificación de proyectos
- Documentación de arquitectura

### 2. Backend Python Agent (`backend-py.md`)
**Desarrollo Backend Python con Clean Architecture**

Agente especializado en desarrollo backend Python usando Clean Architecture y Hexagonal Architecture (Ports & Adapters).

**Stack Tecnológico:**
- FastAPI 0.68.2+
- SQLAlchemy 2.0+ (PostgreSQL)
- MongoEngine (MongoDB)
- Alembic 1.14.0+
- Python 3.11+

**Capacidades:**
- Implementación de Clean Architecture/Hexagonal Architecture
- Desarrollo de APIs REST con FastAPI
- Gestión de bases de datos (PostgreSQL, MongoDB)
- Migraciones con Alembic
- Aplicación de principios SOLID
- Patrones de diseño (Repository, Interactor, DTO)
- Seguridad y autenticación (JWT, OAuth 2.0)
- Optimización de queries y performance

**Cuándo usar:**
- Desarrollo de APIs REST
- Implementación de casos de uso (Interactors)
- Creación de repositorios y adaptadores
- Migraciones de base de datos
- Refactorización hacia arquitectura limpia

### 3. QA Backend Python Agent (`qa-backend-py.md`)
**Testing y QA para Backend Python**

Agente especializado en testing, QA y chaos engineering para sistemas backend Python.

**Capacidades:**
- Testing unitario con Pytest
- Testing de integración
- Testing end-to-end
- Chaos engineering
- Cobertura de código (>90% objetivo)
- Testing de performance
- Testing de seguridad
- Generación de fixtures y mocks
- Análisis de código estático

**Cuándo usar:**
- Escribir tests unitarios e integración
- Aumentar cobertura de código
- Implementar chaos engineering
- Validar seguridad del código
- Testing de performance

### 4. Reviewer Backend Python Agent (`reviewer-backend-py.md`)
**Code Review Automatizado para Backend Python**

Agente especializado en revisión de código que combina las perspectivas del Architect, Backend-Py y QA para proporcionar reviews completas de PRs.

**Capacidades:**
- Análisis de arquitectura y patrones de diseño
- Validación de calidad de código (type hints, SOLID, DRY)
- Revisión de tests y cobertura (>90% objetivo)
- Detección de vulnerabilidades de seguridad
- Evaluación de performance y queries
- Generación de feedback estructurado con scores
- Decisión de APPROVE/REQUEST_CHANGES

**Cuándo usar:**
- Code reviews automatizados en GitHub PRs
- Validación de calidad antes de merge
- Asegurar estándares de arquitectura
- Verificar cobertura de testing
- Auditorías de seguridad

## GitHub Workflows

Este repositorio incluye workflows de GitHub Actions reutilizables para automatizar procesos de CI/CD.

### Workflows Disponibles

#### Code Review Backend Python (`code-review-backend-py.yml`)

Workflow que automatiza el code review usando el agente `reviewer-backend-py` de Claude AI.

**Características:**
- ✅ Revisión automática de PRs
- ✅ Análisis de arquitectura, código y testing
- ✅ Aprobación/rechazo basado en criterios de calidad
- ✅ Bloqueo de merge si no cumple estándares
- ✅ Comentarios detallados en PR

**Requisitos:**
- Secret: `ANTHROPIC_API_KEY`
- Permisos: write para pull-requests

**Documentación completa:**
- [Arquitectura del Code Review Agent](./docs/CODE_REVIEW_AGENT_ARCHITECTURE.md)
- [Guía de Despliegue](docs/CI_CD_GUIDE_TO_CODE_REVIEW_AGENT.md)
- [README de Workflows](./git-workflows/README.md)

### Instalación de Workflows

#### Método 1: Script de Sincronización (Recomendado)

```bash
# Desde tu proyecto
./scripts/sync-workflows.sh

# Con repositorio personalizado
./scripts/sync-workflows.sh https://github.com/tu-empresa/workflows.git

# Con variable de entorno
WORKFLOWS_REPO=https://github.com/tu-empresa/repo.git ./scripts/sync-workflows.sh
```

El script te permite:
1. Ver todos los workflows disponibles
2. Seleccionar cuáles instalar
3. Copiarlos automáticamente a `.github/workflows/`
4. Ver qué secrets necesitas configurar

#### Método 2: Copia Manual

```bash
# Copiar workflow específico
cp git-workflows/code-review-backend-py.yml .github/workflows/

# Copiar todos los workflows
cp git-workflows/*.yml .github/workflows/
```

#### Método 3: Instalación Global

```bash
# Clonar en directorio home
git clone https://github.com/juanpaconpa/claude-agents.git ~/.claude-agents

# Crear alias
echo 'alias sync-workflows="~/.claude-agents/scripts/sync-workflows.sh"' >> ~/.bashrc
source ~/.bashrc

# Usar desde cualquier proyecto
cd /tu/proyecto
sync-workflows
```

### Configuración Post-Instalación

Después de instalar un workflow:

1. **Configurar Secrets**:
   ```
   Repositorio → Settings → Secrets → Actions → New secret
   ```
   - `ANTHROPIC_API_KEY`: Tu API key de Anthropic

2. **Configurar Permisos**:
   ```
   Settings → Actions → General → Workflow permissions
   ```
   - ✅ Read and write permissions
   - ✅ Allow GitHub Actions to create and approve pull requests

3. **Personalizar** (opcional):
   - Editar triggers en `.github/workflows/`
   - Ajustar modelos de Claude
   - Modificar criterios de revisión

Ver [documentación completa de workflows](./git-workflows/README.md) para más detalles.

## Instalación de Agentes

### Método 1: Script de Sincronización (Recomendado)

El método más fácil y rápido para instalar agentes:

```bash
# Clonar el repositorio
git clone https://github.com/juanpaconpa/claude-agents.git
cd claude-agents

# Ejecutar el script de sincronización
./scripts/sync-agents.sh
```

### Método 2: Instalación Remota

Instalar sin clonar el repositorio:

```bash
# Instalar con repositorio por defecto
curl -sSL https://raw.githubusercontent.com/juanpaconpa/claude-agents/main/scripts/sync-agents.sh | bash

# Instalar con repositorio personalizado
curl -sSL https://raw.githubusercontent.com/juanpaconpa/claude-agents/main/scripts/sync-agents.sh | bash -s -- https://github.com/tu-empresa/agents.git
```

### Método 3: Instalación Global

Para usar en cualquier proyecto:

```bash
# Clonar en directorio home
git clone https://github.com/juanpaconpa/claude-agents.git ~/.claude-agents

# Crear alias
echo 'alias sync-agents="~/.claude-agents/scripts/sync-agents.sh"' >> ~/.bashrc
source ~/.bashrc

# Usar desde cualquier proyecto
cd /tu/proyecto
sync-agents
```

### Método 4: Manual

Copiar manualmente los agentes:

```bash
# Crear directorio de agentes
mkdir -p .claude/agents

# Copiar agentes deseados
cp claude-agents/agents/architect.md .claude/agents/
cp claude-agents/agents/backend-py.md .claude/agents/
cp claude-agents/agents/qa-backend-py.md .claude/agents/
```

## Uso del Script de Sincronización

### Sintaxis

```bash
./scripts/sync-agents.sh [REPOSITORY_URL]
```

### Opciones

- `REPOSITORY_URL`: URL del repositorio de agentes (opcional)
- `-h, --help`: Muestra la ayuda

### Ejemplos

**Uso básico:**
```bash
./scripts/sync-agents.sh
```

**Con repositorio personalizado:**
```bash
# Como parámetro
./scripts/sync-agents.sh https://github.com/empresa/company-agents.git

# Como variable de entorno
AGENTS_REPO=https://github.com/empresa/agents.git ./scripts/sync-agents.sh

# Exportar variable (permanente)
export AGENTS_REPO="https://github.com/empresa/agents.git"
./scripts/sync-agents.sh
```

**Selección de agentes:**
- **Opción 1**: Instalar todos los agentes
- **Opción 2**: Selección personalizada (números individuales: `1 3` o rangos: `1-3`)
- **Opción 3**: Salir

### Flujo de Trabajo

1. El script muestra todos los agentes disponibles con sus descripciones
2. Seleccionas qué agentes instalar
3. Confirmas la instalación (en modo personalizado)
4. Los agentes se copian a `.claude/agents/`
5. Se muestra un resumen de la sincronización

## Estructura del Proyecto

```
claude-agents/
├── .gitignore
├── .github/
│   └── workflows/
│       └── validate-agents.yml    # CI para validar agentes
├── .idea/                          # IntelliJ IDEA config
├── README.md                       # Este archivo
├── agents/                         # Agentes de Claude
│   ├── architect.md               # Agente de arquitectura
│   ├── backend-py.md              # Agente de backend Python
│   ├── qa-backend-py.md           # Agente de QA/testing
│   └── reviewer-backend-py.md     # Agente de code review
├── docs/                           # Documentación
│   ├── CI_CD_GUIDE_TO_CODE_REVIEW_AGENT.md  # Guía de CI/CD para code review
│   ├── CODE_REVIEW_AGENT_ARCHITECTURE.md    # Arquitectura del code reviewer
│   ├── QUICKSTART_TO_USE_AGENTS.md          # Inicio rápido
│   └── TESTING_STRATEGY.md                  # Estrategia de testing
├── git-workflows/                  # Workflows reutilizables
│   ├── README.md                  # Documentación de workflows
│   └── code-review-backend-py.yml # Workflow de code review
└── scripts/                        # Scripts de utilidad
    ├── sync-agents.sh             # Script de sincronización de agentes
    ├── sync-workflows.sh          # Script de sincronización de workflows
    ├── validate-agents.sh         # Script de validación de agentes
    └── README.md                  # Documentación de scripts
```

## Configuración para Equipos

### Opción A: Variable de Entorno Global

Configurar para todo el equipo en sus archivos de shell:

```bash
# En .bashrc, .zshrc, etc.
export AGENTS_REPO="https://github.com/empresa/company-claude-agents.git"
```

### Opción B: Alias Personalizado

Crear un alias específico para el equipo:

```bash
alias sync-company-agents="~/.claude-agents/scripts/sync-agents.sh https://github.com/empresa/agents.git"
```

### Opción C: Fork del Repositorio

1. Hacer fork de este repositorio
2. Modificar `DEFAULT_AGENTS_REPO` en `scripts/sync-agents.sh`
3. Agregar/modificar agentes según necesidades del equipo
4. Compartir el fork con el equipo

## Uso de los Agentes

Una vez instalados, los agentes están disponibles en Claude Code:

### En Claude Code CLI

```bash
# Los agentes están automáticamente disponibles
# Claude Code los carga desde .claude/agents/
```

### Invocar un Agente

Los agentes se invocan basándose en el contexto de tu solicitud. Por ejemplo:

- **Architect**: "Analiza la arquitectura de este proyecto y recomienda cómo agregar autenticación"
- **Backend-Py**: "Implementa un interactor para crear usuarios siguiendo Clean Architecture"
- **QA**: "Escribe tests unitarios para este interactor con >90% de cobertura"

## Crear Nuevos Agentes

### Estructura de un Agente

Cada agente es un archivo Markdown con frontmatter YAML:

```markdown
---
name: agent-name
description: Brief description of the agent
model: inherit
color: blue
---

# Agent Title

Your agent prompt here...
```

### Campos del Frontmatter

- `name`: Identificador único del agente (kebab-case)
- `description`: Descripción breve (1 línea)
- `model`: Modelo a usar (`inherit`, `sonnet`, `opus`, `haiku`)
- `color`: Color para la UI (`blue`, `green`, `yellow`, `red`, `purple`, `cyan`)

### Ejemplo

```markdown
---
name: frontend-react
description: React frontend development agent specializing in TypeScript and modern React patterns
model: inherit
color: cyan
---

# Frontend React Agent

You are a specialized React frontend development agent...
```

## Contribuir

### Agregar un Nuevo Agente

1. Fork este repositorio
2. Crea un nuevo archivo en `agents/` siguiendo la estructura
3. Prueba el agente localmente
4. Crea un Pull Request con descripción detallada

### Mejorar un Agente Existente

1. Fork el repositorio
2. Modifica el agente en `agents/`
3. Documenta los cambios
4. Crea un Pull Request

### Reportar Issues

Si encuentras problemas:

1. Verifica que no exista un issue similar
2. Crea un nuevo issue con:
   - Descripción clara del problema
   - Pasos para reproducir
   - Comportamiento esperado vs actual
   - Logs relevantes

## Casos de Uso

### Startup con Clean Architecture

```bash
# Instalar agentes de arquitectura y backend
./scripts/sync-agents.sh
# Selecciona: 2 → Ingresa: 1 2

# Usar el agente de arquitectura
"Analiza este proyecto y recomienda la mejor forma de implementar un sistema de autenticación"

# Usar el agente de backend
"Implementa el sistema de autenticación siguiendo las recomendaciones del arquitecto"
```

### Empresa con Repositorio Privado

```bash
# Configurar repo privado de la empresa
export AGENTS_REPO="git@github.com:empresa/private-agents.git"

# Instalar agentes de empresa
sync-agents

# Los agentes personalizados ahora están disponibles
```

### Freelancer con Múltiples Clientes

```bash
# Cliente A
alias sync-agents-clienta="sync-agents https://github.com/clienta/agents.git"

# Cliente B
alias sync-agents-clientb="sync-agents https://github.com/clientb/agents.git"

# Cambiar entre proyectos fácilmente
cd ~/projects/clienta && sync-agents-clienta
cd ~/projects/clientb && sync-agents-clientb
```

## Actualización de Agentes

Para actualizar agentes a la última versión:

```bash
# Ejecutar nuevamente el script
./scripts/sync-agents.sh

# Seleccionar los agentes a actualizar
# Los archivos existentes serán sobrescritos
```

## Requisitos

- Git
- Bash 4.0+
- Claude Code CLI
- Permisos de escritura en el proyecto

## Solución de Problemas

### Los agentes no aparecen en Claude Code

1. Verifica que los archivos estén en `.claude/agents/`
2. Reinicia Claude Code
3. Verifica que los archivos tengan el formato correcto

### Error al clonar repositorio

1. Verifica tu conexión a internet
2. Verifica que tengas acceso al repositorio
3. Para repos privados, configura SSH o tokens de acceso

### Agentes no se sincronizan

1. Verifica que la carpeta `agents/` exista en el repo
2. Verifica que los archivos `.md` estén presentes
3. Ejecuta con `bash -x` para debug: `bash -x scripts/sync-agents.sh`

## Recursos

- [Guía Rápida](docs/QUICKSTART_TO_USE_AGENTS.md) - Inicio rápido con agentes y workflows
- [Documentación de Scripts](./scripts/README.md) - Documentación de scripts de sincronización
- [Documentación de Workflows](./git-workflows/README.md) - Workflows de GitHub Actions
- [Claude Code Documentation](https://docs.anthropic.com/claude/docs) - Documentación oficial de Claude
