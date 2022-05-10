        ;MOS6510 General Library
        ;Written by Alan
        ;Feel free to paste this code at the end
        ;of your DASM file and use these subroutines.
        ;Lsit of functions:
        ;  Multiply - multiplies x and y and stors the result in Multi1 and Multi2
        ;  ScreenPos - Gets the address of position (X,Y) on the screen
        ;  Place - sets the characer in position (X,Y) to A
        ;  CopyChars - Moves Character Rom to "Character RAM" at $3000
        
        SUBROUTINE
	;Multiply x by y and store it in a varible
        
Multiply
	sta .A
        stx .X
        sty .Y
        clc
        lda #0
        sta Multi1
        sta Multi2
.loop	
	adc .Y
        bcs .carry
.carryReturn
	dex
        bne .loop
        sta Multi1
        lda .A
        ldx .X
        rts
        
.carry
	inc Multi2
        jmp .carryReturn
	
.A	byte #0
.X	byte #0
.Y	byte #0
	
Multi1	byte #0 ;low byte
Multi2	byte #0 ;high byte
	;note that these Multi vars will be used
        ;for vriuos other stuff

	SUBROUTINE
        ;Assuming screen ram is at $0400,
        ;get memory location if the caracter
        ;located at (x,y) on the screen.
        ;Multi=(y*40)+x
        
ScreenPos
	sta .a
        stx .x
        sty .y
        ldx #40
        jsr Multiply
        lda Multi1
        adc .x
        bcs .carry
.return
        sta Multi1
        REPEAT 4
        inc Multi2
        REPEND
        lda .a
        ldx .x
        ldy .y
        rts
        
.carry
	inc Multi2
        jmp .return
.x	byte #0
.y	byte #0
.a	byte #0

	SUBROUTINE
        ;Put character A at position X,Y on the screen
        ;This is added simply for convienence
Place
	jsr ScreenPos
        sta .a
        stx .x
        sty .y
        lda Multi2
        cmp #4
        beq .4
        cmp #5
        beq .5
        cmp #6
        beq .6
        cmp #7
        beq .7

.4
	ldx Multi1
        lda .a
        sta $400,x
        ldx .x
        rts
.5
	ldx Multi1
        lda .a
        sta $500,x
        ldx .x
        rts
.6
	ldx Multi1
        lda .a
        sta $600,x
        ldx .x
        rts
.7
	ldx Multi1
        lda .a
        sta $700,x
        ldx .x
        rts
        
.a	byte #0
.x	byte #0
.y 	byte #0

	SUBROUTINE
        ;Copy CharacterROM to $3000
        ;and use it as the font.
        ;This only copys the first 128 characters.
        ;(There are 512 total)
        
CopyChars
	sta .a ;Save varibles
        stx .x ;so they can be restored
        sty .y ;at the end
        lda $dc0e ;Stop the CIA1 chip.
        and #%11111110 ;I dont know what it does but
        sta $dc0e ;This code wont work unless I do it.
        lda $01 ;Switch IO data
        and #%11111011 ;into character data
        sta $01
        
        ldx #0
.loop
	lda $d000,x 
        sta $3000,x
        lda $d100,x
        sta $3100,x
        lda $d200,x
        sta $3200,x
        dex
        bne .loop
        
        lda $01 ;put everything back to how it was
        ora #%00000100
        sta $01
        lda $dc0e
        ora #1
        sta $dc0e
        
        lda $dc18
        and #%11110000 ; delete the lower nybble
        clc
        adc #12 ;set the bits to 110. This directs to $3000
        sta $dc18
        
        lda .a ;put registers back
        ldx .x
        ldy .y
        rts
.a	byte #0
.x	byte #0
.y	byte #0
