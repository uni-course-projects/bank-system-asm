; ****************************************************************************
;
; Project Title: Bank Management System

; Features:
; - Create Account, Deposit Money, Withdraw Money.
; - Print Account Details, Modify Account, Reset Account.
; - Dynamic PIN validation, PIN verification, Balance checks.  
;
; ----------  UMER (), MASHOOD ()
; 
;
; ****************************************************************************


     
.model small
.stack 100h



; ------------------------ Data Segment ------------------------
.data
      
      
    ; Splash Banner for the Bank Management System
        
    bank_sys_ban_1 db '||                       ||$'  
    bank_sys_ban_2 db '||  BANKING SYSTEM v5.0  ||$'  
    bank_sys_ban_3 db '||                       ||$'                                                                                                                                                                                
    
    ; Decorative Banners for Each Option
    op1mmsg1 db '||            ||$'  
    op1mmsg2 db '||  CREATE    ||$'  
    op1mmsg3 db '||            ||$'  
    
    op2mmsg1 db '||            ||$'  
    op2mmsg2 db '||  DETAILS   ||$'  
    op2mmsg3 db '||            ||$'
    
    op3mmsg1 db '||            ||$'  
    op3mmsg2 db '||  WITHDRAW  ||$'  
    op3mmsg3 db '||            ||$'  
                                                         
    op4mmsg1 db '||            ||$'  
    op4mmsg2 db '||  DEPOSIT   ||$'  
    op4mmsg3 db '||            ||$'                                                                          
    
    op5mmsg1 db '||            ||$'  
    op5mmsg2 db '||  MODIFY    ||$'  
    op5mmsg3 db '||            ||$'
    
    op0mmsg0 db 'Thank you for utilizing our banking system, see you again!$'

    
    ; Menu Options                                  
    opmsg1 db '1. Create New Bank Account $'
    opmsg2 db '2. Print Account Details $'
    opmsg3 db '3. Withdraw Money from Bank Account $'
    opmsg4 db '4. Deposit Money from Bank Account $'
    opmsg5 db '5. Reset Account (Caution: This completely removes everything) $'
    opmsg6 db '6. Modify Account Details (Modify existing account details) ', 10, 13, '7. Exit Program (Press "ESC" on your keyboard) $' 
    
    opmsg8 db 'Press "ENTER" to return to Main Menu... $'
    
    ; Prompts for User Input
    imsg db 'Enter your option: $'
    inputCode db ? 
    
     
    ; Account Details and Variables 
    accountName db 100 dup ('$')       ; Stores account name
    accountPIN db 100 dup ('$')        ; Stores account PIN
    accountPINcount dw 0               ; Number of digits in the PIN
    totalAmount dw 0                   ; Account balance
    inputAmountOption db ?             ; Selected option for deposit/withdraw 
                                  
    ; Option 1 (Create Account) Messages
    op1msg1 db '1. Enter Bank Account Name: $'
    op1msg2 db '2. Enter Bank Account PIN: $'    
    op1msg3 db 'Account has been successfully created. (Press Enter to return back to Main Menu) $'    
    
    ; Option 2 <Print details> Messages
    op2msg1 db 'Bank Account Name: $' 
    op2msg2 db 'Bank Account PIN: $'
    op2msg3 db 'No account currently exists within the database! $'   
    op2msg4 db 'Bank Balance: $'
    op2msg5 db 'Your bank balance is not sufficient enough. $'
    
    ; Option 4 <Money> Messages
    op4msg1 db '1. PKR 1,000 $'
    op4msg2 db '2. PKR 2,000 $'
    op4msg3 db '3. PKR 5,000 $'
    op4msg4 db '4. PKR 10,000 $'
    
    op4msg5 db 'Enter the corresponding number to the amount of cash that you want to engage with: $'  
    op4msg6 db 'You are trying to withdraw above the existing bank balance! (ERROR> $'
    
    ; Option 5 <Reset> Messages
    op5msg1 db 'Account has been reset successfully!', 10, 13, 'You may now create a new account. $'
    
    ; Option 6 <Modify Account> Messages  
    op6msg0   db 'Account Details Successfully Changed! $'
    op6msg1_1 db '1. New Account Name (old: $'
    op6msg1_2 db ' ) : $' 
    op6msg2_1 db '2. New Account PIN (old: $'
    op6msg2_2 db ' ) : $'
    
    ; PIN Protection
    pinop_msg1 db 'Enter Bank Account PIN: $' 
    pinop_msg2 db 'No account currently exists within the database. $'
    incorrect_pin_msg db 'Incorrect PIN. Press any key to retry or "ENTER" for Main Menu.', '$'
    

