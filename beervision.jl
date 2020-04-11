## IMPORTS
using VideoIO, Makie, ImageTransformations

# import custom stuff
include(string(@__DIR__, "/src/DetermineFPS.jl"))
include(string(@__DIR__, "/src/ImageProcessingWrappers.jl"))
include(string(@__DIR__, "/src/MakeGIF.jl"))

function beervision(video_name)
    # choose video frame parameters and extract frames
    video_path = string(@__DIR__,"/data/videos/", video_name)
    foldername = video_name[1:length(video_name)-4]
    video_output_folder = string(@__DIR__,"/data/frames/$foldername")
    video_prefix = string(video_output_folder,"/")
 
    # clear existing images and extract from the video
    try
        rm(video_output_folder, recursive=true)
    catch
    end
    mkdir(string(@__DIR__,"/data/frames/", foldername))  
    N = 100# 100 will give you issues with file naming (eg _09, _10, _100, _11)
    extract_frames(N, video_prefix, video_path)
   
    # generate video file parameters and extract actual video fps rate
    file_params_path = string(video_output_folder,"/_file_params.txt")
    imagefps = determineFPS(file_params_path, video_path)
   
    # loop through image folder and shrink images
    resize_images(0.3, video_output_folder)

    # make a gif of stuff 
    gif_location = "/Users/riomcmahon/Desktop/test.gif" 
    makeGIF(video_output_folder, gif_location)
        
end


## "MAIN LOOP"
beervision("bubbles1.mp4")  # uncomment to run automatically when included from REPL
