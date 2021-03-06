-- fsm for robot

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Robot_FSM IS
	PORT ( Clock, Resetn : IN STD_LOGIC ;
			go_stop, close, time_over : IN STD_LOGIC;
			lspeed, rspeed: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			lFornRev, rFornRev, lGoStop, rGoStop : OUT STD_LOGIC;
			state_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END Robot_FSM;

ARCHITECTURE FSM OF Robot_FSM IS
	TYPE State_type IS (RESET, STRAIGHT, SPIN);
	SIGNAL st : State_type;
BEGIN
	PROCESS ( Resetn, Clock )
	BEGIN
		IF Resetn = '0' THEN
			st <= RESET ;
		ELSIF (Clock'EVENT AND Clock = '1') THEN
			CASE st IS
				WHEN RESET =>
					IF go_stop = '1' THEN
						st <= STRAIGHT;
					END IF ;
				WHEN STRAIGHT =>
					IF close = '1' THEN
						st <= SPIN;
					END IF ;
				WHEN SPIN =>
					IF time_over = '1' THEN
						st <= STRAIGHT;
					END IF;
				END CASE ;
		END IF ;
	END PROCESS ;
	lspeed <= (OTHERS => '1') WHEN st = STRAIGHT ;
	rspeed <= (OTHERS => '1') WHEN st = STRAIGHT OR st = SPIN;
	
END FSM;