BITS 32
GLOBAL _start

%define SYS_EXIT   1
%define SYS_READ   3
%define SYS_WRITE  4
%define SYS_OPEN   5
%define SYS_CLOSE  6

%define STDIN      0
%define STDOUT     1
%define O_RDONLY   0
%define O_WRONLY   1
%define O_CREAT    64
%define O_TRUNC    512

%macro PRINT 1
    push %1
    call print_z
    add esp, 4
%endmacro

SECTION .data

title       db 10, "===============================", 10
            db "             COR", 10
            db "===============================", 10, 0

menu        db 10, "1. Input", 10
            db "2. Output", 10
            db "3. Write", 10
            db "4. Read", 10
            db "5. Exit", 10, 10
            db "Enter your choice: ", 0

input_title db 10, "Enter Student information", 10, 0
p_enroll    db "Enrollment Status: ", 0
p_student   db "Student #: ", 0
p_college   db "College: ", 0
p_program   db "Program: ", 0
p_name      db "Name: ", 0
p_year      db "Year Level: ", 0
p_term      db "Term / School Year: ", 0
p_phone     db "Phone: ", 0
p_zip       db "Zip Code: ", 0
p_address   db "Address: ", 0
p_tuition   db "Tuition Fee (21): ", 0
p_misc      db "Miscellaneous Fee: ", 0
p_idfee     db "ID Validation Fee: ", 0
p_ite1      db "ITE Computer Laboratory Fee (CCS0021): ", 0
p_ite2      db "ITE Computer Laboratory Fee (CS0003): ", 0
p_ite3      db "ITE Computer Laboratory Fee (CS0070): ", 0
p_science   db "Science Lab Fee (GED0081): ", 0
p_total     db "TOTAL ASSESSMENT: ", 0
p_scholar   db "Presidents Scholar with High Honors (75% of Tuition and Miscellaneous Fee): ", 0
p_net       db "NET TOTAL ASSESSMENT: ", 0
p_down      db "Down Payment (Upon Enrollment) 40%: ", 0
p_mid       db "Midterm (Oct 05 - Oct 07 2026) 30%: ", 0
p_final     db "Final (Nov 26 - Dec 03 2026) 30%: ", 0
a_tuition   db "Tuition Fee (21)", 0
a_misc      db "Miscellaneous Fee", 0
a_idfee     db "ID Validation Fee", 0
a_ite1      db "ITE Computer Laboratory Fee (CCS0021)", 0
a_ite2      db "ITE Computer Laboratory Fee (CS0003)", 0
a_ite3      db "ITE Computer Laboratory Fee (CS0070)", 0
a_science   db "Science Lab Fee (GED0081)", 0
a_total     db "TOTAL ASSESSMENT", 0
a_scholar   db "Presidents Scholar with High Honors (75% of Tuition and Miscellaneous Fee)", 0
a_net       db "NET TOTAL ASSESSMENT", 0
a_down      db "Down Payment (Upon Enrollment) 40%", 0
a_mid       db "Midterm (Oct 05 - Oct 07 2026) 30%", 0
a_final     db "Final (Nov 26 - Dec 03 2026) 30%", 0

file_name   db "LABEXER3_COR.txt", 0
write_ok    db 10, "COR successfully written to LABEXER3_COR.txt", 10, 0
read_title  db 10, "Contents of LABEXER3_COR.txt", 10, 0
file_error  db 10, "Unable to open or create the COR file.", 10, 0
invalid     db 10, "Invalid choice. Please select 1 to 5.", 10, 0

