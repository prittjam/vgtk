function l = unnormalize(l, K)
    % l -- line in the normalized coordinates
    % K -- camera matrix

    l = K' \ l;
end