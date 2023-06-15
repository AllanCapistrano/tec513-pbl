function[] = plotSpectrumWindow(signal, M,  plot_title, x_label, y_label)
%  plotSpectrumWindow exibe o espectro da janela.
% Inputs:
%   signal: Sinal a ser exibido.
%   M: Quantidade de coeficientes do filtro.
%   plot_title: Texto que será exibido no título do gráfico gerado.
%   x_label: Texto que será exibido no eixo 'x' do gráfico gerado.
%   y_label: Texto que será exibido no eixo 'y' do gráfico gerado.

    plot(linspace(-pi, pi, M), abs(fftshift(fft(signal)))/length(fft(signal)), 'LineWidth', 8); grid on;
    set(gca, 'LineWidth', 8, 'FontSize', 32, 'FontWeight', 'bold');
    title(plot_title);
    hTitle = get(gca, 'title');
    set(hTitle, 'FontSize', 48, 'FontWeight', 'bold')
    xlabel(x_label, 'interpreter', 'latex','FontSize', 64)
    ylabel(y_label, 'interpreter', 'latex','FontSize', 64);
    xticks([-pi, -pi/2, 0, pi/2, pi]); % Substitui os valores inteiros pelos símbolos correspondentes
    xticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'});
    % Ajustar tamanho da figura para melhor visualização
    fig = gcf;
    fig.Position(3:4) = [800, 400];
    
end