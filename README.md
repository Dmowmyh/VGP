## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)

## Introduction

Simple vim plugin that lets you have a dialogue with a GPT model.

The motivation behind it is if you don't want to open ChatGPT from the
    browser you can emulate the same kind of dialogue in your vim.

You can save the new buffer or modify it (copy and paste code inside it)
    sending the new dialogue to a GPT model.

## Configuration
Configure the plugin by adding the following lines to your `.vimrc` or `init.vim`:
```vim
"Configure opeanai key and model
let g:openai_key = "your_openai_key_here"
let g:openai_model = "your_openai_model_here"

"Configure anthropic key and model
let g:anthropic_key = "your_anthropic_key_here"
let g:anthropic_model = "your_anthropic_model_here"

"Configure where the dialogue will be opened
let g:vgp_split = "horizontal" or "vertical"
```

## Installation

## Usage

Call the plugin with the following commands:
1) :VGPStartDialogue
    - In any vim window opens a new buffer that lets you have a dialogue
2) :VGPSendDialogue
    - Must be executed inside a "dialogue" window that sends the dialogue GPT api for
    completion. A question by the user must be prefixed with <<ME>>. The answers from the
    AI are prefixed with <<AI>>. The <<ME>> and <<AI>> tags are required.
