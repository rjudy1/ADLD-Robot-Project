-- fsm for robot

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Brancher IS
	PORT ( Clock, Resetn : IN STD_LOGIC ;
			start_stop, close : IN STD_LOGIC;
			tooFar : IN STD_LOGIC;
			magnetFound, light : IN STD_LOGIC;
			go_stop,straight : OUT STD_LOGIC;
			lNr : OUT STD_LOGIC;
			playMusic : OUT STD_LOGIC;
			state_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			delay1, delay2 : IN UNSIGNED(6 downto 0)
	);

END Brancher;

ARCHITECTURE FSM OF Brancher IS
	TYPE State_type IS (RESET, TO_FRIEND, PICKUP, AT_FRIEND, LEAVE_HOUSE,
						ENTER_TUNNEL, TUNNEL, TUNNEL_EXIT, RIGHT_FOLLOW, STOP, WAIT_BUS, TO_CHURCH, CHURCH);
	SIGNAL st : State_type;
	SIGNAL count : UNSIGNED(6 DOWNTO 0);

BEGIN
	PROCESS ( Resetn, Clock )
	BEGIN
		IF Resetn = '0' THEN
			st <= RESET ;
		ELSIF (Clock'EVENT AND Clock = '1') THEN
			CASE st IS
				WHEN RESET =>
					if start_stop = '1' THEN
						st <= TO_FRIEND;
					end if;
					
				WHEN TO_FRIEND =>
					count <= "1100000";

					IF light = '0' THEN
						st <= PICKUP;
					END IF;

				WHEN PICKUP =>		
					if count /= 0 then
						count <= count - 1;
					end if;
							
					if count = 0 then
						st <= AT_FRIEND;
					end if;
					
				-- in house, left wall follow
				WHEN AT_FRIEND =>
					count <= delay1; -- higher to not dodge box, lower if just need to clear edge
				
					IF light = '1' THEN
						st <= LEAVE_HOUSE;
					END IF;
						
				WHEN LEAVE_HOUSE =>
					if count /= 0 then
						count <= count - 1;
					end if;
				
					if close = '1' or tooFar = '0' then
						st <= ENTER_TUNNEL;
					end if;
				
				-- left follow until finding tunnel then right follow
				WHEN ENTER_TUNNEL =>
					if light = '0' THEN
						st <= TUNNEL;
					END IF;
					
				WHEN TUNNEL =>
					count <= delay2;--"0010110"; -- increase to sharpen turn

					if light = '1' then
						st <= TUNNEL_EXIT;
					END if;
					
				WHEN TUNNEL_EXIT =>
					if count /= 0 then
						count <= count - 1;
					end if;
				
					IF close = '1' or tooFar = '0' THEN
						st <= RIGHT_FOLLOW;
					END IF;
					
				WHEN RIGHT_FOLLOW =>
					if magnetFound = '1' then
						st <= STOP;
					end if;

				WHEN STOP =>
					if close = '1' then
						st <= WAIT_BUS;
					end if;
				
				WHEN WAIT_BUS =>
					if close = '0' then
						st <= TO_CHURCH;
					end if;
					
				WHEN TO_CHURCH =>
					if close = '1' and light = '0' then
						st <= CHURCH;
					end if;
				
				WHEN CHURCH =>
					-- no exit behavior needed
			END CASE ;
		END IF;
	END PROCESS ;
	
	-- OUTPUT is independent of clock (moore machine)	
	-- RESET: state 0, stop, no music
	-- TO_FRIEND: state 1, go, straight
	-- PICKUP: state 2, stop, play music
	-- AT_FRIEND: state 3, go, not straight, no music, left high
	-- LEAVE_HOUSE, state 4, if count is nonzero, go, stop music, no straight, left; else go straight
	-- ENTER_TUNNEL, state 5, go, not straight, left
	-- TUNNEL: state 6, go, not straight, right
	-- TUNNEL_EXIT: state 7, go, if count is nonzzero, left follow else straight
	-- RIGHT_FOLLOW: state 8, go, right follow, no straight
	-- STOP: state 9, stop
	-- WAIT_BUS: state 10, stop
	-- TO_CHURCH: state 11, go, right follow
	-- CHURCH: state 12, stop, play music

	state_out <= "0000" when st = RESET else
				 "0001" when st = TO_FRIEND else
				 "0010" when st = PICKUP else
				 "0011" when st = AT_FRIEND else
				 "0100" when st = LEAVE_HOUSE else
				 "0101" when st = ENTER_TUNNEL else
				 "0110" when st = TUNNEL else
				 "0111" when st = TUNNEL_EXIT else
				 "1000" when st = RIGHT_FOLLOW else
				 "1001" when st = STOP else
				 "1010" when st = WAIT_BUS else
				 "1011" when st = TO_CHURCH else
				 "1100" when st = CHURCH else
				 "----";
				 
	go_stop <=   '0' when (st = RESET OR st = PICKUP OR st = STOP OR st = WAIT_BUS OR st = CHURCH) else
			     '1'; -- to_friend, at_friend, leave_house, enter_tunnel, tunnel, tunnel_exit, right_follow, to_church		   
	straight <=  '1' when (st = TO_FRIEND or (st = LEAVE_HOUSE AND count = 0) 
						or (st = TUNNEL_EXIT and count = 0))	else
				 '0' when (st = AT_FRIEND or (st = LEAVE_HOUSE AND count /= 0) or st = ENTER_TUNNEL 
						or st = TUNNEL or (st = TUNNEL_EXIT and count /= 0) or st = RIGHT_FOLLOW
						or st = TO_CHURCH)	else
				 '-'; -- irrelevant when stopped
	lNr <=       '1' when (st = RESET or st = AT_FRIEND or st = LEAVE_HOUSE or st = ENTER_TUNNEL
						or (st = TUNNEL_EXIT and count /= 0)) else
		         '0' when ((st = TUNNEL_EXIT and count = 0) or st = RIGHT_FOLLOW or st = TO_CHURCH) else
		         '-'; -- irrelevant when stopped, and on most straights
	playMusic <= '1' when (st = PICKUP or st = CHURCH) else
				 '0'; -- only play music at select times

END FSM;