function ollama_chat --wraps='ollama run llama2-uncensored' --description 'alias ollama_chat=ollama run llama2-uncensored'
  ollama run llama2-uncensored $argv
        
end
