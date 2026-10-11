
# xX -> registers on chip; x0 is always set to 0 
# pin_X -> input pins available to device; direct access
# buff_x -> buffer from host device; direct access
# buff_full -> buffer full; flagged by host
# buff_even_parity -> even parity calculated in parallel

uart_tx: # start uart tx program (8E2 UART)
    
    # at a high level, i think we have to create a secondary clk that
    # operates at the desired baud rate; pins to be set should be 
    # queued to be run at that baud rate

    # pin_0 will be our UART TX pin

    # initialization

    add x0, x0, x1 # x1 will be our counter; init to 0

    idle: # idle state
        bne buff_full, x0, start_bit
        j idle

    start_bit: # send start bit
        add x0, x0, pin_0 # pull low

        start_bit_start_wait: # wait the full data period 
            addi x1, 1, x1
            beq x1, DATA_PERIOD, send_data_bit_0
            j start_bit_start_wait

    # TO THINK ON
    # it will be simpler to NOT add addressing to the buffer
    # i think we should just hard-code each bit
    # but it will make the program messier... might exceed
    # the program length we can support? 

    send_data_bit_0:
        add x0, x0, x1
        add x0, buff_0, pin_0

        send_data_bit_0_wait:
            addi, x1, 1, x1
            beq x1, DATA_PERIOD, send_data_bit_1
            j send_data_bit_0_wait

    send_data_bit_1:
        add x0, x0, x1
        add x0, buff_1, pin_0

        send_data_bit_1_wait:
            addi, x1, 1, x1
            beq x1, DATA_PERIOD, send_data_bit_2
            j send_data_bit_1_wait

    send_data_bit_2:
        add x0, x0, x1
        add x0, buff_2, pin_0

        send_data_bit_2_wait:
            addi, x1, 1, x1
            beq x1, DATA_PERIOD, send_data_bit_3
            j send_data_bit_2_wait

    send_data_bit_3:
        add x0, x0, x1
        add x0, buff_3, pin_0

        send_data_bit_3_wait:
            addi, x1, 1, x1
            beq x1, DATA_PERIOD, send_data_bit_4
            j send_data_bit_3_wait

    send_data_bit_4:
        add x0, x0, x1
        add x0, buff_4, pin_0

        send_data_bit_4_wait:
            addi, x1, 1, x1
            beq x1, DATA_PERIOD, send_data_bit_5
            j send_data_bit_4_wait

    send_data_bit_5:
        add x0, x0, x1
        add x0, buff_5, pin_0

        send_data_bit_5_wait:
            addi, x1, 1, x1
            beq x1, DATA_PERIOD, send_data_bit_6
            j send_data_bit_5_wait

    send_data_bit_6:
        add x0, x0, x1
        add x0, buff_6, pin_0

        send_data_bit_6_wait:
            addi, x1, 1, x1
            beq x1, DATA_PERIOD, send_data_bit_7
            j send_data_bit_6_wait

    send_data_bit_7:
        add x0, x0, x1
        add x0, buff_7, pin_0

        send_data_bit_7_wait:
            addi, x1, 1, x1
            beq x1, DATA_PERIOD, parity_bit
            j send_data_bit_7_wait


    parity_bit: # send parity bit
        add x0, x0, x1
        add x0, buff_even_parity, pin_0

        parity_bit_wait:
            addi, x1, 1, x1
            beq x1, DATA_PERIOD, stop_bits,
            j parity_bit_wait

    stop_bits: # send stop bits
        add x0, x0, x1
        addi x0, 1, pin_0

        stop_bit_wait_1:
            addi x1, 1, x1
            beq x1, DATA_PERIOD, stop_bit_wait_2
            j stop_bit_wait_1

        stop_bit_wait_2:
            addi x0, 1, x1
            beq x1, DATA_PERIOD, idle
            j stop_bit_wait_2
