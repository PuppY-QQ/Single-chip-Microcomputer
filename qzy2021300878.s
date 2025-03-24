ORG		0000H
AJMP	START

ORG 	001BH					//中断服务程序入口
AJMP	TIME

ORG		0030H					//主程序
//SJMP	MAIN
START:							//初始化
MOV		P2,#0FFH				//设为输入
MOV		P1,#0FFH				//设为输入
MOV		P0,#0FFH				//设为输入

MOV		TMOD,#01H               //初始化定时器
MOV		TH0,#3CH
MOV		TL0,#0B0H               //50MS
SETB	TR0						
SETB	EA
SETB	ET0

MOV		10H,#14H				//20个50ms
MOV		R5,#14H				   //对每秒计数
MOV		R4,#23H				   //35s绿灯
MOV		R3,#00H				   //黄灯记号
MOV		R1,#08H                //储存八种信号灯状态

MOV		20H,#03H			   //数码显示器初始化
MOV		21H,#05H
MOV		22H,#04H
MOV		23H,#00H
	
MOV		P2,#15H					//初始化数码显示器
MOV  	P1,#01H					//初始化数码显示器控制引脚


LOOP:						   //循环程序，动态扫描数码显示器
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

AJMP LOOP					  //循环显示

TIME:						  //中断程序
DJNZ	R5,RER5				  
MOV		R5,#014H				  //计1s后重新计数
AJMP	GREEN
//DJNZ	R4,RETT					  //检查灯剩余时间是否为0
//AJMP 	LIGHT					  //为0跳转

RER5:						  
MOV		TH0,#3CH			  //重装计数初值
MOV		TL0,#0B0H
SETB	TR0
RETI

GREEN:						  //检查绿/黄灯的个位数是否为0
MOV		A,21H
JZ		REGRE				  //为0，跳转
DEC		21H					  //不为0，自减1
SJMP	RED					  //跳转检查红灯个位数是否为0

REGRE:						  //处理黄/绿灯借位
DEC		20H					  //十位自减1
MOV		21H,#09H			  //个位置为9

RED:						  //检查红灯的个位数是否为0
MOV		A,23H
JZ		REY					  //为0，跳转
DEC		23H					  //不为0，自减1
DJNZ	R4,RETT					  //检查灯剩余时间是否为0
AJMP 	LIGHT					  //为0跳转到下一状态
RETI

REY:
DEC		22H
MOV		23H,#09H
DJNZ	R4,RETT					  //检查灯剩余时间是否为0
AJMP 	LIGHT					  //为0跳转到下一状态
RETI

LIGHT:
MOV   	DPTR,#COLOR			  
MOV   	A,R1
MOVC 	A,@A+DPTR
MOV		A,R3
JNZ		MAIN					  //检查此时是否为黄灯,是黄灯，跳转重新计时	

XXX:
MOV		R3,#01H					  //黄灯标记
MOV		R4,#5H					  //装载5s黄灯
MOV		20H,#00H			      //数码显示器初始化
MOV		21H,#05H
MOV   	DPTR,#COLOR			  
DEC		R1					      //执行下一个指示灯状态
MOV   	A,R1
MOVC 	A,@A+DPTR 
MOV		P2,A	  
RETI

RETT:							  //退出中断的程序
MOV   	DPTR,#COLOR			  
MOV   	A,R1
MOVC 	A,@A+DPTR 
MOV		P2,A	  
RETI

MAIN:
MOV   	DPTR,#COLOR			  
DEC		R1					      //执行下一个指示灯状态
MOV   	A,R1
MOVC 	A,@A+DPTR 
MOV		P2,A
RE:
MOV		20H,#03H			      //恢复数码显示器初始化
MOV		21H,#05H
MOV		22H,#04H
MOV		23H,#00H

MOV		A,P1
RR		A						  //把绿灯移到下一个路口
RR		A
MOV		P1,A
MOV		R4,#23H					  //重装绿灯计时
MOV		R3,#00H					  //清除黄灯标记
MOV		TH0,#3CH			      //重装计数初值
MOV		TL0,#0B0H				  
SETB	TR0
MOV		A,R1					  //检查是否到最后一个状态
JZ		REEE					  //若是，重新开始循环
RETI

REEE:
MOV		R1,#08H
RETI
 
DEL:				   //动态扫描的延时程序
MOV  R6,#1AH
DL2:
MOV  R7,#10H
DL1:
//NOP
NOP
DJNZ  R7,DL1
DJNZ  R6,DL2
RET		  

TABDIG:				   //1-9字形码
    DB  3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH,77H,7CH,39H,5EH,79H,71H,40H 

COLOR:				   //红绿灯逻辑码
	DB	15H,56H,54H,59H,51H,65H,45H,95H,15H
			 											 
END