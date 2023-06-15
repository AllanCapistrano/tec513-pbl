% clearvars; close all; clc
close all; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TEC513-MI-PDS-UEFS2023.1
%% Problema 03 
% Arquivo principal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Leitura do sinal de entrada com ruï¿½do
[x, Fs] = audioread('SinalRuidoso.wav');

%% Projeto de Filtro FIR
fp = 2600; % Frequência de passagem em Hz.
fr = 4000; % Frequência de rejeição em Hz.

ft = fr - fp; % Faixa de transição em Hz.
fc = (fr + fp)/2; % Frequência de corte em Hz.

% Normalização das frequï¿½ncias

fn = 1.5; % Fator de normalização.

wtn = fn * pi * (ft/Fs); % Frequência de transição normalizada.
wcn = fn * pi * (fc/Fs); % Frequência de corte normalizada.

% Cálculo do tamanho e da ordem do filtro

M = round((8 * pi)/wcn); % Tamanho do filtro (Hamming, Hanning, Bartlett).
M_blackman = round((12 * pi)/wcn); % Tamanho do filtro (Blackman).

N = M - 1; % Ordem do filtro (Hamming, Hanning, Bartlett).
N_blakcman = M_blackman - 1; % Ordem do filtro (Blackman).

% Definições do filtro.
num_bits = 12; % Número de bits.

multiplicador = 2^num_bits; % Multiplicador para implementação em um DSP.
n = 0:1:N; % Vetor discreto (Hamming, Hanning, Bartlett).
n_blackman = 0:1:N_blakcman; % Vetor discreto (Blackman).

window_hamming = (0.54 - 0.46 * cos((2*pi*n)/M))'; % Janela de Hamming.
window_hanning = (0.5 - 0.5 * cos((2*pi*n)/M))'; % Janela de Hanning.
window_bartlett = ([(2*n(1:round(length(n)/2)))/M, 2 - (2*n(round(length(n)/2)+1:length(n)))/M])'; % Janela de Bartlett.
window_blackman = (0.42 - 0.5 * cos((2*pi*n_blackman)/M_blackman) + 0.08 * cos((4*pi*n_blackman)/M_blackman))'; % Janela de Blackman.

w_hamming = window_hamming * multiplicador; % Valor fracionado para janela de Hamming.
w_approximate_hamming = round(w_hamming); % Valor aproximado que seria implementado em um DSP (Hamming).

w_hanning = window_hanning * multiplicador; % Valor fracionado para janela de Hanning.
w_approximate_hanning = round(w_hanning); % Valor aproximado que seria implementado em um DSP (Hanning).

w_bartlett = window_bartlett * multiplicador; % Valor fracionado para janela de Bartlett.
w_approximate_bartlett = round(w_bartlett); % Valor aproximado que seria implementado em um DSP (Bartlett).

w_blackman = window_blackman * multiplicador; % Valor fracionado para janela de Blackman.
w_approximate_blackman = round(w_blackman); % Valor aproximado que seria implementado em um DSP (Blackman).

hd = (sin((n - M/2 + eps)*wcn)./((n - M/2 + eps) * pi))'; % Janela ideal (Hamming, Hanning, Bartlett).
hd_blackman = (sin((n_blackman - M_blackman/2 + eps)*wcn)./((n_blackman - M_blackman/2 + eps) * pi))'; % Janela ideal (Blackman).

h_hamming = hd .* w_approximate_hamming; % Filtro passa-baixa pela janela de Hamming.
h_hanning = hd .* w_approximate_hanning; % Filtro passa-baixa pela janela de Hanning.
h_bartlett = hd .* w_approximate_bartlett; % Filtro passa-baixa  pela janela de Bartlett.
h_blackman = hd_blackman .* w_approximate_blackman; % Filtro passa-baixa  pela janela de Blackman.

y_hamming = conv(x, h_hamming)/multiplicador; % Sinal filtrado pelo filtro passa-baixa utilizando a janela de Hamming.
y_hanning = conv(x, h_hanning)/multiplicador; % Sinal filtrado pelo filtro passa-baixa utilizando a janela de Hanning.
y_bartlett = conv(x, h_bartlett)/multiplicador; % Sinal filtrado pelo filtro passa-baixa utilizando a janela de Bartlett.
y_blackman = conv(x, h_blackman)/multiplicador; % Sinal filtrado pelo filtro passa-baixa utilizando a janela de Blackman.

