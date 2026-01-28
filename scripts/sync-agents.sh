#!/bin/bash

# Colores para mejor visualización
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuración por defecto
DEFAULT_AGENTS_REPO="https://github.com/juanpaconpa/claude-agents.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_SOURCE_DIR="$(dirname "$SCRIPT_DIR")/agents"
PROJECT_AGENTS_DIR=".claude/agents"
TEMP_REPO_DIR="/tmp/claude-agents-sync"

# Obtener AGENTS_REPO de:
# 1. Parámetro de línea de comandos
# 2. Variable de entorno
# 3. Valor por defecto
AGENTS_REPO="${1:-${AGENTS_REPO:-$DEFAULT_AGENTS_REPO}}"

# Función para mostrar ayuda
show_help() {
    echo -e "${CYAN}Claude Agents Synchronization Tool${NC}"
    echo ""
    echo "Uso:"
    echo "  $0 [REPOSITORY_URL]"
    echo ""
    echo "Opciones:"
    echo "  REPOSITORY_URL    URL del repositorio de agentes (opcional)"
    echo "  -h, --help        Muestra esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0"
    echo "  $0 https://github.com/usuario/mis-agentes.git"
    echo "  AGENTS_REPO=https://github.com/usuario/repo.git $0"
    echo ""
    echo "Variables de entorno:"
    echo "  AGENTS_REPO       URL del repositorio de agentes"
    echo ""
    exit 0
}

# Verificar si se solicita ayuda
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
fi

# Banner
echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════╗"
echo "║     Claude Agents Synchronization Tool       ║"
echo "║        Sync agents to local projects         ║"
echo "╚═══════════════════════════════════════════════╝"
echo -e "${NC}"

# Mostrar repositorio en uso
if [ "$AGENTS_REPO" != "$DEFAULT_AGENTS_REPO" ]; then
    print_info "Usando repositorio: ${YELLOW}$AGENTS_REPO${NC}"
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

# Función para obtener la descripción de un agente
get_agent_description() {
    local agent_file="$1"
    if [ -f "$agent_file" ]; then
        # Extraer la descripción del frontmatter YAML
        sed -n '/^description:/p' "$agent_file" | sed 's/description: //'
    else
        echo "No description available"
    fi
}

# Función para obtener agentes desde el directorio local o remoto
get_agents_source() {
    # Si estamos en el repo de agentes, usar directorio local
    if [ -d "$AGENTS_SOURCE_DIR" ] && [ -f "$AGENTS_SOURCE_DIR/../.git/config" ]; then
        # Verificar si el repo local coincide con AGENTS_REPO
        local current_remote=$(cd "$AGENTS_SOURCE_DIR/.." && git config --get remote.origin.url 2>/dev/null)

        # Si usamos un repo personalizado diferente, clonar ese en su lugar
        if [ "$AGENTS_REPO" != "$DEFAULT_AGENTS_REPO" ] && [ "$current_remote" != "$AGENTS_REPO" ]; then
            print_info "Detectado repositorio personalizado, obteniendo desde remoto..."
        else
            echo "$AGENTS_SOURCE_DIR"
            return 0
        fi
    fi

    # Crear directorio temporal único basado en hash del repo URL
    local repo_hash=$(echo -n "$AGENTS_REPO" | md5sum 2>/dev/null || echo -n "$AGENTS_REPO" | md5)
    repo_hash=$(echo "$repo_hash" | cut -d' ' -f1)
    TEMP_REPO_DIR="/tmp/claude-agents-sync-${repo_hash:0:8}"

    # Si no, clonar o actualizar el repo temporal
    print_info "Obteniendo agentes del repositorio remoto..."

    if [ -d "$TEMP_REPO_DIR" ]; then
        cd "$TEMP_REPO_DIR" && git pull -q
        if [ $? -eq 0 ]; then
            print_success "Repositorio actualizado"
        else
            print_error "Error al actualizar repositorio"
            return 1
        fi
    else
        git clone -q "$AGENTS_REPO" "$TEMP_REPO_DIR"
        if [ $? -eq 0 ]; then
            print_success "Repositorio clonado"
        else
            print_error "Error al clonar repositorio: $AGENTS_REPO"
            return 1
        fi
    fi

    echo "$TEMP_REPO_DIR/agents"
    return 0
}

