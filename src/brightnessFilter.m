function H = brightnessFilter(M, N, gain, D0)
% Terang itu kandungan frekuensi rendah (DC = rata-rata intensitas), jadi frekuensi rendah
% dikuatin pake Gaussian: H = 1 + (gain-1) * GLPF. DC dikali tepat `gain`, frekuensi tinggi
% (detail) tetep 1 jadi ga ikut meledak. gain > 1 = lebih terang, D0 = seberapa lebar yang dikuatin.
    D = freqGrid(M, N);
    H = 1 + (gain - 1) * exp(-(D.^2) / (2 * D0^2));
end
