# Quick Start Guide - Claude Agents & Workflows

Guía rápida para comenzar a usar agentes de Claude y workflows de GitHub Actions en tus proyectos.

## 🚀 Inicio Rápido

### Para Agentes de Claude

```bash
# 1. Clonar o navegar al repositorio
cd /ruta/a/claude-agents

# 2. Ejecutar script de sincronización
./scripts/sync-agents.sh

# 3. Seleccionar agentes deseados
# Opción 1: Todos los agentes
# Opción 2: Selección personalizada
```

### Para GitHub Workflows

```bash
# 1. Desde tu proyecto
cd /tu/proyecto

# 2. Ejecutar script de sincronización de workflows
/ruta/a/claude-agents/scripts/sync-workflows.sh

# 3. Seleccionar workflows deseados
# Opción 1: Todos los workflows
# Opción 2: Selección personalizada

# 4. Configurar secrets necesarios
# Ir a: GitHub Repo → Settings → Secrets → Actions
```

## 📦 Instalación

### Método 1: Desde este repositorio (Recomendado)

```bash
# Clonar repositorio
git clone https://github.com/juanpaconpa/claude-agents.git
cd claude-agents

# Instalar agentes
./scripts/sync-agents.sh

# Instalar workflows
./scripts/sync-workflows.sh
```

### Método 2: Con repositorio personalizado

```bash
# Agentes
./scripts/sync-agents.sh https://github.com/tu-empresa/agents.git

# Workflows
./scripts/sync-workflows.sh https://github.com/tu-empresa/workflows.git
```

### Método 3: Con variables de entorno

```bash
# Configurar variables
export AGENTS_REPO="https://github.com/tu-empresa/agents.git"
export WORKFLOWS_REPO="https://github.com/tu-empresa/workflows.git"

# Ejecutar scripts
./scripts/sync-agents.sh
./scripts/sync-workflows.sh
```

### Método 4: Instalación remota

```bash
# Agentes
curl -sSL https://raw.githubusercontent.com/juanpaconpa/claude-agents/main/scripts/sync-agents.sh | bash

# Con repo personalizado
curl -sSL https://raw.githubusercontent.com/juanpaconpa/claude-agents/main/scripts/sync-agents.sh | bash -s -- https://github.com/empresa/agents.git
```

### Método 5: Instalación global

```bash
# Clonar en home
git clone https://github.com/juanpaconpa/claude-agents.git ~/.claude-agents

# Crear aliases
echo 'alias sync-agents="~/.claude-agents/scripts/sync-agents.sh"' >> ~/.bashrc
echo 'alias sync-workflows="~/.claude-agents/scripts/sync-workflows.sh"' >> ~/.bashrc
source ~/.bashrc

# Usar desde cualquier proyecto
cd /tu/proyecto
sync-agents
sync-workflows
```

## 🎯 Ejemplos de Uso

### Agentes

#### 1. Ver ayuda

```bash
./scripts/sync-agents.sh --help
```

#### 2. Instalar todos los agentes

```bash
./scripts/sync-agents.sh
# Selecciona: [1]
```

#### 3. Instalar agentes específicos

```bash
./scripts/sync-agents.sh
# Selecciona: [2]
# Ingresa: 1 3
# Esto instalará 'architect' y 'qa-backend-py'
```

#### 4. Instalar rango de agentes

```bash
./scripts/sync-agents.sh
# Selecciona: [2]
# Ingresa: 1-3
# Esto instalará todos los agentes del 1 al 3
```

### Workflows

#### 1. Ver ayuda

```bash
./scripts/sync-workflows.sh --help
```

#### 2. Instalar todos los workflows

```bash
./scripts/sync-workflows.sh
# Selecciona: [1]
```

#### 3. Instalar workflow específico

```bash
./scripts/sync-workflows.sh
# Selecciona: [2]
# Ingresa: 1
# Confirma: s
```

## 📋 Recursos Disponibles

### Agentes de Claude