schedule    db 10, "+---------+---------------------------------------------+--------+------+------+------------------------------------------+----------------+", 10
            db "| COURSE  | TITLE                                       | SECTION| UNITS| DAYS | TIME                                     | ROOM           |", 10
            db "+---------+---------------------------------------------+--------+------+------+------------------------------------------+----------------+", 10
            db "| CCS0021 | INFORMATION MANAGEMENT (LEC)                | TN24   | 2    | T    | 16:00:00-18:40:00                        | ONLINE         |", 10
            db "| CCS0021L| INFORMATION MANAGEMENT (LAB)                | TN24   | 1    | F    | 16:00:00-18:50:00                        | ONLINE         |", 10
            db "| CS0001  | DISCRETE STRUCTURES 1                       | TN24   | 3    | S / W| 15:00:00-16:50:00 / 15:00:00-16:50:00    | F710 / F710    |", 10
            db "| CS0003  | COMPUTER SYSTEMS & ARCHITECTURE             | TN24   | 2    | F    | 10:00:00-12:40:00                        | ONLINE         |", 10
            db "| CS0003L | COMPUTER SYSTEMS & ARCHITECTURE (LAB)       | TN24   | 1    | TH   | 10:00:00-12:50:00                        | E610           |", 10
            db "| CS0070  | OBJECT ORIENTED PROGRAMMING                 | TN24   | 2    | F    | 07:00:00-09:40:00                        | ONLINE         |", 10
            db "| CS0070L | OBJECT ORIENTED PROGRAMMING-LAB             | TN24   | 1    | TH   | 07:00:00-09:50:00                        | E609           |", 10
            db "| GED0021 | SPECIALIZED ENGLISH PROGRAM 2               | TN24   | 3    | S / W| 11:00:00-12:50:00 / 11:00:00-12:50:00    | F607 / F607    |", 10
            db "| GED0075 | LINEAR ALGEBRA                              | TN24   | 3    | F / T| 13:00:00-14:50:00 / 13:00:00-14:50:00    | ONLINE / ONLINE|", 10
            db "| GED0081 | COLLEGE PHYSICS 1 LECTURE                   | TN24   | 2    | T    | 07:00:00-09:40:00                        | ONLINE         |", 10
            db "| GED0081L| COLLEGE PHYSICS 1 LABORATORY                | TN24   | 1    | S    | 07:00:00-09:50:00                        | F1003          |", 10
            db "+---------+---------------------------------------------+--------+------+------+------------------------------------------+----------------+", 10
            db "| TOTAL UNITS: 21                                                                                                         |                |", 10
            db "+---------+---------------------------------------------+--------+------+------+------------------------------------------+----------------+", 10, 0

assessment  db 10, "ASSESSMENT", 10, 0
spaces      times 100 db ' '

SECTION .bss
choice      resb 8
enrollment  resb 64
student     resb 64
college     resb 96
program     resb 96
studentname resb 128
yearlevel   resb 32
term        resb 64
phone       resb 64
zipcode     resb 32
address     resb 160
filebuf     resb 4096
tuition     resb 32
miscfee     resb 32
idfee       resb 32
itefee1     resb 32
itefee2     resb 32
itefee3     resb 32
sciencefee  resb 32
totalassess resb 32
scholar     resb 32
netassess   resb 32
downpay     resb 32
midterm     resb 32
finalpay    resb 32

SECTION .text

_start:
    mov byte [enrollment], 0
    mov byte [student], 0
    mov byte [college], 0
    mov byte [program], 0
    mov byte [studentname], 0
    mov byte [yearlevel], 0
    mov byte [term], 0
    mov byte [phone], 0
    mov byte [zipcode], 0
    mov byte [address], 0

main_menu:
    PRINT title
    PRINT menu
    push 8
    push choice
    call input_line
    add esp, 8

    cmp byte [choice], '1'
    je do_input
    cmp byte [choice], '2'
    je do_output
    cmp byte [choice], '3'
    je do_write
    cmp byte [choice], '4'
    je do_read
    cmp byte [choice], '5'
    je exit_program

    PRINT invalid
    jmp main_menu

do_input:
    call input_details
    jmp main_menu

do_output:
    PRINT title
    push STDOUT
    call show_cor
    add esp, 4
    jmp main_menu

