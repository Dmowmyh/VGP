"TODO
"Syntax highlighting of <<ME>> and <<AI>> block
"User configuration of TAGS
"User configuration of split (horizontal or vertical)
"Command to set current buffer as dialogue buffer
"Control of set wrap
"User configuration of gpt model
"User configuration to initial AI role and specifics
"Add token information
"Customize highlight colors

function! VGPStartDialogue()
python3 << EOF

import os
import openai
import vim

ME_TAG = "<<ME>>"

vim.command("vnew")
vim.command("let b:is_ai_buffer=1")
vim.command("set wrap")
vim.command("syntax match VGPHighlightTags /<<AI>>/")
vim.command("syntax match VGPHighlightTags /<<ME>>/")
vim.command("hi VGPHighlightTags ctermfg=Green")
vim.current.buffer[0] = ME_TAG

EOF
endfunction
command VGPStartDialogue call VGPStartDialogue()

function! VGPSendDialogue()
python3 << EOF

from io import StringIO

def parse_dialogue(string_io, me_tag, ai_tag):
    content = string_io.read()
    start = 0  
    message_list = []
    while True:
        me_start = content.find(me_tag, start)
        if me_start == -1:
            break

        ai_start = content.find(ai_tag, me_start + len(me_tag))

        if ai_start == -1:
            me_content = content[me_start + len(me_tag):].strip()
            message_list.append({"role": "user", "content": me_content})
            break

        me_content = content[me_start + len(me_tag):ai_start].strip()
        message_list.append({"role": "user", "content": me_content})

        ai_end = content.find(me_tag, ai_start + len(ai_tag))
        if ai_end == -1:
            ai_end = len(content)

        ai_content = content[ai_start + len(ai_tag):ai_end].strip()
        message_list.append({"role": "system", "content": ai_content})

        start = ai_end
    return message_list

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
OPENAI_MODEL = "gpt-3.5-turbo"
openai.api_key = OPENAI_API_KEY
ME_TAG = "<<ME>>"
AI_TAG = "<<AI>>"

is_ai_buffer = vim.eval('exists("b:is_ai_buffer")')
if is_ai_buffer == '1':
    result = '\n'.join(vim.current.buffer[:])
    s = StringIO(result)
    msg_list = parse_dialogue(s, ME_TAG, AI_TAG)
    completion = openai.ChatCompletion.create(
        model=OPENAI_MODEL,
        messages=msg_list
    )
    response = completion.choices[0].message.content;
    vim.current.buffer.append(AI_TAG)
    vim.current.buffer.append(response.splitlines())
    vim.current.buffer.append(ME_TAG)
else:
    raise vim.error("""Buffer does not support ai dialogue, you have to
        let b:is_ai_buffer='1'""")

EOF
endfunction
command VGPSendDialogue call VGPSendDialogue()
