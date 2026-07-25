# lib/home/aider.nix
{
  ...
}: {

  programs.aider-chat = {
    enable = true;
    settings = {
      openai-api-base = "http://172.16.1.50:11434/v1";
      openai-api-key = "ollama";
      model = "openai/qwen2.5-coder:14b";
      edit-format = "diff";
      auto-test = true;
      test-cmd = "go test ./... -v";
      message = "Read docs/context/GEMINI.md and openspec/changes/fr-rsk-work-1/tasks.md. Implement the tasks in internal/risk/. Run tests until they pass.";
    };
  };

}
