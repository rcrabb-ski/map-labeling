function strout = sign_labeler(mapfile)
% SIGN_LABELER( mapfile, XY)
% input:
%   mapfile - file location for bitmap of map to be labeled
%   XY (optional) - preset cooordinates

% List of class names and dialog text for classes
classList = {'Caution', 'Exit', 'FaceMask', 'James', 'Manfred', ...
           'NamePlate',  'OneWay', 'RERCLarge', 'RedFire', 'Restroom', ...
           'Safety', 'SixFeet'};
classdlg = 'Enter class:';
for c = 1:length(classList)
    classdlg = [classdlg newline num2str(c) ' - ' classList{c}];
end

% List of directions for dialog box
orientdlg = 'Enter Orientation (neswud) - multiple characters allowed';
% Coordinate Translation
w = [-1  0  0]';
e = [ 1  0  0]';
s = [ 0 -1  0]';
n = [ 0  1  0]';
u = [ 0  0  1]';
d = [ 0  0 -1]';

% Load and display the map
map = imread(mapfile);
mapfig = figure;
title('Choose landmark location.  Close window if complete')
imshow(map);

% Create data structures
X = [];
Y = [];
classes = [];
orientation = [];

% Get coordinates one click at a time
point = drawpoint;
while (isprop(point,'Position'))
    pt = point.Position;
    usrInput = inputdlg({classdlg, orientdlg}, 'Class and Orientation');
    for ori = usrInput{2}
        X(end+1) = floor(pt(1));
        Y(end+1) = floor(pt(2));
        classes(end+1) = str2num(usrInput{1});
        orientation = [orientation eval(ori)];
    end
    point = drawpoint;
end

save(replace(string(datetime),":","-")+".mat","classes","orientation","Y", "X");
strout = sprintf('[');
for i = 1:length(X)
    strout = append(strout,sprintf('{"Col": %d, "Row": %d, "n_u": %d, "n_v": %d, "n_w": %d, "class": "%s"},\n',...
        X(i), Y(i), orientation(1,i), orientation(2,i), orientation(2,i), classList{classes(i)}));
end
strout(end-1:end+1) = ']\n';
fprintf(strout);
save(replace(string(datetime),":","-")+".mat","classes","orientation","Y", "X","strout");

