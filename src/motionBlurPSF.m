function psf = motionBlurPSF(len, theta)
% PSF motion blur linier: garis sepanjang len piksel, sudut theta derajat. Konvensi sudut ngikut
% data uji (dicek ke reference): theta positif = garis turun ke kanan di citra (sumbu y ke bawah),
% KEBALIKAN fspecial('motion'). Garis disampling rapat, tiap titik masuk ke piksel terdekat, total = 1.
    half = ceil(len / 2);
    psf = zeros(2 * half + 1);
    c = half + 1;
    t = linspace(-len/2, len/2, max(2, ceil(len) * 200));
    t = t(1:end-1) + diff(t(1:2)) / 2;
    col = round(c + t * cosd(theta));
    row = round(c + t * sind(theta));
    for k = 1:numel(t)
        psf(row(k), col(k)) = psf(row(k), col(k)) + 1;
    end
    psf = psf / sum(psf(:));
end