%% Plotagens
figure;
plotWindow(w_hamming, w_approximate_hamming, 'Janela de Hamming', 'Janela de Hamming Aproximada', 'Janela de Hamming', '$n$', '$w[n]$');

figure;
plotWindow(w_hanning, w_approximate_hanning, 'Janela de Hanning', 'Janela de Hanning Aproximada', 'Janela de Hanning', '$n$', '$w[n]$');

figure;
plotWindow(w_bartlett, w_approximate_bartlett, 'Janela de Bartlett', 'Janela de Bartlett Aproximada', 'Janela de Bartlett', '$n$', '$w[n]$');

figure;
plotWindow(w_blackman, w_approximate_blackman, 'Janela de Blackman', 'Janela de Blackman Aproximada', 'Janela de Blackman', '$n$', '$w[n]$');

figure;
plotSpectrumWindow(hd, M, 'Espectro da Janela Ideal', '$\Omega$', '$|H(e^{j\Omega})|$');

figure;
plotSpectrumWindow(h_hamming, M, 'Espectro do Filtro Passa-Baixa (Hamming)', '$\Omega$', '$|H(e^{j\Omega})|$');

figure;
plotSpectrumWindow(h_hanning, M, 'Espectro do Filtro Passa-Baixa (Hanning)', '$\Omega$', '$|H(e^{j\Omega})|$');

figure;
plotSpectrumWindow(h_bartlett, M, 'Espectro do Filtro Passa-Baixa (Bartlett)', '$\Omega$', '$|H(e^{j\Omega})|$');

figure;
plotSpectrumWindow(h_blackman, M_blackman, 'Espectro do Filtro Passa-Baixa (Blackman)', '$\Omega$', '$|H(e^{j\Omega})|$');

figure;
subplot(2, 1, 1);
plot(x);
title('Sinal de Entrada');
hTitle = get(gca, 'title');
set(hTitle, 'FontSize', 48, 'FontWeight', 'bold')
axis([0.98*10^5 1.2*10^5 -1.5 1.5]);
xlabel('$n$', 'interpreter', 'latex','FontSize', 14);
ylabel('$x[n]$', 'interpreter', 'latex','FontSize', 14);

subplot(2, 1, 2);
plot(y_hamming);
title('Sinal Filtrado');
hTitle = get(gca, 'title');
set(hTitle, 'FontSize', 48, 'FontWeight', 'bold')
axis([0.98*10^5 1.2*10^5 -1.5 1.5]);
xlabel('$n$', 'interpreter', 'latex','FontSize', 14);
ylabel('$y[n]$', 'interpreter', 'latex','FontSize', 14);

figure;
subplot(2, 1, 1);
showSpectrum(x, Fs, 25000, 'Espectro do Sinal de Entrada', '$f$(Hz)', '$|X(e^{j2\pi f})|$');

subplot(2, 1, 2);
showSpectrum(y_hamming, Fs, 25000, 'Espectro do Sinal Filtrado', '$f$(Hz)', '$|Y(e^{j2\pi f})|$');

figure;
subplot(2, 1, 1);
showSpectrum(y_hamming, Fs, 5000, 'Espectro do Sinal Filtrado (Hamming)', '$f$(Hz)', '$|Y(e^{j2\pi f})|$');

subplot(2, 1, 2);
showSpectrum(y_hanning, Fs, 5000, 'Espectro do Sinal Filtrado (Hanning)', '$f$(Hz)', '$|Y(e^{j2\pi f})|$');

figure
subplot(2, 1, 1);
showSpectrum(y_bartlett, Fs, 5000, 'Espectro do Sinal Filtrado (Bartlett)', '$f$(Hz)', '$|Y(e^{j2\pi f})|$');

subplot(2, 1, 2);
showSpectrum(y_blackman, Fs, 5000, 'Espectro do Sinal Filtrado (Blackman)', '$f$(Hz)', '$|Y(e^{j2\pi f})|$');

% customFvtool(h_hamming/multiplicador);
% customFvtool(h_hanning/multiplicador)
% customFvtool(h_bartlett/multiplicador)
% customFvtool(h_blackman/multiplicador)

%% Reprodução do sinal de entrada filtrado
sound(y_hamming, Fs);
% sound(y_hanning, Fs);
% sound(y_bartlett, Fs);
% sound(y_blackman, Fs);