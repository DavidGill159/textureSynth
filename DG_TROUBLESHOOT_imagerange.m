img = im2double(imread('C:\code_DG\Image_dataset\HPF_DGcurated\ps_test\Copy of blotchy_0003.png'));
if size(img,3) > 1
    img = rgb2gray(img);
end

fprintf('Min: %.6f, Max: %.6f\n', min(img(:)), max(img(:)));
fprintf('Any values < 0: %d\n', any(img(:) < 0));
fprintf('Any values > 1: %d\n', any(img(:) > 1));

figure;
histogram(img(:), 256); title('Pixel Value Distribution');
xlabel('Pixel Value'); ylabel('Count');
