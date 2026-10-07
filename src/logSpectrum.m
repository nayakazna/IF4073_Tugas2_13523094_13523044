function S = logSpectrum(Fshift)
% log(1+|F|) biar spektrumnya kelihatan, kalo nggak ya cuma titik putih di tengah doang.
    S = log(1 + abs(Fshift));
end
