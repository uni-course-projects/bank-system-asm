# 🏦 Bank Management System – EMU8086 Assembly

A fully functional **console-based Bank Management System** developed in **x86 Assembly Language** for my university course project using the EMU8086 emulator.

Created by:

- **Umer**
- **Mashood**

Course: *Computer Organization & Assembly Language*

---

## Features

- 📝 Create a New Bank Account (Name + PIN)
- 🔐 PIN Verification (Secure login for actions)
- 💰 Deposit / Withdraw Money (Fixed denominations)
- 🧾 View Account Details (Name, PIN, Balance)
- 🛠️ Modify Account Name or PIN
- 🧹 Reset Account (Full wipe)
- 🚫 Error Handling for Invalid Actions (e.g., No account, wrong PIN, insufficient balance)

---

## Assembly Concepts Used

- **Memory Segmenting** – Code, data, and stack separation using `.model small`
- **Register-Based Operations** – AX, BX, SI, CX, etc. for core logic
- **Procedures & Macros** – For modularity and reusability
- **INT 21h DOS Interrupts** – Console input/output operations
- **Control Flow** – Loops, conditionals, menu navigation

---

## Development Tools

- **Assembler**: [EMU8086 Emulator]
- **Debugger**: Built-in EMU8086 debugger

---

## ▶️ How to Run

1. Download and install [EMU8086]
2. Open `bank-v5.asm` in EMU8086.
3. Assemble and run the program.
4. Follow on-screen prompts to navigate the banking menu.

---

## 🎓 What I Learned

- Translating real-world logic into low-level Assembly instructions
- Handling secure user input with direct memory manipulation
- Building modular, structured code using macros and procedures
- Debugging and testing low-level programs manually