| # | Agente | Descripción |
|---|--------|-------------|
| 1 | architect | Especialista en arquitectura de software |
| 2 | backend-py | Desarrollo backend Python con Clean Architecture |
| 3 | qa-backend-py | Testing y QA para backend Python |
| 4 | reviewer-backend-py | Code review automatizado (arquitectura + backend + QA) |

### GitHub Workflows

| # | Workflow | Descripción |
|---|----------|-------------|
| 1 | code-review-backend-py | Revisión automática de PRs con Claude AI |

## 📁 Ubicación de Archivos

### Agentes instalados

```
tu-proyecto/
└── .claude/
    └── agents/
        ├── architect.md
        ├── backend-py.md
        ├── qa-backend-py.md
        └── reviewer-backend-py.md
```

### Workflows instalados

```
tu-proyecto/
└── .github/
    └── workflows/
        └── code-review-backend-py.yml
```

## ✅ Verificar Instalación

### Agentes

```bash
# Listar agentes instalados
ls -la .claude/agents/

# Ver contenido de un agente
cat .claude/agents/architect.md

# Los agentes estarán disponibles automáticamente en Claude Code
```

### Workflows

```bash
# Listar workflows instalados
ls -la .github/workflows/

# Ver contenido del workflow
cat .github/workflows/code-review-backend-py.yml

# Verificar en GitHub
# Ve a: tu-repo → Actions → Verás los workflows disponibles
```

## ⚙️ Configuración Post-Instalación

### Para Workflows

Después de instalar workflows, necesitas configurar:

#### 1. Secrets

```
GitHub Repo → Settings → Secrets and variables → Actions → New secret
```

Para `code-review-backend-py.yml`:
- `ANTHROPIC_API_KEY`: Tu API key de Anthropic

#### 2. Permisos

```
Settings → Actions → General → Workflow permissions
```

Selecciona:
- ✅ Read and write permissions
- ✅ Allow GitHub Actions to create and approve pull requests

#### 3. Probar workflow

```bash
# Crear PR de prueba
git checkout -b test/workflow
echo "# Test" >> test.py
git add test.py
git commit -m "test: verify workflow"
git push origin test/workflow
gh pr create --title "Test Workflow" --body "Testing code review"
```

## 🔄 Actualizar Recursos

### Agentes

```bash
# Simplemente re-ejecuta el script
./scripts/sync-agents.sh

# Los archivos existentes serán sobrescritos con la versión más reciente
```

### Workflows

```bash
# Re-ejecuta el script de workflows
./scripts/sync-workflows.sh

# NOTA: Si personalizaste workflows, haz backup antes
cp .github/workflows/code-review-backend-py.yml .github/workflows/code-review-backend-py.yml.backup
```

## 🏢 Configuración para Equipos

### Opción A: Variables de entorno globales

```bash
# En .bashrc, .zshrc, etc.
export AGENTS_REPO="https://github.com/empresa/company-agents.git"
export WORKFLOWS_REPO="https://github.com/empresa/company-workflows.git"
```

### Opción B: Aliases personalizados

```bash
# Crear aliases para tu empresa
alias sync-company-agents="~/.claude-agents/scripts/sync-agents.sh https://github.com/empresa/agents.git"
alias sync-company-workflows="~/.claude-agents/scripts/sync-workflows.sh https://github.com/empresa/workflows.git"
```

### Opción C: Fork del repositorio

1. Fork este repositorio
2. Modificar `DEFAULT_AGENTS_REPO` y `DEFAULT_WORKFLOWS_REPO` en los scripts
3. Agregar/modificar agentes y workflows según necesidades
4. Compartir el fork con el equipo

## 🐛 Problemas Comunes

### Agentes

#### Los agentes no aparecen en Claude Code

1. Verifica que los archivos estén en `.claude/agents/`
2. Reinicia Claude Code
3. Verifica que los archivos tengan formato correcto

#### Error: "No se pudo acceder a los agentes"

1. Verifica tu conexión a internet
2. Verifica que git esté instalado
3. Para repos privados, configura SSH keys

#### Error: "No se encontraron agentes disponibles"

