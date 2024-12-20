# Compiler Project: Lex and Yacc

This project involves building a compiler using Lex and Yacc. The instructions below will guide you on how to set up, run, and use a graphical user interface (GUI) with the compiler.

---

## How to Run Lex and Yacc in Visual Studio Code

### Step 1: Install Flex and Bison
- Download and install Flex and Bison from [WinFlexBison](https://sourceforge.net/projects/winflexbison/) or you can download the .exe file from `Program/Program.zip` file.

### Step 2: Update Environment Variables
1. Open the Start menu and search for "Environment Variables."
2. Click on **Environment Variables**.
3. Edit the `Path` variable by adding:
   - The path to `flex`.
   - The path to `gcc`.

### Step 3: Create Files
1. Create a new folder.
2. Add the following files to the folder:
   - `LexFile.l`
   - `YaccFile.y`

### Step 4: Install VS Code Extensions
Install the following extensions in Visual Studio Code:
- [Flex Extension](https://marketplace.visualstudio.com/items?itemName=daohong-emilio.yash)
- [Lex Extension](https://marketplace.visualstudio.com/items?itemName=luniclynx.lex)
- [Bison Extension](https://marketplace.visualstudio.com/items?itemName=luniclynx.bison)

#### How Run Lex Only ?
Run the following command in the terminal:
```bash
flex LexFile.l; gcc lex.yy.c -o Lex; ./Lex.exe
```

#### How Run Lex and Yacc ?
Run the following commands in the terminal:
```bash
flex LexFile.l; yacc -d YaccFile.y; gcc lex.yy.c -o lexer; gcc YaccFile.tab.c lex.yy.c -o program
```

### Step 5: Run in Visual Studio Code
1. Open the terminal in VS Code.
2. Execute:
   ```bash
   flex LexFile.l; yacc -d YaccFile.y; gcc lex.yy.c -o lexer; gcc YaccFile.tab.c lex.yy.c -o program
   ```
3. Run the compiled program:
   ```bash
   ./program.exe
   ```

---

## How to Use GUI with Lex and Yacc

This section explains how to create and use a GUI with the compiler, leveraging the `customtkinter` Python library.

### Step 1: Install Python
Download and install Python from [python.org](https://www.python.org/downloads/).

### Step 2: Install Required Libraries
Install `customtkinter` (or `tkinter`) by running:
```bash
pip install customtkinter
```

### Step 3: Create GUI File
1. Create a new file named `GUI.py`.
2. Import the required libraries:
   ```python
   import tkinter as tk
   import customtkinter as ctk
   import subprocess
   import os
   ```

### Step 4: Create a Function to Run Lex and Yacc
Define a function `use_GUI()` to run the program and display the output:
```python
def use_GUI():
    user_input = text_input.get("1.0", tk.END).strip()  
    process = subprocess.Popen(["program.exe"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate(input=user_input.encode())  
    result_output.delete("1.0", tk.END)  
    result_output.insert(tk.END, stdout.decode())  
```
- Ensure the path to `program.exe` is correct.
- This function captures user input, executes the program, and displays the output in the GUI.

### Step 5: Create the GUI Layout
Design the GUI:
```python
root = ctk.CTk()  
root.title("Compiler")
root.geometry("1400x800")  

root.grid_rowconfigure(0, weight=1, minsize=5)  
root.grid_rowconfigure(1, weight=0, minsize=5)
root.grid_columnconfigure(0, weight=1, minsize=5)
root.grid_columnconfigure(1, weight=0, minsize=5)  
root.grid_columnconfigure(2, weight=1, minsize=5)

text_input = ctk.CTkTextbox(root, height=10, width=30, font=("Consolas", 19, "bold"), wrap=tk.WORD, corner_radius=8)
text_input.grid(row=0, column=0, padx=20, pady=10, sticky="nsew")

result_output = ctk.CTkTextbox(root, height=10, width=30, font=("Consolas", 19, "bold"), wrap=tk.WORD, corner_radius=8)
result_output.grid(row=0, column=1, columnspan=3, padx=10, pady=10, sticky="nsew")

run_button = ctk.CTkButton(root, text="Run Code", command=use_GUI, width=200, height=40, font=("Consolas", 15, "bold"))
run_button.grid(row=2, column=0, padx=20, pady=10)

root.mainloop()
```

### Step 6: Run the GUI
Run `GUI.py` to start the graphical interface.

### Notes
- Ensure `program.exe` is in the same folder as `GUI.py`.
- After updating the Lex or Yacc files, rebuild the program using:
  ```bash
  flex LexFile.l; yacc -d YaccFile.y; gcc lex.yy.c -o lexer; gcc YaccFile.tab.c lex.yy.c -o program
  ```


### Youtube Videos 
- [How to install in VS-Code](https://www.youtube.com/watch?v=Zs99QnRUt5c&t)
- [Arabic Flex Tutorial](https://www.youtube.com/watch?v=Zs99QnRUt5c&list=PLd_aE3prUmHfvPeSMzUou3dUEMWIAjT-X)


---



This README file provides a comprehensive guide to setting up, running, and enhancing your compiler project with a GUI. Make sure to follow each step carefully for a successful implementation.

