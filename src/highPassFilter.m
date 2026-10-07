function H = highPassFilter(M, N, type, D0, n)
% H HPF terpusat MxN, tinggal 1 - LPF-nya (Ideal & Gaussian). Butterworth ditulis langsung
% biar D = 0 ga bikin pembagian nol. Catatan: DC ikut kebuang, jadi hasilnya gelap, wajar.
    D = freqGrid(M, N);
    switch type
        case 'Ideal'
            H = double(D > D0);
        case 'Gaussian'
            H = 1 - exp(-(D.^2) / (2 * D0^2));
        case 'Butterworth'
            H = zeros(M, N);
            nz = D > 0;
            H(nz) = 1 ./ (1 + (D0 ./ D(nz)).^(2 * n));
        otherwise
            error('Jenis HPF "%s" ga dikenal.', type);
    end
end
