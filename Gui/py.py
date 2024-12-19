import tkinter as tk
import customtkinter as ctk
import subprocess

def run_calculator():
    user_input = text_input.get("1.0", tk.END).strip()  
    process = subprocess.Popen(["Compiler\\program.exe"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate(input=user_input.encode())  
    result_output.delete("1.0", tk.END)  
    result_output.insert(tk.END, stdout.decode())  

ctk.set_appearance_mode("light")  
ctk.set_default_color_theme("blue") 

root = ctk.CTk()  
root.title("Compiler Project")
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

run_button = ctk.CTkButton(root, text="Run Code", command=run_calculator, width=200, height=40, font=("Consolas", 12, "bold"))
run_button.grid(row=2, column=0, padx=20, pady=10)



root.mainloop()
