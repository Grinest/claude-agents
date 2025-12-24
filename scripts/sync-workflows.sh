#!/bin/bash

# Colores para mejor visualización
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuración por defecto
DEFAULT_WORKFLOWS_REPO="https://github.com/juanpaconpa/claude-agents.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOWS_SOURCE_DIR="$(dirname "$SCRIPT_DIR")/git-workflows"
PROJECT_WORKFLOWS_DIR=".github/workflows"
TEMP_REPO_DIR="/tmp/claude-workflows-sync"

# Obtener WORKFLOWS_REPO de:
# 1. Parámetro de línea de comandos
# 2. Variable de entorno
# 3. Valor por defecto
WORKFLOWS_REPO="${1:-${WORKFLOWS_REPO:-$DEFAULT_WORKFLOWS_REPO}}"

# Función para mostrar ayuda
show_help() {
    echo -e "${CYAN}GitHub Workflows Synchronization Tool${NC}"
    echo ""
    echo "Uso:"
    echo "  $0 [REPOSITORY_URL]"
    echo ""
    echo "Opciones:"
    echo "  REPOSITORY_URL    URL del repositorio de workflows (opcional)"
    echo "  -h, --help        Muestra esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0"
    echo "  $0 https://github.com/usuario/mis-workflows.git"
    echo "  WORKFLOWS_REPO=https://github.com/usuario/repo.git $0"
    echo ""
    echo "Variables de entorno:"
    echo "  WORKFLOWS_REPO    URL del repositorio de workflows"
    echo ""
    exit 0
}

# Verificar si se solicita ayuda
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
fi

# Función para mostrar mensajes
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Banner
echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════╗"
echo "║   GitHub Workflows Synchronization Tool      ║"
echo "║     Sync workflows to local repositories     ║"
echo "╚═══════════════════════════════════════════════╝"
echo -e "${NC}"

# Mostrar repositorio en uso
if [ "$WORKFLOWS_REPO" != "$DEFAULT_WORKFLOWS_REPO" ]; then
    print_info "Usando repositorio: ${YELLOW}$WORKFLOWS_REPO${NC}"
fi

# Función para obtener la descripción de un workflow
get_workflow_description() {
    local workflow_file="$1"
    if [ -f "$workflow_file" ]; then
        # Extraer el nombre del workflow del YAML
        local name=$(grep -m1 "^name:" "$workflow_file" | sed 's/name: //' | tr -d '"' | xargs)

        # Extraer triggers
        local triggers=""
        if grep -q "on:" "$workflow_file"; then
            triggers=$(grep -A5 "^on:" "$workflow_file" | grep -E "^\s+(push|pull_request|schedule|workflow_dispatch)" | head -3 | xargs | tr '\n' ', ')
        fi

        if [ -n "$name" ]; then
            echo "$name"
            if [ -n "$triggers" ]; then
                echo "    Triggers: $triggers"
            fi
        else
            echo "GitHub Workflow"
        fi
    else
        echo "No description available"
    fi
}

# Función para obtener workflows desde el directorio local o remoto
get_workflows_source() {
    # Si estamos en el repo de workflows, usar directorio local
    if [ -d "$WORKFLOWS_SOURCE_DIR" ] && [ -f "$WORKFLOWS_SOURCE_DIR/../.git/config" ]; then
        # Verificar si el repo local coincide con WORKFLOWS_REPO
        local current_remote=$(cd "$WORKFLOWS_SOURCE_DIR/.." && git config --get remote.origin.url 2>/dev/null)

        # Si usamos un repo personalizado diferente, clonar ese en su lugar
        if [ "$WORKFLOWS_REPO" != "$DEFAULT_WORKFLOWS_REPO" ] && [ "$current_remote" != "$WORKFLOWS_REPO" ]; then
            print_info "Detectado repositorio personalizado, obteniendo desde remoto..."
        else
            echo "$WORKFLOWS_SOURCE_DIR"
            return 0
        fi
    fi

    # Crear directorio temporal único basado en hash del repo URL
    local repo_hash
    if command -v md5sum >/dev/null 2>&1; then
        # Linux: md5sum outputs "hash  -"
        repo_hash=$(printf '%s' "$WORKFLOWS_REPO" | md5sum | awk '{print $1}')
    elif command -v md5 >/dev/null 2>&1; then
        # macOS: md5 outputs "MD5 (...) = hash"
        repo_hash=$(printf '%s' "$WORKFLOWS_REPO" | md5 | awk '{print $NF}')
    else
        # Fallback si no hay md5/md5sum disponible
        repo_hash="default"
    fi
    TEMP_REPO_DIR="/tmp/claude-workflows-sync-${repo_hash:0:8}"

    # Si no, clonar o actualizar el repo temporal
    print_info "Obteniendo workflows del repositorio remoto..."

    if [ -d "$TEMP_REPO_DIR" ]; then
        cd "$TEMP_REPO_DIR" && git pull -q
        if [ $? -eq 0 ]; then
            print_success "Repositorio actualizado"
        else
            print_error "Error al actualizar repositorio"
            return 1
        fi
    else
        git clone -q "$WORKFLOWS_REPO" "$TEMP_REPO_DIR"
        if [ $? -eq 0 ]; then
            print_success "Repositorio clonado"
        else
            print_error "Error al clonar repositorio: $WORKFLOWS_REPO"
            return 1
        fi
    fi

    echo "$TEMP_REPO_DIR/git-workflows"
    return 0
}

