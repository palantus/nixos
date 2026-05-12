{ pkgs, inputs, ...}:
{
  home.packages = [
      inputs.opencode-src.packages.${pkgs.system}.default
  ];

  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    provider = {
      ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama (Local)";
        options = {
          "baseURL" = "http://localhost:11434/v1";
        };
        models = {
          "qwen3:8b-32k" = {
            name = "Qwen3";
            tool_call = true;
            limit = {
              context = 32768;
              output = 4096;
            };
          };
        };
      };
    };

    model = "ollama/qwen3:8b-32k";
    lsp = true;
    permission = {
      "*" = "allow";
    };
  };
}
