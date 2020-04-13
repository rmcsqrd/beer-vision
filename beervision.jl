## IMPORTS
using VideoIO, Makie, ImageTransformations, Plots

# import custom stuff
include(string(@__DIR__, "/src/DetermineFPS.jl"))
include(string(@__DIR__, "/src/ImageProcessingWrappers.jl"))
include(string(@__DIR__, "/src/MakeGIF.jl"))
include(string(@__DIR__, "/src/OpenBeerCV.jl"))
include(string(@__DIR__, "/src/BlobCentroidDetect.jl"))
include(string(@__DIR__, "/src/BeerProbability.jl"))

function beervision(video_name)
    ### VIDEO PRE PROCESSING STUFF ###
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
    N = 100  # 100 will give you issues with file naming (eg _09, _10, _100, _11)
    extract_frames(N, video_prefix, video_path)
   
    # generate video file parameters and extract actual video fps rate
    file_params_path = string(video_output_folder,"/_file_params.txt")
    imagefps = determineFPS(file_params_path, video_path)
   
    # loop through image folder and shrink images
    resize_images(0.3, video_output_folder)

    # make a gif of stuff 
    gif_location = string(@__DIR__,"/data/output/",video_name,".gif")
    bubble_array= makeGIF(video_output_folder, gif_location)

    ### IMAGE PROCESSING STUFF ###
    # create threshold baseline for static parts of images
    threshold_value = 0.25
    threshold_array, gray_array = background_threshold(bubble_array, threshold_value)
    gif_location = string(@__DIR__,"/data/output/",video_name,"threshold",".gif")
    save(gif_location, threshold_array)
   
     
    # create vanity gif because it looks cool
    vanity_gif = side_by_side(gray_array, threshold_array)
    gif_location = string(@__DIR__,"/data/output/",video_name,"vanity",".gif")
    save(gif_location, vanity_gif)

    # compute centroids and generate gif
    centroid_array = BlobCentroidDetect(threshold_array)  # note that if you try to generate a gif with this data and >20ish frames stuff breaks for some reason. Overaly works tho
    #centroid_overlay = ColorCentroidOverlay(bubble_array, centroid_array)
    #gif_location = string(@__DIR__,"/data/output/",video_name,"centroids",".gif")
    #save(gif_location, centroid_overlay)
    
    # do probability calculations using the computed centroids
    count_region_y = 100  # measured from top of image, down (in px)
    count_region_h = 10  # height of counting region
    n_bins = 50  # the number of bins to sample from
    output_array, distribution_data = DistributionEstimate(bubble_array, centroid_array, count_region_y, count_region_h, n_bins, imagefps)
    gif_location = string(@__DIR__,"/data/output/",video_name,"distdata",".gif")
    save(gif_location, output_array)
    
    # plot a histogram
    bins = distribution_data[:, 1]
    data = distribution_data[:, 2]
    histogram(data, bins)
    
        
end


## "MAIN LOOP"
beervision("bubbles1.mp4")  # uncomment to run automatically when included from REPL
