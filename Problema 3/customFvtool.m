function[] = customFvtool(signal)
% customFvtool � uma customiza��o da fun��o nativa fvtool.
% Inputs:
%   signal: Sinal a ser plotado pela fun��o fvtool.

    fvtool(signal);
    hXlabel = get(gca, 'xlabel');
    set(hXlabel, 'FontSize', 56, 'FontWeight', 'bold')
    hYlabel = get(gca, 'ylabel');
    set(hYlabel, 'FontSize', 56, 'FontWeight', 'bold')

end