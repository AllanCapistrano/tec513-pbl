function [pulse_train] = pulseTrain(fs, Ts, stop_time)
%  pulseTrain gera um trem de pulsos.
% Inputs:
%   fs: Frequência de amostragem.
%   Ts: Período de amostragem do sinal de entrada.
%   stop_time: Valor de tempo final do sinal de entrada.
% Outputs:
%   pulse_train: Trem de pulsos gerados.

    t = [0:Ts:stop_time]; % Vetor de duração do trem de pulsos. t(length(t))
    d = [0:1/fs:round(stop_time)]; % Vetor de pontos iniciais dos pulsos.
    w = 1/(fs*2); % Largura do pulso
    
    pulse_train = pulstran(t, d, 'rectpuls', w);
end