; ------------------------ Code Segment ------------------------  

.code   

;------------------------                                                                   

;  U T I L S            
                
;------------------------                                                                     


; Procedure: Wait for "Enter" Key
; Description: Pauses execution until the user presses the "Enter" key.

proc enter_to_continue
    
   enter_to_continue_input:
      mov ah, 1         ; DOS interrupt to read character input
      int 21h
      cmp al, 13        ; Check if "Enter" key (ASCII 13) is pressed
      je main_loop       ; Return to the main loop if pressed
      jmp enter_to_continue_input  
      
   ret
    
enter_to_continue endp

; ----------------------------------------------------------------------------

; Procedure: Check if Account Exists
; Description: Verifies if an account has been created by checking the PIN length.

checkAccountCreated proc
    
  cmp accountPINcount, 0      ; Check if the PIN digit count is zero
  je accountNotCreated        ; If yes, display "No account created" error
  ret                         ; Otherwise, return
  
  accountNotCreated:
    call clearScreen          ; Clear the screen
    printString pinop_msg2    ; Display "Account NOT created" message
    call enter_to_continue                  ; Wait for the user to press "Enter"
    
    ret
       
checkAccountCreated endp

; ----------------------------------------------------------------------------

; Procedure: Print Number
; Description: Converts a number in AX into ASCII characters and prints it.

printNumber proc                  
    ;initilize count 
    mov cx, 0 
    mov dx, 0
     
    digit_extraction:
    cmp ax, 0               ; Check if AX is zero
    je print_digits         ; If zero, proceed to print digits
    mov bx, 10              ; Divisor (base 10)
    div bx                  ; Divide AX by BX; remainder in DX
    push dx                 ; Push remainder (digit) onto the stack
    inc cx                  ; Increment digit count
    xor dx, dx              ; Clear DX for the next iteration
    jmp digit_extraction    ; Repeat until all digits are extracted
    
         
    print_digits:
    cmp cx, 0               ; Check if there are digits to print
    je exitprint            ; If no digits, exit
    pop dx                  ; Pop digit from the stack
    add dx, '0'             ; Convert to ASCII character
    mov ah, 2               ; DOS interrupt for character output
    int 21h
    dec cx                  ; Decrement digit count
    jmp print_digits        ; Continue printing digits
    
    exitprint: 
    ret 
    
printNumber endp

; ----------------------------------------------------------------------------

; Procedure: Clear Screen
; Description: Clears the console by simulating a screen clear with new lines.

clearScreen proc near
    
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    call newLine
    ret
        
clearScreen endp 

; ----------------------------------------------------------------------------

; Procedure: Print New Line
; Description: Prints a single new line (carriage return + line feed).
                                     
newLine proc near   
    
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h    
    ret
    
newLine endp

; ----------------------------------------------------------------------------

; Macro: Print String
; Description: Outputs a null-terminated string to the console.

printString macro str 
       
  lea dx, str
  mov ah, 9
  int 21h 
  
endm

; ----------------------------------------------------------------------------

; Procedure: Get PIN Input
; Description: Prompts the user for PIN input and validates against stored PIN.

