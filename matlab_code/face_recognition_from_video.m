
function face_recognition_from_video()

    clear;

    % These var effects the working mode 
    % Check the configuration carefully !
    SIZE = [144 , 144];
    IS_DISPLAY_WHILE_WRITING = true ;
    IS_WRITE_TO_FILE = true ;
    VIDEO_IN_PATH = 'test/video/JohnnyEnglishReborn(2011)Trailer-HDMovie.mp4';
    VIDEO_OUT_PATH = 'test/video/detectedFace_johnyenglish';
    TIME_START = 30; % which time you want to start from in second

    % get the classifier 
    faceClassifier = loadCompactModel('face_recognition_classifier_johny_english_trailer');
    
    % see full list supported type movie 
    VideoReader.getFileFormats()

    % Read movie 
    movieObj = VideoReader(VIDEO_IN_PATH); % open file 
    get(movieObj)
    
    % Number of Frames 
    %nFrames = movieObj.NumberOfFrames ; 
    
    % Width and Height
    width = movieObj.Width;
    height = movieObj.Height; 
    fprintf(' [INFO] Width x Height = %d x %d ', width , height);
    
    % Video Player
    if IS_DISPLAY_WHILE_WRITING
        videoPlayer = vision.VideoPlayer('Position', [100, 100 [width, height] + 30 ]); 
    end
    
    % Face Detector
    faceDetector = vision.CascadeObjectDetector();
    
    % Read all frames in once 
    % images = read(movieObj); 
    % This creates a 4-dimensional array of size (height, width , rgbColor ,
    % nFrames)
    % Get the i-th image
    % I = images(:,:,:,i); 
    % Can also read an interval (from frame number 100 to 200)
    % images = read(movieObj, [100 200])
    
    % Video Writer 
    % Create mp4 file 
    if IS_WRITE_TO_FILE
        videoWriter = VideoWriter(VIDEO_OUT_PATH, 'MPEG-4') ; % .mp4
        open(videoWriter);
    end
    
    runLoop = true ;
    
    % set starting from 
    movieObj.CurrentTime = TIME_START ;
    
    % Read every frame from this movie 
    while hasFrame(movieObj) && runLoop
       img = readFrame(movieObj); % 
       imgGray = rgb2gray(img);
       %fprintf('\n [INFO] Current Time %d ', movieObj.CurrentTime);
       
       % Detect faces 
       faceBoxes = faceDetector.step(imgGray);
       
       if ~isempty(faceBoxes)
           % loop through each faceBox
           for i = 1 : size(faceBoxes,1)
                
                % Detect
                % faceBox = faceBoxes(i,:)
                %img = insertObjectAnnotation(img,'rectangle',faceBox,char(strcat('Face',string(i))));
                
                x = faceBoxes(i,1);
                y = faceBoxes(i,2);
                w = faceBoxes(i,3);
                h = faceBoxes(i,4);
                
                % get max_width , max_height
                max_height = size(imgGray,1);
                max_width = size(imgGray,2);

                % fix exceeds matrix vertically
                if y+h > max_height
                   h = max_height - y;
                end

                % fix exceeds matrix horizontally
                if x+w > max_width
                   w = max_width - x; 
                end
                
                face_roi = img(y:y+h, x:x+w);
                face_roi = imresize(face_roi, SIZE);
                
                % HOG features extraction 
                hog_feature = extractHOGFeatures(face_roi);
                [name,NegLoss,PBScore] = predict(faceClassifier,hog_feature);
                
                % Add box with name and score
                img = insertObjectAnnotation(img,'rectangle',[x,y,w,h],char(strcat(name,' , ', string(PBScore*100), '%')));
                
           end
       end
       
       % Display image
       %imshow(img, []); 
       if IS_DISPLAY_WHILE_WRITING
           step(videoPlayer, img);
           runLoop = isOpen(videoPlayer) ; 
       end
       
       if IS_WRITE_TO_FILE
           writeVideo(videoWriter, img);
       end

       % Pause a little so we can see the image. If no argument is given,
       % it waits until a key is pressed 
       %pause(0.1);
    end
    
    if IS_WRITE_TO_FILE
        fprintf('\n [INFO] Write to file %s complete. Starting from %.2fs  to %.2fs ', VIDEO_OUT_PATH, TIME_START, movieObj.CurrentTime );
    end
    
    if IS_DISPLAY_WHILE_WRITING
        release(videoPlayer);
    end
    
end