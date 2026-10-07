function H = psf2otf_(psf, M, N)
% PSF jadi H(u,v) ukuran MxN. Hasilnya origin di pojok (belum di-shift),
% jadi bungkus pake fftshift dulu sebelum masuk GUI
    [pm, pn] = size(psf);
    padded = zeros(M, N);
    padded(1:pm, 1:pn) = psf;
    padded = circshift(padded, -[floor(pm/2), floor(pn/2)]);
    H = fft2(padded);
end
