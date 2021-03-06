-- entity name: gNN_asp_registers
--
-- Copyright (C) 2011 -- Version 1.0
-- Author: Antoine Bosselut and Irtaza Rizvi
-- Date:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

package lab_package2 is
type r_vector is array(0 to 3) of std_logic_vector(0 to 2);
type r_vector_array is array(0 to 7) of r_vector;
end lab_package2;

 
library ieee;
use ieee.std_logic_1164.all;
use work.lab_package2.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity g07_asp_registers is
port(
clk: in bit;
asp_rst: in bit;
asp_reg_id: in integer range 0 to 7;
asp_row_in: in r_vector;
asp_column_in: in r_vector;
readwrite: in bit;
control: in bit;
asp_dr_i: in std_logic_vector(0 to 7);
asp_row_out: out r_vector;
asp_column_out: out r_vector;
asp_length: out std_logic_vector(0 to 2);
asp_lrow: out r_vector;
asp_lrow_id: out std_logic_vector(0 to 2);

asp_lcol: out r_vector;
asp_empty: out std_logic_vector(0 to 7);
asp_dr: out std_logic_vector(0 to 7)
);
end g07_asp_registers;

architecture a of g07_asp_registers is
BEGIN
	PROCESS (clk, asp_rst, asp_reg_id, asp_row_in, asp_column_in, control)
	variable asp_row_array: r_vector_array;
	variable asp_col_array: r_vector_array;
	variable no_cells: integer range 0 to 4;
	variable my_length: integer range 0 to 4;
	variable lrow: integer range 0 to 7;
	variable empty: std_logic_vector(0 to 7);
	BEGIN			
		IF (asp_rst='1') THEN
			FOR i in 0 to 7 LOOP
				FOR j in 0 to 3 LOOP
					asp_row_array(i)(j):="111";
					asp_col_array(i)(j):="111";
				END LOOP;
			END LOOP;
			asp_lrow <= asp_row_array(0);
			asp_lcol <= asp_col_array(0);
			asp_row_out <= asp_row_array(0);			
			asp_column_out <= asp_col_array(0);
			asp_empty <= "11111111";
			asp_dr <= "00000000";		
		ELSIF (clk 'EVENT AND clk='1' AND control = '1') THEN
			my_length := 0;
			lrow := 0;
			empty := "00000000";
			IF (readwrite = '0') THEN
				asp_row_array(asp_reg_id):= asp_row_in;
				asp_col_array(asp_reg_id):= asp_column_in;
				asp_row_out <= asp_row_array(asp_reg_id);
				asp_column_out <= asp_col_array(asp_reg_id);
			ELSIF(readwrite = '1') THEN
				asp_row_out <= asp_row_array(asp_reg_id);
				asp_column_out <= asp_col_array(asp_reg_id);
			END IF;

			for i in 0 to 7 loop
				no_cells := 0;
				for j in 0 to 3 loop
					if (asp_row_array(i)(0) = "111") then
						empty(i) := '1';
					end if;
					if (asp_row_array(i)(j) /= "111") then
						no_cells := no_cells + 1;
					end if;
				end loop;
				if (no_cells > my_length and asp_dr_i(i) = '0') then
					my_length := no_cells;
					lrow := i;
				end if;
			end loop;
			asp_lrow <= asp_row_array(lrow);
			asp_lrow_id <= std_logic_vector(to_unsigned(lrow, 3));
			asp_lcol <= asp_col_array(lrow);
			asp_length <= std_logic_vector(to_unsigned(my_length, 3));
			asp_empty <= empty;
			asp_dr <= asp_dr_i;
			
		END IF;
	END PROCESS;
end a;