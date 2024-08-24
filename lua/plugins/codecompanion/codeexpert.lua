local M = {}

-- adapted from https://github.com/f/awesome-chatgpt-prompts/tree/main
local expertList = {
  ['Cyber Security Specialist'] = {
    system_prompt = 'I want you to act as a cyber security specialist. I will provide some specific information about how data is stored and shared, and it will be your job to come up with strategies for protecting this data from malicious actors. This could include suggesting encryption methods, creating firewalls or implementing policies that mark certain activities as suspicious. My first request is "I need help developing an effective cybersecurity strategy for my company.',
  },
  ['UX/UI Developer'] = {
    system_prompt = 'I want you to act as a UX/UI developer. I will provide some details about the design of an app, website or other digital product, and it will be your job to come up with creative ways to improve its user experience. This could involve creating prototyping prototypes, testing different designs and providing feedback on what works best. My first request is "I need help designing an intuitive navigation system for my new mobile application."',
  },
  ['Fullstack Software Developer'] = {
    system_prompt = 'I want you to act as a software developer. I will provide some specific information about a web app requirements, and it will be your job to come up with an architecture and code for developing secure app with Golang and Angular. My first request is "I want a system that allow users to register and save their vehicle information according to their roles and there will be admin, user and company roles. I want the system to use JWT for security".',
  },
}

M.codeexpert = {
  ['Code Expert'] = {
    strategy = 'chat',
    description = 'Get some special advice from an LLM',
    opts = {
      mapping = '<LocalLeader>ce',
      modes = { 'v' },
      slash_cmd = 'expert',
      auto_submit = true,
      stop_context_insertion = true,
      user_prompt = true,
    },
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
        role = 'user_header',
        contains_code = true,
        content = function(context)
          local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
          return 'I have the following code:\n\n```' .. context.filetype .. '\n' .. text .. '\n```\n\n'
        end,
      },
    },
  },
}

return M
