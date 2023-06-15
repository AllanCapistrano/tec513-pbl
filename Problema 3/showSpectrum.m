function[] = showSpectrum(signal, Fs, fm, plot_title, x_label, y_label)
%  showSpectrum exibe o espectro de um sinal.
% Inputs:
%   signal: Sinal que deseja ver o espectro.
%   Fs: Frequ�ncia de amostragem.
%   fm: Frequ�ncia m�xima para exibi��o.
%   plot_title: Texto que ser� exibido no t�tulo do gr�fico gerado.
%   x_label: Texto que ser� exibido no eixo 'x' do gr�fico gerado.
%   y_label: Texto que ser� exibido no eixo 'y' do gr�fico gerado.

    % Gera��o do sinal de entrada na frequencia
    fft_signal = fft(signal);
    fft_length = length(fft_signal);
    fft_signal = abs(fft_signal)/fft_length;
    Tf = Fs/fft_length;
    Tfmax = (fft_length - 1)*Tf;
    f = 0:Tf:Tfmax;

    % Corre��o do sinal de frequencia
    metade = round(fft_length/2);
    fp = f(1:metade);
    fft_signal_positive = fft_signal(1:metade);
    fn = f(metade+1:fft_length) - Tfmax - Tf;
    fft_signal_negative = fft_signal(metade+1:fft_length);
    ft = [fn, fp];
    fft_signal_total = [fft_signal_negative', fft_signal_positive'];
    fft_signal_total = fft_signal_total';

    % Plotagem do sinal de frequencia
    y_axis_max = max(fft_signal_total) + max(fft_signal_total)/50;
    plot(ft, fft_signal_total); grid on;
    axis([-fm fm 0 y_axis_max]);
    title(plot_title);
    hTitle = get(gca, 'title');
    set(hTitle, 'FontSize', 48, 'FontWeight', 'bold')
    xlabel(x_label, 'interpreter', 'latex','FontSize', 14);
    ylabel(y_label, 'interpreter', 'latex','FontSize', 14);
end