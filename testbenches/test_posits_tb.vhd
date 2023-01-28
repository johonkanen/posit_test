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

    constant regime_bits   : integer := 4;
    constant exponent_bits : integer := 3;
    constant fraction_bits : integer := 8;

    type posit_record is record
        sign : std_logic;
        regime   : unsigned(regime_bits-1 downto 0);
        exponent : unsigned(exponent_bits-1 downto 0);
        fraction : unsigned(fraction_bits-1 downto 0);
    end record;

------------------------------------------------------------------------
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
        constant shadow_bit : real := 1.0;

    begin
        return 2**posit.regime*2.0**(5)*(shadow_bit+real(to_integer(posit.fraction))/256.0);
    end to_real;
------------------------------------------------------------------------
    function get_posit_sign
    (
        real_number : real
    )
    return std_logic 
    is
        variable return_value : std_logic;
    begin
        if real_number >= 0.0 then
            return_value := '0';
        else
            return_value := '1';
        end if;

        return return_value;
        
    end get_posit_sign;
------------------------------------------------------------------------
    function get_regime_bits
    (
        real_number : real
    )
    return unsigned 
    is
        variable return_value : unsigned(regime_bits-1 downto 0) := "0001";
    begin
        report "regime bits not yet done" severity warning;
        
        return return_value;
    end get_regime_bits;
------------------------------------------------------------------------
    function get_exponent_bits
    (
        real_number : real
    )
    return unsigned 
    is
        variable return_value : unsigned(exponent_bits-1 downto 0) := "101";
    begin
        report "get_exponent_bits not yet done" severity warning;
        
        return return_value;
        
    end get_exponent_bits;
------------------------------------------------------------------------
    function get_fraction_bits
    (
        real_number : real
    )
    return unsigned 
    is
        variable return_value : unsigned(fraction_bits-1 downto 0) := "11011101";
    begin
        report "get_fraction_bits not yet done" severity warning;
        
        return return_value;
        
    end get_fraction_bits;
------------------------------------------------------------------------
    function to_posit
    (
        real_number : real
    )
    return posit_record
    is
        variable return_value : posit_record := ((sign => '0', regime => "0001", exponent => "101", fraction => "11011101"));
    begin
        return_value.sign     := get_posit_sign(real_number);
        return_value.regime   := get_regime_bits(real_number);
        return_value.exponent := get_exponent_bits(real_number);
        return_value.fraction := get_fraction_bits(real_number);
        
        return return_value;
    end to_posit;
------------------------------------------------------------------------

    signal test1 : real := to_real((sign => '0', regime => "0001", exponent => "101", fraction => "11011101"));
    signal testi2 : real := 256.0**(-3);

    signal test_posit : posit_record := to_posit(3.55393e-6);

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
            check(test_posit.sign     = '0'        , "sign should be '0', but got '1'");
            check(test_posit.regime   = "0001"     , "sign should be '0001'");
            check(test_posit.exponent = "101"      , "exponent should be '101'");
            check(test_posit.fraction = "11011101" , "exponent should be '11011101'");

            -- check(to_real(to_posit(3.5)) = 3.5, "goal is to be able to convert real to posit and back");


        end if; -- rising_edge
    end process stimulus;	
------------------------------------------------------------------------
end vunit_simulation;
