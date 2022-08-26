;print string func

print_string:
    pusha ; all on stack
    mov ah, 0x0e ;BIOSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS TELETYPE

    loop:
        mov al, [bx] ;using bx as a parameter (NOTE: its only the first char as the pointer points tofirst char we later increment )
        cmp al, 0 ; if its null terminated
        je finish ;then jump to finish
        int 0x10 ; Else print the char at the current memory address
        add bx, 1  ;increment the address by 1 to move on to the next one
        jmp loop    ;LOOOOOOOOOOOOOOOOOOOOOP

    finish:
        popa ; all of stack
        ret   ; back to main code 