getPinInput proc
    
    call clearScreen
  
    pin_input_loop:
        printString pinop_msg1          ; Display "Enter PIN" message
        
        mov si, offset accountPIN       ; Load stored PIN address
        mov cx, accountPINcount         ; Number of digits in the PIN
        mov di, 0                       ; Loop counter for entered digits

    input_digit:
        mov ah, 7                       ; DOS interrupt to read a single character
        int 21h
        cmp al, 13                      ; Check if "Enter" is pressed
        je main_loop                     ; Return to main menu if "Enter"

        cmp al, [si]                    ; Compare input digit with stored PIN
        jne incorrect_pin               ; If mismatch, jump to incorrect PIN handler

        mov dl, '*'                     ; Display asterisks for entered digits
        mov ah, 2
        int 21h

        inc si                          ; Move to next stored PIN digit
        inc di                          ; Increment input digit count
        loop input_digit                ; Repeat for all PIN digits
    
        ret                             ; Exit procedure on successful PIN match

    incorrect_pin:
        call clearScreen 
        
        printString incorrect_pin_msg   ; Display "Incorrect PIN" message
        call newLine 
        
        jmp pin_input_loop              ; Retry PIN input

getPinInput endp

; ----------------------------------------------------------------------------
                                                         
;    M E N U   SYSTEM  
                                                                  
; ----------------------------------------------------------------------------

; Procedure: Display Menu
; Description: Displays the main menu options on the screen.

DisplayMenu proc near
    
    ; Print decorative banner   
    printString bank_sys_ban_1
    call newLine
    
    printString bank_sys_ban_2
    call newLine
    
    printString bank_sys_ban_3
    call newLine
         
 
    
    ; Print menu options
    call newLine 
    
    printString opmsg1  ; Option 1: Create Account
    call newLine
    
    printString opmsg2  ; Option 2: Print Account Details
    call newLine
    
    printString opmsg3  ; Option 3: Withdraw Money
    call newLine
    
    printString opmsg4  ; Option 4: Deposit Money
    call newLine
    
    printString opmsg5  ; Option 5: Reset Account
    call newLine
    
    printString opmsg6  ; Option 6: Modify Account Details
    call newLine
    ret
            
DisplayMenu endp       

; ----------------------------------------------------------------------------

; Procedure: Get Input for Menu
; Description: Prompts the user to select an option from the menu.

GetInputMenuSystem proc near 
    
    call newLine
    printString imsg
    
    mov ah, 1
    int 21h
    
    mov inputCode, al 
    
    ret   
         
GetInputMenuSystem endp

; ---------------------------------------------------
                                                                   
;  1: CREATE ACCOUNT                                                                                    

; ---------------------------------------------------

; Macro: Input String for Account Name
; Description: Reads a string input from the user and stores it in a variable.

macro Input_String_Option_1_1 str 
    
    mov si, offset str  ; Load the destination address
    
    input: 
        mov ah, 1  ; DOS interrupt for single character input
        int 21h
        
        cmp al, 13      ; Check if "Enter" is pressed
        je Label_Option_1_1   ; Exit if "Enter" is pressed
        
        mov [si], al    ; Store character in destination
        inc si          ; Move to next byte
        
        jmp input       ; Repeat
        
    exitMac:
        ret
  
endm

; ----------------------------------------------------------------------------

; Macro: Input PIN for Account
; Description: Reads a string input from the user and stores it in a variable.

macro Input_String_Option_1_2 str 
    
    mov si, offset str  ; Load the destination address
    
    input2: 
        mov ah, 1       ; DOS interrupt for single character input
        int 21h
        
        cmp al, 13      ; Check if "Enter" is pressed
        je Label_Option_1_2   ; Exit if "Enter" is pressed
        
        inc accountPINcount
        
        mov [si], al    ; Store character in destination
        inc si          ; Move to next byte
        jmp input2      ; Repeat
        
    exitMac2:
        ret
  
endm

; ----------------------------------------------------------------------------

proc enter_to_continue_prog_1
    
   enter_to_continue_prog_1_in:
      mov ah, 1
      int 21h
      
      cmp al, 13
      je main_loop
      
      jmp enter_to_continue_prog_1_in
      
   ret
    
