function face_recognition_simple_from_camera()

    clear
    SIZE = [144, 144]; % 144x144 face region of image
    
    % get the classifier 
    faceClassifier = loadCompactModel('face_recognition_classifier_my_face');
    
    % How to predict
    %[label,NegLoss,PBScore] = predict(faceClassifier,queryFeatures);

    % Create the face detector object using Viola-Jones algorithm.
    % Refs: 
    %   https://www.vocal.com/video/face-detection-using-viola-jones-algorithm/
    %   https://en.wikipedia.org/wiki/Viola%E2%80%93Jones_object_detection_framework
    faceDetector = vision.CascadeObjectDetector();

    % Create the webcam object
    cam = webcam(1);

    % Capture one frame to get its size 
    videoFrame = snapshot(cam);
    frameSize = size(videoFrame);

    % Create the video player object 
    videoPlayer = vision.VideoPlayer('Position', [100, 100 [frameSize(2), frameSize(1)] + 30]); 

    runLoop = true; 
    numPts = 0;
    
    %while runLoop && frameCount < 400 
    while runLoop
        
       %Get the next frame 
       img = snapshot(cam);
       imgGray = rgb2gray(img);

       % Detect faces 
       faceBoxes = faceDetector.step(imgGray);
       
       if ~isempty(faceBoxes)
           % loop through each faceBox
           for i = 1 : size(faceBoxes,1)
                
                % Detect
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
                img = insertObjectAnnotation(img,'rectangle',[x,y,w,h],char(strcat(name,' , ', num2str(max(PBScore)))));
                
           end
       end
       
       step(videoPlayer, img);
        %step(videoPlayer2, videoFrame2);

        % Check whether the video player window has been closed 
        runLoop = isOpen(videoPlayer) ; %&& isOpen(videoPlayer2)
        
    end


    % Clean up
    clear cam;
    release(videoPlayer);
    release(faceDetector);
    


end