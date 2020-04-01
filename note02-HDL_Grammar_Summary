# HDL 문법 알아보기

강의일 : 3월 마지막 & 4월 첫째주
학습목표 : Verilog HDL에 대한 기본지식을 익히고, 문법 기초를 배운다.

목차:
1. [Verilog HDL의 역사](###Verilog-HDL의-역사)
2. [HDL 기반 설계의 장점](###-HDL-기반-설계의-장점)
3. [HDL vs. C programming](###HDL-vs.-C-programming)
4. [Verilog 어휘 규칙](##Verilog-어휘-규칙)
5. [모델링 예시](##모델링-예시)

### Verilog HDL의 역사

- 직접 그려서 설계하다보니 힘들어서 Verilog 개발 -> Cadence라는 회사에서 Verilog HDL 이라는 문법 공개 -> IEEE에서 표준화 (1995) -> VHDL라는 표준어에서 더 기능이 많아서, Verilog에서도 2001에 개정해 기능 추가. -> C언어로 짜도 돌아가게끔 새로 개발, System Verilog라는 C에 더 가까운 언어 짰음.
- 일반 Verilog와 System Verilog는 Low Level <-> High Level이라는 차이, 그래서 Low level로 갈 수록 빡세지만 성능이 빠르고 좋음. High Level은 사람 입장에서 알아듣기 훨씬 편하지만 군더더기 있음.

### HDL 기반 설계의 장점

- 설계시간의 단축 (직접 회로도를 그리는 것에 비해서.)
  - 언어를 쓰니 표현이 사람이 보기 더 좋음. 설계 오류를 잡기가 훨씬 용이하다.
  - 수정을 할 때도 편하다.
- 설계의 질 향상
  - 설계를 위해 필요한 개개인의 능력치 허들이 낮아짐. 
  - 프로그래밍이기 때문에 모르는 것 검색하기가 좋다.
  - 똑같은 알고리즘이라도 다양한 방법으로 만들 수 있음. 그래서 선택할 수 있다.
- 설계 기술이나 공정에 무관하게 설계 가능
  - 도면을 삼성반도체에 맞춰서 설계했는데 중간에 하이닉스로 옮겨야 할 상황에서, 회로도를 직접 그려서 설계하면 갈아엎어야 함. 하지만 언어로 추상적으로 미리 설계를 해두고 툴을 이용해 변환을 하게 되면 그런 걱정 NO
- 설계 비용 절감 
  - 똑같은 설계여도 갈려들어갈 엔지니어 머리수가 줄어드니 인건비 절감, 생산성 향상
  - 설계 기간 단축 
  - 전임자가 만들어놓은 거 재사용하기 편함
- **표준 HDL** 사용자의 확대
  -  IEEE 표준이면서 미국 정부 공인이라, 전세계 어느 기술자에게 보여줘도 통함.



### HDL vs. C programming

|            |                             HDL                              |                        C programming                         |
| ---------- | :----------------------------------------------------------: | :----------------------------------------------------------: |
| 사용목적   |                        디지털 IC 제작                        |  프로세서(PC나 전자기기에 있는)의 동작 제어를 통한 SW 구현   |
| 제약 조건  |           결국 회로로 옮길 수 있는 설계를 해야 함.           |                              -                               |
| 동작 흐름  |           Concurrent(회로의 흐름 - 동시 동작) [^1]           |              Sequential(명령의 흐름 - 절차지향)              |
| 시뮬레이션 |       결과물로 가는 하나의 단계<br />(전체 검증의 30%)       |        결과물로 이어지는 단계<br />(전체 검증의 90%)         |
| 최적화     | 회로의 복잡도를 줄이거나(크기 줄이기) 회로의 동작속도를 빠르게 하는 것[^2] | 실행파일(bin파일)의 크기를 줄이거나 CPU에서 연산속도를 빠르게 하는 것 |
| 결과물     |                       회로도(netlist)                        |                  실행파일(dll, exe, bin 등)                  |

이런 차이점들 때문에, HDL을 일반적인 프로그래밍 언어처럼 접근해선 안 된다.



## Verilog 어휘 규칙

어휘 토큰(lexial tokens)

- 여백(white space)

  - 단어와 단어 사이의 공간(space, tab). 분리 이외의 아무런 의미는 없다. 사람이 읽기 편하게 하기 위함.

- 주석(comment)

  - '재사용 가능'이라는 장점을 살리기 위해선 주석이 매우 중요하다.
  - C와 동일하게,  //라인 , 또는 /\*블록\*/ 으로 표현한다.

- 연산자(operator): 단항, 2항, 3항 연산자

- 수표현(number representation)

  - 정수형: 진법은 10진수, 16진수, 8진수, 2진수 4가지만 존재 (하드웨어로 바뀔 수 있는 숫자)

  - 형식: 

    ``` verilog
    [size_constant] ' <base_foramt> <number_value>
    // Default: Signed Decimal Number
    ```

    - **size_constant**: 값의 비트수대로, 저 자리에 non zero, unsigned 10진수를 기입.

      - Default : 비트 크기가 지정되지 않은 수는 32비트로 표현된다.

      - 만약 number value와 size constant가 서로 부합하지 않을 경우: 

        1. size constant가 더 _작음_: 숫자가 짤리면서 warning이 뜬다. 어떻게 대처하는지는 툴에 따라 다를 수 있음.

        2. size constant가 더 _큼_: 자동확장됨. 빈 공간에 가장 왼쪽 표기를 보고, 다음 표에 해당하는 값으로 채움.

           | Left-most Bit |   Expansion   |
           | :-----------: | :-----------: |
           |       0       |   0 extend    |
           |       1       |   0 extend    |
           |      x X      | x or X extend |
           |      z Z      | z or Z extend |

           

    - **base_format**: 2 (b,B)/ 8(o,O) / 10(d,D) / 16(h,H)  진수 표현, 그리고 Signed[^3]의 경우 앞에 s,S를 붙여줌. (ex - 'sd' means signed decimal)

    - **number_value**: 정해줬던 base_format에 맞추어 unsigned 숫자를 사용하여 정확한 값을 표현.

      |     Format      | Prefix |     Legal characters     |
      | :-------------: | :----: | :----------------------: |
      |    binary(2)    |   'b   |      0 1 xX zZ _ ?       |
      |    octal(8)     |   'o   |      0to7 xX zZ _ ?      |
      |   decimal(10)   |   'd   |          0to9_           |
      | hexadecimal(16) |   'h   | 0to9 atof AtoF xX zZ _ ? |

      - xX : Unknown. 하드웨어 상에서 0과 1이 충돌되어 알 수 없는 상태가 되는걸 표현
        zZ : high-impedance. 하드웨어에서 끊어진 값을 표현. 
        ?    : Z와 동일한 high-impedance. "don't care" 상태를 나타내기도 함.
        _    : 가독성 개선. (ex: 01001010 를 0100_1010 로 끊어 표현할 수 있다. )
      - 음수를 표현하고 싶을 땐 부호를 모든 표기의 맨 앞에 땡겨야 한다.
        ex. 8'd-6 (X) / -8'd6 (O)
      - 자세한 어휘 사항과 예시는 Lecture03 교안 12페이지에 수록.
        또한 인터넷에서 본 [다른 슬라이드](https://docplayer.net/20906086-Verilog-representation-of-number-literals.html)를 참고해서 정리했음.

  - 실수형(Real number; floating point): 연산은 다 되나, **하드웨어로 바뀌지 않는** 수. **테스트를 위해**, 주변장치를 세팅하는 데 쓰는 자료형이다.

    ```verilog
    1.2
    1.30e-2
    0.1e-0
    29E-2
    236.123_763_e-12 // 다시 말하지만 _ 는 무시된다! 
    
    /* Invalid Cases */ 
    /*
    .12
    9.
    4.E3
    .2e-7
    */
    ```

    

    

- 문자열(string)

  - 이중 인용 부호 " " 사이에 있는 문자들을 일컬음.
  - 여러 라인에 걸친 문자열은 사용 불가
  - reg형의 변수이며, 문자열 내의 문자 수에 8을 곱한 크기의 비트 폭을 가짐
    (8 bits unsigned 정수형 ASCII 상수로 표현됨)

  ```verilog
  module sting_test;
      reg [8*14:1] stringvar;
      
      initial begin
          stringvar = "Hello World";
          $display("%s is stored as %h", stringvar, stringvar);
          // 이런 display같은 건 실제 하드웨어에선 쓰임이 없다.
          stringvar = {stringvar, "!!!"};
          $display("%s is stored as %h", stringvar, stringvar);
      end
  endmodule
  ```

  | 확장 문자열 |        확장 문자열에 의해 생성되는 특수 문자        |
  | :---------: | :-------------------------------------------------: |
  |     \n      |                        개행                         |
  |     \t      |                         탭                          |
  |     \\      |       기능이 아닌 \ 모양 그 자체를 치기 위함        |
  |     \"      |       기능이 아닌 " 모양 그 자체를 치기 위함        |
  |    \ddd     | A Character specified in 1-3 octal digits (0<=d<=7) |

  

- 식별자(identifier)

  - 변수 이름을 뜻함.

    - 규칙 - C와 비슷함.

      1. 알파벳(대소문자 구분됨), 숫자, 기호$, _
      2.  첫 글자는 무조건 문자나 _로 시작해야 함.

      ```verilog
      shiftreg_a
      _bus3
      n$657
      ```

  - 확장 식별자(escaped identifier):

    - \\(back slash)로 시작하며, 여백으로 끝남. 이렇게 쓰면 특수한 문자(@#%^ 등)도 혼용해서 쓸 수 있게 됨

      ```verilog
      \busa+index
      \-clock
      \***error-condition***
      \{a,b}
      ```

      

- 키워드(keyword)

  - Verilog 시스템에서 미리 정의한 식별자.
  - 근데 \\ 로 시작하면 이 역시 확장식별자로 인식되어, 사용 가능해짐.
    (하지만 추천하지 않는다. Tool에서 오류가 날 수 있기 때문)

- 시스템 task와 시스템 함수

  - 문자 $로 시작되는 이름은 시스템 task, 시스템함수. **하드웨어에 합성 안 되고, 주로 시뮬레이터를 제어할 때 쓴다.** Testbench를 만들 때 사용.

    ```verilog
    $display("display a message");
    $finish;
    ```

- 컴파일러 지시어(compiler directive)

  - 문자 \` (1 왼쪽에 있는 키 + Shift)로 시작한다.

  - C 의 전처리 코드와 비슷한 역할이다.

  - 회로도로 바꾸는 프로그램에도 명령 가능. 즉 하드웨어 합성에 영향 끼친다.

  - 동일 프로그램의 다른 파일에도 적용하도록 지시 가능.

    ```verilog
    `define worldsize 8
    ```

- 속성 (attribute)

  - HDL 명령어와는 무관하게 합성 툴에게 명령을 하는 것. 
    _사용자, " 이렇게 만들어주세요! "  "난 이런 회로가 필요해!"_

  - 특정 값을 지정하지 않을시, Default는 1이다.

    ```verilog
    /* 선언하는 방법 (추상)*/
    attribute_instance::=
    	(*attr_spec{,attr_spec}*)
    // attribute spec이 여러 개일 경우 중괄호 안에 , 로 구분하여 여러 개 작성 가능.
    attr_spec::=
    	attr_name = constant_expression
    	|attr_name
    attr_name::=
    	identifier
    // attribute name은 식별자와 동일하게 선언한다.
    ```

    - 실제 예시:  논리 합성을 위한 속성의 예 - 밑의 세 코드는 모두 동일하게 해석된다.

      ```verilog
      (* full_case, parallel_case *)
      case (foo)
          < rest_of_case_statement >
      ```

      ```verilog
      (* full_case=1, parallel_case=1 *)
      case (foo)
          < rest_of_case_statement >
      ```

      ```verilog
      (* full_case, parallel_case=1 *)
      case (foo)
          < rest_of_case_statement >
      ```

    - 실제 예시: 모듈 정의에 속성이 지정된 예 

      ```verilog
      (* optimize_power *) // 또는 optimize_power=1
      module mod1(<port_list>);
      ```

    - 실제 예시: 모듈 사례화에 속성이 지정된 예

      ```verilog
      (* optimize_power=0 *) mod1 synth1(<port)list>);
      ```

    - 실제 예시: reg 선언에 속성이 지정된 예

      ```verilog
      (* fsm_state* )	reg [7:0] state1;
      (* fsm_state =1 *) reg [3:0] state2, state3;
      ```

---



## 모델링 예시

Verilog의 구문은

1. 논리합성(assign, if ~ else, case, for, always 등)
2. 시뮬레이션(initial, $finish, $fopen 등)
3. Library제공(specify, $width, table 등)

총 세 가지 분류로 나눌 수 있다.



#### 논리합성 모델링 예

- 게이트 프리미티브를 이용한 모델링 예시 (반가산기)

  ```verilog
  module half_adder(a, b, sum, cout);
      input a, b;
      output sum, cout;
      wire cout_bar;
      
      xor(sum, a, b);
      nand(cout_bar, b);
      not(cout, cout_bar);
  endmodule
  ```

- 연속할당문을 이용한 모델링 예시:

  ```verilog
  module half_adder2(a, b, sum, cout);
      input a, b;
      output sum, cout;
      
      assign cout = a&b;
      assign sum = a^b;
  endmodule
  ```

- 하위 모듈을 이용한 모델링:

  ``` verilog
  module full_add(a, b, cin, sum, cout);
      input a, b, cin;
      output sum, cout;
      wire w1, w2, w3;
      
      half_adder U1(.a(a), .b(b), .sum(w1), .cout(w2));
      //... 중략. 암튼 SW 플밍에서 함수 쓰는 거랑 비슷한 거임. 
  ```

  

#### 테스트벤치 모델링 예

약간 우리학교 프로그래밍 수업의 OJ 심사 방식과 비슷하게, 입력 벡터를 만들고 모니터 반응을 확인하는 식으로 테스트를 해야 함. 그런 테스트용 프로그램을 짜는 과정이다.

테스트벤치 설계에선 

- 테스트벤치 만들기 예시:

  ``` verilog
  module test_fix ();
      reg A, B, C;
      
      circuit c1(A, B, C, Out);
      
      initial begin
          	A=0; B=0; C=0;
          #50 A=1;
          #50 A=0; 	  C=1;
          #50 		  C=0;
          #50 $finish;
      end
  endmodule
  ```

  이런 식으로 원하는 파형을 만들어줄 수 있음!



---

[^1]: 모든 구문이 동시 실행된다는 걸 이해해야 함. 따라서 명령 순서를 바꿔도 동작 순서가 바뀌지 않는다!
[^2]: 코드를 길게 짠다고 해서 복잡도가 올라가지 않는다. 결과물 회로도가 어떻게 나올지 생각하면서 짜야 최적화를 할 수 있다.
[^3]: 저장되는 값은 같으나, 연산할 때 방식이 달라지는 정도임. 예를 들어 4'shf 와 4'hf는 동일하게 1111로 표현되어 저장되지만, 연산을 할 때 다르게 적용될 것임. 4'shf는 - 4'sh1과 동치. 
