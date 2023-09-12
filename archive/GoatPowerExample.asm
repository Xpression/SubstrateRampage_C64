.filenamespace goatPowerExample
:BasicUpstart2(mainStartup)

//----------------------------------------------------------
//				Variables
//----------------------------------------------------------
.var			debug = true
.var			musicEnabled = false
.const 			irqpointer = $0314
//----------------------------------------------------------

//----------------------------------------------------------
//				Main Startup Code
//----------------------------------------------------------
mainStartup:
* = mainStartup "Main Startup"
				lda #$00
				sta $d020
				sta $d021
				jsr examplePart.partInit
				sei
		:SetupIRQ(examplePart.partIrqStart, examplePart.partIrqStartLine, false)
		:FillScreen($0400,$20,$d800,LIGHT_GRAY)
				cli
				jmp examplePart.partJump
//----------------------------------------------------------
examplePart: {
.pc = $0b00 "ExamplePart"
//----------------------------------------------------------
.var 			rastertimeMarker = debug ? $d020 : $d024
.label			partIrqStartLine = $14
//----------------------------------------------------------
partInit:
				rts
//----------------------------------------------------------
partIrqStart: {
			.for(var j=0; j<6; j++) {
				nop
			}				
				ldx #$00
!:
				lda colors1,x
				sta $d020
				sta $d021
			.for(var j=0; j<22; j++) {
				nop
			}				
				inx
				cpx #colorend-colors1
				bne !-

				lda #0
				sta $d020
				sta $d021
		:EndIRQ(partIrqStart,partIrqStartLine,false)
}
colors1:
				.text "fncmagolk@fncmagolk@fncmagolk@"
colorend:
//----------------------------------------------------------
partJump:
				jmp *
//----------------------------------------------------------
}
//----------------------------------------------------------
//	Macros
//----------------------------------------------------------
.macro SetupIRQ(IRQaddr,IRQline,IRQlineHi) {
				lda #<IRQaddr
				sta irqpointer
				lda #>IRQaddr
				sta irqpointer+1
				lda #$1f
				sta $dc0d
				sta $dd0d
				lda #$81
				sta $d01a
				sta $d019
		.if(IRQlineHi) {
				lda #$9b
		} else {
				lda #$1b
		}
				sta $d011
				lda #IRQline
				sta $d012
}
//----------------------------------------------------------
.macro EndIRQ(nextIRQaddr,nextIRQline,IRQlineHi) {
				asl $d019
				lda #<nextIRQaddr
				sta irqpointer
				lda #>nextIRQaddr
				sta irqpointer+1
				lda #nextIRQline
				sta $d012
		.if(IRQlineHi) {
				lda $d011
				ora #$80
				sta $d011
		}	
				jmp $febc
}
//----------------------------------------------------------
.macro FillScreen(screen,char,colorbuff,color) {
				ldx #$00
loop:
		.for(var i=0; i<3; i++) {
				lda #char
				sta screen+[i*$100],x
				lda #color
				sta colorbuff+[i*$100],x
		}
				lda #char
				sta screen+[$2e8],x
				lda #color
				sta colorbuff+[$2e8],x
				inx
				bne loop
}
//----------------------------------------------------------