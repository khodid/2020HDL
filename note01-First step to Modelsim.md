# Modelsim 설치와 첫 실습

강의 일자 : 3월 마지막 주( 2주차 )

## Modelsim 소개

 Modelsim은 HDL로 설계한 것을 시뮬레이션 돌릴 수 있는 툴이다. 실무에서는 더 고급툴을 쓰긴 하는데, 프로그래밍과도 비슷하게 하나를 익혀두면 다른 것도 익히기 쉬우니깐 Modelsim 하나만 배우면 비슷한 기능을 하는 툴들은 금방 익힐 수 있다.

 이 수업을 통해 Modelsim의 사용 방법을 배우게 될 것이지만, 더욱 알고 싶으면 유저 가이드(help) 등을 참고해서 더 익히면 된다. 기능을 훨씬 넓게 쓰면 디버깅과 검증이 훨씬 쉬워진다. '아 이런 기능 있으면 좋을텐데' 하는 거 어지간한 거 다 있다. 그러니 유저 가이드를 적극 참고해라.

찾아보니 유저 메뉴얼이라는 이름으로 700페이지가 넘는 파일이 있다. [ModelSim_Users_Manual_v10.1c.pdf](C:\Users\35896\Desktop\공부자료\3-1\하드웨어프로그래밍\ModelSim_Users_Manual_v10.1c.pdf) 
참고 ^^.

## 파일 작성하기

1. ModelSim PE Student Edition을 실행

2. 프로젝트 생성 / 열기 

   - 새로운 프로젝트를 생성 : File -> New -> Project 
     - 이 때 프로젝트를 위해 디렉토리를 내가 따로 관리하는 곳으로 미리 만들어놓는 것이 좋다. Project Location에 그 디렉토리를 넣으면 됨. (실습 예에선 c:/Verilog/practice, 교수님 추천은 HDL, temp, ... 그리고 그 안에 프로젝트 이름과 동일한 이름의 폴더를 만들면 된다.)
     - Directory 안에 work라는 이름으로 Library가 생성된다. 각 프로젝트마다 전용 라이브러리 파일이 존재한다.
   - 기존 프로젝트 열기: File > Open  후 해당 프로젝트가 있는 디렉토리 찾기. 
     그 후 mpf 파일(프로젝트를 여는 핵심이 되는 파일임.) 을 클릭.
     (사실 그냥 컴퓨터 파일에서 바로 mpf를 찾아 열어도 된다.)
     - Wave 창에 해놓은 수많은 설정들은 시뮬레이션 종료와 동시에 사라지는데, 이걸 저장하려면 시뮬레이션 종료 전에 File>Save Format으로 저장을 하고, 불러올 땐 시뮬레이션을 하고 wave창을 켜 둔 상태에서 File>Load>Macro File로 간 후 _wavename.do_ 를 선택한다. / 그리고 혹시 시뮬레이션 로드한 상태에서 코드를 수정해야겠다 생각하면, Simulate> Restart로 해야 기존 설정 유지하면서 볼 수 있음.

3. 기본 화면에서 Create New File을 선택!

   - 참고로 이 기본 화면 하단에 있는 Transcript 창을 통해 모니터링을 할 수 있다. 실습 하다가 막히는 게 있으면 이 창을 확인해야 함.

4.  File 이름을 치거나(신규) Browse(기존 코드 열기)를 하고, type : Verilog로 선택. (문법을 맞춰줘야 하기 때문)

   - 만약 잘못 설정했을 시, 그냥 지우고 새로 만들거나 이게 저장된 디렉으로 가서 확장자를 바꿔주면 된다.

5.  filename.v를 더블클릭, 또는 우클릭->'Edit'

6. 코드를 작성한다

   ``` verilog
   /* Example 1 */
   module example;
       reg signed [5:0] a;
       reg signed [5:0] b;
       reg signed [5:0] result;
       
       initial begin
           a = 6'sb000101; b = 6'sb001000;
           
           #10 result = a & b;
           $display("a : %b , b : %b, a & b = %b", a, b, result);
           
           #10 result = a | b;
           $display("a : %b , b : %b, a | b = %b", a, b, result);
           
       end
   endmodule
   ```

7. 컴파일 : filename.v 우클릭>Compile>Compile All 을 하거나, 상단 메뉴창에서 컴파일 버튼을 찾는다. 

   - Transcript 창에 _Compile of filename.v was successful_ 이 뜨는걸 확인한다.
   - 빨간색 에러 문구가 뜬다면 코드를 고친다. 이 때 에러 문구를 더블 클릭하면 어디서 에러가 난 건지 자세히 알 수 있다.

8. 시뮬레이션

   - 방법: 
     1. 컴파일 버튼 옆의 시뮬레이트 버튼을 클릭, 또는 Simulate>Start Simulate.. 를 선택
        그 후 Work 디렉토리에서 작성한 module 이름을 선택한다.
        OK 클릭
     2. Wave 창과 Object[^1] 창이 뜰 텐데, 안 뜬다면 View 메뉴에서 선택을 하면 띄울 수 있다.
     3. Object 창에서 변수들을 Wave 창으로 드래그한다. 상단에 시간 입력하는 곳에 내가 시뮬레이션 돌리고 싶은 시간을 입력해주고, Run 버튼이나 Simulate>Run>Run-All 선택.[^2]
     4. 실행 결과는 Transcript 창에서 확인 가능하다. (결과를 띄우도록 코딩을 했다면)

