ORG		0000H
AJMP	START

ORG 	001BH					//�жϷ���������
AJMP	TIME

ORG		0030H					//������
//SJMP	MAIN
START:							//��ʼ��
MOV		P2,#0FFH				//��Ϊ����
MOV		P1,#0FFH				//��Ϊ����
MOV		P0,#0FFH				//��Ϊ����

MOV		TMOD,#01H               //��ʼ����ʱ��
MOV		TH0,#3CH
MOV		TL0,#0B0H               //50MS
SETB	TR0						
SETB	EA
SETB	ET0

MOV		10H,#14H				//20��50ms
MOV		R5,#14H				   //��ÿ�����
MOV		R4,#23H				   //35s�̵�
MOV		R3,#00H				   //�ƵƼǺ�
MOV		R1,#08H                //��������źŵ�״̬

MOV		20H,#03H			   //������ʾ����ʼ��
MOV		21H,#05H
MOV		22H,#04H
MOV		23H,#00H
	
MOV		P2,#15H					//��ʼ��������ʾ��
MOV  	P1,#01H					//��ʼ��������ʾ����������


LOOP:						   //ѭ�����򣬶�̬ɨ��������ʾ��
MOV		DPTR,#TABDIG
//*1*						   
MOV   A,20H
MOVC  A,@A+DPTR
MOV   P0,A
ACALL DEL
MOV   A,P1
RL    A
MOV   P1,A

//*2*
MOV   A,21H
MOVC  A,@A+DPTR
MOV   P0,A
ACALL DEL
MOV   A,P1
RL    A
MOV   P1,A

//*3*
MOV   A,22H
MOVC  A,@A+DPTR
MOV   P0,A
ACALL DEL
MOV   A,P1
RL    A
MOV   P1,A

//*4*
MOV   A,23H
MOVC  A,@A+DPTR
MOV   P0,A
ACALL DEL
MOV   A,P1
RL    A
MOV   P1,A

//*5*
MOV   A,22H
MOVC  A,@A+DPTR
MOV   P0,A
ACALL DEL
MOV   A,P1
RL    A
MOV   P1,A

//*6*
MOV   A,23H
MOVC  A,@A+DPTR
MOV   P0,A
ACALL DEL
MOV   A,P1
RL    A
MOV   P1,A

//*7*
MOV   A,22H
MOVC  A,@A+DPTR
MOV   P0,A
ACALL DEL
MOV   A,P1
RL    A
MOV   P1,A

//*8*
MOV   A,23H
MOVC  A,@A+DPTR
MOV   P0,A
ACALL DEL
MOV   A,P1
RL    A
MOV   P1,A			 	 

AJMP LOOP					  //ѭ����ʾ

TIME:						  //�жϳ���
DJNZ	R5,RER5				  
MOV		R5,#014H				  //��1s�����¼���
AJMP	GREEN
//DJNZ	R4,RETT					  //����ʣ��ʱ���Ƿ�Ϊ0
//AJMP 	LIGHT					  //Ϊ0��ת

RER5:						  
MOV		TH0,#3CH			  //��װ������ֵ
MOV		TL0,#0B0H
SETB	TR0
RETI

GREEN:						  //�����/�ƵƵĸ�λ���Ƿ�Ϊ0
MOV		A,21H
JZ		REGRE				  //Ϊ0����ת
DEC		21H					  //��Ϊ0���Լ�1
SJMP	RED					  //��ת����Ƹ�λ���Ƿ�Ϊ0

REGRE:						  //�����/�̵ƽ�λ
DEC		20H					  //ʮλ�Լ�1
MOV		21H,#09H			  //��λ��Ϊ9

RED:						  //����Ƶĸ�λ���Ƿ�Ϊ0
MOV		A,23H
JZ		REY					  //Ϊ0����ת
DEC		23H					  //��Ϊ0���Լ�1
DJNZ	R4,RETT					  //����ʣ��ʱ���Ƿ�Ϊ0
AJMP 	LIGHT					  //Ϊ0��ת����һ״̬
RETI

REY:
DEC		22H
MOV		23H,#09H
DJNZ	R4,RETT					  //����ʣ��ʱ���Ƿ�Ϊ0
AJMP 	LIGHT					  //Ϊ0��ת����һ״̬
RETI

LIGHT:
MOV   	DPTR,#COLOR			  
MOV   	A,R1
MOVC 	A,@A+DPTR
MOV		A,R3
JNZ		MAIN					  //����ʱ�Ƿ�Ϊ�Ƶ�,�ǻƵƣ���ת���¼�ʱ	

XXX:
MOV		R3,#01H					  //�ƵƱ��
MOV		R4,#5H					  //װ��5s�Ƶ�
MOV		20H,#00H			      //������ʾ����ʼ��
MOV		21H,#05H
MOV   	DPTR,#COLOR			  
DEC		R1					      //ִ����һ��ָʾ��״̬
MOV   	A,R1
MOVC 	A,@A+DPTR 
MOV		P2,A	  
RETI

RETT:							  //�˳��жϵĳ���
MOV   	DPTR,#COLOR			  
MOV   	A,R1
MOVC 	A,@A+DPTR 
MOV		P2,A	  
RETI

MAIN:
MOV   	DPTR,#COLOR			  
DEC		R1					      //ִ����һ��ָʾ��״̬
MOV   	A,R1
MOVC 	A,@A+DPTR 
MOV		P2,A
RE:
MOV		20H,#03H			      //�ָ�������ʾ����ʼ��
MOV		21H,#05H
MOV		22H,#04H
MOV		23H,#00H

MOV		A,P1
RR		A						  //���̵��Ƶ���һ��·��
RR		A
MOV		P1,A
MOV		R4,#23H					  //��װ�̵Ƽ�ʱ
MOV		R3,#00H					  //����ƵƱ��
MOV		TH0,#3CH			      //��װ������ֵ
MOV		TL0,#0B0H				  
SETB	TR0
MOV		A,R1					  //����Ƿ����һ��״̬
JZ		REEE					  //���ǣ����¿�ʼѭ��
RETI

REEE:
MOV		R1,#08H
RETI
 
DEL:				   //��̬ɨ�����ʱ����
MOV  R6,#1AH
DL2:
MOV  R7,#10H
DL1:
//NOP
NOP
DJNZ  R7,DL1
DJNZ  R6,DL2
RET		  

TABDIG:				   //1-9������
    DB  3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH,77H,7CH,39H,5EH,79H,71H,40H 

COLOR:				   //���̵��߼���
	DB	15H,56H,54H,59H,51H,65H,45H,95H,15H
			 											 
END