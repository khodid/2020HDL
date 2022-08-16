# Testbench 설계하기

- 목적: 설계한 block의 올바른 동작을 검증하기 위해 만든다.

- Testbench란...

  TestBench는 입력 신호(stimuli)를 넣어주고, signal probe(출력)을 모니터링하기 위한 환경이다.

- Testbench의 구성(component)
  - 테스트하고자 하는 module을 instantiation(상위 모듈에 링크 시키는 것; 인스턴스화)을 통해 불러오는 다른 하나의 module이다. 가상의 상위 모듈이라고 봐도 좋다.
  - port가 없다: 외부 신호, 등 없음.
- Stimuli: 테스트하고자 하는 module에 assign되는 test 값. testbench에는 stimuli를 발생시키는 회로 모델링이 필요하다.

```verilog
module Testbench_Name():
    
    // 1. Stimuli signals & Stimuli declarations
    
    // 2. UUT instantiation & port mapping
    
endmodule
```

실제로 보면 이런 구성이다.





### 자동 오류 검출

시스템이 복잡해지고, 일일히 데이터 넣어주기도 힘들고 육안으로 확인하기도 어려워지기 때문에 자동오류검출을 한다.

결과 값을 내가 미리 알려준 것과 비교하게 만드는 것!

```verilog
module test_auto;
    reg[7:0] total =0;
    wire Y, refY;
    
    // make stimuli for test
    initial #10 forever total = total+1;
    wire [3:0] A = total[7:4];
    wire [3:0] B = total[3:0];
    
    // design under test
    divider DUT(Y, A, B);
    
    // Reference value (behavioral modeling)
    assign refY = A/B;
    
    // Automatic checking errors
    always @(*)
        if(Y !== refY)
            begin 
                $display("Error!!, Y = %d, refY = %d", Y, refY);
                $stop
            end
```

 Reference value에 쓰인 A/B 연산은 실제론 합성이 불가하나, 테스트하고자 하는 것과 비교하기 위해 만들어내는 것이다. 이렇게 내가 기대하는 결과를 만드는지를 알아낼 수 있는것이다. 일치하지 않을 경우 각각의 Y값과 refY 값이 어떤지 검출해내면 되는 것! Display 같은 것은 C의 printf와 비슷하다.



또한 입력 테스트벡터도 임의로 넣어줄 수가 있는데, 이를 파일입력 방식을 이용해 할 수가 있다.



 여기 

https://www.youtube.com/watch?v=pEJFZ4SoL_M&feature=youtu.be

15분부터 멀쩡할 때 다시 보자. 