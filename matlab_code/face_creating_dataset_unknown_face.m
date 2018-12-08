
% Get dataset from : http://vis-www.cs.umass.edu/lfw/

% Requisition : 
%   Only image types exists in directory 
%   Each image has only 1 face 

function face_creating_dataset_unknown_face()

    % Input:
    %   id: id for this person 
    %   name: person's name 
    %   dir_name : directory of this person's picture . 
    % Example:
    %   id = 0 
    %   name = unknown
    %   Directory of the person's picture = 'dataset_notyetdetected/unknown'
    % It contains a lot of directories of many other people 
    % Since this project is using SVM for classifying, so you need to put
    % the dataset about unknown face 
    clear
    
    % SIZE
    SIZE = [144, 144];
    
    % Create the face detector object using Viola-Jones algorithm.
    % Refs: 
    %   https://www.vocal.com/video/face-detection-using-viola-jones-algorithm/
    %   https://en.wikipedia.org/wiki/Viola%E2%80%93Jones_object_detection_framework
    faceDetector = vision.CascadeObjectDetector();
    
    % Read all file name in that directory
    dir_path = 'dataset_notyetdetect/unknown';
    dirs = dir(dir_path);
    
    notInitializedVar = true ;
    % loop through all directories in 'unknown' directory to get all pic
    % paths for later use !! 
    % After run these loops , it returns 'lstPicPaths' including all pic
    % paths 
    for iDir = 3 : size(dirs, 1)
        dirName = dirs(iDir).name;
        picNames = dir(char(strcat(dir_path, '/', dirName))); 
        
        % loop through all pics in each sub-directory in 'unknown'
        % directory
        for iPic = 3 : size(picNames,1)
            
            % Full path of that picture
            fullPicPath = char(strcat(dir_path, '/', dirName, '/', picNames(iPic).name));
            
            % Save it 
            if notInitializedVar 
                lstPicPaths =  { fullPicPath };
                notInitializedVar = false;
            else
                lstPicPaths = cat(1, lstPicPaths , fullPicPath );
            end 
        end
    end
    
    % Input id = 0 , name = 'unknown' for default 
    id = 0 ; 
    name = 'unknown';
    
    % Create OUTPUT directory
    % dir_path = 'dataset/<id>_<name>'
    dir_path_out = char(strcat('dataset/', string(id), '_' , name ));
    [status, ~, ~] = mkdir(dir_path_out);
    if status == 1
        fprintf('\n [CREATING DIRECTORY] %s', dir_path_out);
    else
        fprintf('\n [WARNING] %s , creating directory is missing something !', dir_path_out )
    end
    
    num_detected = 0 ;
    
    % Loop through each image path in 'lstPicPaths'
    for i = 1:size(lstPicPaths, 1)
        
        path = char(lstPicPaths(i));
        fprintf('\n [INFO] Read image from file %s', path);
        
        % read image
        img = imread(path);
        img_gray = rgb2gray(img);
        
        %Detection mode [x,y, w,h]
        bbox = faceDetector.step(img_gray);
        
        if ~isempty(bbox) && size(bbox, 1) == 1 
           
            num_detected = num_detected + 1; 
            fprintf('\n [INFO] Detected face');
            
            % Display
            %img = insertObjectAnnotation(img,'rectangle',bbox,char(strcat('Scanning [' ,string(num_detected) ,'/100]')));
            
            % 
            x = bbox(1);
            y = bbox(2);
            w = bbox(3);
            h = bbox(4);
            img_out_path = char(strcat(dir_path_out , '/' , string(num_detected) , '.png'));
            img_out = img_gray(y:y+h, x:x+w);
            
            % resize to 144x144
            img_out = imresize(img_out, SIZE);
            
            % Write to file
            imwrite(img_out, img_out_path);
            fprintf(' [SAVE] Picture number %d is saved !\n' , num_detected)
           
        end
        
    end
    
    % Clean up 
    release(faceDetector);

end