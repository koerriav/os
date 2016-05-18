print_string:
	mov ah,0x0e
	loop:
		mov al,[bx]
		cmp al,0
		je	return
		int 0x10
		add bx,1
		jmp loop
	return:
		ret
print_hex:
	mov ax,0
	mov al,dl
	and al,0x0f
	call convert
	mov [tmp_buffer1+5],al
	mov ax,0
	mov al,dl
	shr al,4
   call convert
	mov [tmp_buffer1+4],al
	mov ax,0
	mov al,dh
	and al,0x0f
	call convert
	mov [tmp_buffer1+3],al
	mov ax,0
	mov al,dh
	shr al,4
	call convert
	mov [tmp_buffer1+2],al
	mov bx,tmp_buffer1
	call print_string
	ret
	tmp_buffer1: db '0x0000',0x0a,0
convert:
	cmp al,0xa
	jl	convertNum
	jmp convertChar
	convertNum:
		add al,0x30
		ret
	convertChar:
		add al,0x37
		ret
disk_load:
	push dx
	mov ah,0x02
	mov al,dh	;读dh个sectors
	mov ch,0x00	;磁道号
	mov dh,0x00	;磁头号
	mov cl,0x02	;从第二扇区开始

	int 0x13
	jc disk_error
	pop dx
	cmp dh,al
	jne disk_error
	ret
disk_error:
	mov bx,DISK_ERROR_MSG
	call print_string
	ret
DISK_ERROR_MSG: db "Disk read error!",0
	
