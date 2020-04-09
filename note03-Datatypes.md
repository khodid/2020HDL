# 자료형

강의일: 4월 10일 강의 FL (4주차)
학습목표: 

- 디지털 하드웨어는 논리 값으로 상태를 표현한다. 하드웨어가 가지는 상태를 Verilog HDL에서 표현하는 방법, 신호가 갖는 자료형(data type)을 알아보자.



## Verilog의 논리값

| 논리값 |           의   미           |
| :----: | :-------------------------: |
|   0    | logic zero, false condition |
|   1    |  logic one, true condition  |
|   x    |     unknown logic value     |
|   z    |    high-impedance state     |

디지털 논리회로를 표현하는 것이기 때문에, 논리 값을 이용한다. 

- unknown value : 
   회로를 만들다 보면 0과 1이 충돌이 되거나, 입력이 정해지지 않아 특정 논리값이라고 확정지을 수 없는 경우가 있다. 0이 되기도 하고 1이 되기도 하고, 불안정한 형태로 나타난다.
   디지털 신호라는 건 0V와 3.3V, 또는 0V와 5V를 기준으로 삼는데, 그 중간 값을 갖는 경우는? 뭔가가 **잘못된 상태**이지만 이 역시 표시할 방법이 있어야 잘못되었다는 걸 말해줄 수 있다. 그래서 눈에 잘 띄라고 unknown의 색깔을 빨간 색으로 표시하는 편이다.
  - 의도를 가지고 **만들어낼 수 있는 상태가 아니다**.
  - 코딩을 할 때 **조건문에 들어갈 수 없다**. 0과 1의 _중간값_ 이 아니라 _0인지 1인지 알 수 없는 값_ 이기 때문.
    " a가 unknown이면 ~ " (X)

- high-impedance :
   끊어졌다는 뜻. 삼상 버퍼(Tri state buffer)와 같은 형태로 회로에서 구현된다. 주로 버스를 만들 때 사용된다. 
  - 의도를 가지고 **만들어낼 수 있는 상태**다. (저항 쎄게 걸기)
  - 신호에 high impedence에 걸렸는지는 확인하지 못한다. 따라서 **조건문에 들어갈 수 없다**.



## Verilog HDL 자료형

자료형은 크게 두가지로 나눌 수 있다.

### Net 자료형

- 특징:
  - 논리 게이트나 모듈 등 하드웨어 요소(소자)들 사이의 물리적 연결(와이어 선이나 간단한 회로)을 나타내기 위해 사용함.
  - Driver(구동자; 연속할당문, 게이트 프리미티브)의 값에 의해 net의 값이 연속적으로 유지됨 - **값을 저장하지 않음**. 주어지는 입력에 의해 계속 바뀐다.
  - Driver가 **연결되지 않으면, default 초기값인 high-impedence**가 됨. 
  - 예외: *trireg net* 은 값을 저장하고, 이전에 구동된 값을 유지한다.
- 종류: **wire**, tri, wand, triand, trior, supply0, supply1, tri0, tri1, trireg
- **Default 자료형: 1 비트의 *wire* ** 
  따라서 선언하지 않고 대뜸 변수를 쓰면, 컴파일러에선 이를 1비트 wire로 인식한다.

 Verilog가 처음에 생겼을 때 필요했기 때문에 다양한 type이 있지만, CMOS? 라는 공정으로 통일이 됐기 때문에 **실제 모델링에선 wire 형만 쓰는 편이다**. 

- 자료형 소개: wire, supply0, supply1, tri

  - wire: 단순 연결 기능을 하는 net

  - supply0: 회로 접지(circuit ground)에 연결되는 net.

  - supply1: 전원(power supply)에 연결되는 net

    - 단순히 a=1을 주는 것보단 a=supply1 이런 식으로 주는 게 훨씬 좋다.

  - tri: 3상태 net에 사용한다.

    아래, <wire, tri net의 진리표> (두 개의 신호가 충돌났을 때)

    | wire/tri |   0   |   1   |  x   |   z   |
    | :------: | :---: | :---: | :--: | :---: |
    |  **0**   |   0   |   x   |  x   | **0** |
    |  **1**   |   x   |   1   |  x   | **1** |
    |  **x**   |   x   |   x   |  x   |   x   |
    |  **z**   | **0** | **1** |  x   |   z   |

    - unknown은 어느 신호와 만나도 unknown
    - high-z는 어느 신호를 만나도 다른 신호를 그대로 유지하게 한다.
    - 이외 다른 wired net의 진리표(wand, triand, wor, trior, tri0, tri1)가 소개되었지만... 실전에서 안 쓴다니깐 그냥 안 적고 넘어가겠다. 필요할 일이 있으면 그 때 검색하자.

    

