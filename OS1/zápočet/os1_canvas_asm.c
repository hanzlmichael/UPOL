#include <stdio.h>
#include <stdlib.h>

struct canvas {
	unsigned int size;
	unsigned int height;
	unsigned int width;
	unsigned char *canvasArray;
};

struct canvas *canvas_create(unsigned int width, unsigned int height) {	
	_asm {
		push 16 // velikost struktury canvas
		call malloc
		add esp, 4   // musim rucne navysit registr esp, bez toho error
		mov ebx, eax // vysledek volane funkce se vraci v eax
		mov eax, height
		mul width
		mov edx, 2
		mul edx
		test eax, 7 // ecx % 8 == 0 
		jnz nonZero
		mov eax, height
		mul width
		mov ecx, 4
		div ecx 
		mov dword ptr[ebx], eax // do canvas.size da vysledek (height*width)/4
		jmp konec
	nonZero:
		mov eax, height
		mul width
		mov edx, 4
		div edx
		inc eax
		mov dword ptr[ebx], eax // do canvas.size da vysledek (height*width)/4 + 1		
	konec:
		mov ecx, height
		mov dword ptr[ebx + 4], ecx
		mov ecx, width
		mov dword ptr[ebx + 8], ecx
		mov ecx, dword ptr[ebx] // do ecx si dam hodnotu canvas.size ?? otestovat
		push ecx
		call malloc
		add esp, 4
		mov dword ptr[ebx + 12], eax	
		mov esi, eax // do esi dam odkaz na canvasArray
		mov ecx, dword ptr[ebx] // do eax dam canvas.size
		mov al, 0
	opakuj:
		mov byte ptr[esi], al
		add esi, 1
		loop opakuj // vynulovani canvasArray
		mov eax, ebx  // return canvas pomoci registru eax
	}
}

void canvas_print(struct canvas *canvas) {
	char* newline = "\n";
	char* plus = "+";
	char* vertical = "|";
	char* horizontal = "-";
	char* empty = ".";
	_asm {
		mov ebx, canvas
		mov esi, dword ptr [ebx + 12] // pointer na canvasArray
		mov edx, 0 // index i (vnejsi cyklus)
		xor ecx, ecx
		jmp outerLoop
	recalculate:
		inc edx // i++
		mov cl, 0
		// v ecx si na spodnich 8 bitech (CL) pocitam vnitrni cyklus index j, na hornich 8 bitech (AH) pocitam promenne na radcich a v hornich
		// na hornich 16 bitech ktere vzdy pred pouzitim rotuju, pocitam celkovy pocet bitu 
	outerLoop:
		mov esi, dword ptr[ebx + 12] // pointer na canvasArray
		mov edi, dword ptr[ebx] // edi = canvas->size
		cmp edx, edi // i, canvas.size
		je end		
			innerLoop:
				cmp cl, 8 // index j == 8
				je recalculate				
				xor eax, eax
				mov ax, 2 
				mul [ebx + 8] // canvas->width
				mul [ebx + 4] // canvas->heigth
				rol ecx, 16
				cmp ax, cx // (canvas->height * canvas->width * 2) == bitCounter
				rol ecx, 16
				je end // kdyz rovno tak ukoncim (je vytisknuto vse)				
				xor eax, eax
				mov al, ch //countSymbolsOnRow
				cmp al, [ebx + 8] // (countSymbolsOnRow == canvas->width)
				je printNewLine // pokud se rovna vytisknu novy radek
				jmp noNewLine // netisknu novy radek
			printNewLine:
				push eax // zalohuju si vsechny registry za zasobnik
				push ecx // zalohuju si vsechny registry za zasobnik
				push edx // zalohuju si vsechny registry za zasobnik
				push newline 
				call printf
				add esp, 16
				mov eax, [esp - 4]
				mov ecx, [esp - 8]
				mov edx, [esp - 12]
				mov ch, 0 // vynuluju countSymbolsOnRow
			noNewLine:
				mov al, [esi + edx] // do eax = canvasArray[edx] editedbyte je [esi + edx]
				shl al, cl         // al << j
				and al, 128  // al & mask
				cmp al, 0 //  if ((editedByte << j) & mask)
				je isFalse
				inc cl // j++
				mov al, [esi + edx] // mozna chyba? musim do al
				shl eax, cl
				and eax, 128
				cmp eax, 0 
				je printVertical
				push eax // zalohuju si vsechny registry za zasobnik
				push ecx // zalohuju si vsechny registry za zasobnik
				push edx // zalohuju si vsechny registry za zasobnik
				push plus
				call printf
				add esp, 16
				mov eax, [esp - 4]
				mov ecx, [esp - 8]
				mov edx, [esp - 12] // vraceni puvodnich hodnot do registru
				jmp toContinue
			printVertical:
				push eax // zalohuju si vsechny registry za zasobnik
				push ecx // zalohuju si vsechny registry za zasobnik
				push edx // zalohuju si vsechny registry za zasobnik
				push vertical
				call printf
				add esp, 16
				mov eax, [esp - 4]
				mov ecx, [esp - 8]
				mov edx, [esp - 12] // vraceni puvodnich hodnot do registru
				jmp toContinue				
			isFalse:
				inc cl // j++
				mov al, [esi + edx]
				shl al, cl
				and al, 128
				cmp al, 0
				je printDot
				push eax // zalohuju si vsechny registry za zasobnik
				push ecx // zalohuju si vsechny registry za zasobnik
				push edx // zalohuju si vsechny registry za zasobnik
				push horizontal
				call printf
				add esp, 16
				mov eax, [esp - 4]
				mov ecx, [esp - 8]
				mov edx, [esp - 12] // vraceni puvodnich hodnot do registru
				jmp toContinue		
			printDot:
				push eax // zalohuju si vsechny registry za zasobnik
				push ecx // zalohuju si vsechny registry za zasobnik
				push edx // zalohuju si vsechny registry za zasobnik
				push empty
				call printf // tisk tecky
				add esp, 16 
				mov eax, [esp - 4]
				mov ecx, [esp - 8]
				mov edx, [esp - 12] // vraceni puvodnich hodnot do registru
			toContinue:
				xor eax, eax
				mov ax, 2
				rol ecx, 16
				add ax, cx
				mov cx, ax
				rol ecx, 16
				inc ch // countSymbolsOnRow
				inc cl
				jmp innerLoop
	end:		
	}
}

