#include <stdio.h>
#include <stdlib.h>

struct canvas 
	unsigned int size;
	unsigned int height;
	unsigned int width;
	unsigned char *canvasArray;
};

struct canvas *canvas_create(unsigned int width, unsigned int height) 
	struct canvas *canvas = (struct canvas*)malloc(sizeof(struct canvas));
	if ((height * width * 2) % 8 == 0) canvas->size = ((height * width) / 4);
	else canvas->size = ((height * width * 2) / 8) + 1;
	canvas->height = height;
	canvas->width = width;
	canvas->canvasArray = (unsigned char *)malloc(canvas->size * sizeof(unsigned char));
	//vynulovani
	for (int i = 0; i < canvas->size; i++) 
		canvas->canvasArray[i] = 0;
	}
	return canvas;
}

void canvas_free(struct canvas *canvas) 
	free(canvas->canvasArray);
	free(canvas);
}

void canvas_print(struct canvas *canvas) 
	int countSymbolsOnRow = 0; // pociadlo printnutych symbolu na 1 radku
	unsigned char editedByte = 0;
	int bitCounter = 0; // kolik celkem bitu printnuto
	unsigned char mask = 128; // v bitech 1000 0000
	
	for (int i = 0; i < canvas->size; i++) 
		// zpracovavany byte
		editedByte = canvas->canvasArray[i];
		// ve vnitrnim cyklu vzdy posunuju o index j a s maskou delam bitovy AND, tim zjistim 
		// jestli je na indexu 0 nebo 1
		for (int j = 0; j < 8; j++) 
			if (bitCounter == canvas->height * canvas->width * 2) break;
			if (countSymbolsOnRow == canvas->width) {
				printf("\n"); 
				countSymbolsOnRow = 0;
			}
			if ((editedByte << j) & mask) 
				j++;
				if ((editedByte << j) & mask) printf("+"); // kdyz je dvojice bitu 11
				else printf("|");						   // kdyz je dvojice bitu 10
				bitCounter += 2;
			} else {
				j++;
				if ((editedByte << j) & mask) printf("-"); // kdyz je dvojice bitu 01
				else printf(".");			 // kdyz je dvojice bitu 00
				bitCounter += 2;
			}
			countSymbolsOnRow++;
		}
	}
}

void canvas_hline(struct canvas *canvas, unsigned int x, unsigned int y, int length) 
	int inOneByte = 4;
	int actualByte = 0;
	int moveBitsOnPosition = 0;
	int indexToProcess = 0;
	unsigned char mask = 64; // v bitech 0100 0000
	int intX = x;

	// prepocitavam hodnoty length a souradnice x, abych vzdycky posouval bity doprava
	// od souradnice x,
	if ((intX + length) < 0) 
		length = (x + length) * (-1);
		x = 0;
	}
	if ((length < 0) && ((x + length) > 0)) 
		x = x + length + 1;
		length = length * (-1);
	}
	if ((x + length) > (canvas->width - 1)) 
		length = canvas->width - x;
	}
	indexToProcess = x;
	// posunuju o index moveBitsOnPosition a s maskou delam bitovy OR
	for (int i = 0; i < length; i++) {
		actualByte = indexToProcess / inOneByte + (y * (canvas->size / canvas->height));
		moveBitsOnPosition = (indexToProcess % inOneByte) * 2;
		canvas->canvasArray[actualByte] = (mask >> moveBitsOnPosition) | canvas->canvasArray[actualByte];
		indexToProcess++;
	}	
}

void canvas_vline(struct canvas *canvas, unsigned int x, unsigned int y, int length) {
	int inOneByte = 4; // párù v 1 bajtu
	int actualByte = 0;
	int moveBitsOnPosition = 0; // o kolik posunuju bitù
	int indexToProcess = x; // zpracovavany index
	int len = length;
	int sizeOfRow = canvas->size / canvas->height;
	int processedRow = 0; // zpracovavany radek
	unsigned char mask = 128;

	if (length < 0) len *= -1;
	if ((y + length) > canvas->height) len = canvas->height - y;
	for (int i = 0; i < len; i++) {
		if ((indexToProcess < canvas->width) || (indexToProcess >= 0)) {
			actualByte = indexToProcess / inOneByte + (y * sizeOfRow + processedRow);
			moveBitsOnPosition = (indexToProcess % inOneByte) * 2;
			canvas->canvasArray[actualByte] = (mask >> moveBitsOnPosition) | canvas->canvasArray[actualByte];
			if (length < 0) processedRow -= sizeOfRow;
			else processedRow += sizeOfRow;
		}
		else break;
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
	return 0;
}
