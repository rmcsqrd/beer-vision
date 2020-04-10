## IMPORTS
using VideoIO
using Makie
using ImageTransformations

# import custom stuff
include(string(@__DIR__, "/src/DetermineFPS.jl"))
include(string(@__DIR__, "/src/ExtractFrames.jl"))
include(string(@__DIR__, "/src/MakeGIF.jl"))

function main(video_name)
    # choose video frame parameters and extract frames
    video_path = string(@__DIR__,"/data/videos/", video_name)
    foldername = video_name[1:length(video_name)-4]
    try
        mkdir(string(@__DIR__,"/data/frames/", foldername))  # make a new directory if doesn't exist. If it does exist ignore error and move on
    catch
        
    end
    video_output_folder = string(@__DIR__,"/data/frames/$foldername")
    video_prefix = string(video_output_folder,"/")
 
    # do a naive check to see if folder has contents, if not, extract images
    if length(readdir(string(video_output_folder,"/"))) == 1  # check for pesky .DS_store 
        N = 10 # 100 will give you issues with file naming (eg _09, _10, _100, _11)
        extract_frames(N, video_prefix, video_path)
    end
   
    # generate video file parameters and extract actual video fps rate
    file_params_path = string(video_output_folder,"/_file_params.txt")
    imagefps = determineFPS(file_params_path, video_path)
    
    makeGIF(video_output_folder)
        
end


## "MAIN LOOP"
main("bubbles1.mp4")
