# 행위 수준 모델링(Behavioral Level Modeling)



[TOC]

## Always 와  Initial 구문

### Always문

- 기능 : 시뮬레이션이 진행되는 동안 무한히 반복적으로 실행된다.
- 활용 :
  - **논리합성 지원** - 조합논리회로, 순차논리회로의 모델링
  - 테스트벤치 작성

- 형식

  ```verilog
  always [@(sensitivity_list)] begin
      blocking_or_unblocking statements;
  end
  ```

  - sensitivity_list : 감지해야 할 모든 입력신호를 여기 나열한다. @(s1 or s2 or s3) 나 @(s1, s2, s3) 로 넣어 주면 된다.나열된 신호 목록 중 하나 이상이 변화가 생겼을 때, always문 내부의 begin-end 블록이 실행됨. (블록 처리 안 해주면 한 줄만 실행됨)

    - 조합 논리회로를 설계하는 경우, 우변에 오는 신호(모든 입력 신호)를 모두 감지신호 목록에 넣어줘야 오류나 **메모리 낭비** 없이 설계할 수 있다. 

      - 만약 빠트리게 되면 원하지 않는 메모리가 더 생긴다.

    - TIP - @(\*)나 @\*를 넣으면, 우변에 언급되는 모든 net과 variable을 넣어주는 것과 동치다. 
  
      ```verilog
      always @*				// equivalent to @(b)
          begin
              @(i) kid = b; // i is not added to @*
        end
      ```
  
      ```verilog
      always @*				// equivalent to @(a or b or c or d) and @(a,b,c,d)
          begin
              tmp1 = a&b;
              tmp2 = c&d;
              y = tmp1 | tmp2;
        end
      ```
  
    
    
  - 순차 논리회로를 설계하는 경우, posedge clk 와 같은 것을 넣어주는 식으로 clk 신호를 구현한다.
  
-  always 구문을 테스트 벤치에 사용하는 경우
  
    반드시 **시간의 진행에 관한 제어(이를테면 delay)가 포함**되어야 한다. 그렇지 않으면 zero-delay infinite loop가 발생해 deadlock에 빠진다.
    
    ```verilog
    // 무한 루프 예시
    always clk = ~clk;
    // 이렇게 고쳐야 한다 - 주기가 40ns인 clock 짜기
    always #20 clk = ~clk;
    ```
    
  - 내부의 begin-end 블록은 절차형 문장들로 구성되며, 나열된 순서대로 실행된다.



### Initial 문

- 기능:  시뮬레이션이 진행되는 동안 단 한 번 실행된다.

- 활용: **논리합성 미지원**. 주로 테스트벤치에 사용한다.

- 형식

  ```verilog
  initial begin
      blocking_or_nonblocking statements;
  end
  ```

- 예시 코드

  ```verilog
  /* 시뮬레이션에 사용할 입력 신호 생성 */
  initial begin
      	din = 6'b000000;
      #10 din = 6'b011001;
      #10 din = 6'b011011;
      #10 din = 6'b011000;
      #10 din = 6'b001000;
  end
  ```

  ```verilog
  /* 변수 값 초기화 */
  initial begin
      areg = 0;
      for(index=0; index<size; index = index+1)
          memory[index] = 0;
  end
  ```

물론 굳이 initial문으로 넣지 않고 그냥 선언과 동시에 initialize 해도 된다. 둘 다 논리합성 안 되는 건 마찬가지.

## 절차형 할당문

- 기능 : reg, integer, time, real, realtime 자료형의 변수에 값을 갱신(할당)함.
  - 할당문 우변의 비트 수가 좌변 변수의 비트 수보다 작다면, 우변이 signed일 경우 우변의 값이 좌변의 비트 크기만큼 부호 확장(MSB 자동삽입)이 됨