- net 자료형 선언의 예

  ```verilog
  wire w1, w2;			// 1비트 wire 자료형은 선언 생략 가능
  wire [7:0] bus;			// 8비트 버스 선언
  
  wire enable=1'b0;		// 0을 초기값으로 갖는 1비트 wire 
  /* "설계"할 때 위처럼 하지 마라. 하드웨어는 초기값이 있을 수 없다.
  모든 초기값은 reset으로 초기화한다(for flipflop or memory).
  다만 테스트를 위해, 실험자료 만들 땐 써도 된다. */
  
  wand w3;				// 
  tri [15:0] busa;		// 
  ```

   C 프로그래밍은 무조건 변수를 선언을 하고 써야 하는데, 여기선 그냥 w1, w2, 선언 문구 없이 바로 써먹어도 된다. default가 1비트 wire니깐. 
  그런데 오히려 실수로 변수 선언을 하지 않아도 컴파일 에러가 뜨지 않는다는 점 때문에 더 어려울 수 있음.



### Variable 자료형

- 특징: 
  - 절차형 할당문의 실행에 의해 그 값이 바뀌며, 할당에서부터 다음 할당까지 값을 유지함(임시 저장, 기억). 즉 특수한 문장에 의해서만 사용된다.
  - Default 초기값: 
    - reg, time, integer형: x(unknown)
    - real, realtime형: 0.0
  - variable에 음의 값을 주는 경우
    - signed reg, integer, real, realtime 형: 부호를 유지
    - unsigned reg, time 형: 2's compliment로 저장된 값을 unsigned값으로서 그대로 인식한다.
- 기억할 수 있는, 순차회로용으로 탄생 (플립플롭, 메모리)
- 종류: **reg**, **integer**, real, time, realtime
  - signed reg와 integer의 차이: integer는 무조건 32비트.

  저장 장치(레지스터)를 표현하기 위해 있는 것이다.

 **실제 모델링에선 reg(레지스터)형과 integer** 형을 쓰는 편이다. 나머지는 제공되긴 하나 실제제 회로 합성에 사용하지 않음. 테스트용이다.



#### reg 자료형

- 개요: 
  - 레지스터. 절차적 할당문에 의해 값을 받는 자료형. 값을 기억하는 회로와 저장 소자(플립플롭\_edge-sensitive[^1], 래치\_level-sensitive[^2] 등)를 모델링 할 때 쓴다. 
  -  항상 하드웨어적인 저장소자만을 의미하지 않는다. 조합논리회로의 모델링에도 일반적인 wire, AND gate, OR gate 등으로 사용할 수 있다. verilog 언어는 자료형의 쓰임에 엄격하진 않다.

- reg 자료형 선언의 예

  ```verilog
  reg a;							// a scalar reg
  reg [3:0] v;					// 4비트 레지스터(vector)
  reg signed [3:0] signed_reg;	// -8에서 7사이의값을 갖는 4비트 vector
  reg [-1:4] b;					// 6 비트 벡터 reg
  reg [4:0] x, y, z;				// 전부 다 5비트 레지스터로 선언됨
  ```

  - reg의 경우 선언하지 않고 사용하면 에러가 난다.

- reg형 변수 사용 예

  ```verilog
  module dff(clk, d, qout):
      input d, clk;
      output qout;
      reg qout;
      
      always @(posedge clk) begin
          qout <= d;					// ** 주목
      end
  endmodule
  ```

  위와 같이, **always문으로 시작하는 블록에서 사용되는 변수는 reg형으로 선언**되어야만 한다.



#### reg 이외의 variable 자료형

- integer 자료형
  - 정수형 값을 취급하며, 절차적 할당문에 의해 값이 변경된다.
  - signed reg와 동치
- time 자료형
  - 시뮬레이션 시간을 표시, 처리하거나 저장하기 위해 사용된다.
  - 64비트의 unsigned reg와 동치

- real, realtime
  - 실수형 값을 취급함. / 설계용 X, 테스트용O

``` verilog
integer a;			// 정수형 값
time last_chng;		// 시간 값을 표시하는 변수
real float;			// 실수 값을 저장하는 변수
realtime rtime;		// 실수 값으로 시간을 저장하는 변수
```



#### Net 형과 Variable 형의 비교

- 할당 모드(lec 7에서 자세히 다룰 거임)
  - net: 프리미티브 출력, 연속할당문, force...release PCA 에서 사용 가능
  - variable:  프리미티브 출력 (sequential 한정), 절차형 할당문, assign...deassign PCA 에서 사용 가능



### 벡터

- 벡터 Vector
  - 범위 지정을 갖는 여러개 비트의 net 또는 reg 자료형
  - 특별히 signed로 선언하거나 signed로 선언된 포트에 연결되는 경우를 제외하곤 unsigned 취급을 함.
  - 단일 할당문으로 값을 받을 수 있다. (**한방에 전체 값 주기 가능**)

- 벡터의 선언

  > \<data_type\> [msb : lsb] \<identifier\>

  ```verilog
  reg [7:0] regs;			// 8비트 reg
  wire [15:0] d_out;		// 16비트 wire
  ```