enter_to_continue_prog_1 endp

; ----------------------------------------------------------------------------

; Procedure: Create Account
; Description: Allows the user to create an account by entering a name and PIN.

option_1_prog proc
        
    call clearScreen
    
    ; Display "Create Account" Banner
    printString op1mmsg1
    call newLine
    
    printString op1mmsg2
    call newLine
    
    printString op1mmsg3
    call newLine
    
    call newLine
    
    ; Input Account Name
    
    printString op1msg1  ; Prompt for account name
    Input_String_Option_1_1 accountName   ; Read user input into 'accountName'
    
    ; Input Account PIN
    
    Label_Option_1_1: 
    
      call newLine  
      printString op1msg2 ; Prompt for account PIN 
      Input_String_Option_1_2 accountPIN   ; Read user input into 'accountPIN'
    
    Label_Option_1_2:
        
        call newLine
        call newLine
        
        printString op1msg3  ; Display success message
        call enter_to_continue_prog_1          ; Wait for "Enter" to return to menu
           
    ret
    
option_1_prog endp

; ----------------------------
                                                                   
;   2:  DETAILS                 
                                                      
; ----------------------------        

; Procedure: enter_to_continue_prog_2
; Logic: Ensures the user acknowledges the end of the process by pressing "Enter" 
;        before returning to the main menu. This prevents abrupt menu transitions.

proc enter_to_continue_prog_2
    
   call newLine                  ; Insert a blank line for readability
   printString opmsg8            ; Prompt: "Press Enter to Return to Main Menu"
   
   enter_to_continue_prog_2_in:
      mov ah, 1                  ; DOS interrupt to read a single key
      int 21h
      
      cmp al, 13                 ; Check if the key is "Enter"
      je main_loop                ; If "Enter" is pressed, return to the main menu
      
      jmp enter_to_continue_prog_2_in               ; Otherwise, keep waiting for "Enter"
      
   ret
    
enter_to_continue_prog_2 endp

; ---------------------------------------------------------------------------- 

; Procedure: option_2_prog
; Logic: Displays the stored account details only if an account exists 
;        and the correct PIN is entered. Shows the account name, PIN, and balance.

option_2_prog proc
  
  call checkAccountCreated  ; Validate if the account has been created 
  call getPinInput  ; Verify the user by comparing entered PIN with stored PIN
  call clearScreen  ; Clear the console to prepare for fresh output
  
  
  
  ; Display a banner for "Account Details"
  
    printString op2mmsg1       ; Line 1 of the banner
    call newLine
    
    printString op2mmsg2       ; Line 2 of the banner
    call newLine 
    
    printString op2mmsg3       ; Line 3 of the banner
    call newLine  
  
    call newLine              ; Additional spacing for readability
    
  
  ; Print Account Name
    printString op2msg1        ; Prompt: "Account Name: "
    printString accountName    ; Output the stored account name
    call newLine
  
  ; Print Account PIN
    printString op2msg2        ; Prompt: "Currently Saved Account PIN: "
    printString accountPIN     ; Output the stored account PIN
    call newLine   
  
  ; Print Account Balance
  printString op2msg4          ; Prompt: "Total Money Left: "
  
  mov ax, totalAmount          ; Load the stored account balance into AX
  cmp ax, 0                    ; Check if the balance is zero
  
  je InsufficientBalanceError              ; If no balance, skip to the error message
  
  call printNumber             ; Convert and display the numeric balance
  call newLine
  
  call enter_to_continue_prog_2                  ; Wait for the user to acknowledge
  
  InsufficientBalanceError:
    printString op2msg5        ; Display: "You Have No Money"
    call newLine 
    
    call enter_to_continue_prog_2                ; Wait for the user to acknowledge
    
  ret             
  
option_2_prog endp 

; --------------------------------------
                                                                
;  3:  WIDTHDRAW           

; --------------------------------------
            
; Procedure: enter_to_continue_prog_3
; Logic: Ensures the user presses "Enter" before returning to the main menu,
;        similar to other options. Prevents abrupt transitions.

