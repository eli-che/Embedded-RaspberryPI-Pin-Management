	.data
counter:	.quad 0
GPIO:		.quad 0
	.text
	.global setup
	.global interrupt

interrupt:
	addq $1, counter
	cmpq $1, counter
	je one
	cmpq $2, counter
	je two
	cmpq $3, counter
	je three
	cmpq $4, counter
	je four
	cmpq $5, counter
	je five
	cmpq $6, counter
	je six
	cmpq $7, counter
	je seven
	cmpq $8, counter
	je eight
	cmpq $9, counter
	je nine
	cmpq $10, counter
	je ten
	cmpq $11, counter
	je eleven
	cmpq $12, counter
	je twelve
	cmpq $13, counter
	je thirteen
	cmpq $14, counter
	je fourteen
	cmpq $15, counter
	je fifteen
	cmpq $16, counter
	je zero
	ret

setup:
	call calcgpio
	call inpinone
	call outpinone
	call outpintwo
	call outpinthree
	call outpinfour
	ret

one:
	call pinfouron
ret

two:
	call pinthreeon
	call pinfouroff
ret

three:
	call pinfouron
ret

four:
	call pintwoon
	call pinthreeoff
	call pinfouroff
ret

five:
	call pinfouron
ret

six:
	call pinthreeon
	call pinfouroff
ret

seven:
	call pinfouron
ret

eight:
	call pinoneon
	call pintwooff
	call pinthreeoff
	call pinfouroff
ret

nine:
	call pinfouron
ret

ten:
	call pinthreeon
	call pinfouroff
ret

eleven:
	call pinfouron
ret

twelve:
	call pintwoon
	call pinthreeoff
	call pinfouroff
ret

thirteen:
	call pinfouron
ret

fourteen:
	call pinthreeon
	call pinfouroff
ret

fifteen:
	call pinfouron
ret

zero:
	movq $0, counter
	call pinoneoff
	call pintwooff
	call pinthreeoff
	call pinfouroff
ret





calcgpio:
##LADDA IN BAS ADRESS TILL GPIO, FUNKAR
	movq $96, %rax # Set rax to 96 0x60
	salq $16, %rax # bitshift it left 16 positions )  AAAA, sparas i RAX
	movq $65535, %rbx # 0xFFFF
	movq $4096, %rcx # 0x1000
	andq %rbx, %rcx #Sparas i RCX ) BBBBB
	movq $158, %rdx
	notq %rdx # CCCCCCC
	movq $255, %rsi # 0xFF
	andq %rdx, %rsi #Sparas i rsi ) DDDDD
	orq %rcx, %rax #Sparas i RAX EEEE
	orq %rsi, %rax #Sparas i RAX FFFFF
	movq  %rax, GPIO
	xorq %rcx, %rcx
	xorq %rsi, %rsi
	xorq %rbx, %rbx
	xorq %rdx, %rdx
	ret
##GPI ADRESS LADDAR, SLUT

inpinone:
	#Input GPIO 0
	movq GPIO, %rbx
	addq $0x1000, %rbx
	movq %rbx, GPIO
	movq $0x3, %rcx
	salq $14, %rcx
	orw %cx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret

outpinone:
#Output GPIO 1
	movq GPIO, %rbx
	movq $0x2, %rcx
	salq $6, %rcx
    salq $6, %rcx
	orw %cx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret

outpintwo:
	#Output GPIO 2
	movq GPIO, %rbx
	movq $0x2, %rcx
	salq $6, %rcx
    salq $4, %rcx
	orw %cx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret

outpinthree:
	#Output GPIO 3
	movq GPIO, %rbx	
	movq $0x2, %rcx
	salq $6, %rcx
    salq $2, %rcx
	orw %cx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret

outpinfour:
	#Output GPIO 4
	movq GPIO, %rbx	
	movq $0x2, %rcx
	salq $6, %rcx
    salq $0, %rcx
	orw %cx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret

pinoneon:
	#GPIO 1 ON
	movq GPIO, %rbx	
	movq $0x3, %rcx
	salq $4, %rcx
	addq $1, %rcx
	salq $0, %rcx
	addq $3, %rbx
	orl %ecx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret

pintwoon:
	#GPIO 2 ON
	movq GPIO, %rbx	
	movq $0x3, %rcx
	salq $4, %rcx
	addq $1, %rcx
	salq $8, %rcx
	addq $3, %rbx
	orl %ecx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret


pinthreeon:
	#GPIO 3 ON
	movq GPIO, %rbx	
	movq $0x3, %rcx
	salq $4, %rcx
	addq $1, %rcx
	salq $16, %rcx
	addq $3, %rbx
	orl %ecx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret


pinfouron:
	#GPIO 4 ON
	movq GPIO, %rbx	
	movq $0x3, %rcx
	salq $4, %rcx
	addq $1, %rcx
	salq $24, %rcx
	addq $3, %rbx
	orl %ecx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret

pinoneoff:
	#GPIO 1 OFF
	movq GPIO, %rbx	
	movq $0xCF, %rcx
	salq $0, %rcx
	notq %rcx
	addq $3, %rbx
	andl %ecx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret

pintwooff:
	#GPIO 2 OFF
	movq GPIO, %rbx	
	movq $0xCF, %rcx
	salq $8, %rcx
	notq %rcx
	addq $3, %rbx
	andl %ecx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret

pinthreeoff:
	#GPIO 3 OFF
	movq GPIO, %rbx	
	movq $0xCF, %rcx
	salq $16, %rcx
	notq %rcx
	addq $3, %rbx
	andl %ecx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret


pinfouroff:
	#GPIO 4 OFF
	movq GPIO, %rbx	
	movq $0xCF, %rcx
	salq $24, %rcx
	notq %rcx
	addq $3, %rbx
	andl %ecx, (%rbx)
	xorq %rcx, %rcx
	xorq %rbx, %rbx
ret