- 연속 할당과 절차형 할당의 차이
  - 연속할당 : 입력 피연산자의 값에 변화가 발생할 때마다 우변의 식이 평가되고, 그 결과 값이 좌변의 net을 구동함. 하드웨어적 특성 가짐.
  - 절차형 할당 : 문장이 나열된 순서대로 실행됨. 소프트웨어적 특성 가짐.

### Blocking 할당문

현재 할당문이 실행될 때까진 바로 다음 할당문의 실행이 차단(blocking)된다는 의미에서 blocking 할당문이다.

- 형식

  ```verilog
  // 연산자 = 사용
  reg_lvalue = [delay_or_event_operator] expression
  ```

  - reg_lvalue : reg, integer, time, real, realtime 자료형인 변수가 들어가야 한다.
  - delay : #6와 같은 지연을 넣어주면 됨
  - event_operator : @(posedge clk)와 같은 이벤트 연산자
  - expression: 좌변의 변수에 할당될 값.

### Nonblocking 할당문

순차적 흐름에 의한 blocking 없이, **우변의 값들이 미리 동시에 평가**되고 정해진 할당 스케줄(assignment scheduling)에 의해 값이 할당됨. / 교수님은 한꺼번에 할당된다고 소개하신다..

- 할당 스케줄이란?

  - 문장의 나열 순서, 지정된 지연 값 등. 

- 활용: 

  - 동일 시점에서 변수들의 순서나 상호 의존성에 의해 할당이 이루어져야 하는 경우에 사용됨.

    예를 들면, 교환 연산을 할 때 tmp 저장소를 따로 둘 필요 없이 그냥 a<=b; b<=a; 라고만 써줘도 되는 것.
    
  - Flip-Flop이 만들어진다.

- 형식:

  ```verilog
  // 연산자 <= 사용
  reg_lvalue <= [delay_or_event_oprator] expression
  ```

  <= 연산자는 수식 내부에 사용되면 관계 연산자로 해석되고, 할당문에 사용되면 할당 기호로 해석된다.

### Blocking VS Nonblocking

```verilog
module non_blk1;
    output out;
    reg a, b, clk;
    
    initial begin
        a = 0;
        b = 1;
        clk = 1;
    end
    
    always clk = #5 ~clk;
    
    always @(posedge clk) begin
        a <= b;
        b <= a;
    end
endmodule
```

이렇게 Nonblocking 할당문을 쓸 경우 우변의 값은 미리 평가되어 클락이 올 때 a와 b가 서로 0과 1을 교환하는 형태로 파형이 나타난다. 

a와 b에 할당할 각 값은 미리 준비해놓고, clk의 positive edge가 나타날 때 동시에 할당을 하는 것. 참고로 블록 안의 할당은 clock의 edge보다 아주 조금 늦게 일어난다.

```verilog
module non_blk1;
    output out;
    reg a, b, clk;
    
    initial begin
        a = 0;
        b = 1;
        clk = 1;
    end
    
    always clk = #5 ~clk;
    
    always @(posedge clk) begin
        a = b; // a = 1
        b = a; // b = a = 1
    end
endmodule
```

blocking 할당문을 쓸 경우, b = a는 a = b가 대입된 이후에 평가가 되므로 교환이 제대로 이루어지지 않는다.  이 때 clk의 edge와 할당하는 시점은 같다. 하드웨어적으론 불가능한 동작이다.



지연을 갖는 경우...

```verilog
module non_block2;
    reg a, b, c, d, e, f;
    // blocking assignments
    initial begin
        a = #10 1; // 10ns에 실행
        b = #2  0; // 12ns에 실행
        c = #4  1; // 16ns에 실행
    end
    
    // non-blocking assignments
    initial begin
        d<= #10 1; // 10ns에 실행
        e<= #2  0; // 2ns 에 실행
        f<= #4  1; // 4ns에 실행
    end
endmodule
```

이렇게, blocking 할당문을 쓸 경우 앞선 할당문의 delay가 끝나고 실행이 마칠 때까지 뒤의 할당문의 delay가 흐르지 않는 반면, non-blocking을 쓸 경우 각각 할당문의 delay는 0초부터 따로 흐른다.

