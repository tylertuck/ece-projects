	library ieee;
use ieee.std_logic_1164.all;

entity LAB6_Part2 is port(
		Q1, Q0, IR2, IR1, IR0: in std_logic;
		D1, D0, PC_INC, PC_LD, IR_LD, MSA1, MSA0, MSB1, MSB0, MSC2, MSC1, MSC0 : out std_logic);
end LAB6_Part2;

architecture behavior of LAB6_Part2 is
begin
D1 <= (not IR2 and IR1 and not IR0 and not Q1 and Q0) or (IR2 and not IR1 and IR0 and not Q1 and Q0);
D0 <= (not Q1 and not Q0) or (IR2 and not IR1 and IR0 and not Q1 and Q0);

MSA1 <= (not IR2 and not IR1 and IR0 and not Q1 and Q0) or (not IR2 and IR1 and IR0 and not Q1 and Q0)
  or (IR2 and not IR1 and not IR0 and not Q1 and Q0);
MSA0 <= (not Q1 or Q0);

MSB1 <= (IR2 or IR1 or IR0 or Q1 or not Q0);
MSB0 <= (not IR2 and not IR1 and not IR0 and not Q1 and Q0);

MSC2 <= (not IR2 and not IR1 and IR0 and not Q1 and Q0) or (not IR2 and IR1 and IR0 and not Q1 and Q0)
     or (IR2 and not IR1 and not IR0 and not Q1 and Q0);
MSC1 <= (not IR2 and IR1 and IR0 and not Q1 and Q0) or (IR2 and not IR1 and not IR0 and not Q1 and Q0);
MSC0 <= (not IR2 and not IR1 and IR0 and not Q1 and Q0) or (not IR2 and IR1 and IR0 and not Q1 and Q0);

IR_LD <= not Q1 and not Q0;
PC_INC <= (Q1 or Q0) and (not Q1 or not Q0);
PC_LD <= (Q1 and Q0);

end behavior;