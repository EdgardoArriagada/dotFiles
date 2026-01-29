#!/bin/bash
# Claude Code MCP Interaction Logger
CLAUDE_CONFIG="$HOME/.claude.json"

# Get project name 
get_project_name() {
    local project_name=""
    
    if [[ -n "$CLAUDE_PROJECT_DIR" ]]; then
        local git_config="${CLAUDE_PROJECT_DIR}/.git/config"
        
        if [[ -f "$git_config" ]]; then
            # Extract URL from git config (e.g., git@github.com-emu:melisource/fury_genai-tracker-hooks.git)
            local git_url=$(grep -E "^\s*url\s*=" "$git_config" | head -1 | sed -E 's/.*url[[:space:]]*=[[:space:]]*//')
            
            # Extract project name: everything after the last '/' and before '.git'
            # Works for: git@github.com-emu:melisource/fury_genai-tracker-hooks.git
            # Works for: https://github.com/melisource/fury_genai-tracker-hooks.git
            project_name=$(echo "$git_url" | sed -E 's|.*/([^/]+)\.git.*|\1|')
        fi
    fi
    
    echo "$project_name" | sed 's/[^a-zA-Z0-9_-]/_/g'
}

save_data() {
    local input_data="$1"
    local file_name="$2"
    local dir_path=$(dirname "$file_name")
    mkdir -p "$dir_path" 2>/dev/null
    echo "$input_data" >> "$file_name" 2>/dev/null
}


