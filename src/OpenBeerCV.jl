## IMPORTS
using ImageView

function background_threshold(composite_array)

    # this function takes an average of all the frames in a set and returns an average intensity of the images.
    # In doing this, it creates a baseline that we can use to detect moving object on a frame by frame basis.
    
    # loop through array and create intensity matrix
    intensity_mat = Array{Any}(undef, size(composite_array)[1], size(composite_array)[2], size(composite_array)[3])

    @showprogress 1 "Converting to grayscale..." for k in 1:size(intensity_mat)[3]
        intensity_mat[:, :, k] = Gray.(composite_array[:, :, k])
    end

    # loop through array and create average intensity image for threshold baseline
    threshold_baseline = Array{Gray{Float64}}(undef, size(intensity_mat)[1], size(intensity_mat)[2])

    @showprogress 1 "Creating baseline threshold..." for j in 1:size(threshold_baseline)[1]
        for i in 1:size(threshold_baseline)[2]
            threshold_baseline[j,i] = sum(intensity_mat[j,i,:])/size(intensity_mat)[3] 
        end
    end

    # loop through array and create generate thresholded images
    threshold_array = Array{Any}(undef, size(intensity_mat)[1], size(intensity_mat)[2], size(intensity_mat)[3])
    thresh_val = 0.1
    @showprogress 1 "Creating Threshold Array..." for k in 1:size(threshold_array)[3]
        for j in 1:size(threshold_array)[1]
            for i in 1:size(threshold_array)[2]
                val_difference = intensity_mat[j, i, k] - threshold_baseline[j, i]
                val_avg = sum(intensity_mat[j, i, k]+threshold_baseline[j, i])/2
                
                if abs(val_difference/val_avg) < thresh_val
                    threshold_array[j, i, k] = 0.0
                else
                    threshold_array[j, i, k] = 1.0
                end
            end
        end
        
    end
    return threshold_array  
   
end
