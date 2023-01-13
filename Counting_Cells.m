%Vanessa Silbar
%7/7/21, Image processing for bacteria colonies
%1/12/23, edited for just counting cells

% Sam Freitas
% 7/16/21 edited :D

warning('off', 'MATLAB:MKDIR:DirectoryExists');

clear all
close all force hidden

curr_path = pwd;
disp('Select Experiment')

img_dir_path = uigetdir(curr_path);

%set to 0 if you don't care about separating colonies
manually_separate = 1;

% crop the images if they are just kinda bad
crop_images = 1;

% export the masks 
export_masks = 1;

img_paths = dir(fullfile(img_dir_path, '*.png'));

disp(['Processing data for: ' img_dir_path])

[~,name] = fileparts(img_dir_path); %gets name of experiment/plate

exp_name = strings(1,length(img_paths));
img_name = strings(1,length(img_paths));
img_num = strings(1,length(img_paths));
total_num_colony = zeros(1,length(img_paths));
img_num_colony = zeros(1,length(img_paths));
count = 1;

for i = 1:length(img_paths)
    
    exp_name(count) = string(name);
    img_name(count) = string(fullfile(img_paths(i).folder,img_paths(i).name));
    img_num(count) = string(img_paths(i).name);
    total_num_colony(count) = count;
    count = count + 1;
    
    % get image path
    this_img_path = fullfile(img_dir_path,img_paths(i).name);
    % read in image
    this_img = imread(this_img_path);
    % convert to grayscale
    data = im2gray(this_img); 
    
    imshow(data);
    [centers, radii] = imfindcircles(data,[8 30]);
    viscircles(centers, radii, 'EdgeColor','r');
    
    img_num_colony(i) = length(centers);
    saveas(gcf, fullfile(img_dir_path,'exported_images',img_paths(i).name));
    
    close all
end
    close all

csv_header = ["Sub Experiment Name","Image Path","Image Number",...
    "Total Colony Counter","Image Colony Counter"];

exp_table = [exp_name;img_name;img_num;total_num_colony;img_num_colony];

for i = 1:size(exp_table,2)
    for j = 1:size(exp_table,1)
        final_table(i,j) = exp_table(j,i);
    end
end

T = cell2table(cellstr(final_table),'VariableNames',csv_header);

output_csv_path = fullfile(img_dir_path,'data.csv');
disp(['Data output to ' output_csv_path])

writetable(T,output_csv_path);
    
