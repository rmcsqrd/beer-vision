## IMPORTS
using VideoIO
using Makie
using ImageTransformations

## FUNCTION

#TODO:  accept function inputs from julia REPL or command line
#       break out sub commands into /src for readability 
#       resize the images and actually do some image processing.
#       figure out some sort of workflow to make a gif of your progress images
#       

function main(video_name)
    # choose video frame parameters and extract frames
    video_path = string(@__DIR__,"/data/videos/", video_name)
    foldername = video_name[1:length(video_name)-4]
    try
        mkdir(string(@__DIR__,"/data/frames/", foldername))  # make a new directory if doesn't exist. If it does exist ignore error and move on
    catch
        
    end
    video_folder = string(@__DIR__,"/data/frames/$foldername")
    video_prefix = string(video_folder,"/")
 
    # do a naive check to see if folder has contents, if not, extract images
    if length(readdir(string(video_folder,"/"))) == 1  # check for pesky .DS_store 
        N = 99 # 100 will give you issues with file naming (eg _09, _10, _100, _11)
        extract_frames(N, video_prefix, video_path)
    end
   
    # generate video file parameters and extract actual video fps rate
    file_params_path = string(video_folder,"/_file_params.txt")
    imagefps = determineFPS(file_params_path, video_path)
    
    # resize images because outputted frames are big by looping through folder
    for (root, dirs, files) in walkdir(video_folder)
        for file in files
            if file[length(file)-3:length(file)] == ".jpg"
                println(imagefps)
           end
       end
    end
end

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

function DisplayBubbles(video)
    VideoIO.playvideo(video)

end

function determineFPS(param_path, video_path)
    # this function really lazily interprets ffmpeg files and makes the following assumptions
    #       The fps range is between 10-99 with two significant figures (eg xx.xx fps)
    #       the offset in the stderr reported by ffmpeg is the same
    
    # generate the params file and read it
    run(pipeline(`ffprobe $video_path`, stderr=param_path))
    f = open(param_path)
    s = read(f, String)
    close(f)

    # do some lazy absolute reference stuff that will probably break to get the fps rate
    index = findfirst("fps", s)
    fps = parse(Float64, s[index[1]-6:index[1]-2])
    return fps
end

## "MAINLINE" 
main("bubbles1.mp4")

