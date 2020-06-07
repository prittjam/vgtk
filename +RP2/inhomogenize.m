function x = inhomogenize(x)
    x = x(reshape([0:3:size(x,1)-1]+[1;2],1,[]),:);
end
