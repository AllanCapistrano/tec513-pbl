function [filtered, Zeros, Poles] = lowPassFilter(signal, Fs, Fc)
%  lowPassFilter realiza a filtragem passa-baixa de um sinal.
% Inputs:
%   signal: Sinal que deseja realizar a filtragem.
%   Fs: Frequ�ncia de amostragem do sinal de entrada.
%   Fc: Frequ�ncia de corte.
% Outputs:
%   filtered: Sinal filtrado.

    Wn = Fc/(Fs/2); % Frequ�ncia de corte normalizada.
    
    min_att = 3; % Atenua��o m�nima da banda de passagem.
    max_att = 80; % Atenua��o m�xima da banda de rejei��o.

    % C�lculo dos coeficientes do filtro Butterworth.
    [n, Wn] = buttord(Wn, 1.5*Wn, min_att, max_att, 's');
    [Zeros, Poles] = butter(n, Wn, 'low');

    % Aplica��o do filtro ao sinal de entrada.
    filtered = filter(Zeros, Poles, signal);
end