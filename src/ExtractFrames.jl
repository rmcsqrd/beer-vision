module ExtractFrames
export extract_frames

extract_frames = extract_frames(N, prefix, path)    

    function extract_frames(N, prefix, path)
        #DisplayBubbles(video_path)
        io = VideoIO.open(path)
        f = VideoIO.openvideo(io)
    
      for i in 1:N 
            img = read(f)
            #imshow(img)  #uncomment if you want to see the image frames
            save(prefix, img)
        end 

    end
end