proc enter_to_continue_prog_3  
    
    call newLine              ; Insert a blank line for better spacing
    printString opmsg8         ; Prompt: "Press Enter to Return to Main Menu"
    
    enter_to_continue_prog_3_in:
    mov ah, 1                  ; DOS interrupt to read a single key
    int 21h                                                         
    
    cmp al, 13                 ; Check if the key is "Enter"
    je main_loop                ; If "Enter" is pressed, return to the main menu  
    
    jmp enter_to_continue_prog_3_in        ; Otherwise, wait for "Enter" 
    
    ret
    
enter_to_continue_prog_3 endp

; ----------------------------------------------------------------------------

; Procedure: option_3_prog
; Logic: Allows the user to withdraw money in fixed denominations. 
;        Ensures the account exists, PIN is verified, and sufficient balance is available.

option_3_prog proc
  
  call checkAccountCreated  ; Validate if the account has been created
  call getPinInput  ; Verify the user by comparing entered PIN with stored PIN
  call clearScreen  ; Clear the console for better user experience
  
   
  ; Display a banner for "Withdraw Money"
  
    printString op3mmsg1       ; Line 1 of the banner
    call newLine
    
    printString op3mmsg2       ; Line 2 of the banner
    call newLine 
    
    printString op3mmsg3       ; Line 3 of the banner
    call newLine
    
    
    call newLine
    call newLine
  
  ; Display withdrawal options 
  
    printString op4msg1        ; Option: "1. Rs 1000"
    call newLine 
    
    printString op4msg2        ; Option: "2. Rs 2000"
    call newLine
    
    printString op4msg3        ; Option: "3. Rs 5000"
    call newLine 
    
    printString op4msg4        ; Option: "4. Rs 10000"
    call newLine
  
  call inputAmountCode       ; Get the user’s choice for withdrawal amount  
  
  ; Handle the withdrawal logic based on the user’s choice
  
  cmp inputAmountOption,'1'
  je withdraw_op_1  ; If '1', attempt to withdraw Rs 1000
  
  cmp inputAmountOption,'2'
  je withdraw_op_2  ; If '2', attempt to withdraw Rs 2000
  
  cmp inputAmountOption,'3'
  je withdraw_op_3  ; If '3', attempt to withdraw Rs 5000
  
  cmp inputAmountOption,'4'
  je withdraw_op_4  ; If '4', attempt to withdraw Rs 10000
  
  
  ; Withdrawal Handlers
    
  withdraw_op_1:
    mov bx, totalAmount        ; Load the current balance into BX
    cmp bx, 1000               ; Check if the balance is at least Rs 1000
    
    jl InsufficientWithdrawalBalance                ; If insufficient, jump to the error handler
    
    sub totalAmount, 1000      ; Deduct Rs 1000 from the balance
    jmp main_loop               ; Return to the main menu
    
  withdraw_op_2:        
    mov bx, totalAmount        ; Load the current balance into BX
    cmp bx, 2000               ; Check if the balance is at least Rs 2000
    
    jl InsufficientWithdrawalBalance                ; If insufficient, jump to the error handler
    
    sub totalAmount, 2000      ; Deduct Rs 2000 from the balance
    jmp main_loop               ; Return to the main menu 
    
  withdraw_op_3:        
    mov bx, totalAmount        ; Load the current balance into BX
    cmp bx, 5000               ; Check if the balance is at least Rs 5000
    
    jl InsufficientWithdrawalBalance                ; If insufficient, jump to the error handler
    
    sub totalAmount, 5000      ; Deduct Rs 5000 from the balance
    jmp main_loop               ; Return to the main menu 
    
  withdraw_op_4:        
    mov bx, totalAmount        ; Load the current balance into BX
    cmp bx, 10000               ; Check if the balance is at least Rs 10,000
    
    jl InsufficientWithdrawalBalance                ; If insufficient, jump to the error handler
    
    sub totalAmount, 10000     ; Deduct Rs 10,000 from the balance
    jmp main_loop                    
   
  ; Error Handler: Insufficient Balance+ 
  InsufficientWithdrawalBalance:
    
    call newLine
    call newLine
    
    printString op4msg6        ; Display: "You Are Withdrawing Too MUCH!" 
    
    call enter_to_continue_prog_3                ; Wait for user acknowledgment, "enter".
   
  ret  

