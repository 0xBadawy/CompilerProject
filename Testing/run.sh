#!/bin/bash
flex text1.l && gcc lex.yy.c -o a && ./a
