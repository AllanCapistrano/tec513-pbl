function[] = customFvtool(signal)
% customFvtool é uma customização da função nativa fvtool.
% Inputs:
%   signal: Sinal a ser plotado pela função fvtool.

    fvtool(signal);
    hXlabel = get(gca, 'xlabel');
    set(hXlabel, 'FontSize', 56, 'FontWeight', 'bold')
    hYlabel = get(gca, 'ylabel');
    set(hYlabel, 'FontSize', 56, 'FontWeight', 'bold')

end