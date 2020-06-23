function border = input_border(img, n, message)
    if nargin < 2 || isempty(n)
        n = 4;
    end
    if nargin < 3 || isempty(message)
        message = ['Please pick ' num2str(n) ' points.'];
    end 
    f=figure;
    imshow(img);
    title(message)
    [borderx,bordery] = ginput(n);
    close(f);
    border = [borderx bordery];
end