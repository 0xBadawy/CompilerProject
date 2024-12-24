# Simple Compiler Documentation

## Overview

This code implements a simple compiler-like parser for a programming language with support for variables, assignments, expressions, loops, conditionals, and printing. It utilizes the Bison parser generator and supports basic operations like addition, subtraction, multiplication, and division. It also allows for the declaration of variables of types `int`, `float`, `char`, and `string`.

## Data Structures

- `A[26]`: Integer array for storing integer values.
- `B[26]`: Float array for storing float values.
- `C[26]`: Char array for storing character values.
- `D[26][26]`: 2D array for storing string values.
- `var[26]`: Array to track the type of each variable.
- `l[26]`: Array for location storage for variables.
- `loc[26]`: Array for storing variable locations.
- `d[3]`, `op[3]`: Arrays for storing operations and conditions.
  
## Supported Tokens

- `ID`: Identifier (variable name).
- `CH`: Single character.
- `CHH`: String of characters.
- `NUM_INT`: Integer numbers.
- `NUM_FLOAT`: Float numbers.
- `INT`: Integer type keyword.
- `FLOAT`: Float type keyword.
- `CHAR`: Char type keyword.
- `STRING`: String type keyword.
- `PRINT`: Print keyword.
- `FOR`: For loop keyword.
- `IF`: If conditional keyword.
- `THEN`: Then keyword in conditionals.
- `ELSE`: Else keyword in conditionals.
  
## Non-Terminals

- `s`: Program statement (starting point of the grammar).
- `stm`: Single statement.
- `exp`, `term`, `factor`: Expressions, terms, and factors for arithmetic operations.
- `assm`: Assignment statement.
- `incd`: Increment/Decrement operations.
- `rel`: Relational expression.
- `log`: Logical expressions.
- `italz`: Variable initialization.
- `count`: Counter for loops.
- `cond`: Condition expression for loops.
- `for`: For loop statement.
- `if`: If-Else conditional statement.
- `decl`: Declaration of variables.

## Grammar Rules

### 1. Statements
- A program consists of a sequence of statements. Statements can be expressions, assignments, declarations, prints, if-statements, or loops.
  
### 2. For Loop
- A `for` loop follows the format `for(italz; cond; count){s}`. It supports both conditions based on location and variable arrays. The loop iterates based on specified conditions and modifies the variables accordingly.

### 3. Condition for Loop
- Conditions are checked using relational operators (`<`, `>`, `<=`, `>=`, `==`, `!=`) to control the execution of a loop.

### 4. Counter for Loop
- Increment and decrement operations for variables are supported using the `++` and `--` operators. These operations modify variables' values and affect loop execution.

### 5. If Condition
- Conditional checks are implemented with `if (log) then {...}` and `if (log) then {...} else {...}`. Logical expressions are evaluated using `&`, `|`, and `!` operators.

### 6. Variable Initialization
- Variables can be initialized using `int`, `float`, `char`, and `string` types. For example, `int a = 5;`.

### 7. Declarations
- Variables are declared with types (`int`, `float`, `char`, `string`) and can optionally be initialized. Errors are raised if variables are redeclared with a different type.

### 8. Print Statements
- Variables, strings, characters, or integers can be printed using the `print` keyword. Examples include `PRINT(ID)` for printing the value of a variable.

### 9. Expressions
- Arithmetic operations such as addition (`+`), subtraction (`-`), multiplication (`*`), and division (`/`) are supported within expressions.

### 10. Assignment
- Variables can be assigned new values using the assignment operator (`=`). For example, `a = 5;` or `b = 3.5;`.

## Error Handling

The following errors are handled:
- Syntax errors during parsing.
- Uninitialized variable usage.
- Redeclaring variables with a different type.
- Dividing by zero in arithmetic operations.

### Example of an Error:
```c
❌Error : variable not declared before
