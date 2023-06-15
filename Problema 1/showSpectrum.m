function [y, w] = showSpectrum(signal, t, Fs, x_limit, y_limit, x_label, y_label, plot_title)
%  showSpectrum exibe o espectro de um sinal.
% Inputs:
%   signal: Frequ�ncia de amostragem.
%   t: Per�odo de amostragem do sinal de entrada.
%   Fs: Valor de tempo final do sinal de entrada.
%   x_limit: Limite de exibi��o no eixo 'x' do gr�fico gerado.
%   y_limit: Limite de exibi��o no eixo 'y' do gr�fico gerado.
%   x_label: Texto que ser� exibido no eixo 'x' do gr�fico gerado.
%   y_label: Texto que ser� exibido no eixo 'y' do gr�fico gerado.
%   plot_title: Texto que ser� exibido no t�tulo do gr�fico gerado.

    y = fft(signal); grid on;
    yaux = fliplr(y(1, 2:end));
    X = [yaux y];
    bandwidth = ceil(length(X)/4);
    X(1, 1:bandwidth) = 0;
    X(1, 3*bandwidth:end) = 0;
    length(X);
    omega = [0:Fs/length(y):Fs-(Fs/length(y))];
    waux = -fliplr(omega(1, 2:end));
    w = [waux omega];
    length(w);
    plot(w, abs(X/length(t))); grid on;
    axis([-x_limit x_limit 0 y_limit])
    xlabel(x_label, 'interpreter', 'latex','FontSize',14);
    ylabel(y_label, 'interpreter', 'latex','FontSize',14);
    title(plot_title);
end