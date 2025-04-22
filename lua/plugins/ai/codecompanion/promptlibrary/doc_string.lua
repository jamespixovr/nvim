return {
  strategy = 'inline',
  description = 'Add appropriate documentation to the selected code',
  opts = {
    short_name = 'docstrings',
    auto_submit = true,
  },
  prompts = {
    {
      role = 'system',
      content = function(context)
        return 'You are a senior '
          .. context.filetype
          .. ' developer. You add clear and appropriate documentation based on code context.'
          .. [[
			   Keep the following in mind when writing documentation:
				1. **Identify Key Points**: Carefully read the provided code to understand its functionality.
                2. **Review the Documentation**: Ensure the documentation:
                  - Includes necessary explanations.
                  - Helps in understanding the code's functionality.
                  - Follows best practices for readability and maintainability.
                  - Is formatted correctly.

                For C/C++ code: use Doxygen comments using `\` instead of `@`.
                For Python code: Use Docstring numpy-notypes format.
			 ]]
      end,
      opts = {
        visible = false,
      },
    },
    {
      role = 'user',
      content = function(context)
        local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
        return string.format(
          [[
Add appropriate documentation to this code:
- For functions: Add proper docstrings following language conventions, including types if present
- For configuration/script code: Add simple descriptive comments explaining purpose
- Do NOT modify any of the actual code - only add documentation
- Keep any existing documentation style
- Return the complete code with added documentation

```%s
%s
```]],
          context.filetype,
          text
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
