LIBRARY ieee  ; 
    USE ieee.NUMERIC_STD.all  ; 
    USE ieee.std_logic_1164.all  ; 
    use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity test_posits_tb is
  generic (runner_cfg : string);
end;

architecture vunit_simulation of test_posits_tb is

    constant clock_period      : time    := 1 ns;
    constant simtime_in_clocks : integer := 50;
    
    signal simulator_clock     : std_logic := '0';
    signal simulation_counter  : natural   := 0;
    -----------------------------------
    -- simulation specific signals ----
    type posit_record is record
        sign : std_logic;
        regime : unsigned(3 downto 0);
        exponent : unsigned(2 downto 0);
        fraction : unsigned(7 downto 0);
    end record;

    function to_real
    (
        posit : posit_record
    )
    return real
    is
    -------------------------
    function "**"
    (
        left : integer;
        right : unsigned
    )
    return real
    is
        variable number_of_zeroes : integer := 0;
    begin
        for i in right'right to right'left loop
            if right(i) = '0' then
                number_of_zeroes := number_of_zeroes + 1;
            else
                number_of_zeroes := 0;
            end if;
        end loop;

        return 256.0**(-number_of_zeroes);
    end "**";
    -------------------------
    begin
        return 2**posit.regime*2.0**(5)*(1.0+real(to_integer(posit.fraction))/256.0);
    end to_real;

    signal test1 : real := to_real((sign => '0', regime => "0001", exponent => "101", fraction => "11011101"));
    signal testi2 : real := 256.0**(-3);

begin

------------------------------------------------------------------------
    simtime : process
    begin
        test_runner_setup(runner, runner_cfg);
        wait for simtime_in_clocks*clock_period;
        test_runner_cleanup(runner); -- Simulation ends here
        wait;
    end process simtime;	

    simulator_clock <= not simulator_clock after clock_period/2.0;
------------------------------------------------------------------------

    stimulus : process(simulator_clock)

    begin
        if rising_edge(simulator_clock) then
            simulation_counter <= simulation_counter + 1;


        end if; -- rising_edge
    end process stimulus;	
------------------------------------------------------------------------
end vunit_simulation;
