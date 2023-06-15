clearvars; close all; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TEC513-MI-PDS-UEFS2023.1
%% Problema 01 
% Arquivo principal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Vari�veis
% xt <= � o sinal de entrada gerado
% fc <= � o frame das frequ�ncias geradas em Hz
% phi <= � o frame de fases usados em Rad
% t <= � o dominio em segundos

% Fs <= � a frequ�ncia de amostragem do sinal de entrada
% Ts <= � o per�odo de amostragem do sinal de entrada

% Fc <= � a frequ�ncia de cortedo filtro passa-baixa
% Zeros <= s�o as ra�zes do numerador da fun��o de transfer�ncia do filtro
% Poles <= s�o as ra�zes do denominador da fun��o de transfer�ncia do filtro
% xc <= � o sinal filtrado

% fs <= frequ�ncia de amostragem do trem de pulsos retangulares
% signalpulse <= � o trem de pulsos retangulares

% xs <= � o sinal amostrado pelo trem de pulsos retangulares

% xn <= � o sinal discreto

%% Sinal de entrada
[xt,fc,phi,t] = gerador(2,10,4000);
Fs = 24000; % Frequ�ncia de amostragem.
Ts = 1/Fs; % Per�odo de amostragem.

%% Exibi��o do sinal de entrada em diferentes dom�nios
figure;
subplot(2, 1, 1);
plot(t, xt); grid on;
xlabel('Tempo  $t$(s)', 'interpreter','latex','FontSize',14);
ylabel('$x(t)$', 'interpreter','latex','FontSize',14);
title('Sinal de entrada');
axis([0.04 0.06 -15 15]);

subplot(2, 1, 2);
showSpectrum(xt, t, Fs, 5000, 0.3, '$f$(Hz)', '$|X(j2\pi f)|$', 'Espectro do sinal de entrada');


%% Exibi��o do espectro do sinal de entrada
figure;
subplot(2, 1, 1);
showSpectrum(xt, t, Fs, 5000, 0.3, '$f$(Hz)', '$|X(j2\pi f)|$', 'Espectro do sinal de entrada');

%% Filtragem
Fc = 2000; % Frequ�ncia de corte para o filtro.

% Aplica��o do filtro ao sinal de entrada.
[xc, Zeros, Poles] = lowPassFilter(xt, Fs, Fc);

%% Exibi��o do espectro do sinal filtrado
subplot(2, 1, 2);
showSpectrum(xc, t, Fs, 5000, 0.3, '$f$(Hz)', '$|X(j2\pi f)|$', 'Espectro do sinal filtrado');

%% Exibi��o do sinal filtrado em diferentes dom�nios
figure;
subplot(2, 1, 1);
plot(t, xc); grid on;
axis([0.04 0.06 -6 6]);
xlabel('$t (s)$','Interpreter','latex','FontSize',14)
ylabel('$x_c(t)$','Interpreter','latex','FontSize',14) 
title("Sinal Filtrado");

subplot(2, 1, 2);
showSpectrum(xc, t, Fs, 5000, 0.3, '$f$(Hz)', '$|X(j2\pi f)|$', 'Espectro do sinal filtrado');

%% Exibi��o da magnitude e fase do filtro butterworth
figure;
freqz(Zeros, Poles);

%% Exibi��o do sinal de entrada
figure;
subplot(2, 1, 1);
plot(t, xt); grid on;
xlabel('Tempo  $t$(s)', 'interpreter','latex','FontSize',14);
ylabel('$x(t)$', 'interpreter','latex','FontSize',14);
title('Sinal de entrada');
axis([0.04 0.06 -15 15]);

%% Exibi��o do sinal de sa�da
subplot(2, 1, 2);
plot(t, xc); grid on;
xlabel('Tempo  $t$(s)', 'interpreter','latex','FontSize',14);
ylabel('$x_c(t)$', 'interpreter','latex','FontSize',14);
title('Sinal filtrado');
axis([0.04 0.06 -5 5]);

%% Exibi��o do sinal filtrado
figure;
plot(t, xc); grid on;
axis([0.04 0.06 -6 6]);
xlabel('$t (s)$','Interpreter','latex','FontSize',14)
ylabel('$x_c(t)$','Interpreter','latex','FontSize',14)
title("Sinal Filtrado");

%% Gera��o do trem de pulsos
fs = 6000; % Frequ�ncia de amostragem.

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

%% Exibi��o do sinal amostrado em diferentes dom�nios
figure;
subplot(2, 1, 1);
plot(t, xs,'color','red');
axis([0.04 0.06 -6 6]);
xlabel('$n$','Interpreter','latex','FontSize',14)
ylabel('$x_s(t)$','Interpreter','latex','FontSize',14)
title("Sinal Amostrado");

subplot(2, 1, 2);
showSpectrum(xs, t, Fs, fs+4000, 0.15, '$f$(Hz)', '$|X(j2\pi f)|$', 'Espectro do sinal amostrado');

%% Convers�o do sinal cont�nuo para discreto

% Transformada de Fourier (FT) do sinal amostrado
Xs = fft(xs);
freq = linspace(-fs/2, fs/2, length(Xs)); % Peri�dica em fs

% Rela��o FT <-> DTFT
Xn = Xs.*(1/fs);
freq_d = linspace(-(1/2), (1/2), length(Xn)); % Peri�dica em f = k*(fs/N)

%% Exibi��o do espectro do sinal amostrado (FT) e sinal discreto (DTFT)
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

%% Exibi��o do comparativo do sinal filtrado e do sinal discreto
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