function [load_bit, rst_sincrono, en_incr_ciclos, en_incr_contador, load_salida, fin_recepcion, estado_actual] = state_machine_ll(mitad_pulso, rx_fe, bit_8)

% Definición de estados como constantes
inicio = 0;
bit_start = 1;
espera_bit = 2;
guarda_bit = 3;
carga_out = 4;
fin = 5;
fghghgh


% The state is a 3-bit register
persistent state, state = xl_state(inicio,{xlUnsigned, 3, 0});

% Inicialización de salidas
load_bit = false; 
load_salida = false;
rst_sincrono = false;
fin_recepcion = false;
en_incr_ciclos = true;
en_incr_contador = false;

switch state
    case inicio
        if rx_fe == 1
            state = bit_start;
        else
            state = inicio;
        end
        rst_sincrono = true;
        en_incr_ciclos = false;

    case bit_start
        if mitad_pulso == 1
            state = espera_bit;
        else
            state = bit_start;
        end

    case espera_bit
        if mitad_pulso == 1
            state = guarda_bit;
        else
            state = espera_bit;
        end
        
    case guarda_bit
        if bit_8 == 1
            state = carga_out;
        else
            state = espera_bit;
        end
        load_bit = true;
        en_incr_contador = true;

    case carga_out
        state = fin;
        load_salida = true;

    case fin
        state = inicio;
        fin_recepcion = true;

    otherwise
        state = inicio;

end

estado_actual = state;
end