# Función para listar agentes disponibles
list_agents() {
    local source_dir="$1"
    local output_var="$2"
    local agents=()
    local agent_paths=()
    local index=1

    echo ""
    echo -e "${CYAN}Agentes disponibles:${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Buscar en directorio raíz y subdirectorios
    while IFS= read -r -d '' agent_file; do
        if [ -f "$agent_file" ]; then
            # Calcular ruta relativa desde source_dir
            local rel_path="${agent_file#$source_dir/}"
            local agent_name="${rel_path%.md}"
            local agent_desc=$(get_agent_description "$agent_file")

            # Mostrar con prefijo de directorio si está en subdirectorio
            local display_name="$agent_name"
            if [[ "$rel_path" == */* ]]; then
                display_name="${BLUE}$(dirname "$rel_path")/${NC}${YELLOW}$(basename "$rel_path" .md)${NC}"
            else
                display_name="${YELLOW}$agent_name${NC}"
            fi

            agents+=("$agent_name")
            agent_paths+=("$agent_file")
            echo -e "${GREEN}[$index]${NC} $display_name"
            echo -e "    $agent_desc"
            echo ""
            ((index++))
        fi
    done < <(find "$source_dir" -name "*.md" -print0 | sort -z)

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Return array via nameref
    eval "$output_var=(\"\${agents[@]}\")"
}

# Función para copiar agentes
copy_agents() {
    local source_dir="$1"
    shift
    local agents=("$@")
    local copied=0
    local failed=0

    # Crear directorio de destino si no existe
    mkdir -p "$PROJECT_AGENTS_DIR"

    echo ""
    print_info "Sincronizando agentes..."
    echo ""

    for agent in "${agents[@]}"; do
        local source_file="$source_dir/${agent}.md"
        # Mantener estructura plana en destino (basename solo)
        local dest_file="$PROJECT_AGENTS_DIR/$(basename "${agent}.md")"

        if [ -f "$source_file" ]; then
            cp "$source_file" "$dest_file"
            if [ $? -eq 0 ]; then
                print_success "Sincronizado: ${YELLOW}$agent${NC} → $(basename "${agent}.md")"
                ((copied++))
            else
                print_error "Error al copiar: $agent"
                ((failed++))
            fi
        else
            print_warning "Agente no encontrado: $agent"
            ((failed++))
        fi
    done

    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Resumen de sincronización        ║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC}  Agentes sincronizados: ${GREEN}$copied${NC}"
    echo -e "${GREEN}║${NC}  Errores:               ${RED}$failed${NC}"
    echo -e "${GREEN}║${NC}  Ubicación:             ${CYAN}$PROJECT_AGENTS_DIR${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
}

# Función principal
main() {
    # Obtener fuente de agentes
    local agents_source=$(get_agents_source)
    if [ $? -ne 0 ]; then
        print_error "No se pudo acceder a los agentes"
        exit 1
    fi

    # Listar agentes disponibles
    local available_agents=()
    list_agents "$agents_source" available_agents
    local agent_count=${#available_agents[@]}

    if [ $agent_count -eq 0 ]; then
        print_error "No se encontraron agentes disponibles"
        exit 1
    fi

    # Menú de opciones
    echo ""
    echo -e "${CYAN}¿Qué agentes deseas sincronizar?${NC}"
    echo ""
    echo -e "${GREEN}[1]${NC} Todos los agentes"
    echo -e "${GREEN}[2]${NC} Selección personalizada"
    echo -e "${GREEN}[3]${NC} Salir"
    echo ""
    read -p "Selecciona una opción [1-3]: " option

    case $option in
        1)
            # Copiar todos los agentes
            copy_agents "$agents_source" "${available_agents[@]}"
            ;;
        2)
            # Selección personalizada
            echo ""
            print_info "Ingresa los números de los agentes que deseas instalar"
            print_info "Separados por espacios (ej: 1 3 5) o rangos (ej: 1-3)"
            echo ""
            read -p "Agentes a instalar: " selection

            # Procesar selección
            local selected_agents=()
            for item in $selection; do
                if [[ $item == *-* ]]; then
                    # Rango (ej: 1-3)
                    IFS='-' read -ra RANGE <<< "$item"
                    for ((i=${RANGE[0]}; i<=${RANGE[1]}; i++)); do
                        if [ $i -ge 1 ] && [ $i -le $agent_count ]; then
                            selected_agents+=("${available_agents[$((i-1))]}")
                        fi
                    done
                else
                    # Número individual
                    if [ "$item" -ge 1 ] && [ "$item" -le $agent_count ]; then
                        selected_agents+=("${available_agents[$((item-1))]}")
                    fi
                fi
            done

            if [ ${#selected_agents[@]} -eq 0 ]; then
                print_error "No se seleccionaron agentes válidos"
                exit 1
            fi

            echo ""
            print_info "Agentes seleccionados: ${YELLOW}${selected_agents[@]}${NC}"
            echo ""
            read -p "¿Continuar con la instalación? [s/N]: " confirm

            if [[ $confirm =~ ^[Ss]$ ]]; then
                copy_agents "$agents_source" "${selected_agents[@]}"
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
    print_info "Ahora puedes usar tus agentes en Claude Code"
    echo ""
}

# Ejecutar script
main