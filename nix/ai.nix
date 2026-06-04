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

  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
  };

  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    context = ./../ai/.claude/CLAUDE.md;
    settings = {
      theme = "auto";
      editorMode = "vim";
      skipAutoPermissionPrompt = true;
      permissions.defaultMode = "auto";
      hooks = {
        Stop = [
          {
            matcher = "*";
            hooks = [{
              type = "command";
              command = "~/.config/tmux/session-notify.sh";
            }];
          }
        ];
      };
    };
  };
}
