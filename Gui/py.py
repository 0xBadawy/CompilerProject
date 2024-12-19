import tkinter as tk
import customtkinter as ctk
import subprocess

def run_calculator():
    user_input = text_input.get("1.0", tk.END).strip()  # Get input from Text widget
    process = subprocess.Popen(["Compiler\\program.exe"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate(input=user_input.encode())  # Send input to calc.exe
    result_output.delete("1.0", tk.END)  # Clear previous output
    result_output.insert(tk.END, stdout.decode())  # Display output

# Set the appearance mode and the theme
ctk.set_appearance_mode("light")  # You can also use "dark" mode
ctk.set_default_color_theme("green")  # Choose a color theme

root = ctk.CTk()  # Use CTk instead of Tk for a custom window
root.title("Lex/Yacc Calculator")
root.geometry("800x800")  # Set window size

# Make the window responsive by adjusting the grid's weights
root.grid_rowconfigure(0, weight=1, minsize=50)  # Make row 0 flexible
root.grid_rowconfigure(1, weight=0, minsize=50)  # Make row 1 fixed
root.grid_rowconfigure(2, weight=1, minsize=50)  # Make row 2 flexible
root.grid_columnconfigure(0, weight=1, minsize=200)  # Make column 0 flexible
root.grid_columnconfigure(1, weight=0, minsize=200)  # Make column 1 fixed

# Create and style the input text box using customtkinter
text_input = ctk.CTkTextbox(root, height=10, width=30, font=("Helvetica", 12), wrap=tk.WORD, corner_radius=8)
text_input.grid(row=0, column=0, padx=20, pady=10, sticky="nsew")

# Create and style the run button using customtkinter
run_button = ctk.CTkButton(root, text="Run Calculation", command=run_calculator, width=200, height=40, font=("Helvetica", 12, "bold"))
run_button.grid(row=1, column=0, padx=20, pady=10, sticky="nsew")

# Create and style the result output text box using customtkinter
result_output = ctk.CTkTextbox(root, height=10, width=30, font=("Helvetica", 12), wrap=tk.WORD, corner_radius=8)
result_output.grid(row=2, column=0, padx=20, pady=10, sticky="nsew")


root.mainloop()