void canvas_hline(struct canvas *canvas, unsigned int x, unsigned int y, int len) {
	_asm {
		mov eax, x
		mov edx, len
		add eax, edx
		cmp eax, 0
		jge secondCondition
		mov eax, x
		add eax, len
		imul eax, -1
		mov len, eax
		mov x, 0
		jmp cycleBegin
	secondCondition:
		mov eax, len
		cmp eax, 0
		jge thirdCondition
		mov eax, x
		add eax, len
		cmp eax, 0
		jle thirdCondition
		mov eax, x
		add eax, len
		add eax, 1
		mov x, eax
		mov eax, len
		imul eax, -1
		mov len, eax
		jmp cycleBegin 
	thirdCondition:
		mov eax, len
		cmp eax, 0
		mov ebx, canvas
		mov ecx, [ebx + 8]
		sub ecx, 1
		cmp eax, ecx
		jle cycleBegin
		mov eax, [ebx + 8]
		sub eax, x
		mov edx, eax 
	cycleBegin:
		mov ecx, 0
	round:
		cmp ecx, len
		je hlineEnd
		xor edx, edx
		mov eax, x
		mov ebx, 4 // chyba v deleni, opraveno
		div ebx
		mov edi, eax // (indexToProcess / 4)
		mov esi, canvas // do esi si zalohuju adresu canvasu
		mov eax, [esi] // eax = canvas->size
		xor ebx, ebx
		xor edx, edx
		mov ebx, [esi + 4] // ebx = canvas->heigth
		div ebx 
		mov ebx, y
		mul ebx
		add eax, edi // = actualByte
		mov edi, eax // uchovam si hodnotu actualByte pro dalsi vypocet
		xor edx, edx
		mov eax, x
		mov ebx, 4
		div ebx // remainder mi zustane v edx
		mov eax, edx
		mov bl, 2
		mul bl // vysledek v eax = moveBitsOnPosition
		mov ebx, ecx // zalohuju counter
		mov ecx, eax // dosadim movebitsonposition
		mov eax, 64 
		shr eax, cl // mask >> moveBitsOnPosition
		mov ecx, ebx // obnovim counter v ecx
		mov ebx, [esi + 12] // canvasArray
		mov edx, [ebx + edi] // edx = canvas->canvasArray[actualByte];
		or eax, edx // eax = (mask >> moveBitsOnPosition) | canvas->canvasArray[actualByte]
		mov dword ptr[ebx + edi], eax // otestovano
		inc x
		inc ecx
		jmp round
	hlineEnd:
	}
}

