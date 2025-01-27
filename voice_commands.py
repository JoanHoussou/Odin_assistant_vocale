import tkinter as tk
from gui import AssistantGUI

def main():
    root = tk.Tk()
    gui = AssistantGUI(root)
    root.mainloop()

if __name__ == "__main__":
    main()