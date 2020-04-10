## IMPORTS
using VideoIO
using Makie
using ImageTransformations

# import custom stuff
include(string(@__DIR__, "/src/DetermineFPS.jl"))
include(string(@__DIR__, "/src/ExtractFrames.jl"))

## FUNCTIONS

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
                println(file)
           end
       end
    end
end


## "MAIN LOOP"
main("bubbles1.mp4")
