function strout = sign_labeler(XY)
map = imread('/Users/rcrabb/PycharmProjects/ParticleFilter/maps/walls_1.bmp');
mapfig = figure;
imshow(map);
if isempty(XY)
    [xi, yi] = getpts(mapfig);
    xi = floor(xi);
    yi = floor(yi);
    XY = [xi, yi]';
else
    xi = XY(1,:)';
    yi = XY(2,:)';
end
% Coordinate Translation
w = [ -1 0]';
e = [1 0]';
s = [ 0 -1]';
n = [0 1]';
ns = [0 1; 0 -1]';
ew = [1 0; -1 0]';
% Sign Data
classes = [];
orientation = [];
xi = [];
yi = [];
close(mapfig)
for xy = XY
    mapCopy = map;
    imshow(mapCopy);
    hold on
    plot(xy(1), xy(2), 'co', 'MarkerSize', 7);
    plot(xy(1), xy(2), 'c+', 'MarkerSize', 7);
    class = input('Class number: ');
    ori = input('Orienation (n, e, s, w, ew, ns): ');
    classes = [classes class*ones(1,numel(ori)/2)];
    xi = [xi xy(1)*ones(1,numel(ori)/2)];
    yi = [yi xy(2)*ones(1,numel(ori)/2)];
    orientation = [orientation ori];
    close all
end
save(replace(string(datetime),":","-")+".mat","classes","orientation","yi", "xi");
strout = sprintf('[');
for i = 1:length(xi)
    strout = append(strout,sprintf('{"Col": %d, "Row": %d, "n_u": %d, "n_v": %d, "class": %d},\n',xi(i), yi(i), orientation(1,i), orientation(2,i), classes(i)));
end
strout(end-1:end+1) = ']\n';
fprintf(strout);
save(replace(string(datetime),":","-")+".mat","classes","orientation","yi", "xi","strout");