### 배열

- 배열 Array

  - 별도의 자료형 없음. reg이나 wire 선언을 이용해 선언해줌.
  - 전체 또는 일부분을 한번(동시)에 값 주는 게 불가함. **element 단위로 값을 할당하고 참조하는** 수밖에 없음.
  - RAM, ROM, Resister File 등의 **메모리 모델링**에 사용한다.

- 배열의 선언

  > \<data_type\> \<identifier\> \[ Uaddr : Laddr \] \[ Uaddr2 : Laddr2 \]
  >
  > \<date_type\> \[ msb : lsb \] \<identifier\> \[ Uaddr : Laddr \] \[ Uaddr2 : Laddr2 \]

  벡터는 1D만 가능한 반면, 배열은 2D, 3D, 4D까지도 가능하다. 
  그리고 식별자 뒤쪽으로 index가 온다.

  ```verilog
  /* 배열 선언 */
  
  reg [7:0] mema [0:255];	// memory mema of 256 8-bit registers
  reg arrayb[7:0][0:255];	// 2-D array of 1-bit registers
  wire w_array[7:0][5:0];	// an array of wires
  integer inta[1:64]		// an array of 64 integer values
  time chng_hist[1:1000];	// an array of 1000 time values
  
  
  /* 배열 요소에 대한 할당 */
  
  /* 1. 불가능한 문법 ILLEGAL syntax */
  mema = 0;		// 배열 전체에 쓰기 시도
  arrayb[1] = 0;	// arrayb[1][0]부터 arrayb[1][255]까지 동시 쓰기 시도
  arrayb[1][12:31]// 다수의 element에 동시 쓰기 시도
  /* 2. 가능한 문법 */
  mema[1] =0;
  arrayb[1][0] = 0;
  inta[4] = 33559;			// decimal 33559를 저장 
  chng_hist[t_index] = $time 	// integer index로 참조된 공간에 현재시간 저장
  ```

- 메모리

  - reg 요소를 갖는 1차원 배열

  - 배열에 속하므로, **단일 할당문으로 전체 값 할당하기 불가**.

    ```verilog
    reg [1:n] rega;	// n-bit register(vector)
    reg mema [1:n]; // memory of n 1-bit registers (Array)
    
    // 메모리는 선언 방식부터가 배열처럼 식별자 뒤쪽에 인덱스를.
    
    /* 문법 차이 살펴보기 */
    rega = 0; 		// Legal
    rega[1] = 0; 	// Legal
    mema = 0;		// Illegal
    mema[1] = 0; 	// Legal
    ```

    

### Parameter

- 개요

  - variable 또는 net 범주에 속하지 않는 상수값 / C언어에서의 매크로 상수와 비슷한 개념인데, 값을 대체하는 기능에 + α가 있음.
  - 회로의 비트 크기 또는 지연값을 지정하고 간편하게 바꾸기 위해 사용함
  - defparam문 또는 모듈 인스턴트 문의 parameter overriding에 의해 값을 변경시킬 수 있음
  - 자료형과 범위지정을 가질 수 있음. 범위가 지정 안 된 경우, 상수 값에 적합한 크기의 비트 폭을 default로 가짐.

- parameter 선언

  ```verilog
  parameter msb = 7;			// defines msb as constant value 7.
  parameter e = 25; f = 9;	// 복수 개의 파라미터
  parameter r= 5.7;			// 실수도 넣을 수 있고, 온갖 숫자 다 넣기 가능.
  ```

- 쓰임새 : 모듈 인스턴스의 parameter overriding

  ```verilog
  module modXnor(y_out, a, b):
      parameter size = 8, delay =15;
      output 	[size-1 : 0] y_out;
      input	[size-1 : 0] a, b;
      wire	[size-1 : 0] #delay y_out = a ~^ b;
  endmodule
  
  module Param:
      wire 	[7:0] y1_out;
      wire 	[3:0] y2_out;
      reg		[7:0] b1, c1;
      reg		[3:0] b2, b2;
      modXnor			G1(y1_out, b1, c1);
      modXnor #(4,5)	G2(y2_out, b2, b2); 
      // 참조할 때 이렇게 하면, parameter에 8, 15 대신 size=4, delay=5가 들어간다! 
  endmodule
  ```

  이런 식으로 size나 delay를 유동적으로 둘 때 가장 많이 쓰인다.

- 쓰임새 : Primitive gate의 delay

  ```verilog
  nand #3 G1(out_nd2, in0, in1); // 딜레이를 줄 수 있다고 한다.. 
  ```

  





---

[^1]: clock의 edge(0과 1이 바뀌는 지점)에서 값을 받아들여 기억하는 구조
[^2]: clock이 0이거나 1일 때 항상 열려 있어 값을 받아들여 기억하는 구조. 다만 래치의 경우 현재는 잡음에 약해 오류에 민감하다는 이유로 잘 안 쓴다.
