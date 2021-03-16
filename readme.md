# shift_register
A simple shift register module

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


## FuseSoC
Use [FuseSoc](https://github.com/olofk/fusesoc) to simplify integrating this core into your project. If you're
interested in more cores by me, take a peek at [my FuseSoC core library](https://github.com/adwranovsky/CoreOrchard).

## License
This project is licensed under the [OHDL](http://juliusbaxter.net/ohdl/ohdl.txt), which is a weak, copyleft license for HDL.