do_write:
    call write_cor_file
    jmp main_menu

do_read:
    call read_cor_file
    jmp main_menu

exit_program:
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 80h

input_details:
    push ebp
    mov ebp, esp
    PRINT input_title

    PRINT p_enroll
    push 64
    push enrollment
    call input_line
    add esp, 8

    PRINT p_student
    push 64
    push student
    call input_line
    add esp, 8

    PRINT p_college
    push 96
    push college
    call input_line
    add esp, 8

    PRINT p_program
    push 96
    push program
    call input_line
    add esp, 8

    PRINT p_name
    push 128
    push studentname
    call input_line
    add esp, 8

    PRINT p_year
    push 32
    push yearlevel
    call input_line
    add esp, 8

    PRINT p_term
    push 64
    push term
    call input_line
    add esp, 8

    PRINT p_phone
    push 64
    push phone
    call input_line
    add esp, 8

    PRINT p_zip
    push 32
    push zipcode
    call input_line
    add esp, 8

    PRINT p_address
    push 160
    push address
    call input_line
    add esp, 8

    PRINT p_tuition
    push 32
    push tuition
    call input_line
    add esp, 8

    PRINT p_misc
    push 32
    push miscfee
    call input_line
    add esp, 8

    PRINT p_idfee
    push 32
    push idfee
    call input_line
    add esp, 8

    PRINT p_ite1
    push 32
    push itefee1
    call input_line
    add esp, 8

    PRINT p_ite2
    push 32
    push itefee2
    call input_line
    add esp, 8

    PRINT p_ite3
    push 32
    push itefee3
    call input_line
    add esp, 8

    PRINT p_science
    push 32
    push sciencefee
    call input_line
    add esp, 8

    PRINT p_total
    push 32
    push totalassess
    call input_line
    add esp, 8

    PRINT p_scholar
    push 32
    push scholar
    call input_line
    add esp, 8

    PRINT p_net
    push 32
    push netassess
    call input_line
    add esp, 8

    PRINT p_down
    push 32
    push downpay
    call input_line
    add esp, 8

    PRINT p_mid
    push 32
    push midterm
    call input_line
    add esp, 8

    PRINT p_final
    push 32
    push finalpay
    call input_line
    add esp, 8

    pop ebp
    ret

show_cor:
    push ebp
    mov ebp, esp
    pushad
    mov edi, [ebp+8]

    mov esi, p_enroll
    call out_z
    mov esi, enrollment
    call out_z
    mov esi, nl
    call out_z

    mov esi, p_student
    call out_z
    mov esi, student
    call out_z
    mov esi, nl
    call out_z

    mov esi, p_college
    call out_z
    mov esi, college
    call out_z
    mov esi, nl
    call out_z

    mov esi, p_program
    call out_z
    mov esi, program
    call out_z
    mov esi, nl
    call out_z

    mov esi, p_name
    call out_z
    mov esi, studentname
    call out_z
    mov esi, nl
    call out_z

    mov esi, p_year
    call out_z
    mov esi, yearlevel
    call out_z
    mov esi, nl
    call out_z

    mov esi, p_term
    call out_z
    mov esi, term
    call out_z
    mov esi, nl
    call out_z

    mov esi, p_phone
    call out_z
    mov esi, phone
    call out_z
    mov esi, nl
    call out_z

    mov esi, p_zip
    call out_z
    mov esi, zipcode
    call out_z
    mov esi, nl
    call out_z

    mov esi, p_address
    call out_z
    mov esi, address
    call out_z
    mov esi, nl
    call out_z

    mov esi, schedule
    call out_z
    mov esi, assessment
    call out_z

    push tuition
    push a_tuition
    push edi
    call out_assess
    add esp, 12

    push miscfee
    push a_misc
    push edi
    call out_assess
    add esp, 12

    push idfee
    push a_idfee
    push edi
    call out_assess
    add esp, 12

    push itefee1
    push a_ite1
    push edi
    call out_assess
    add esp, 12

    push itefee2
    push a_ite2
    push edi
    call out_assess
    add esp, 12

    push itefee3
    push a_ite3
    push edi
    call out_assess
    add esp, 12

    push sciencefee
    push a_science
    push edi
    call out_assess
    add esp, 12

    push totalassess
    push a_total
    push edi
    call out_assess
    add esp, 12

    mov esi, nl
    call out_z

    push scholar
    push a_scholar
    push edi
    call out_assess
    add esp, 12

    mov esi, nl
    call out_z

    push netassess
    push a_net
    push edi
    call out_assess
    add esp, 12

    mov esi, nl
    call out_z

    push downpay
    push a_down
    push edi
    call out_assess
    add esp, 12

    push midterm
    push a_mid
    push edi
    call out_assess
    add esp, 12

    push finalpay
    push a_final
    push edi
    call out_assess
    add esp, 12

    popad
    pop ebp
    ret

