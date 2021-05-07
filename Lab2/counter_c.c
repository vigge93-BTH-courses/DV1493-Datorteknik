#include <stdlib.h>
#include <stdio.h>

/***********************************************/
/*                                             */
/*                                             */
/*           Do not touch this file            */
/*                                             */
/*                                             */
/***********************************************/

#define NLEDS 4

char gpio[7] = {0}; // 0x601061
void setup(void);
void interrupt(void);
void display_gpio(void);

void
dump_gpio() {
	for(int i=0 ; i<7 ; i++)
		printf("%d: 0x%x\n\r",i, gpio[i]);
}

int
main(int argc, char *argv[]) {
	for(int i=3; i<7; ++i) gpio[i] = '0';
	gpio[2] = 0;
	printf("~=*=~ Binary couter ~=*=~\n");
	printf("Type any character to progress the counter\n");
	printf("Press 'q' to exit the program\n\n");
	system("/bin/stty raw");
	setup();
	while(1) {
		display_gpio();
		char btn = (char)getchar();
		if(btn == 'q') break;
		if(*(short*)gpio & 0xC000 ) {
			gpio[2] = btn;
			interrupt();
		}
	}
	system("/bin/stty cooked");
	printf("\n");
	return 0;
}

void
display_gpio(void){
	printf("\r");
	if(gpio[2] != 0)
		printf("[39;104m%c[0;0m", gpio[2]);
	else
		printf("-");
	for(size_t i = 3; i<NLEDS+3 ; ++i) {
		if((*(short*)gpio) & ((0x2<<6) << (2*(4-(i-2))))) {
			if(gpio[i] == '1')
				printf("[39;101m%c[0;0m", gpio[i]);
			else if(gpio[i] == '0')
				printf("[39;100m%c[0;0m", gpio[i]);
			else
				printf("-");
		} else printf("-");
	}
	printf("\r");
}
