close all; clc;

[x, Fs] = audioread('Classical.wav');

% Explicacao parmetros
% Fs original 44100
% Deseja 8000
% 44100 / 8000 = 5,5125
% 44100 / 5,5125 = 8000
% 44100 * 1/5,5125 = 8000
% 44100 * 10000/55125 = 8000

x_resampled = resample(x, 10000, 55125);
new_Fs = 8000;

y = conv(x_resampled, coef_rf');

figure;
subplot(2, 1, 1);
showSpectrum(x_resampled, new_Fs, 5000, 'Espectro do Sinal de Entrada', '$f$(Hz)', '$|X(e^{j2\pi f})|$');

subplot(2, 1, 2);
showSpectrum(y, new_Fs, 5000, 'Espectro do Sinal Filtrado', '$f$(Hz)', '$|Y(e^{j2\pi f})|$');

figure;
spectrogram(x_resampled, 256, [], [], new_Fs, 'yaxis');

% sound(y, new_Fs);