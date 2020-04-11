## IMPORTS
using ImageView

function background_threshold(composite_array)

    # this function takes an average of all the frames in a set and returns an average intensity of the images.
    # In doing this, it creates a baseline that we can use to detect moving object on a frame by frame basis.
    
    # loop through array and create intensity matrix
    intensity_mat = Array{Any}(undef, size(composite_array)[1], size(composite_array)[2], size(composite_array)[3])

    for k in 1:size(intensity_mat)[3]
        intensity_mat[:, :, k] = Gray.(composite_array[:, :, k])
    end

    # loop through array and create average intensity image for threshold baseline
    threshold_baseline = Array{Gray{Float64}}(undef, size(intensity_mat)[1], size(intensity_mat)[2])

    for j in 1:size(threshold_baseline)[1]
        for i in 1:size(threshold_baseline)[2]
            threshold_baseline[j,i] = sum(intensity_mat[j,i,:])/size(intensity_mat)[3] 
        end
    end
    imshow(threshold_baseline)
end
