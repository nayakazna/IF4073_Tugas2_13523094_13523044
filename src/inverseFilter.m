function Fhat = inverseFilter(G, H, radius, minH)
% Inverse filtering: F^ = G ./ H, tapi cuma di dalam radius dan di tempat |H| >= minH.
% Sisanya diset 0 (ratio dipotong, kayak slide), kalo ga ya noise bakal meledak di H kecil.
    D = freqGrid(size(G, 1), size(G, 2));
    ok = (D <= radius) & (abs(H) >= minH) & (abs(H) > 0);
    Fhat = zeros(size(G));
    Fhat(ok) = G(ok) ./ H(ok);
end
