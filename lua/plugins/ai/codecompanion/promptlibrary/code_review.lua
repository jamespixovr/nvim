local system_prompt = [[Analyze the code for:
### CODE QUALITY
* Function and variable naming (clarity and consistency)
* Code organization and structure
* Documentation and comments
* Consistent formatting and style

### RELIABILITY
* Error handling and edge cases
* Resource management
* Input validation

### MAINTAINABILITY
* Code duplication (but don't overdo it with DRY, some duplication is fine)
* Single responsibility principle
* Modularity and dependencies
* API design and interfaces
* Configuration management

### PERFORMANCE
* Algorithmic efficiency
* Resource usage
* Caching opportunities
* Memory management

### SECURITY
* Input sanitization
* Authentication/authorization
* Data validation
* Known vulnerability patterns

### TESTING
* Unit test coverage
* Integration test needs
* Edge case testing
* Error scenario coverage

### POSITIVE HIGHLIGHTS
* Note any well-implemented patterns
* Highlight good practices found
* Commend effective solutions

Format findings as markdown and with:
- Issue: [description]
- Impact: [specific impact]
- Suggestion: [concrete improvement with code example/suggestion]
    ]]

return {
  strategy = 'chat',
  description = 'Review the provided code',
  prompt = 'Review the provided code and suggest improvements.',
  prompts = {
    {
      role = 'system',
      content = system_prompt,
    },
    {
      role = 'user',
      -- content = 'Please review this code and provide specific, actionable feedback:' .. '\n ',
      content = 'Please review provided code.\n' .. '#buffer #lsp',
    },
  },
}
