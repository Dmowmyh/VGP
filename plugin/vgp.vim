"TODO
"Syntax highlighting of <<ME>> and <<AI>> block
"User configuration of TAGS
"Command to set current buffer as dialogue buffer
"User configuration to initial AI role and specifics
"Add token information
"Customize highlight colors
"Use stream and async

function! VGPStartDialogue()
python3 << EOF

import vim

ME_TAG = "<<ME>>"

if vim.eval('exists("g:vgp_split")') == '1':
    if vim.eval("g:vgp_split") == 'horizontal':
        vim.command("new")
    elif vim.eval("g:vgp_split") == 'vertical':
        vim.command("vnew")
    else:
        vim.command("vnew")
else:
    vim.command("vnew")

vim.command("let b:is_ai_buffer=1")
#vim.command("set wrap")
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
import vim
import openai

if vim.eval('exists("g:openai_key")') != '1':
    raise vim.error('''You must configure your openai api key with
    let g:openai_key = "YOUR_KEY"''')

if vim.eval('exists("g:openai_model")') != '1':
    raise vim.error('''You must choose gpt model with
    let g:openai_model = "MODEL_NAME"''')

OPENAI_API_KEY = vim.eval("g:openai_key")
openai.api_key = OPENAI_API_KEY
OPENAI_MODEL = vim.eval("g:openai_model")

if vim.eval('exists("b:is_ai_buffer")') != '1':
    raise vim.error("""Buffer does not support ai dialogue, you have to
        let b:is_ai_buffer='1'""")

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

ME_TAG = "<<ME>>"
AI_TAG = "<<AI>>"

def send_dialogue_and_output():
    result = '\n'.join(vim.current.buffer[:])
    s = StringIO(result)
    msg_list = parse_dialogue(s, ME_TAG, AI_TAG)
    completion = openai.ChatCompletion.create(
        model=OPENAI_MODEL,
        messages=msg_list,
        stream=False
    )
    response = completion.choices[0].message.content

    #TODO(): Information about token usage
    #usage = completion.usage
    #total_tokens = usage["total_tokens"]
    #prompt_tokens = usage["prompt_tokens"]
    #completion_tokens = usage["completion_tokens"]
    #vim.current.buffer[0:0] = [
    #    "Total tokens: " + str(total_tokens),
    #    "Prompt tokens: " + str(prompt_tokens),
    #    "Completion tokens: " + str(completion_tokens)
    #]

    vim.current.buffer.append(AI_TAG)
    vim.current.buffer.append(response.splitlines())
    vim.current.buffer.append(ME_TAG)

send_dialogue_and_output()

EOF
endfunction
command VGPSendDialogue call VGPSendDialogue()
