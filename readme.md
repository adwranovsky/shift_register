# shift_register_sipo
A simple serial-in parallel-out shift register module

## Parameters
### WIDTH
The bit width of the shift register.
### COVER
For testing use only. Set to 1 to include cover properties during formal verification.

## Ports
### clk_i
The system clock

### rst_i
An active high, synchronous reset that sets value_o to 0

### advance_i
When high, The value of bit_i appears on value_o[0] and the rest of value_o shifts upwards

# shift_register_piso
A simple parallel-in serial-out shift register module

## Parameters
### WIDTH
The bit width of the shift register

### DEFAULT_VALUE
The default value loaded into the internal register on reset

### FILL_VALUE
Either 1'b1 or 1'b0. The internal register is filled from the left with this value when advance_i is high

### COVER
For testing use only. Set to 1 to include cover properties during formal verification

## Ports
### clk_i
The system clock

### rst_i
An active high, synchronus reset that sets the internal register value to 0. Asserting this is the same as asserting
set_i with value_i equal to 0.

### set_i
Asserting loads the internal register with the value of value_i. Takes precedence over advance_i.

### bit_o
The output bit. Is equal to the least-significant bit of the internal register value.

### advance_i
Shifts over the internal register one value to the right

### value_i
See set_i.


## FuseSoC
Use [FuseSoc](https://github.com/olofk/fusesoc) to simplify integrating this core into your project. If you're
interested in more cores by me, take a peek at [my FuseSoC core library](https://github.com/adwranovsky/CoreOrchard).

## License
This project is licensed under the [OHDL](http://juliusbaxter.net/ohdl/ohdl.txt), which is a weak, copyleft license for HDL.
