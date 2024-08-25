local M = {}

-- adapted from https://github.com/f/awesome-chatgpt-prompts/tree/main
local expertList = {
  ['Cyber Security'] = {
    description = 'Act as a Cyber Security Specialist',
    system_prompt = 'I want you to act as a cyber security specialist. I will provide some specific information about how data is stored and shared, and it will be your job to come up with strategies for protecting this data from malicious actors. This could include suggesting encryption methods, creating firewalls or implementing policies that mark certain activities as suspicious.',
  },
  ['UX/UI Developer'] = {
    description = 'Act as a UX/UI Developer',
    system_prompt = 'I want you to act as a UX/UI developer. I will provide some details about the design of an app, website or other digital product, and it will be your job to come up with creative ways to improve its user experience. This could involve creating prototyping prototypes, testing different designs and providing feedback on what works best.',
  },
  ['Fullstack Software Developer'] = {
    description = 'Act as a Fullstack Software Developer',
    system_prompt = 'I want you to act as a software developer. I will provide some specific information about a web app requirements, and it will be your job to come up with an architecture and code for developing secure app with Golang and React.',
  },
}

function M.prompt_list()
  local default_prompts = {
    ['Code Expert'] = {
      strategy = 'chat',
      description = 'Get some special advice from an LLM',
      prompts = {
        {
          role = 'system',
          content = function(context)
            return 'I want you to act as a senior '
              .. context.filetype
              .. ' developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples.'
          end,
        },
        {
          role = 'user',
          contains_code = true,
          content = function(context)
            local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
            return 'I have the following code:\n\n```' .. context.filetype .. '\n' .. text .. '\n```\n\n'
          end,
        },
      },
    },
  }
  for k, v in pairs(expertList) do
    default_prompts[k] = {
      strategy = 'chat',
      description = v.description,
      prompts = {
        {
          role = 'system',
          content = v.system_prompt,
        },
        {
          role = '${user}',
          contains_code = true,
        },
      },
    }
  end
  return default_prompts
end

M.default_prompts = M.prompt_list()

return M
