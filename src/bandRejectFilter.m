function H = bandRejectFilter(M, N, type, D0, W, n)
% Bandreject terpusat MxN, rumus ngikut slide 14: D0 = radius pita, W = lebar pita, n = orde (Butterworth).
% D = 0 dijaga manual biar ga jadi NaN (DC aman, lolos terus).
    D = freqGrid(M, N);
    switch type
        case 'Ideal'
            H = ones(M, N);
            H(D >= D0 - W/2 & D <= D0 + W/2) = 0;
        case 'Gaussian'
            H = 1 - exp(-0.5 * ((D.^2 - D0^2) ./ (D .* W)).^2);
        case 'Butterworth'
            H = 1 ./ (1 + abs((D .* W) ./ (D.^2 - D0^2)).^(2 * n));
        otherwise
            error('Jenis bandreject "%s" ga dikenal.', type);
    end
    H(isnan(H)) = 0;
end
