#!/bin/bash
# Global SDD Hook - Claude Code
# Routes hook events to appropriate log directories based on hook_event_name
# No dependencies required - pure bash

readonly SDD_LOGS_BASE_DIR="$HOME/.claude/logs"
readonly SESSION_START_LOG_DIR="$SDD_LOGS_BASE_DIR/session-start"
readonly SESSION_END_LOG_DIR="$SDD_LOGS_BASE_DIR/session-end"
readonly POST_TOOL_USE_LOG_DIR="$SDD_LOGS_BASE_DIR/post-tool-use"
readonly USER_PROMPT_LOG_DIR="$SDD_LOGS_BASE_DIR/user-prompt"

mkdir -p "$SESSION_START_LOG_DIR" 2>/dev/null || true
mkdir -p "$SESSION_END_LOG_DIR" 2>/dev/null || true
mkdir -p "$POST_TOOL_USE_LOG_DIR" 2>/dev/null || true
mkdir -p "$USER_PROMPT_LOG_DIR" 2>/dev/null || true

extract_hook_event_name() {
    local input="$1"
    if [ -z "$input" ]; then
        echo "unknown"
        return
    fi
    
    local hook_name=$(echo "$input" | grep -o '"hook_event_name":"[^"]*"' | sed 's/"hook_event_name":"//;s/"$//' | head -1)
    if [ -z "$hook_name" ]; then
        echo "unknown"
    else
        echo "$hook_name"
    fi
}

get_repo_name() {
    local project_name=""
    
    if [[ -n "$CLAUDE_PROJECT_DIR" ]]; then
        local git_config="${CLAUDE_PROJECT_DIR}/.git/config"
        
        if [[ -f "$git_config" ]]; then
            local git_url=$(grep -E "^\s*url\s*=" "$git_config" | head -1 | sed -E 's/.*url[[:space:]]*=[[:space:]]*//')
            
            project_name=$(echo "$git_url" | sed -E 's|.*/([^/]+)\.git.*|\1|')
        fi
    fi
    
    echo "$project_name" | sed 's/[^a-zA-Z0-9_-]/_/g'
}

process_sdd_hook() {
    local input="$1"
    local log_dir="$2"
    local hook_type="$3"
    
    local user_id=$(whoami | base64)
    local utc_time=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    local fury_app=$(get_repo_name)
    
    local enriched_json="{\"fury_app\":\"${fury_app}\",\"utc_time\":\"${utc_time}\",\"id\":\"${user_id}\",\"hook_type\":\"${hook_type}\",\"crude_data\":${input}}"
    
    local timestamp=$(date -u +"%Y%m%d_%H%M%S_%3N" 2>/dev/null || date -u +"%Y%m%d_%H%M%S")
    echo "$enriched_json" > "$log_dir/${timestamp}.json"
}

main() {
    input=$(cat)
    
    hook_event_name=$(extract_hook_event_name "$input")
    
    case "$hook_event_name" in
        SessionStart)
            process_sdd_hook "$input" "$SESSION_START_LOG_DIR" "session-start"
            ;;
            
        SessionEnd)
            process_sdd_hook "$input" "$SESSION_END_LOG_DIR" "session-end"
            ;;
        
        PostToolUse)
            process_sdd_hook "$input" "$POST_TOOL_USE_LOG_DIR" "post-tool-use"
            ;;
            
        UserPromptSubmit)
            process_sdd_hook "$input" "$USER_PROMPT_LOG_DIR" "user-prompt"
            ;;
    esac
    
    exit 0
}

main
