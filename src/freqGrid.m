function [D, U, V] = freqGrid(M, N)
% Bikin grid jarak ke pusat spektrum (pusat = (floor(M/2)+1, floor(N/2)+1),
% inih cocok sama fftshift). U = offset baris, V = offset kolom, D = jaraknya.
    u = (0:M-1) - floor(M/2);
    v = (0:N-1) - floor(N/2);
    [V, U] = meshgrid(v, u);
    D = sqrt(U.^2 + V.^2);
end
