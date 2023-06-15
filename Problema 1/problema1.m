clearvars; close all; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TEC513-MI-PDS-UEFS2023.1
%% Problema 01 
% Arquivo principal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Variáveis
% xt <= é o sinal de entrada gerado
% fc <= é o frame das frequências geradas em Hz
% phi <= é o frame de fases usados em Rad
% t <= é o dominio em segundos

% Fs <= é a frequência de amostragem do sinal de entrada
% Ts <= é o período de amostragem do sinal de entrada

% Fc <= é a frequência de cortedo filtro passa-baixa
% Zeros <= são as raízes do numerador da função de transferência do filtro
% Poles <= são as raízes do denominador da função de transferência do filtro
% xc <= é o sinal filtrado

% fs <= frequência de amostragem do trem de pulsos retangulares
% signalpulse <= é o trem de pulsos retangulares

% xs <= é o sinal amostrado pelo trem de pulsos retangulares

% xn <= é o sinal discreto

%% Sinal de entrada
[xt,fc,phi,t] = gerador(2,10,4000);
Fs = 24000; % Frequência de amostragem.
Ts = 1/Fs; % Período de amostragem.

%% Exibição do sinal de entrada em diferentes domínios
figure;
subplot(2, 1, 1);
plot(t, xt); grid on;
xlabel('Tempo  $t$(s)', 'interpreter','latex','FontSize',14);
ylabel('$x(t)$', 'interpreter','latex','FontSize',14);
title('Sinal de entrada');
axis([0.04 0.06 -15 15]);

subplot(2, 1, 2);
showSpectrum(xt, t, Fs, 5000, 0.3, '$f$(Hz)', '$|X(j2\pi f)|$', 'Espectro do sinal de entrada');


%% Exibição do espectro do sinal de entrada
figure;
subplot(2, 1, 1);
showSpectrum(xt, t, Fs, 5000, 0.3, '$f$(Hz)', '$|X(j2\pi f)|$', 'Espectro do sinal de entrada');

%% Filtragem
Fc = 2000; % Frequência de corte para o filtro.

% Aplicação do filtro ao sinal de entrada.
[xc, Zeros, Poles] = lowPassFilter(xt, Fs, Fc);

%% Exibição do espectro do sinal filtrado
subplot(2, 1, 2);
showSpectrum(xc, t, Fs, 5000, 0.3, '$f$(Hz)', '$|X(j2\pi f)|$', 'Espectro do sinal filtrado');

%% Exibição do sinal filtrado em diferentes domínios
figure;
subplot(2, 1, 1);
plot(t, xc); grid on;
axis([0.04 0.06 -6 6]);
xlabel('$t (s)$','Interpreter','latex','FontSize',14)
ylabel('$x_c(t)$','Interpreter','latex','FontSize',14) 
title("Sinal Filtrado");

subplot(2, 1, 2);
showSpectrum(xc, t, Fs, 5000, 0.3, '$f$(Hz)', '$|X(j2\pi f)|$', 'Espectro do sinal filtrado');

%% Exibição da magnitude e fase do filtro butterworth
figure;
freqz(Zeros, Poles);

%% Exibição do sinal de entrada
figure;
subplot(2, 1, 1);
plot(t, xt); grid on;
xlabel('Tempo  $t$(s)', 'interpreter','latex','FontSize',14);
ylabel('$x(t)$', 'interpreter','latex','FontSize',14);
title('Sinal de entrada');
axis([0.04 0.06 -15 15]);

%% Exibição do sinal de saída
subplot(2, 1, 2);
plot(t, xc); grid on;
xlabel('Tempo  $t$(s)', 'interpreter','latex','FontSize',14);
ylabel('$x_c(t)$', 'interpreter','latex','FontSize',14);
title('Sinal filtrado');
axis([0.04 0.06 -5 5]);

%% Exibição do sinal filtrado
figure;
plot(t, xc); grid on;
axis([0.04 0.06 -6 6]);
xlabel('$t (s)$','Interpreter','latex','FontSize',14)
ylabel('$x_c(t)$','Interpreter','latex','FontSize',14)
title("Sinal Filtrado");

%% Geração do trem de pulsos
fs = 6000; % Frequência de amostragem.

signalpulse = pulseTrain(fs, Ts, max(t)); % Trem de pulsos.

figure;
plot(t, signalpulse);
xlim([0 0.008]);
xlabel('$t (s)$','Interpreter','latex','FontSize',14)
ylabel('$p(t)$','Interpreter','latex','FontSize',14)
title("Trem de Pulsos");

%% Amostragem
xs = xc.*signalpulse;

figure;
hold on
plot(t, xc);
plot(t, xs,'color','red');
hold off
axis([0.04 0.06 -6 6]);
xlabel('$n$','Interpreter','latex','FontSize',14)
ylabel('$x_s(t)$','Interpreter','latex','FontSize',14)
title("Sinal Amostrado");

%% Exibição do sinal amostrado em diferentes domínios
figure;
subplot(2, 1, 1);
plot(t, xs,'color','red');
axis([0.04 0.06 -6 6]);
xlabel('$n$','Interpreter','latex','FontSize',14)
ylabel('$x_s(t)$','Interpreter','latex','FontSize',14)
title("Sinal Amostrado");

subplot(2, 1, 2);
showSpectrum(xs, t, Fs, fs+4000, 0.15, '$f$(Hz)', '$|X(j2\pi f)|$', 'Espectro do sinal amostrado');

%% Conversão do sinal contínuo para discreto

% Transformada de Fourier (FT) do sinal amostrado
Xs = fft(xs);
freq = linspace(-fs/2, fs/2, length(Xs)); % Periódica em fs

% Relação FT <-> DTFT
Xn = Xs.*(1/fs);
freq_d = linspace(-(1/2), (1/2), length(Xn)); % Periódica em f = k*(fs/N)

%% Exibição do espectro do sinal amostrado (FT) e sinal discreto (DTFT)
figure;
subplot(2, 1, 1)
plot(freq, abs(fftshift(Xs)));
xlabel('$f$(Hz)','Interpreter','latex','FontSize',14);
ylabel('$|X_s(j2\pi f)|$','Interpreter','latex','FontSize',14);
title("FT do sinal amostrado");

subplot(2, 1, 2)
plot(freq_d, abs(fftshift(Xn)));
xlabel('$f$(Hz)','Interpreter','latex','FontSize',14);
ylabel('$|X_s(e^{j2\pi f})|$','Interpreter','latex','FontSize',14);
title("DTFT do sinal amostrado");

%% Transformada inversa de fourier do espectro do sinal discreto
xn = ifft(Xn);
xn = xn .* fs;

n = 0:length(xn)-1;

%% Exibição do comparativo do sinal filtrado e do sinal discreto
figure;
subplot(2, 1, 1);
plot(t, xc); grid on;
axis([0 5e-3 -1.5 1.5]);
xlabel('$t (s)$','Interpreter','latex','FontSize',14)
ylabel('$x_c(t)$','Interpreter','latex','FontSize',14)
title("Sinal Filtrado");

subplot(2, 1, 2);
stem(n, xn); grid on;
axis([0 120 -1.5 1.5]);
xlabel('$n$','Interpreter','latex','FontSize',14)
ylabel('$x[n]$','Interpreter','latex','FontSize',14)
title("Sinal Discreto");