물론 #delay를 할당문 앞쪽에 배치했을 경우, 똑같이 10ns, 12ns, 16ns 시점에 실행이 된다.

```verilog
module multiple2;
    reg al
    initial a=1;
    initial begin
        a <= #4 1; // 4ns a = 1
        a <= #4 0; // 4ns a = 0
        #20 $stop; // 4ns 시점에, a에는 0이 저장. (지연이 동일하므로 순서는 나열순서를 따름.)
    end
endmodule
```



- 강의 예제

  ```verilog
  always @(posedge clk) begin
      a =  b + c;
      d =  a * 10;
      e <= d + f;
  end
  ```

  라는 코드는, blocking과 nonblocking 할당문의 특성에 따라

  ```verilog
  always @(posedge clk) begin
      a = b+c;
      a = a*10;
      e <= a + f;
  end
  ```

  라는 코드와 같다.

  ```verilog
  always @(posedge clk) begin
      a <= b + c;
      d <= a * 10;
      e <= d + f;
  end
  ```

  위 코드는 앞선 코드들과 전혀 다르게 동작한다.

  ![image-20200423180005713](C:\Users\35896\AppData\Roaming\Typora\typora-user-images\image-20200423180005713.png)

  



## 조건문

### if-else 문

- 형태

  ```verilog
  if(expression)
      statement_true;
  [else
      statement_false;]
  ```

  C 언어와 비슷하다. 다만 블록의 범위를 한정하는 {}가 없기 때문에, 들여쓰기를 꼼꼼하게 사용하거나 begin-end 블록으로 묶어주는 것이 좋다.

  expression이 0, x, z일 경우 statement_false 실행 (x,z를 '거짓'으로 취급하는 것은 아니다. !z 도 거짓으로 취급됨.)

  ```verilog
  if(index>0)					// IF1
      if(rega > reg b)		// IF2
          result = rega;
  	else 					// else of the IF2
          result = regb; 
  ```

  ```verilog
  if(index>0) begin			// IF1
      if(rega > reg b)		// If2
          result = rega;
  end			
  else result = regb;			// else of the IF1 
  ```

  또한, C와 마찬가지로 else if(expression) 을 중간에 끼워 넣는 것도 가능하다.

- else 부분이 없다면, expression이 거짓일 때 아무 것도 하지 않으므로 변수는 이전에 할당받은 값을 유지한다. 이 때문에 **latch가 생겨** 원하지 않는 메모리를 발생시킬 수 있다. **// 이쪽 부분 이해가 잘 안 간다.** 따라서 조합논리회로에선 else를 써야 하고, flip-flop 모델에서는 else를 굳이 쓰지 않아도 된다.

- if-elseif 문의 순서를 조정해줌으로써 신호들의 우선순위를 설정해줄 수 있다. 

  ```verilog
  // 비동기식 D 플립플롭 - clk 변화 없어도 set, reset에 따라 동작 변화
  module dff_sr_async(clk, d, rb, sb, q, qb); 
      input clk, d, rb, sb; 
      output q, qb; reg q; 
      always @(posedge clk or negedge rb or negedge sb) 
          begin 
              if(rb == 0) q <= 0;    // reset의 변화가 가장 먼저 고려됨
              else if(sb == 0) q <= 1; 
              else q <= d; 
          end
  	assign qb = ~q; 
  endmodule
  ```

  ```verilog
  // 동기식 D 플립플롭 - clk 동작할 때 set, reset 반영
  module dff_sync_rst(clk, d, rst_n, q, qb); 
      input  clk, d, rst_n; 
      output q, qb; 
      reg    q;
  	assign qb = ~q;
  always @(posedge clk) // include only clk 
      begin 
          if(!rst_n)          // active-low 
              reset q <= 1'b0; 
          else q <= d; 
      end 
  endmodule
  ```

  

### case 문

