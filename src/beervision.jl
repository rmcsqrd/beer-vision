## IMPORTS
using VideoIO
using Makie

## FUNCTION
function main()
    video = "/Users/riomcmahon/Programming/beervision/data/VID_20200404_200544.mp4"
    VideoIO.playvideo(video)
    close(video) 

end

## "MAINLINE" 
main()
