import tkinter as tk
import customtkinter as ctk
import subprocess

 
def handle_output(output,error):
    error_text = ""
    result_text = ""
    for line in output.split("\n"):
        if "Error :"  in line or "Debug :" in line:
            error_text += line + "\n"
        else:
            result_text += line + "\n"
    # error_text += error_text.strip()    
    output_textbox.delete("1.0", tk.END)
    output_textbox.insert(tk.END, result_text)

    error_textbox.delete("1.0", tk.END)
    error_textbox.insert(tk.END, error_text)

def run_code():
    user_code = code_input.get("1.0", tk.END).strip()
    process = subprocess.Popen(["../src/program.exe"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate(input=user_code.encode())
    handle_output(stdout.decode(), stderr.decode())

ctk.set_appearance_mode("light")
ctk.set_default_color_theme("blue")

root = ctk.CTk()
root.title("Compiler GUI")
root.geometry("1600x900")
root.configure(padx=20, pady=20)

header_frame = ctk.CTkFrame(root, corner_radius=15, fg_color="#f0f0f0")
header_frame.grid(row=0, column=0, columnspan=3, sticky="nsew", padx=10, pady=(0, 20))

header_label = ctk.CTkLabel(header_frame, text=" Compiler Project", font=("Consolas", 32, "bold"))
header_label.pack(pady=10)

input_frame = ctk.CTkFrame(root, corner_radius=15, fg_color="#e6e6e6")
input_frame.grid(row=1, column=0, rowspan=2, padx=10, pady=10, sticky="nsew")

input_label = ctk.CTkLabel(input_frame, text="Code Input:", font=("Consolas", 18, "bold"))
input_label.pack(anchor="w", padx=10, pady=(10, 5))

code_input = ctk.CTkTextbox(input_frame, font=("Consolas", 16), wrap=tk.WORD, corner_radius=12, height=15, width=50)
code_input.pack(expand=True, fill="both", padx=10, pady=10)

output_frame = ctk.CTkFrame(root, corner_radius=15, fg_color="#e6e6e6")
output_frame.grid(row=1, column=1, padx=10, pady=10, sticky="nsew")

output_label = ctk.CTkLabel(output_frame, text="Output:", font=("Consolas", 18, "bold"))
output_label.pack(anchor="w", padx=10, pady=(10, 5))

output_textbox = ctk.CTkTextbox(output_frame, font=("Consolas", 16), wrap=tk.WORD, corner_radius=12, height=15, width=50)
output_textbox.pack(expand=True, fill="both", padx=10, pady=10)

error_frame = ctk.CTkFrame(root, corner_radius=15, fg_color="#e6e6e6")
error_frame.grid(row=2, column=1, padx=10, pady=10, sticky="nsew")

error_label = ctk.CTkLabel(error_frame, text="Errors:", font=("Consolas", 18, "bold"), text_color="red")
error_label.pack(anchor="w", padx=10, pady=(10, 5))

error_textbox = ctk.CTkTextbox(error_frame, font=("Consolas", 16), wrap=tk.WORD, corner_radius=12, height=10, width=50, fg_color="#ffe6e6")
error_textbox.pack(expand=True, fill="both", padx=10, pady=10)

button_frame = ctk.CTkFrame(root, corner_radius=15, fg_color="#f0f0f0")
button_frame.grid(row=3, column=0, columnspan=2, padx=10, pady=10, sticky="nsew")

run_button = ctk.CTkButton(button_frame, text="◀ Run Code", font=("Consolas", 16, "bold"), command=run_code, width=150, height=50)
run_button.grid(row=0, column=0, padx=20, pady=20)

clear_button = ctk.CTkButton(button_frame, text="Clear Input", font=("Consolas", 16, "bold"), command=lambda: code_input.delete("1.0", tk.END), width=150, height=50)
clear_button.grid(row=0, column=1, padx=20, pady=20)

exit_button = ctk.CTkButton(button_frame, text="Exit", font=("Consolas", 16, "bold"), command=root.destroy, width=150, height=50)
exit_button.grid(row=0, column=2, padx=20, pady=20)

root.grid_rowconfigure(1, weight=3)
root.grid_rowconfigure(2, weight=2)
root.grid_columnconfigure(0, weight=3)
root.grid_columnconfigure(1, weight=2)

root.mainloop()
