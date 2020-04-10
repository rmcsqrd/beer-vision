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
        
