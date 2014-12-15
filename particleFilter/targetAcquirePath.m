initialFileName = 'sequence/test_1.pgm';
imageCount = 200;
image1 = imread(initialFileName);
targetInitialPosition = [20 30];
targetSize = [20 20];
targetPixelWindow = image1((targetInitialPosition(1):targetInitialPosition(1)+targetSize(1)-1),(targetInitialPosition(2):targetInitialPosition(2)+targetSize(2)-1))
targetPosition = zeros(200,2);
[targetPosition(1,1) targetPosition(1,2)] = findsubmat(image1, targetPixelWindow);

for imageCounter=2:200
    imageFileName = strcat('sequence/test_',num2str(imageCounter),'.pgm');
    imageData = imread(imageFileName);    
    [targetPosition(imageCounter,1) targetPosition(imageCounter,2)] = findsubmat(imageData, targetPixelWindow);
    imageinfo(:,:,imageCounter) = imageData;
end

targetPositionCorrected = zeros(200,2);
targetPositionCorrected(:,1) = targetPosition(:,2);
targetPositionCorrected(:,2) = -1*targetPosition(:,1);
figure(3)
plot(targetPositionCorrected(:,1),targetPositionCorrected(:,2))

    