- 형태

  ```verilog
  case(expression)
      case_item {, case_item} : statement_or_null;
      | default [:] statement_or_null;
  endcase
  ```

  - default문은 선택 사항이고, 단 하나만 존재할 수 있다.
    - 앞선 else와 마찬가지로, 이 항이 없다면 변수는 이전에 할당 받은 값을 유지하며 조합논리회로를 구성할 땐 써주어야 한다.
    - 좋은 코딩을 하려면 default 적극 활용할 것. **마지막 줄을 default로 해주는 것**도 좋은 방법이다. 
  - case_item들은 나열된 순서대로 평가됨.
  - C와 다른 점은 딱 맞는 문장만 실행된다는 점.(break 필요 없음)

- 사용예

  ```verilog
  module mux21_case(a, b, sel, out);
      input   [1:0] a, b;
      input		  sel;
      output  [1:0] out;
      reg		[1:0] out;
      
      always @(a, b, sel) begin
          case(sel)
              0: out = a;
              1: out = b;
          endcase
      end
  endmodule
  ```

  sel이 0이면 a가 output으로 나가고, sel이 1이면 b가 output으로 나간다.

- 조건식에 x나 z가 들어간 경우:

  - case문에서는 0, 1, x, z를 포함해 정확히 같은 경우에만 일치하는 것으로 판단함에 주의해야 한다.  또한 이 경우엔 논리합성이 불가능하다.

  ```verilog
  case(select[1:2])
      2'b00			:result = 0;
      2'b01			:result = flaga;
      2'b0x, 2'b0z	:result = flaga ? 'bx : 0;
      2'b10			:result = flagb;
      2'bx0, 2'bz0	:result = flagb ? 'bx : 0;
      default			:result = 'bx;
  endcase
  ```

- Don't Care 조건을 허용하는 Case문

  - casez: z를 don't care로 취급. don't care조건으로 **? 기호** 사용 가능.
  - casex: x와 z 둘다 don't care로 취급. don't care 조건으로 **x기호** 사용 가능.
  
  나머지 문법 기능들은 case문과 동일하다고. **don't care로 취급하는 해당 비트는 비교에서 제외**한다. **논리 합성 가능! **
  
  <예시>
  
  ```verilog
  /* casez를 사용함. */
  reg [7:0] ir;
  casez(ir) 
      8'b1???????: instruction1(ir); 
      8'b01??????: instruction2(ir); 
      8'b00010???: instruction3(ir); 
      8'b000001??: instruction4(ir); 
  endcase
  ```
  
  ```verilog
  /* Casex를 이용한 우선순위 인코더 */
  module pri_enc_casex(encode, enc);
      input 	[3:0] encode;
      output 	[1:0] enc;
      reg		[1:0] enc;
      
      always@(encode) begin
          casex(encode)
              4'b1xxx : enc = 2'b11;
              4'b01xx : enc = 2'b10;
              4'b001x : enc = 2'b01;
              4'b0001 : enc = 2'b00;
          endcase
      end
  endmodule
  ```
  
- case 조건식에 상수를 넣는 case문

  case 조건식에 상수를 넣어 case_item과 비교시킬 수도 있다.

  ```verilog
  /* 우선순위 인코더 */
  module pri_enc_case(encode, enc);
      input	[3:0] encode;
      output	[1:0] enc;
      reg		[1:0] enc;
      always @(encode) begin
          case(1)
              encode[3] : enc = 2'b11;
              encode[2] : enc = 2'b10;
              encode[1] : enc = 2'b01;
              encode[0] : enc = 2'b00;
              default	  : $display("Error: one of the bits expected ON");
          endcase
      end
  endmodule
  ```

  1을 각 encode 비트 값과 비교하여, 해당 비트가 1이 될 때 문장이 실행되는 모듈이다.



## 반복문

### Forever 문

- 기능: 문장이 무한히 반복적으로 실행된다.
- 활용: **논리합성 지원 안 된다**. 테스트 벤치에서만 사용.

