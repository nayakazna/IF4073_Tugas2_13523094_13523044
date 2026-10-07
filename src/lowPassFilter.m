function H = lowPassFilter(M, N, type, D0, n)
% H LPF terpusat MxN: 'Ideal' / 'Gaussian' / 'Butterworth'. n cuma kepake di Butterworth.
    D = freqGrid(M, N);
    switch type
        case 'Ideal'
            H = double(D <= D0);
        case 'Gaussian'
            H = exp(-(D.^2) / (2 * D0^2));
        case 'Butterworth'
            H = 1 ./ (1 + (D ./ D0).^(2 * n));
        otherwise
            error('Jenis LPF "%s" ga dikenal.', type);
    end
end
