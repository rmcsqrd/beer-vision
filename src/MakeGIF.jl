## IMPORTS
using FileIO, ImageMagick, Colors, FixedPointNumbers, ProgressMeter

## FUNCTIONS
function makeGIF(image_folder, save_location)
    # this implementation inspired by https://discourse.julialang.org/t/plotting-a-sequence-of-images-as-a-gif/23808/4
    # loop through files in folder and verify ends in .jpg

    numfiles = length(readdir(image_folder))
    sizeImg = size(load(string(image_folder,"/","01.jpg")))  # this is really bad but I'm really lazy
    GIFimg = Array{RGB{Normed{UInt8,8}}}(undef, sizeImg[1], sizeImg[2], numfiles-1)
    
    for (root, dirs, files) in walkdir(image_folder)
        imcnt = 1
        @showprogress 1 "Making gif..." for (filecnt, file) in enumerate(files)
            if file[length(file)-3:length(file)] == ".jpg"
                img = load(string(image_folder,"/",file))
                GIFimg[:,:, imcnt] = img
                imcnt += 1
            end

       end 
    end 
    save(save_location, GIFimg)
    return GIFimg

end
