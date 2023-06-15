%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TEC513-MI-PDS-UEFS2023.1
%% Problema 01 
% Arquivo gerador multifrequ�ncia e �udio file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Fun��o: [xt,fc,phi,t]=gerador(tempo,fcmin,fcmax)

% Vari�veis de entrada
% tempo <= dura��o do sinal gerado em segundos
% fcmin <= conponente de frequ�ncia m�nimo em Hz
% fcmax <= conponente de frequ�ncia m�ximo em Hz

% Vari�veis de sa�da
% xt <= � o sinal gerado
% fc <= � o frame das frequ�ncias geradas em Hz
% phi <= � o frame de fases usados em Rad
% t <= � o dominio em segundos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Por exemplo, execute a linha abaixo 
%% no Command Window para gerar o sinal!!!!!
%
%[xt,fc,phi,t]=geradorr(2,10,4000);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Fun��o Gerador
function [xt,fc,phi,t]=gerador(tempo,fcmin,fcmax)  % temo em segundos
 % Defini��es no tempo:
 Fs = 24000;                   % amostras por segundo <= Freq. de amostragem 
%  Fs = 8000;                   % amostras por segundo <= Freq. de amostragem 
 dt = 1/Fs;                   % segundos por amostras
 StopTime = tempo;            % intervalo de dura��o dos sinais em segundos
 t = 0:dt:StopTime-dt;        % segundos
 % Ondas senoidais:
 interval=100;                % intervalos em Hz entre sinais gerados 
 fc = fcmin:interval:fcmax;   % fcmin>0 Hz e fcmax<4000 Hz
 phi = 0:(pi/2)/length(fc):pi/2;
                                  %%%A=0.5*ones(1,length(fc));
 A=0.5*rand(1,length(fc));        % Amplitudes dos sinais limitados em 0,5 e aleat�rios
%  A=0.5;
 for i=1:length(fc)
     for j=1:length(t)
        x(i,j) = A(i)*cos(2*pi*fc(i)*t(j)+phi(i));
%           x(i,j) = A*cos(2*pi*fc(i)*t(j)+phi(i));
     end
 end
 xt=sum(x,1);
 length(xt);
% Graficando
% Dom�nio do tempo
figure(1);
subplot(3,1,1);
plot(t(1,1:1500),x(1,1:1500),'k',t(1,1:1500),x(2,1:1500),'r',t(1,1:1500),x(10,1:1500),'m'); grid on;
xlabel('Tempo  $t$(s)','interpreter','latex');
ylabel('Amplitude');
title('$x_{1}(t)$, $x_{2}(t)$ e $x_{10}(t)$ alguns componentes que compoem o sinal de entrada','interpreter','latex');
axis([0 0.18 -0.5 0.5]);

subplot(3,1,2);
plot(t,xt,'b'); grid on;
xlabel('Tempo  $t$(s)','interpreter','latex');
ylabel('Amplitude');
title('Sinal de entrada $x(t)$','interpreter','latex');
axis([0 0.18 -15 15]);

% Dom�nio da frequ�ncia  
subplot(3,1,3);
y=fft(xt); grid on;
yaux=fliplr(y(1,2:end));
X=[yaux y];
faixa=ceil(length(X)/4);
X(1,1:faixa)=0;
X(1,3*faixa:end)=0;
length(X);
omega=0:Fs/length(y):Fs-(Fs/length(y));
waux=-fliplr(omega(1,2:end));
w=[waux omega];
length(w);
plot(w,abs(X/length(t))); grid on;
xlabel('$f$(Hz)','interpreter','latex');
ylabel('Magnitude');
title('Espectro do sinal de entrada $|X(j2\pi f)|$','interpreter','latex');

% Som
%sound(xt,Fs);
end