void canvas_vline(struct canvas *canvas, unsigned int x, unsigned int y, int len) {
	_asm {
		xor ecx, ecx
		mov eax, len 
		push eax // len [esp - 4]
		push 0 // [esp - 8] processedRow
		add esp, 8
		mov cl, 0 // index i cyklu na dolnich 8 bitech
		cmp len, 0
		jge vlineSecondCond
		mov eax, len
		mov ebx, -1
		mul ebx // pokud delka 'len' mensi nez 0 tak len *= -1
		mov len, eax
	vlineSecondCond: // prepocitani delky, jeli souradnice y + delka vetsi nez vyska canvasu
		mov eax, [esp - 4]
		add eax, y
		mov esi, canvas
		mov edx, [esi + 4] // canvas->heigth 
		cmp eax, edx
		jle vlineRound
		mov eax, edx
		sub eax, y
		mov len, eax 
	vlineRound:
		xor eax, eax 
		mov eax, len // z eax pouziju jen spodnich 8 bitu abych mohl srovnat z cl
		cmp cl, al // vyresit !!! 'len' musi byt jen spodnich 8 bitu aby slo srovnat // SOLVED? otestovat
		je vlineEnd
		mov eax, x
		mov esi, canvas
		mov edx, [esi + 8] // canvas->width 
		cmp eax, edx       // x < canvas->width
		jl conditionBody
		mov eax, x
		mov edx, 0
		cmp eax, edx
		jge conditionBody
		jmp conditionFailed			
	conditionBody:
		xor edx, edx
		xor ebx, ebx 
		mov eax, x
		mov ebx, 4
		div ebx
		mov edi, eax // zalohuju si mezivysledek indexToProcess / 4 do edi
		mov ebx, canvas
		xor edx, edx
		mov eax, [ebx]     // canvas->size
		mov esi, [ebx + 4] // canvas->heigth
		mov ebx, esi 
		div ebx // canvas->size / canvas->height; // vysledek v eax 
		mov eax, eax
		mul y // y * sizeOfRow
		xor ebx, ebx
		mov ebx, [esp - 8] // spatny vysledek? overit  *** zmeneno
		add eax, ebx
		add eax, edi // indexToProcess / inOneByte + (y * sizeOfRow + processedRow) a to = actualByte
		mov edi, eax // zalohuju mezivysledek actualByte do edi
		mov eax, x
		xor edx, edx
		mov ebx, 4
		div ebx // otestovat ze spravny vysledek
		mov eax, edx
		mov ebx, 2
		mul ebx // v eax mam moveBitsOnPosition (ten bude potreba posleze 8 bitovy) - otestovat ze muze byt mul!!
		mov ebx, 128
		mov edx, ecx // zalohuju si ecx
		xor ecx, ecx
		mov ecx, eax
		shr ebx, cl // mask(128) >> moveBitsOnPosition
		mov ecx, edx // vraceno zpet (processed a index i)
		mov eax, ebx
		mov esi, canvas
		mov ebx, [esi + 12] // canvasArray
		mov edx, [ebx + edi] // edx = canvas->canvasArray[actualByte];
		or eax, edx // eax = (mask >> moveBitsOnPosition) | canvas->canvasArray[actualByte]
		mov dword ptr[ebx + edi], eax 
		mov eax, [esp - 4] 
		cmp eax, 0  
		jge vlineRoundEnd
		mov ebx, canvas
		xor edx, edx
		mov eax, [ebx]     // canvas->size
		mov esi, [ebx + 4] // canvas->heigth
		mov ebx, esi
		div ebx // canvas->size / canvas->height; // vysledek v eax 
		mov edx, eax
		xor eax, eax
		mov eax, [esp - 8]
		sub eax, edx
		mov [esp - 8], eax // processedRow -= sizeOfRow; 
		inc cl
		jmp vlineRound
	vlineRoundEnd:
		mov ebx, canvas
		xor edx, edx
		mov eax, [ebx]     // canvas->size
		mov esi, [ebx + 4] // canvas->heigth
		mov ebx, esi
		div ebx // canvas->size / canvas->height; // vysledek v eax 
		mov edx, eax // edx = sizeOfRow
		xor eax, eax
		mov eax, [esp - 8]
		add eax, edx
		mov [esp - 8], eax // processedRow += sizeOfRow;
		inc cl 
		jmp vlineRound
	conditionFailed:
		inc cl
		jmp vlineRound
	vlineEnd:
	}
}

void canvas_free(struct canvas *canvas) {
	_asm {
		mov ebx, canvas
		mov esi, [ebx + 12] // canvas->canvasArray
		push esi
		call free
		add esp, 4
		mov ebx, canvas
		push ebx
		call free
		add esp, 4
	}
}

int main() {
	struct canvas *c = canvas_create(20, 10);
	canvas_hline(c, 3, 2, 13); 
	canvas_hline(c, 14, 5, -11);
	canvas_vline(c, 4, 1, 6);
	canvas_vline(c, 14, 6, -6);
	canvas_vline(c, 9, 5, 20);
	canvas_print(c);
	canvas_free(c);
}
