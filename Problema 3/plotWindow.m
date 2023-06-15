function[] = plotWindow(signal_1, signal_2, legend_1, legend_2, plot_title, x_label, y_label)
%  plotWindow exibe o gráfico da janela.
% Inputs:
%   signal_1: Primeiro sinal a ser exibido.
%   signal_2: Segundo sinal a ser exibido.
%   legend_1: Legenda do primeiro sinal.
%   legend_2: Legenda do segundo sinal.
%   plot_title: Texto que será exibido no título do gráfico gerado.
%   x_label: Texto que será exibido no eixo 'x' do gráfico gerado.
%   y_label: Texto que será exibido no eixo 'y' do gráfico gerado.

    hold on;
    plot(signal_1, 'DisplayName', legend_1, 'LineWidth', 8);
    plot(signal_2, 'r--', 'DisplayName', legend_2, 'LineWidth', 8); 
    set(gca, 'LineWidth', 8, 'FontSize', 32, 'FontWeight', 'bold');
    hold off;
    title(plot_title);
    hTitle = get(gca, 'title');
    set(hTitle, 'FontSize', 48, 'FontWeight', 'bold')
    xlabel(x_label, 'interpreter', 'latex','FontSize', 64)
    ylabel(y_label, 'interpreter', 'latex','FontSize', 64);
    legend show
    set(legend, 'FontSize', 24)

end