option_3_prog endp 

; ------------------------

; 4: DEPOSIT                  
           
; ------------------------

; Procedure: enter_to_continue_prog_4
; Logic: Ensures the user presses "Enter" before returning to the main menu 
;        after completing or cancelling a deposit operation

proc enter_to_continue_prog_4
    
   call newLine              ; Insert a blank line for better readability
   printString opmsg8         ; Prompt: "Press Enter to Return to Main Menu"
    
   enter_to_continue_prog_4_in:                  
      mov ah, 1               ; DOS interrupt to read a single key
      int 21h 
      
      cmp al, 13              ; Check if the key is "Enter"
      je main_loop             ; If "Enter" is pressed, return to the main menu
      
      jmp enter_to_continue_prog_4_in            ; Otherwise, wait for "Enter"
      
   ret 
   
enter_to_continue_prog_4 endp

; ----------------------------------------------------------------------------

; Procedure: inputAmountCode
; Logic: Prompts the user to select a deposit amount and stores their choice.

proc inputAmountCode
    
  call newLine              ; Add spacing before prompt
  printString op4msg5       ; Prompt: "Enter Code"
  
  mov ah, 1                 ; DOS interrupt for single key input
  int 21h
  
  mov inputAmountOption, al ; Store user input in `inputAmountOption`
  
  ret  
  
inputAmountCode endp

; ----------------------------------------------------------------------------

; Procedure: option_4_prog
; Logic: Allows the user to deposit money in fixed denominations. 
;        Ensures the account exists and the PIN is verified.

option_4_prog proc
  
  call checkAccountCreated  ; Ensure an account exists
  call getPinInput          ; Verify the user's PIN 
  
  call clearScreen          ; Clear the screen for fresh output
  
  ; Display "Deposit Money" Banner
    printString op4mmsg1       ; Line 1 of the banner
    call newLine  
    
    printString op4mmsg2       ; Line 2 of the banner
    call newLine  
    
    printString op4mmsg3       ; Line 3 of the banner
    call newLine  
    

    call newLine
  
  ; Display Deposit Options
    printString op4msg1        ; Option: "1. Rs 1000"
    call newLine
    
    printString op4msg2        ; Option: "2. Rs 2000"
    call newLine
    
    printString op4msg3        ; Option: "3. Rs 5000"
    call newLine 
    
    printString op4msg4        ; Option: "4. Rs 10000"
    call newLine
  
  call inputAmountCode         ; Get the user’s choice for deposit amount
  
  ; Process Deposit Options
  cmp inputAmountOption, '1'   ; If '1', add Rs 1000
  je deposit_op_1
  
  cmp inputAmountOption, '2'   ; If '2', add Rs 2000
  je deposit_op_2 
  
  cmp inputAmountOption, '3'   ; If '3', add Rs 5000
  je deposit_op_3
  
  cmp inputAmountOption, '4'   ; If '4', add Rs 10000
  je deposit_op_4
  
  ; Deposit Amount Handlers
   
  deposit_op_1:    
    add totalAmount, 1000      ; Add Rs 1000 to the account balance
    jmp main_loop               ; Return to the main menu
    
  deposit_op_2:
    add totalAmount, 2000      ; Add Rs 2000 to the account balance
    jmp main_loop               ; Return to the main menu
    
  deposit_op_3:
    add totalAmount, 5000      ; Add Rs 5000 to the account balance
    jmp main_loop               ; Return to the main menu
    
  deposit_op_4:
    add totalAmount, 10000      ; Add Rs 10,000 to the account balance
    jmp main_loop               ; Return to the main menu
   
  ret  

