-- fsm for robot

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Controller IS
	PORT ( Clock, Resetn : IN STD_LOGIC ;
			go_stop, close, go_str : IN STD_LOGIC;
			tooClose, tooFar : IN STD_LOGIC;
			lspeed, rspeed: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			lForRev, rForRev, lGoStop, rGoStop : OUT STD_LOGIC;
			state_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
			
END Controller;

ARCHITECTURE FSM OF Controller IS
	TYPE State_type IS (RESET, STRAIGHT, SPIN_INSIDE, TURN_TOWARDS, TURN_AWAY);
	SIGNAL st : State_type;
	
BEGIN
	PROCESS ( Resetn, Clock )
	BEGIN
		IF Resetn = '0' THEN
			st <= RESET ;
		ELSIF (Clock'EVENT AND Clock = '1') THEN
			CASE st IS
				WHEN RESET =>
					if go_stop = '1' then
						st <= STRAIGHT;
					end if;
					
				WHEN STRAIGHT =>
					IF go_str = '1' THEN
						st <= STRAIGHT;
					ELSIF close = '1' THEN
						st <= SPIN_INSIDE;
					ELSIF tooClose = '1' THEN
						st <= TURN_AWAY;
					ELSIF tooFar = '1' THEN
						st <= TURN_TOWARDS;
					END IF ;

				WHEN SPIN_INSIDE =>
					IF tooClose = '0' THEN
						st <= STRAIGHT;
					END IF;

				WHEN TURN_TOWARDS =>
					IF tooFar = '0' or go_str = '1' THEN
						st <= STRAIGHT;
					ELSIF close = '1' THEN
						st <= SPIN_INSIDE;
					END IF;

				WHEN TURN_AWAY =>
					IF tooClose = '0' or go_str = '1' THEN
						st <= STRAIGHT;
					ELSIF close = '1' THEN
						st <= SPIN_INSIDE;
					ELSIF tooFar = '1' THEN
						st <= TURN_TOWARDS;
					END IF;
				
			END CASE ;
		END IF;
	END PROCESS;

	state_out <= "0000" when st = RESET else
				 "0001" when st = STRAIGHT else
				 "0100" when st = SPIN_INSIDE else
				 "0010" when st = TURN_TOWARDS else
				 "0011" when st = TURN_AWAY else
				 "----";
	lgostop <= '0' when st = RESET else
			   '1';
	rgostop <= '0' when st = RESET else
			   '1';
	lforrev <= '1';
	rforrev <= '1';
	lspeed <= "00" when st = SPIN_INSIDE else
			  "01" when st = TURN_AWAY else
			  "11" when (st = STRAIGHT or st = TURN_TOWARDS) else
			  "--";
	rspeed <= "01" when st = TURN_TOWARDS else
			  "11" when (st = STRAIGHT or st = TURN_AWAY or st = SPIN_INSIDE) else
			  "--";	
END FSM;