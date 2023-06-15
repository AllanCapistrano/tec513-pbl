clearvars; close all; clc

[x, Fs] = audioread('rejeita_faixa.wav');
    
% Configurações para plotagem.
fm = 25000; % Frequencia máxima de exibição.
plot_title = 'Espectro do sinal de entrada';
x_label = '$f$(Hz)';
y_label = '$|X(e^{j2\pi f})|_{dB}$';

showSpectrum(x, Fs, fm, plot_title, x_label, y_label);    