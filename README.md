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

## Installation

## Usage

1) :VGPStartDialogue
    - In any vim window opens a new buffer that lets you have a dialogue
2) :VGPSendDialogue
    - Must be executed inside a "dialogue" window that sends the dialogue GPT api for
    completion. A question by the user must be prefixed with <<ME>>. The answers from the
    AI are prefixed with <<AI>>. The <<ME>> and <<AI>> tags are required.