# Check if MCP server is HTTP type
# Returns 0 (true) if HTTP, 1 (false) otherwise
is_http_mcp() {
    local mcp_block="$1"
    
    # First check if type is explicitly set to "http"
    local server_type=$(echo "$mcp_block" | grep -m 1 '"type"' | sed -n 's/.*"type"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
    if [[ "$server_type" == "http" ]]; then
        return 0
    fi
    
    # If type is not available, check if it has "url" attribute
    if [[ -z "$server_type" ]]; then
        local url=$(echo "$mcp_block" | grep -m 1 '"url"' | sed -n 's/.*"url"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
        if [[ -n "$url" ]]; then
            return 0
        fi
    fi
    
    return 1
}


# Check if MCP server is stdio type
# Returns 0 (true) if stdio, 1 (false) otherwise
is_stdio_mcp() {
    local mcp_block="$1"
    
    # First check if type is explicitly set to "stdio"
    local server_type=$(echo "$mcp_block" | grep -m 1 '"type"' | sed -n 's/.*"type"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
    if [[ "$server_type" == "stdio" ]]; then
        return 0
    fi
    
    # If type is not available, check if it has "args" attribute
    if [[ -z "$server_type" ]]; then
        local args=$(echo "$mcp_block" | grep -m 1 '"args"' | sed -n 's/.*"args"[[:space:]]*:[[:space:]]*\[.*/\0/p')
        if [[ -n "$args" ]]; then
            return 0
        fi
    fi
    
    return 1
}

get_mcp_url() {
    local mcp_block="$1"
    
    if [ -z "$mcp_block" ]; then
        echo "null"
        return 1
    fi
    
    local url=""
    
    # Extract URL based on type using robust detection functions
    if is_http_mcp "$mcp_block"; then
        url=$(echo "$mcp_block" | grep -m 1 '"url"' | sed -n 's/.*"url"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
    elif is_stdio_mcp "$mcp_block"; then
        url=$(echo "$mcp_block" | grep -A 5 '"args"' | grep -o 'https\?://[^"]*' | head -1)
    fi
    
    if [ -z "$url" ]; then
        echo "null"
    else
        echo "$url"
    fi
}


get_mcp_block_from_local_scope() {
    local config_file="$HOME/.claude.json"
    local project_path="$1"
    local mcp_name="$2"
    
    # Get the project block using awk
    local project_block=$(awk -v search="\"$project_path\":" '
        BEGIN { found=0; depth=0; start_depth=-1 }
        {
            if (!found && index($0, search) > 0) {
                found = 1
                start_depth = depth
            }
            
            if (found) {
                print $0
                
                # Count braces in the line
                for (i=1; i<=length($0); i++) {
                    char = substr($0, i, 1)
                    if (char == "{") depth++
                    else if (char == "}") depth--
                }
                
                # Exit when we return to the starting depth (project block closed)
                if (depth <= start_depth && start_depth >= 0 && NR > 1) {
                    exit
                }
            }
        }
    ' "$config_file" 2>/dev/null)
    
    if [ -z "$project_block" ]; then
        echo ""
        return 1
    fi
    
    # Find the specific MCP within the project's mcpServers using awk
    local mcp_block=$(echo "$project_block" | awk -v search="\"$mcp_name\":" '
        BEGIN { found=0; depth=0 }
        {
            if (!found && index($0, search) > 0) {
                found = 1
                depth = 0
            }
            
            if (found) {
                print $0
                
                # Count braces
                for (i=1; i<=length($0); i++) {
                    char = substr($0, i, 1)
                    if (char == "{") depth++
                    else if (char == "}") depth--
                }
                
                # Exit when the MCP block closes
                if (depth <= 0 && NR > 1) {
                    exit
                }
            }
        }
    ')
    
    echo "$mcp_block"
}

get_mcp_block_from_user_scope() {
    local config_file="$HOME/.claude.json"
    local mcp_name="$1"
    
    # Get the global mcpServers block (at root level, not inside projects)
    local global_mcp_section=$(awk '
        /"mcpServers"[[:space:]]*:[[:space:]]*{/ {
            found_line = NR
            depth = 0
            delete block
            block_idx = 0
        }
        found_line > 0 && NR >= found_line {
            block[block_idx++] = $0
            
            # Count braces in the line
            for (i=1; i<=length($0); i++) {
                char = substr($0, i, 1)
                if (char == "{") depth++
                else if (char == "}") depth--
            }
            
            # When we close the mcpServers block, save it
            if (depth == 0 && NR > found_line) {
                # Store this block as the latest (global is typically last)
                for (i=0; i<block_idx; i++) {
                    saved_block[i] = block[i]
                }
                saved_block_size = block_idx
                found_line = 0
            }
        }
        END {
            # Print the last mcpServers block found (global)
            for (i=0; i<saved_block_size; i++) {
                print saved_block[i]
            }
        }
    ' "$config_file" 2>/dev/null)
    
    if [ -z "$global_mcp_section" ]; then
        echo ""
        return 1
    fi
    
    # Find the specific MCP within global mcpServers
    local mcp_block=$(echo "$global_mcp_section" | awk -v search="\"$mcp_name\":" '
        BEGIN { found=0; depth=0 }
        {
            if (!found && index($0, search) > 0) {
                found = 1
                depth = 0
            }
            
            if (found) {
                print $0
                
                # Count braces
                for (i=1; i<=length($0); i++) {
                    char = substr($0, i, 1)
                    if (char == "{") depth++
                    else if (char == "}") depth--
                }
                
                # Exit when the MCP block closes
                if (depth <= 0 && NR > 1) {
                    exit
                }
            }
        }
    ')
    
    echo "$mcp_block"
}


get_mcp_block_from_project_scope() {
    local mcp_name="$1"
    local config_file="$CLAUDE_PROJECT_DIR/.mcp.json"
    
    # Check if .mcp.json exists in the project
    if [ ! -f "$config_file" ]; then
        echo ""
        return 1
    fi
    
    # Extract the mcpServers block and find the specific MCP
    local mcp_block=$(awk -v search="\"$mcp_name\":" '
        BEGIN { found=0; depth=0 }
        {
            if (!found && index($0, search) > 0) {
                found = 1
                depth = 0
            }
            
            if (found) {
                print $0
                
                # Count braces
                for (i=1; i<=length($0); i++) {
                    char = substr($0, i, 1)
                    if (char == "{") depth++
                    else if (char == "}") depth--
                }
                
                # Exit when the MCP block closes
                if (depth <= 0 && NR > 1) {
                    exit
                }
            }
        }
    ' "$config_file" 2>/dev/null)
    
    echo "$mcp_block"
}


get_mcp_block_with_priority() {
    local mcp_name="$1"
    local project_path="$CLAUDE_PROJECT_DIR"
    
    local mcp_block=""
    
    # 1. Try local scope (project config in ~/.claude.json)
    if [ -n "$project_path" ]; then
        mcp_block=$(get_mcp_block_from_local_scope "$project_path" "$mcp_name")
    fi

    # 2. Try project scope first (.mcp.json in project directory)
    if [ -z "$mcp_block" ] && [ -n "$project_path" ]; then
        mcp_block=$(get_mcp_block_from_project_scope "$mcp_name")
    fi
    
    # 3. Try user scope (global config in ~/.claude.json)
    if [ -z "$mcp_block" ] && [ -n "$project_path" ]; then
        mcp_block=$(get_mcp_block_from_user_scope "$mcp_name")
    fi
    
    echo "$mcp_block"
}


get_mcp_command() {
    local mcp_block="$1"
    
    if [ -z "$mcp_block" ]; then
        echo "null"
        return 1
    fi
    
    # Check if it's a stdio MCP
    if is_stdio_mcp "$mcp_block"; then
        # Extract command field
        local command=$(echo "$mcp_block" | grep -m 1 '"command"' | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
        if [ -z "$command" ]; then
            echo "null"
        else
            echo "$command"
        fi
    else
        echo "null"
    fi
}


generate_unique_id() {
    local timestamp=$(date +%s%N)
    local random_part=$RANDOM
    echo "${timestamp}_${random_part}"
}


validate_and_set_null_if_needed() {
    local value="$1"
    
    if [ "$value" != "null" ]; then
        echo "\"${value}\""
    else
        echo "null"
    fi
}


add_metada_and_save() {
    local input_data="$1"
    
    # Extract MCP name from tool_name (e.g., mcp__fury__search_sdk_docs -> fury)
    local mcp_name=$(echo "$input_data" | grep -o 'mcp__[^_]*__' | sed 's/mcp__//; s/__//')
    
    # Get MCP block once with priority: project config first, then global config
    local mcp_block=$(get_mcp_block_with_priority "$mcp_name")
    
    # Extract URL and command from the block
    local mcp_url=$(get_mcp_url "$mcp_block")
    local mcp_command=$(get_mcp_command "$mcp_block")
    
    # Get other metadata
    local app_name=$(get_project_name)
    local utc_timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    local session_id=$(generate_unique_id "$input_data")
    local user_id=$(whoami | base64)
    
    # Build the final JSON with metadata (always include mcp_command, can be null)
    # Format mcp_url and mcp_command: if "null" string, use JSON null, otherwise quote as string
    local mcp_url_json=$(validate_and_set_null_if_needed "$mcp_url")
    local mcp_command_json=$(validate_and_set_null_if_needed "$mcp_command")
    
    local modified_json="{\"fury_app\":\"${app_name}\",\"mcp_url\":${mcp_url_json},\"mcp_command\":${mcp_command_json},\"utc_time\":\"${utc_timestamp}\",\"id\": \"$user_id\", \"crude_data\":$input_data}"
    
    # Save to file
    save_data "$modified_json" "$HOME/.claude/logs/${session_id}_logs.json"
}

# Main processing function
process_mcp_hook() {
    local input_data=$(cat)

    # Test input data. You can uncomment the one you want to test to check the flow.
    # mcp http
    # local input_data='{"session_id":"7929176f-f924-4f35-8da3-4d6c1e2b1f7c","transcript_path":"/Users/julianestehe/.claude/projects/-Users-julianestehe-apps-tooling-genai-fury-mcp-prompt-reviewer/7929176f-f924-4f35-8da3-4d6c1e2b1f7c.jsonl","cwd":"/Users/julianestehe/apps/tooling-genai/fury_mcp-prompt-reviewer","permission_mode":"default","hook_event_name":"PostToolUse","tool_name":"mcp__fury__search_sdk_docs","tool_input":{"query":"workqueue SDK complete documentation setup configuration operations client","language":"java","service":"workqueue"}}'
    # mcp stdio
    # local input_data='{"session_id":"c548bfeb-964a-4137-ac59-e4d451ab75ce","transcript_path":"/Users/julianestehe/.claude/projects/-Users-julianestehe-apps-tooling-genai-fury-mcp-prompt-reviewer/c548bfeb-964a-4137-ac59-e4d451ab75ce.jsonl","cwd":"/Users/julianestehe/apps/tooling-genai/fury_mcp-prompt-reviewer","permission_mode":"default","hook_event_name":"PostToolUse","tool_name":"mcp__revisor__changes_review","tool_input":{"repository_path":"/Users/julianestehe/apps/tooling-genai/fury_mcp-prompt-reviewer","application_name":"mcp-prompt-reviewer","base_branch":"master","language":"python"},"tool_response":[{"type":"text","text":"test response"}]}'
    # print everythin to debug
    # echo "$input_data" >> "$HOME/.claude/logs/logs.json" 2>/dev/null

    local event_name=$(echo "$input_data" | grep -o '"hook_event_name":"[^"]*"' | sed 's/.*:"\([^"]*\)".*/\1/')
    case "$event_name" in
        "PostToolUse")
            add_metada_and_save "$input_data"
            ;;
    esac
}

# Main execution
process_mcp_hook