```verilog
forever statement;
```

### Repeat 문

- 기능: 문장이 지정된 횟수만큼 반복된다. 반복 횟수를 나타내는 수식에 x나 z가 들어가면 0으로 취급되어 statement는 실행되지 않는다.

```verilog
repeat (expression) statement;
```



<예시> shift-add 곱셈기

```verilog
module multiplier_8b(opa, opb, result);
    paramenter SIZE = 8, LongSize = 2*SIZE;
    input	[SIZE-1:0]		opa, opb;
    output	[LongSize-1:0]	result;
    reg		[LongSize-1:0]	result;
    
    always @(opa, opb) begin
        shift_opa = opa;
        shift_opb = opb;
        result    = 0;
        repeat(SIZE) begin
            if(shift_opb[0])
                result = result + shift_opa;
            shift_opa = shift_opa << 1;
            shift_opb = shift_opb >> 1;
        end
    end
endmodule
```



### While / For문

- C언어와 비슷하다. while문은 조건식의 값이 참인 이상 계속 반복실행하고, for문은 \[제어 변수 초기화->수식 평가(0, x, z인 경우 루프 탈출)->제어 변수 갱신\] 의 프로세스를 반복한다.

```verilog
while (expression) statement;
for(variable_assign; expression ; variable_assign) statement;
```



## 타이밍 제어

절차형 할당의 실행을 제어하기 위한 제어 방법은 event 제어와 delay 두 가지다. 

- 형태

  - \# delay 제어
  - @ event 제어
  -  while 루프와 event 제어의 조합에 함께 사용되는 wait문

- 문법

  ```verilog
  delay_control ::=
  	      #delay_value
  	    | #(mentypax_expression)
  
  delay_or_event control ::=
  	      delay_control
  	    | event_control
  	    | repeat (expression) event_control
  
  event_control ::=
        @event_identifier
          | @(event_expression)
          | @* or @(*)
          
  event_expression ::=
            expression
          | hierarchical_identifier
          | posedge expression
          | negedge expression
          | event_expression or event_expression
          | event_expression , event_expression
        
  ```

  

### 지연 제어

**합성불가능**

- 기능: 지정된 지연 값만큼 문장의 실행이 지연된다.
- 형식:
  - 지연 값이 x,z일 경우 0으로 처리됨.
  - 지연 값이 음수일 경우 2의 보수 unsigned 정수로 해석함.
  - 지연 값에 수식과 parameter 사용 가능.

<예시>

```verilog
#10 rega = regb;
#d  rega = regb; 			// d is parameter
#((d+e)/2) rega = regb;		// d와 e의 평균을 지연값으로.
```



### Event 제어

**합성가능**

- 기능: 
  - net이나 variable의 값 변화 또는 선언된 이벤트의 발생에 동기화. 
  - net이나 variable의 변화 방향에 따라 검출할 수도 있다 - 플립플롭 설계 필수요소
    - posedge: 0이 1,x,z으로 변하거나 x,z가 1로 변할 시 posedge 검출.
    - negedge: 1이 0,x,z로 변하거나 x, z가 0으로 변할시 negedge 검출. 
  - 만약 event 발생 수식의 결과가 1비트 이상이면 LSB의 변화를 기준으로 삼는다.

- Named Event

  - event라는 자료형을 선언할 수 있다. 사용되기 전에 선언 돼야 함

    ```verilog
    // event 선언문
    event list_of_event_identifiers
    // trigger 문
    -> event_indentifier; 
    ```

  - 특성

    - 임의의특정 시간에 발생될 수 있음
    - 지속 시간을 갖지 않음.
    - event 제어 구문을 이용해서 event 발생을 감지할 수 있다. 

  - 예시

    ```verilog
    module ff_event (clock, reset, din, q);
        input reset, clock, din;
        output q;
        reg q;
        event upedge;     // event 선언
        
        always @(posedge clock)
            -> upedge;
        always @(upedge or negedge reset) begin
            if(reset == 0) q = 0;
            else		   q = din;
        end
    endmodule
    ```

    관계를 잘 모르겠다 아직...

