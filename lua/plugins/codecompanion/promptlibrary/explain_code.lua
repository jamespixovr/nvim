return {
  strategy = 'chat',
  description = 'Explain how the code works',
  prompts = {
    {
      role = 'system',
      content = 'You are an expert programmer skilled at explaining complex code in a clear and concise manner. Break down the explanation into logical components and highlight key concepts.',
    },
    {
      role = 'user',
      content = 'Please explain how the following code works:' .. '\n ',
    },
  },
  -- prompt = 'Please explain how this code works in detail.',
}
