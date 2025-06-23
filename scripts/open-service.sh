#!/usr/bin/env bash

# Service web interface launcher
# Opens web interfaces for locally running services

declare -A SERVICES=(
    ["syncthing"]="http://localhost:8384"
)

show_help() {
    echo "Usage: open-service [SERVICE_NAME|--list|--help]"
    echo ""
    echo "Opens web interface for specified service in default browser"
    echo ""
    echo "Options:"
    echo "  --list, -l    List all available services"
    echo "  --help, -h    Show this help message"
    echo ""
    echo "Available services:"
    for service in "${!SERVICES[@]}"; do
        echo "  $service"
    done | sort
}

list_services() {
    echo "Available services and their URLs:"
    for service in "${!SERVICES[@]}"; do
        printf "  %-15s %s\n" "$service" "${SERVICES[$service]}"
    done | sort
}

check_service_running() {
    local service="$1"
    if systemctl --user is-active --quiet "$service.service" 2>/dev/null; then
        return 0
    elif systemctl is-active --quiet "$service.service" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

open_service() {
    local service="$1"
    local url="${SERVICES[$service]}"
    
    if [[ -z "$url" ]]; then
        echo "Error: Unknown service '$service'"
        echo "Use 'open-service --list' to see available services"
        exit 1
    fi
    
    if ! check_service_running "$service"; then
        echo "Warning: $service service doesn't appear to be running"
        echo "Attempting to open URL anyway..."
    fi
    
    echo "Opening $service at $url"
    
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$url"
    else
        echo "Error: xdg-open not found"
        echo "URL: $url"
        exit 1
    fi
}

# Parse arguments
case "${1:-}" in
    ""|--help|-h)
        show_help
        exit 0
        ;;
    --list|-l)
        list_services
        exit 0
        ;;
    *)
        open_service "$1"
        ;;
esac