1. Verifica que estás en el directorio correcto
2. Verifica que la carpeta `agents/` existe en el repo
3. Ejecuta con debug: `bash -x scripts/sync-agents.sh`

### Workflows

#### Workflow no se ejecuta en PRs

1. Verifica que el workflow esté en `.github/workflows/`
2. Verifica que los paths coincidan con tu estructura
3. Verifica que GitHub Actions esté habilitado

#### Error: "Secret not found"

1. Ve a: Settings → Secrets → Actions
2. Verifica que `ANTHROPIC_API_KEY` esté configurado
3. El valor debe empezar con `sk-ant-`

#### Workflow falla con error de permisos

1. Ve a: Settings → Actions → General
2. Selecciona "Read and write permissions"
3. Habilita "Allow GitHub Actions to create and approve pull requests"

## 📚 Casos de Uso Comunes

### 1. Startup con Clean Architecture

```bash
# Instalar agentes de arquitectura y desarrollo
./scripts/sync-agents.sh
# Selecciona: 2 → Ingresa: 1 2

# Instalar workflow de code review
./scripts/sync-workflows.sh
# Selecciona: 1

# Usar en Claude Code
"Analiza este proyecto y recomienda cómo implementar autenticación"
"Implementa el sistema siguiendo Clean Architecture"
```

### 2. Empresa con repositorios privados

```bash
# Configurar repos de empresa
export AGENTS_REPO="git@github.com:empresa/private-agents.git"
export WORKFLOWS_REPO="git@github.com:empresa/private-workflows.git"

# Instalar recursos
sync-agents
sync-workflows
```

### 3. Freelancer con múltiples clientes

```bash
# Cliente A
alias sync-a-agents="sync-agents https://github.com/clienta/agents.git"
alias sync-a-workflows="sync-workflows https://github.com/clienta/workflows.git"

# Cliente B
alias sync-b-agents="sync-agents https://github.com/clientb/agents.git"
alias sync-b-workflows="sync-workflows https://github.com/clientb/workflows.git"

# Cambiar entre proyectos
cd ~/projects/clienta && sync-a-agents && sync-a-workflows
cd ~/projects/clientb && sync-b-agents && sync-b-workflows
```

## 🔗 Enlaces Útiles

### Documentación Principal

- [README del Proyecto](../README.md) - Documentación completa
- [Documentación de Scripts](../scripts/README.md) - Detalles de los scripts
- [Documentación de Workflows](../git-workflows/README.md) - Detalles de workflows

### Documentación Específica

- [Arquitectura del Code Review Agent](./CODE_REVIEW_AGENT_ARCHITECTURE.md)
- [Guía de Despliegue](./CI_CD_GUIDE_TO_CODE_REVIEW_AGENT.md)
- [Estrategia de Testing](./TESTING_STRATEGY.md)

### Recursos Externos

- [Claude Code Documentation](https://docs.anthropic.com/claude/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Anthropic API Documentation](https://docs.anthropic.com/api)

## 💡 Tips y Mejores Prácticas

1. **Mantén los agentes actualizados**: Re-ejecuta los scripts regularmente
2. **Versiona tus personalizaciones**: Si modificas agentes/workflows, usa git
3. **Documenta cambios**: Si el equipo usa recursos personalizados, documéntalos
4. **Prueba antes de aplicar**: Usa branches de test para validar workflows
5. **Revisa los costos**: Workflows con Claude API tienen costo, monitorea uso

## 🆘 Soporte

¿Necesitas ayuda?

1. Revisa la [documentación completa](../README.md)
2. Busca en [issues existentes](https://github.com/juanpaconpa/claude-agents/issues)
3. Crea un [nuevo issue](https://github.com/juanpaconpa/claude-agents/issues/new) con:
   - Descripción del problema
   - Pasos para reproducir
   - Logs relevantes
   - Sistema operativo y versión

---

**¿Listo para empezar?** Ejecuta `./scripts/sync-agents.sh` y comienza a usar agentes de Claude en tu proyecto! 🚀