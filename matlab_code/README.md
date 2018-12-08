! Note: mỗi lần tắt cửa sổ camera thì chương trình sẽ tự động dừng !
- Test camera trước để xem camera hoạt động ổn không. Chạy file 'test_camera.m'
- Detection face : phát hiện các khuôn mặt từ camera. Chạy file 'face_detection_video.m'
- Thu thập dữ liệu: 
    + Thu thập từ 1 nhiều hình down về từ internet:
        + Down về và lưu vào 'dataset_notyetdetected' , và đặt tên thư mục là tên của người đó
        + Label tự động và kiểm tra. Chạy file 'face_creating_dataset_from_pictures.m' cần bạn input 3 thông tin ( thư mục của những bức ảnh của 1 người mà bạn down về, id , tên của người đó) 
        + File đó sẽ lấy toàn bộ hình trong thư mục mà bạn đã nhập. Sử dụng Face Detection để tìm ra vùng chứa khuôn mặt. Resize ảnh về 144x144 và chuyển sang màu xám. Lưu vào thư mục 'dataset/(id)_(personName)/*.png' 
    + Thu thập từ camera scan 100 ảnh :
        + Input 2 thông tin: id và tên của người được labeled
        + Chạy file 'face_creating_dataset_from_camera.m' và đợi scan 100 hình 
        + Lưu vào thư mục với format 'dataset/(id)_(personName)/*.png' 
- Training:
    + Chạy 'face_training.m' để train toàn bộ hình trong thư mục 'dataset'
    + Sử dụng SVM
    + Bộ Classifier sẽ được lưu trong 'face_recognition_classifier.mat' để tiện cho dùng sau này
- Face Recognition and Face Tracking: 
    + Chạy file 'face_recognition_simple_from_camera.m' và test thử
