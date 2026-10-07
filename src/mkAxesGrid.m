function axs = mkAxesGrid(parent, titles, region, bgAxes, gridCol, fg)
% Nata axes jadi 2 baris, tiap axes dikasih judul. Ben gk ngitung posisi manual tros
    n = numel(titles);
    cols = ceil(n / 2);
    cw = region(3) / cols;
    ch = region(4) / 2;
    axs = cell(1, n);
    for k = 1:n
        r = ceil(k / cols);
        c = k - (r - 1) * cols;
        x = region(1) + (c - 1) * cw;
        y = region(2) + (2 - r) * ch;
        axs{k} = axes(parent, 'Units', 'normalized', ...
            'Position', [x + 0.1*cw, y + 0.04*ch, 0.8*cw, 0.78*ch], ...
            'Color', bgAxes, 'XColor', gridCol, 'YColor', gridCol, ...
            'XTick', [], 'YTick', []);
        title(axs{k}, titles{k}, 'Color', fg, 'FontSize', 9, 'Interpreter', 'none');
    end
end
