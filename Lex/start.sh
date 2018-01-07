#!/bin/bash
lex httpRequest.l
gcc lex.yy.c -o prog -ll
./prog