write_cor_file:
    push ebp
    mov ebp, esp
    mov eax, SYS_OPEN
    mov ebx, file_name
    mov ecx, O_WRONLY | O_CREAT | O_TRUNC
    mov edx, 0644o
    int 80h
    cmp eax, 0
    jl write_failed
    push eax
    call show_cor
    add esp, 4
    pop ebx
    mov eax, SYS_CLOSE
    int 80h
    PRINT write_ok
    jmp write_done
write_failed:
    PRINT file_error
write_done:
    pop ebp
    ret

read_cor_file:
    push ebp
    mov ebp, esp
    PRINT read_title
    mov eax, SYS_OPEN
    mov ebx, file_name
    mov ecx, O_RDONLY
    xor edx, edx
    int 80h
    cmp eax, 0
    jl read_failed
    mov ebx, eax
    push ebx
    mov eax, SYS_READ
    mov ecx, filebuf
    mov edx, 4096
    int 80h
    mov edx, eax
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, filebuf
    int 80h
    mov eax, SYS_CLOSE
    pop ebx
    int 80h
    jmp read_done
read_failed:
    PRINT file_error
read_done:
    pop ebp
    ret

input_line:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    mov ecx, [ebp+8]
    mov edx, [ebp+12]
    dec edx
    mov eax, SYS_READ
    mov ebx, STDIN
    int 80h
    mov esi, ecx
    xor edi, edi
find_end:
    cmp edi, eax
    jge terminate_input
    cmp byte [esi+edi], 10
    je terminate_at_end
    cmp byte [esi+edi], 13
    je terminate_at_end
    inc edi
    jmp find_end
terminate_at_end:
    mov byte [esi+edi], 0
    jmp input_done
terminate_input:
    mov byte [esi+edi], 0
input_done:
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

print_z:
    push ebp
    mov ebp, esp
    mov ecx, [ebp+8]
    call strlen
    mov edx, eax
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    int 80h
    pop ebp
    ret

out_z:
    pushad
    mov ecx, esi
    call strlen
    mov edx, eax
    mov eax, SYS_WRITE
    mov ebx, edi
    int 80h
    popad
    ret

out_assess:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    mov edi, [ebp+8]
    mov esi, [ebp+12]
    mov ecx, esi
    call strlen
    mov edx, eax
    mov ecx, esi
    mov ebx, edi
    mov eax, SYS_WRITE
    int 80h
    mov ecx, 87
    sub ecx, edx
    mov edx, ecx
    mov ecx, spaces
    mov ebx, edi
    mov eax, SYS_WRITE
    int 80h
    mov esi, [ebp+16]
    call out_z
    mov esi, nl
    call out_z
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

strlen:
    push ebx
    mov ebx, ecx
    xor eax, eax
strlen_loop:
    cmp byte [ebx+eax], 0
    je strlen_done
    inc eax
    jmp strlen_loop
strlen_done:
    pop ebx
    ret

SECTION .data
nl          db 10, 0
