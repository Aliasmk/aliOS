# aliOS
Rudimentary x86 Operating System Project

aliOS will take multiple forms throughout this project. Each version will ideally build up additional functionality and complexity from the previous, starting from a 16-bit real mode Hello World program.

## Current Status:
Can boot img file in Virtual Box as a floppy. Displays "aliOS -- Hello World"

Prompts for text, and when entered it will echo what you wrote. It can also can compare strings and if the user types 'ayy' it will echo 'lmao'.

Migrated text related-code to a new main file, which is loaded and called from the bootloader. Now the main can be expanded further beyond 512 bytes if so desired.