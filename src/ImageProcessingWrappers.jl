using ProgressMeter, ImageTransformations, Images

function resize_images(resize_ratio, image_folder)

    for (root, dirs, files) in walkdir(image_folder)
        @showprogress 1 "Resizing Images..." for (filecnt, file) in enumerate(files)
            if file[length(file)-3:length(file)] == ".jpg"
                filepath = string(image_folder,"/",file)
                img = load(filepath)
                img = imresize(img, ratio = resize_ratio) 
                save(filepath, img)

            end
        end
    end 
end

function extract_frames(N, prefix, path)
    # this function extracts frames from a video
    
    io = VideoIO.open(path)
    f = VideoIO.openvideo(io)

    @showprogress 1 "Extracting frames..." for i in 1:N
        img = read(f)
        if i >= 10
            save(string(prefix,"$i.jpg"), img)
        else
            save(string(prefix,"0$i.jpg"),img)  # this helps with sorting the files
        end
    end

end

