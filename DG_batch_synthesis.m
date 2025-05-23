%% === CONFIGURATION ===
inputDir = 'C:\code_DG\Image_dataset\HPF_DGcurated\ps_test';     % Folder with your input images
outputDir = 'C:\code_DG\Image_dataset\HPF_DGcurated_PS_synths';  % Output folder for results
numVariants = 20;                  % Number of variants per image
Nsc = 4; Nor = 4;                  % Steerable pyramid params
Na = 7;                            % Spatial neighborhood (e.g., 7x7)
Niter = 25;                        % Synthesis iterations

mkdir(outputDir);
imgFiles = dir(fullfile(inputDir, '*.png'));
numImages = length(imgFiles);
totalSteps = numImages * numVariants;

%% === INITIALISE PROGRESS BAR ===
set(0, 'DefaultFigureVisible', 'off');  % Stop figure popups
close all hidden                         % Close lingering figures
h = waitbar(0, 'Starting synthesis...');

stepCount = 0;

%% === LOOP OVER DATASET IMAGES ===
for i = 1:numImages
    inputName = imgFiles(i).name;
    img = im2double(imread(fullfile(inputDir, inputName)));
    if size(img,3) > 1
        img = rgb2gray(img);  % Ensure grayscale
    end
    img = min(max(img, 0), 1);  % Ensure bounded

    % Dynamically scale Nsc if needed
    maxNsc = floor(log2(min(size(img))) - 2);
    safeNsc = min(Nsc, max(Na, maxNsc));  % Ensure Nsc >= Na

    % === Texture Analysis ===
    params = textureAnalysis(img, safeNsc, Nor, Na);

    % === Synthesize Variants ===
    for j = 1:numVariants
        imageSize = size(img);
        synth = textureSynthesis(params, imageSize, Niter, [], [], safeNsc);
        synthName = sprintf('%s_variant%02d.png', inputName(1:end-4), j);
        imwrite(synth, fullfile(outputDir, synthName));

        % === Update Progress Bar ===
        stepCount = stepCount + 1;
        
        waitbar(stepCount / totalSteps, h, ...
            sprintf('Image %d/%d, Variant %d/%d', i, numImages, j, numVariants));
    end
end

close(h);  % Close the progress bar
disp('✅ Synthesis complete.');