9. 디버깅

   - Radix 변경[^3]: Object 창이나 Wave 창에서  신호(변수)를 선택 혹은 드래그 하여 우클릭>Radix 
   - 신호 복사하기: Wave창에서 우클릭>Edit>Copy&Paste 
   - 아날로그 파형으로 확인하기: Wave창에서 신호에 대고 우클릭>Format>Analog
   - 신호 표기방법(파형색, 이름색) 바꾸기: 우클릭>Properties
   - 커서: 원하는 시간에서의 상태를 확인하기 위해 씀. 노란색 커서 메뉴를 이용해도 되고, Wave창에서 신호 이름 떠있는 섹션 하단의 커서 목록이 있으니 거기의 초록불(+) 빨간불(-)을 써도 됨. 자물쇠는 커서를 고정시키기 위한 것. 파형 창에 왼클릭을 할 경우 가장 가까운 커서가 따라온다. 클릭한 상태로 들고 움직이면 됨. 아이콘 각각에 대한 설명도 해주셨는데 하다보면 익힐 수 있을 것 같아서 굳이 설명하지 않겠음.
   - 확대: 네모 두개 겹친 것에 화살표 그림 있는 버튼 누르고 사선으로 드래그해 줌인할 수 도 있고, 두 커서 사이를 줌인하도록 할 수도 있다.
   - 그룹화(Group): 신호가 많아질 때 (찾기 편하기 위해) 연관된 신호끼리 묶어놓기.
     - Combine Signal은 아예 신호 두 개를 N bits + M bits = N + M bits 이런 식으로 아예 합친 새로운 신호를 만드는 기능이니 헷갈리지 말 것.
   - 회로도처럼 시각적으로 신호 간의 관계 확인하기: View > Dataflow 선택 후 보고 싶은 신호를 Object 창으로부터 드래그 (Wave 창과 관련이 있어 오류가 난다면 그쪽을 확인 ㄱ.)

10. 한 프로젝트 내에 여러 파일 작성하기:

    1. Simulate > End Simulation을 하면 시뮬이 끝나면서 프로젝트로 돌아갈 수 있다. 
       프로젝트 자체를 닫고 싶으면, File>Close Project
    2. 그런 후 프로젝트 목록에서 우클릭, Add to Project>New File 클릭
       - 참고로 서로 다른 파일에 작성된 코드더라도, Module 이름을 동일하게 쓰면 동일한 모듈로 생각한다. 따라서 Module 정의를 중복되게 하면 충돌이 나는데, 프로그램 내에선 컴파일을 __최근(나중)에 한 걸로 덮어쓰기__를 한다.

    ``` verilog
    module example2;    
        reg [3:0] a;
        reg [3:0] b;
        reg [3:0] out;
        reg sel, clk;
        
        initial begin
            clk = 0;
            forever #10 clk = ~clk;
            end
                
        initial begin
            sel = 0;
            a = 4;
            b = 6;
            #20 sel = 1;
            #20 sel = 0;
            end
        always @(posedge clk) begin
            if(sel==0) begin
                out <= a;
            end
            else begin
                out <= b;
            end
        end
    endmodule
    ```

    이렇게 작성하고 아까와 같이 Compile 후 Start Simulate를 선택하면, work 디렉토리에 컴파일 성공한 모듈들이 나열될 것이다.

    - 복수의 파일을 엮어 시뮬레이션 돌리기:

      - 코드 짜기 

        file  ::  week2lecture / muxex.v

        ``` verilog
        module muxex(a, b, sel, clk, out);
            input [3:0] a;
            input [3:0] b;
            input sel;
            input clk;
            output reg [3:0] out;
            
            always @(posedge clk) begin
                if (sel == 0) begin
                    out <= a;
                end
                else begin
                    out <= b;
                end
            end
        endmodule
        ```

        file :: week2lecture / testmuxex.v

        ``` verilog
        module testmuxex();
            reg [3:0] a;
            reg [3:0] b;
            reg sel;
            reg clk;
            wire [3:0] out;
            
            initial begin
                clk = 0;
                forever #10 clk = ~clk;
            end
            initial begin
                sel = 0;
                a = 4;
                b = 6;
                #20 sel = 1;
                #20 sel = 0;
            end
            
            muxex dut(a, b, sel, clk, out);
        endmodule
        ```

      - Compile 이후, Start Simulate를 할 때 work 파일 아래의 여러 코드 중에서, __가장 상위에 있어서 다른 모듈을 불러올 수 있는 파일__을 선택하면 된다. 하위 계층의 모듈을 선택할 경우, 상위 계층의 모듈을 따라오지 않기 때문에 전체적인 시뮬레이션 불가.  
        TIP : 컴파일은 에러가 없는데 시뮬이 문제가 있다면 상위->하위 파일참조를 실수했을 가능성이 있다.
      - 하위 계층의 신호를 특별히 봐야 할 때는 그 instant를 object창에 드래그해도 됨.











[^1]: 각 신호의 상태를 보여주는 창이다.   
[^2]: 참고로, Run을 누를 때마다 설정했던 실행 시간 만큼 추가로 더 실행된다. Run-All을 누를 경우 바로 옆의 Break 버튼을 누르기 전까지 계속 리얼타임으로 시뮬레이션을 돌린다. 
[^3]: 십진수(Decimal), 이진수(Binary), 팔진수(Octal) 등등으로 진법 변경.