option_4_prog endp

; ----------------------------------------------------------------------------

;  5: RESET ACCOUNT                  

; ----------------------------------------------------------------------------

; Procedure: enter_to_continue_prog_5
; Logic: Ensures the user presses "Enter" to acknowledge the reset operation 
;        and return to the main menu.

proc enter_to_continue_prog_5
    
   call newLine              ; Insert a blank line for readability
   printString opmsg8         ; Prompt: "Press Enter to Return to Main Menu" 
   
   enter_to_continue_prog_5_in:
      mov ah, 1               ; DOS interrupt to read a single key
      int 21h
      
      cmp al, 13              ; Check if the key is "Enter"
      je main_loop             ; Return to the main menu if "Enter" is pressed
      
      jmp enter_to_continue_prog_5_in            ; Otherwise, keep waiting for "Enter"
      
   ret
    
enter_to_continue_prog_5 endp

; ----------------------------------------------------------------------------

; Procedure: option_5_prog
; Logic: Resets the account by clearing the name, PIN, and balance. 
;        Resets the PIN digit count to zero and informs the user of success.


option_5_prog proc
  
  call checkAccountCreated     ; Ensure an account exists
  call getPinInput             ; Verify the user's PIN   
    
  
  call clearScreen
  
  ; Clear the account name by overwriting it with spaces
  
  mov si, offset accountName   ; Load the starting address of the account name
  mov cx, 100                   ; Number of bytes to clear
  
  clearAccountName:
    mov [si], ' '              ; Replace each character with a space
    inc si                     ; Move to the next byte
  
  loop clearAccountName
  
  
  mov cx, 30                   ; Number of bytes to clear
  mov si, offset accountPIN    ; Load the starting address of the account PIN
  
  clearAccountPassword:
    mov [si], ' '              ; Replace each character with a space
    inc si                     ; Move to the next byte
    
  loop clearAccountPassword  
  
  ; Reset other account variables (remaining ones)
  mov totalAmount, 0           ; Set account balance to zero
  mov accountPINcount, 0       ; Reset PIN digit count to zero
  
  ; Inform the user that the account has been reset
  call clearScreen
       
  printString op5msg1          ; Display: "Account Has Been Reset Successfully"
  call enter_to_continue_prog_5                  ; Wait for the user to acknowledge
     
  ret
    
option_5_prog endp

; ------------------------------

; 6: MODIFY DETAILS         

; ------------------------------

; Procedure: enter_to_continue_prog_6
; Logic: Ensures the user acknowledges the completion of account modification
;        by pressing "Enter" before returning to the main menu.

proc enter_to_continue_prog_6                  
    
   call newLine              ; Insert a blank line for readability
   printString opmsg8        ; Prompt: "Press Enter to Return to Main Menu"
   
   enter_to_continue_prog_6_in:
      mov ah, 1              ; DOS interrupt to read a single key
      int 21h
      
      cmp al, 13             ; Check if the key is "Enter" 
      je main_loop            ; Return to the main menu if "Enter" is pressed
      
      jmp enter_to_continue_prog_6_in           ; Otherwise, wait for "Enter" 
      
   ret 
   
enter_to_continue_prog_6 endp 

; ----------------------------------------------------------------------------

; Macro: Input String for Account Name
; Description: Reads a string input from the user and stores it in a variable.


macro Input_String_Option_6_1 str
   
 mov si, offset str           ; Load the destination address
 
    Input_String_Option_6_1_in: 
        mov ah, 1             ; DOS interrupt for single character input
        int 21h 
        
        cmp al, 13            ; Check if "Enter" is pressed
        je Label_Option_6_1         ; Exit if "Enter" is pressed
        
        mov [si], al          ; Store character in destination
        inc si                ; Move to next byte
        
        jmp Input_String_Option_6_1_in        ; Repeat
endm 

; ----------------------------------------------------------------------------

; Macro: Input PIN for Account 
; Description: Reads a string input from the user and stores it in a variable.

