function Fhat = wienerFilter(G, H, K)
% Wiener dengan K = Sn/Sf (konstanta, kayak slide): F^ = conj(H) ./ (|H|^2 + K) .* G.
% K = 0 jadi inverse filter murni, K gede makin kalem (tapi makin burem).
    Fhat = conj(H) ./ (abs(H).^2 + K) .* G;
end
