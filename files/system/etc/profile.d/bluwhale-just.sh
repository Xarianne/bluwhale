#!/bin/bash
# System-wide alias for bluwhale just recipes

# Point directly to the MASTER Justfile
alias ujust='just --justfile /usr/share/bluwhale/just/Justfile --working-directory ~'

# The user-friendly entry point
alias show-menu='ujust menu'
