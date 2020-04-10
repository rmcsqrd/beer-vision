function extract_frames(N, prefix, path)
    #DisplayBubbles(video_path)
    io = VideoIO.open(path)
    f = VideoIO.openvideo(io)

    for i in 1:N
        img = read(f)
        #imshow(img)  #uncomment if you want to see the image frames
        if i >= 10
            save(string(prefix,"$i.jpg"), img)
        else
            save(string(prefix,"0$i.jpg"),img)  # this helps with sorting the files
        end
    end

end
