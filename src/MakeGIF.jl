## IMPORTS
using FileIO, ImageMagick, Colors, FixedPointNumbers

## FUNCTIONS
function makeGIF(image_folder)
    # this implementation inspired by https://discourse.julialang.org/t/plotting-a-sequence-of-images-as-a-gif/23808/4
    # loop through files in folder and verify ends in .jpg
    for (root, dirs, files) in walkdir(image_folder)
        imcnt = 1
        for (filecnt, file) in enumerate(files)
            if file[length(file)-3:length(file)] == ".jpg"
                filepath = string(image_folder,"/",file)
                img = load(filepath)
                
                if isequal(imcnt, 1)
                    # initialize empty array globally because I was having issues with the scope
                    # magic number because the only other thing in the folder should be _file_params.txt and .DS_store 
                    global GIFimg = Array{RGBX{Normed{UInt8,8}}}(undef, size(img)[1], size(img)[2], length(files)-2)                end
                GIFimg[:,:, imcnt] = img
                imcnt += 1

           end
       end 
    end 
    save("/Users/riomcmahon/Desktop/test.gif", GIFimg)

end