- event들은  **or** 나 **,** 로 묶을 수 있다.

### wait 문

- 기능 : 주어진 조건이 참이 될 때까지 절차형 할당문의 실행을 지연시킴. level-sensitive event 제어. 되도록 **설계할 땐 쓰지 말** 것.

- 문법

  ```verilog
  wait (expression) statement_or_null;
  ```

  조건을 평가하여 참이면 실행, 거짓이면 실행이 중지된다. 

- 예시

  ```verilog
  begin
      wait (!enable) #10 a = b;
      #10 c = d;
  end
  ```

  always wait(expression) statement
  와 always @(expression)은 같은 의미이다.

### Intra-assignment 타이밍 제어 

**논리 합성할 땐 안 된다! 테스트 할 때만**

지금까지 설명된 지연과 event 제어는 절차형 할당문 앞에 위치하며 할당문 자체의 실행을 지연시켰는데, 이 제어는 순차 할당문 내부에 포함된다. 

우변의 수식에 대한 평가를 먼저 실행하고, 좌변의 객체에 새로운 값이 할당되는 시점을 지연시킨다.

즉, 기존의 지연 문은

> 직전 문장 실행  -> delay -> 우변 계산 -> 좌변에 할당

이었다면, 이 경우는

>  우변 계산 -> delay -> 좌변에 할당

식으로 딜레이를 주는 것. 

```verilog
// intra-assignment
a = #5 b;
// equivalent
begin
    temp = b;
    #5 a = temp;
end
```

```verilog
// intra-assignment
a = @(posedge clk) b;
// equivalent
begin
    temp = b;
    @(posedge clk) a = temp;
end
```

```verilog
// intra-assignment
a = repeat(3) @(posedge clk) b;   // clock 신호 3 번 기다리고 실행하라. 
// equivalent
begin
    temp = b;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk) a = temp;
end
```

만약 이걸 하드웨어로 구현하고 싶다면?

always @(posedge clk)  begin문을 이용해... 





## 블록문

- 형식

  - begin-end :  절차형 할당문 블록
    - 문장의 나열 순서에 따라 **순차적**으로 실행된다. - 마지막 문장이 실행되면 종료.
  - fork-join    : 병렬문 블록
    - 나열 순서와 무관하게 **동시**에 실행됨. 			-  지연을 고려해 마지막에 실행되는 문장 실행 후 종료.

- 블록 이름

  - begin이나 fork 뒤에

    > :name_of_block

    를 추가해서 블록 이름을 붙일 수 있음.

  - 이점 : 

    - 지역변수와 parameter, named event를 해당 블록을 위해서만 선언 가능.
    - disable 문에서 특정 블록 참고 가능

- 블록은 서로 중첩이 가능하다.



### Begin-end 절차형 할당문 블록

- 특징

  - 블록 내 문장들은 **나열된 순**대로 순차적 실행

    ```verilog
    begin
        areg = breg;
        creg = areg; // creg stores the value of breg
    end
    ```

  - delay는 이전 문장의 시뮬레이션 시간에 대해 **상대적**으로 결정됨.

  - 제어는 문장이 나열된 순서를 기준으로 마지막 문장의 실행이 완료된 이후에(블록이 끝난 후에) 블록 밖으로 전달된다.



### fork-join 블록

- 특징
  - 블록 내 문장들은 **동시에**수행됨.
  - 각 문장의 delay는 각 문장 사이의 상대적인 지연이 아닌 **블록에 들어가는 시뮬레이션 시간을 기준으로** 결정된다.
  - 제어는 시간적으로 마지막에 실행되는 문장의 실행이 완료된 이후에(블록이 끝난 다음) 블록 밖으로 전달됨.
  - 회로 만들 때는 쓰면 안 되고, **테스트 벤치 만들 때만** 써라!