# Función para listar workflows disponibles
list_workflows() {
    local source_dir="$1"
    local output_var="$2"
    local workflows=()
    local index=1

    echo ""
    echo -e "${CYAN}Workflows disponibles:${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    for workflow_file in "$source_dir"/*.yml "$source_dir"/*.yaml; do
        if [ -f "$workflow_file" ]; then
            local workflow_name=$(basename "$workflow_file")
            local workflow_desc=$(get_workflow_description "$workflow_file")

            workflows+=("$workflow_name")
            echo -e "${GREEN}[$index]${NC} ${YELLOW}$workflow_name${NC}"
            echo -e "    $workflow_desc"
            echo ""
            ((index++))
        fi
    done

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Return array via nameref
    eval "$output_var=(\"${workflows[@]}\")"
}

# Función para copiar workflows
copy_workflows() {
    local source_dir="$1"
    shift
    local workflows=("$@")
    local copied=0
    local failed=0

    # Crear directorio de destino si no existe
    mkdir -p "$PROJECT_WORKFLOWS_DIR"

    echo ""
    print_info "Sincronizando workflows..."
    echo ""

    for workflow in "${workflows[@]}"; do
        local source_file="$source_dir/$workflow"
        local dest_file="$PROJECT_WORKFLOWS_DIR/$workflow"

        if [ -f "$source_file" ]; then
            cp "$source_file" "$dest_file"
            if [ $? -eq 0 ]; then
                print_success "Sincronizado: ${YELLOW}$workflow${NC}"
                ((copied++))
            else
                print_error "Error al copiar: $workflow"
                ((failed++))
            fi
        else
            print_warning "Workflow no encontrado: $workflow"
            ((failed++))
        fi
    done

    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Resumen de sincronización        ║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC}  Workflows sincronizados: ${GREEN}$copied${NC}"
    echo -e "${GREEN}║${NC}  Errores:                 ${RED}$failed${NC}"
    echo -e "${GREEN}║${NC}  Ubicación:               ${CYAN}$PROJECT_WORKFLOWS_DIR${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
}

# Función principal
main() {
    # Obtener fuente de workflows
    local workflows_source=$(get_workflows_source)
    if [ $? -ne 0 ]; then
        print_error "No se pudo acceder a los workflows"
        exit 1
    fi

    # Verificar que el directorio existe
    if [ ! -d "$workflows_source" ]; then
        print_error "Directorio de workflows no encontrado: $workflows_source"
        exit 1
    fi

    # Listar workflows disponibles
    local available_workflows=()
    list_workflows "$workflows_source" available_workflows
    local workflow_count=${#available_workflows[@]}

    if [ $workflow_count -eq 0 ]; then
        print_error "No se encontraron workflows disponibles"
        exit 1
    fi

    # Menú de opciones
    echo ""
    echo -e "${CYAN}¿Qué workflows deseas sincronizar?${NC}"
    echo ""
    echo -e "${GREEN}[1]${NC} Todos los workflows"
    echo -e "${GREEN}[2]${NC} Selección personalizada"
    echo -e "${GREEN}[3]${NC} Salir"
    echo ""
    read -p "Selecciona una opción [1-3]: " option

    case $option in
        1)
            # Copiar todos los workflows
            copy_workflows "$workflows_source" "${available_workflows[@]}"
            ;;
        2)
            # Selección personalizada
            echo ""
            print_info "Ingresa los números de los workflows que deseas instalar"
            print_info "Separados por espacios (ej: 1 3 5) o rangos (ej: 1-3)"
            echo ""
            read -p "Workflows a instalar: " selection

            # Procesar selección
            local selected_workflows=()
            for item in $selection; do
                if [[ $item == *-* ]]; then
                    # Rango (ej: 1-3)
                    IFS='-' read -ra RANGE <<< "$item"
                    for ((i=${RANGE[0]}; i<=${RANGE[1]}; i++)); do
                        if [ $i -ge 1 ] && [ $i -le $workflow_count ]; then
                            selected_workflows+=("${available_workflows[$((i-1))]}")
                        fi
                    done
                else
                    # Número individual
                    if [ "$item" -ge 1 ] && [ "$item" -le $workflow_count ]; then
                        selected_workflows+=("${available_workflows[$((item-1))]}")
                    fi
                fi
            done

            if [ ${#selected_workflows[@]} -eq 0 ]; then
                print_error "No se seleccionaron workflows válidos"
                exit 1
            fi

            echo ""
            print_info "Workflows seleccionados: ${YELLOW}${selected_workflows[@]}${NC}"
            echo ""
            read -p "¿Continuar con la instalación? [s/N]: " confirm

            if [[ $confirm =~ ^[Ss]$ ]]; then
                copy_workflows "$workflows_source" "${selected_workflows[@]}"
            else
                print_info "Instalación cancelada"
                exit 0
            fi
            ;;
        3)
            print_info "Saliendo..."
            exit 0
            ;;
        *)
            print_error "Opción inválida"
            exit 1
            ;;
    esac

    echo ""
    print_success "¡Sincronización completada!"
    print_info "Los workflows han sido instalados en: ${CYAN}$PROJECT_WORKFLOWS_DIR${NC}"
    echo ""
    print_warning "IMPORTANTE: Verifica que tienes los secrets necesarios configurados:"
    echo ""

    # Extraer secrets mencionados en los workflows
    for workflow in "${selected_workflows[@]:-${available_workflows[@]}}"; do
        local workflow_file="$workflows_source/$workflow"
        if [ -f "$workflow_file" ]; then
            local secrets=$(grep -o 'secrets\.[A-Z_]*' "$workflow_file" | sed 's/secrets\.//' | sort -u)
            if [ -n "$secrets" ]; then
                echo -e "${YELLOW}$workflow:${NC}"
                for secret in $secrets; do
                    echo "  - $secret"
                done
            fi
        fi
    done
    echo ""
    print_info "Configura los secrets en: Repositorio → Settings → Secrets → Actions"
    echo ""
}

# Ejecutar script
main