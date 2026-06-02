{ config, pkgs, lib, ... }:
{
  programs.mcp = {
    enable = true;
    servers = {
      jira = {
        type = "http";
        url = "https://mcp.atlassian.com/v1/mcp";
      };
      github = {
        type = "http";
        url = "https://api.githubcopilot.com/mcp/readonly";
        headers = {
          Authorization = "Bearer {env:GITHUB_TOKEN}";
        };
      };
      mongodb = {
        command = "npx";
        args = [ "-y" "mongodb-mcp-server@latest" "--readOnly" ];
        env = {
          MDB_MCP_CONNECTION_STRING = "mongodb://localhost:27017";
        };
      };
    };
  };

  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      theme = "auto";
      editorMode = "vim";
      skipAutoPermissionPrompt = true;
      permissions.defaultMode = "auto";
      hooks = {
        SessionStart = [
          {
            hooks = [{
              type = "command";
              command = ''f="AGENTS.md"; [ -f "$f" ] && jq -n --rawfile content "$f" '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":("Contents of AGENTS.md:\n\n" + $content)}}' 2>/dev/null || true'';
            }];
          }
          {
            hooks = [{
              type = "command";
              command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" SessionStart'';
            }];
          }
        ];
        PreToolUse = [{
          matcher = "*";
          hooks = [{
            type = "command";
            command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" PreToolUse'';
          }];
        }];
        PostToolUse = [{
          matcher = "*";
          hooks = [{
            type = "command";
            command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" PostToolUse'';
          }];
        }];
        Stop = [{
          matcher = "*";
          hooks = [{
            type = "command";
            command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" Stop'';
          }];
        }];
        SubagentStop = [{
          matcher = "*";
          hooks = [{
            type = "command";
            command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" SubagentStop'';
          }];
        }];
        Notification = [
          {
            matcher = "*";
            hooks = [{
              type = "command";
              command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" Notification'';
            }];
          }
          {
            matcher = "*";
            hooks = [{
              type = "command";
              command = "~/.config/tmux/session-notify.sh";
            }];
          }
        ];
        SessionEnd = [{
          hooks = [{
            type = "command";
            command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" SessionEnd'';
          }];
        }];
        UserPromptSubmit = [{
          hooks = [{
            type = "command";
            command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" UserPromptSubmit'';
          }];
        }];
      };
    };
  };

  home.activation.cloneAgentMonitor = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor" ]; then
      ${pkgs.git}/bin/git clone https://github.com/hoangsonww/Claude-Code-Agent-Monitor \
        "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor"
    fi
  '';
}