macro Input_String_Option_6_2 str 
    
 mov si, offset str           ; Load the destination address
 
 mov accountPINcount, 0 
 
    Input_String_Option_6_2_in: 
        mov ah, 1             ; DOS interrupt for single character input
        int 21h 
        
        cmp al, 13            ; Check if "Enter" is pressed
        je Label_Option_6_2         ; Exit if "Enter" is pressed
        
        inc accountPINcount   ; Increment PIN count as the new PIN is entered 
        
        mov [si], al          ; Store character in destination
        inc si                ; Move to next byte
        
        jmp Input_String_Option_6_2_in      ; Repeat
endm  

; ----------------------------------------------------------------------------

; Procedure: option_6_prog
; Logic: Modifies the account details, allowing the user to update the name and PIN.
;        Ensures the account exists and validates the user with the PIN before changes.


option_6_prog proc
  
  call checkAccountCreated    ; Ensure an account exists    
  call getPinInput            ; Verify the user's PIN
  call clearScreen            ; Clear the screen for better readability
  
  ; Display "Modify Account Details" Banner
    printString op5mmsg1       ; Line 1 of the banner
    call newLine
    
    printString op5mmsg2       ; Line 2 of the banner
    call newLine 
    
    printString op5mmsg3       ; Line 3 of the banner
    call newLine 
    

    call newLine
  
  ; Prompt for New Account Name
  printString op6msg1_1        ; "1. New Account Name (old: "
  printString accountName      ; Display the current account name
  printString op6msg1_2        ; "): "
  
  Input_String_Option_6_1 accountName            ; Capture new account name input
  
  ; Prompt for New Account PIN
  Label_Option_6_1:
    
    call newLine   
    
    printString op6msg2_1      ; "2. New Account PIN (old: "
    printString accountPIN     ; Display the current account PIN
    printString op6msg2_2      ; "): "
    Input_String_Option_6_2 accountPIN         ; Capture new account PIN input
  
  Label_Option_6_2:
    
    ; Finished MSG
    
    call newLine
    call newLine
    
    printString op6msg0        ; "Account Details Successfully Changed!"
    call enter_to_continue_prog_6                ; Wait for the user to acknowledge
  
  
  ret 
   
option_6_prog endp

; ---------------------------
                                                                   
;   E N T R Y    P O I N T   
                                                                
; ---------------------------

; Entry Point: Main
; Logic: The central loop of the program, repeatedly displaying the menu and 
;        executing the appropriate option based on user input.
       
MainProgramExecution proc
    
    mov ax, @data           ; Initialize data segment
    mov ds, ax
        
    main_loop:
        
        call clearScreen
        call DisplayMenu             ; Display the main menu
        call GetInputMenuSystem      ; Capture the user's menu choice 
        
        ; Determine the action based on user input
                                              
        cmp inputCode, 27
        je ExitMainProgramExecution              ; If 'ESC', exit the program

        cmp inputCode, '1'
        je option_1_prog                     ; If '1', create a new account
        
        cmp inputCode, '2'
        je option_2_prog                     ; If '2', print account details

        cmp inputCode, '3'
        je option_3_prog                     ; If '3', withdraw money

        cmp inputCode, '4'
        je option_4_prog                     ; If '4', deposit money

        cmp inputCode, '5'
        je option_5_prog                     ; If '5', reset account

        cmp inputCode, '6'
        je option_6_prog                     ; If '6', modify account details 
        

        jmp main_loop                        ; If no valid input, return to the menu
                       
    ExitMainProgramExecution:
      
    ; Exit Banner
    call newLine
    call newLine
    call newLine
    call newLine
    
    
    printString op0mmsg0        ; Line 0 of the exit banner
    call newLine
    call newLine
      
    call newLine

    ; Terminate the program
    mov ah, 4Ch                ; DOS interrupt for program termination
    int 21h
    
   MainProgramExecution endp  

end MainProgramExecution                      ; Program ends at the main entry point

; -------------