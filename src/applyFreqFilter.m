function [result, F, G] = applyFreqFilter(channel, H)
% FFT -> kali H -> balik lagi. H harus ukurannya sama dan terpusat ya, jangan lupa.
    F = fftshift(fft2(channel));
    G = F .* H;
    result = real(ifft2(ifftshift(G)));
end
