; AH = 02
; AL = number of sectors to read	(1-128 dec.)
; CH = track/cylinder number  (0-1023 dec., see below)
; CL = sector number  (1-17 dec.)
; DH = head number  (0-15 dec.)
; DL = drive number (0=A:, 1=2nd floppy, 80h=drive 0, 81h=drive 1)
; ES:BX = pointer to buffer
; 
; 
; on return:
; AH = status  (see INT 13,STATUS)
; AL = number of sectors read
; CF = 0 if successful
;    = 1 if error

; load 'dh' sectors from drive 'dl' into ES:BX
disk_load:
	pusha
	
	push dx

	mov ah, 0x02
	mov al, dh
	mov cl, 0x02 ; 0x01 is our boot sector, 0x02 is the first 'available' sector
	mov ch, 0x00
	; dl <- drive number. Our caller sets it as a parameter and gets it from BIOS
	mov dh, 0x00 ; (0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2)

    ; [es:bx] <- pointer to buffer where the data will be stored
    ; caller sets it up for us, and it is actually the standard location for int 13h
	int 0x13
	jc disk_error
 
	pop dx
    cmp al, dh    ; BIOS also sets 'al' to the # of sectors read. Compare it.
    jne sectors_error
	popa
	ret

disk_error:
    mov bx, DISK_ERROR
    call print
    call print_nl
    mov dh, ah ; ah = error code, dl = disk drive that dropped the error
    call print_hex ; check out the code at http://stanislavs.org/helppc/int_13-1.html
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print

disk_loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0
