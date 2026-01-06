dispLevels = 16;
p1 = 5;
p2 = 10;

% Read the stereo images as grayscale
leftImg = rgb2gray(imread('left.png'));
rightImg = rgb2gray(imread('right.png'));

% Apply a Gaussian filter
leftImg = imgaussfilt(leftImg,0.68,'FilterSize',5);
rightImg = imgaussfilt(rightImg,0.68,'FilterSize',5);

% Get image size
[rows,cols] = size(leftImg);

% Compute data cost (matching cost)
dataCost = zeros(rows,cols,dispLevels);
leftImg = double(leftImg);
rightImg = double(rightImg);
for d = 0:dispLevels-1
    rightImgShifted = [zeros(rows,d),rightImg(:,1:end-d)];
    dataCost(:,:,d+1) = abs(leftImg-rightImgShifted);
end

% Compute smoothness cost
d = 0:dispLevels-1;
diff = abs(d-d');
smoothnessCost = (diff==1)*p1+(diff>=2)*p2;

% Initialize tables with costs for the 8 directions
L1 = zeros(rows,cols,dispLevels);
L2 = zeros(rows,cols,dispLevels);
L3 = zeros(rows,cols,dispLevels);
L4 = zeros(rows,cols,dispLevels);
L5 = zeros(rows,cols,dispLevels);
L6 = zeros(rows,cols,dispLevels);
L7 = zeros(rows,cols,dispLevels);
L8 = zeros(rows,cols,dispLevels);
L9 = zeros(rows,cols,dispLevels);
L10 = zeros(rows,cols,dispLevels);
L11 = zeros(rows,cols,dispLevels);
L12 = zeros(rows,cols,dispLevels);
L13 = zeros(rows,cols,dispLevels);
L14 = zeros(rows,cols,dispLevels);
L15 = zeros(rows,cols,dispLevels);
L16 = zeros(rows,cols,dispLevels);

% Forward pass
for y = 3:rows
    for x = 3:cols-2
        % left to right direction
        cost = squeeze(dataCost(y,x-1,:)+L1(y,x-1,:));
        cost = min(cost+smoothnessCost);
        L1(y,x,:) = cost-min(cost);
        
        % left2/up to right2/down direction
        cost = squeeze(dataCost(y-1,x-2,:)+L2(y-1,x-2,:));
        cost = min(cost+smoothnessCost);
        L2(y,x,:) = cost-min(cost);

        % left/up to right/down direction
        cost = squeeze(dataCost(y-1,x-1,:)+L3(y-1,x-1,:));
        cost = min(cost+smoothnessCost);
        L3(y,x,:) = cost-min(cost);
        
        % left/up2 to right/down2 direction
        cost = squeeze(dataCost(y-2,x-1,:)+L4(y-2,x-1,:));
        cost = min(cost+smoothnessCost);
        L4(y,x,:) = cost-min(cost);

        % up to down direction
        cost = squeeze(dataCost(y-1,x,:)+L5(y-1,x,:));
        cost = min(cost+smoothnessCost);
        L5(y,x,:) = cost-min(cost);
        
        % right/up2 to left/down2 direction
        cost = squeeze(dataCost(y-2,x+1,:)+L6(y-2,x+1,:));
        cost = min(cost+smoothnessCost);
        L6(y,x,:) = cost-min(cost);

        % right/up to left/down direction
        cost = squeeze(dataCost(y-1,x+1,:)+L7(y-1,x+1,:));
        cost = min(cost+smoothnessCost);
        L7(y,x,:) = cost-min(cost);
        
        % right2/up to left2/down direction
        cost = squeeze(dataCost(y-1,x+2,:)+L8(y-1,x+2,:));
        cost = min(cost+smoothnessCost);
        L8(y,x,:) = cost-min(cost);
    end
end

% Backward pass
for y = rows-2:-1:1
    for x = cols-2:-1:3
        % right to left direction
        cost = squeeze(dataCost(y,x+1,:)+L9(y,x+1,:));
        cost = min(cost+smoothnessCost);
        L9(y,x,:) = cost-min(cost);
        
        % right2/down to left2/up direction
        cost = squeeze(dataCost(y+1,x+2,:)+L10(y+1,x+2,:));
        cost = min(cost+smoothnessCost);
        L10(y,x,:) = cost-min(cost);

        % right/down to left/up direction
        cost = squeeze(dataCost(y+1,x+1,:)+L11(y+1,x+1,:));
        cost = min(cost+smoothnessCost);
        L11(y,x,:) = cost-min(cost);
        
        % right/down2 to left/up2 direction
        cost = squeeze(dataCost(y+2,x+1,:)+L12(y+2,x+1,:));
        cost = min(cost+smoothnessCost);
        L12(y,x,:) = cost-min(cost);

        % down to up direction
        cost = squeeze(dataCost(y+1,x,:)+L13(y+1,x,:));
        cost = min(cost+smoothnessCost);
        L13(y,x,:) = cost-min(cost);
        
        % left/down2 to right/up2 direction
        cost = squeeze(dataCost(y+2,x-1,:)+L14(y+2,x-1,:));
        cost = min(cost+smoothnessCost);
        L14(y,x,:) = cost-min(cost);

        % left/down to right/up direction
        cost = squeeze(dataCost(y+1,x-1,:)+L15(y+1,x-1,:));
        cost = min(cost+smoothnessCost);
        L15(y,x,:) = cost-min(cost);
        
        % left2/down to right2/up direction
        cost = squeeze(dataCost(y+1,x-2,:)+L16(y+1,x-2,:));
        cost = min(cost+smoothnessCost);
        L16(y,x,:) = cost-min(cost);
    end
end

% Compute total cost (aggregated cost)
S = L1 + L2 + L3 + L4 + L5 + L6 + L7 + L8 + ...
    L9 + L10 + L11 + L12 + L13 + L14 + L15 + L16;

% Update disparity map
[~,ind] = min(S,[],3);
disparityMap = ind-1;

% Update disparity image
scaleFactor = 256/dispLevels;
disparityImg = uint8(disparityMap*scaleFactor);

% Show disparity image
figure
imshow(disparityImg)

% Save disparity image
imwrite(disparityImg,'disparity.png')
