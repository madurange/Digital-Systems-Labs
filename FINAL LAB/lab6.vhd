LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY lab6 IS
	PORT(	A					:IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			B					:IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			RESET, CLK		:IN STD_LOGIC;
			CHECK, R			:OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			X,Y,Z				:OUT STD_LOGIC);
END lab6;

ARCHITECTURE counter OF lab6 IS
	TYPE STATE IS (s0,s1,s2,s3,s4,s5,s6,s7,c0,c1);
	SIGNAL n,nc 	 : STATE;
	SIGNAL zz 		: STD_LOGIC;
	SIGNAL count 	: INTEGER RANGE 0 TO 16383;
BEGIN
	PROCESS (RESET,CLK)
	BEGIN
		IF RESET = '0' THEN
			count <= 0;
			nc <= c0;
		ELSIF (CLK'EVENT AND CLK = '1') THEN
			count <= count +1;
			IF count = 16383 THEN
				CASE nc IS
					WHEN c0 => nc <= c1;
					WHEN c1 => nc <= c0;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	WITH nc SELECT
			zz   <=   '0'  WHEN c0,
						'1'  WHEN c1;
	PROCESS(n,zz)
		BEGIN
			IF RESET = '0' THEN
				n <= s0;
		ELSIF (zz'EVENT AND zz = '0') THEN
			CASE n IS
					WHEN s0 => n <= s1;
					WHEN s1 => n <= s2;
					WHEN s2 => n <= s3;
					WHEN s3 => n <= s4;
					WHEN s4 => n <= s5;
					WHEN s5 => n <= s6;
					WHEN s6 => n <= s7;
					WHEN s7 => n <= s0;
				END CASE;
			END IF;
	END PROCESS;
	
	WITH n SELECT X <= 	
					'0' WHEN s0,
					'0' WHEN s1,
					'0' WHEN s2,
					'0' WHEN s3,
					'1' WHEN s4,
					'1' WHEN s5,
					'1' WHEN s6,
					'1' WHEN s7;
	WITH n SELECT Y <= 	
					'0' WHEN s0,
					'0' WHEN s1,
					'1' WHEN s2,
					'1' WHEN s3,
					'0' WHEN s4,
					'0' WHEN s5,
					'1' WHEN s6,
					'1' WHEN s7;
					
	WITH n SELECT Z <= 	
					'0' WHEN s0,
					'1' WHEN s1,
					'0' WHEN s2,
					'1' WHEN s3,
					'0' WHEN s4,
					'1' WHEN s5,
					'0' WHEN s6,
					'1' WHEN s7;
END counter;