function [filtered, Zeros, Poles] = lowPassFilter(signal, Fs, Fc)
%  lowPassFilter realiza a filtragem passa-baixa de um sinal.
% Inputs:
%   signal: Sinal que deseja realizar a filtragem.
%   Fs: Frequência de amostragem do sinal de entrada.
%   Fc: Frequência de corte.
% Outputs:
%   filtered: Sinal filtrado.

    Wn = Fc/(Fs/2); % Frequência de corte normalizada.
    
    min_att = 3; % Atenuação mínima da banda de passagem.
    max_att = 80; % Atenuação máxima da banda de rejeição.

    % Cálculo dos coeficientes do filtro Butterworth.
    [n, Wn] = buttord(Wn, 1.5*Wn, min_att, max_att, 's');
    [Zeros, Poles] = butter(n, Wn, 'low');

    % Aplicação do filtro ao sinal de entrada.
    filtered = filter(Zeros, Poles, signal);
end