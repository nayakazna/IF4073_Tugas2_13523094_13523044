function H = notchRejectFilter(M, N, notches, radius, n)
% Notch reject Butterworth orde n. Tiap notch (du,dv) dari pusat otomatis dipasangin kembaran
% simetrisnya (-du,-dv), jadi cukup masukin satu spike dari tiap pasangan.
% H = hasil kali 1/(1+(radius/Dk)^2n) untuk semua notch & kembarannya. Dk = 0 -> H = 0.
    [~, U, V] = freqGrid(M, N);
    H = ones(M, N);
    for k = 1:size(notches, 1)
        du = notches(k, 1); dv = notches(k, 2);
        Dk  = sqrt((U - du).^2 + (V - dv).^2);
        Dmk = sqrt((U + du).^2 + (V + dv).^2);
        H = H .* (1 ./ (1 + (radius ./ Dk).^(2 * n))) .* (1 ./ (1 + (radius ./ Dmk).^(2 * n)));
    end
end
