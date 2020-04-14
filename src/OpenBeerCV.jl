function background_threshold(composite_array, thresh_val)

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
    @showprogress 1 "Creating Threshold Array..." for k in 1:size(threshold_array)[3]
        for j in 1:size(threshold_array)[1]
            for i in 1:size(threshold_array)[2]
                val_difference = intensity_mat[j, i, k] - threshold_baseline[j, i]
                val_avg = sum(intensity_mat[j, i, k]+threshold_baseline[j, i])/2
                

                if abs(val_difference/val_avg) < thresh_val
                    threshold_array[j, i, k] = Gray{N0f8}(0.0)
                else
                    threshold_array[j, i, k] = Gray{N0f8}(1.0)
                end
            end
        end
        
    end
    return threshold_array, intensity_mat
end


function side_by_side(composite_array, threshold_array)
    
    # total vanity gif generator to create a side by side gif of bubbles and thresholded gif
    vanity_array = Array{Any}(undef, size(composite_array)[1], size(composite_array)[2], size(composite_array)[3])
    
    @showprogress 1 "mirror, mirror..." for k in 1:size(threshold_array)[3]
        for j in 1:size(threshold_array)[1]
            for i in 1:size(threshold_array)[2]
                # if i > 0.5*size(threshold_array)[2]
                if i < (k*size(threshold_array)[2]/size(threshold_array)[3])
                    vanity_array[j, i, k] = threshold_array[j, i, k]
                else
                    vanity_array[j, i, k] = composite_array[j, i, k]
                end
                    
            end
        end
        
    end
    return vanity_array
end

function ColorCentroidOverlay(color_array, centroid_array)
    # this function plots the centroids of the bubbles onto the color video
    overlay = Array{RGB{N0f8}}(undef, size(color_array)[1], size(color_array)[2], size(color_array)[3])
    
    for k in 1:size(centroid_array)[3]
        for j in 1:size(centroid_array)[1]
            for i in 1:size(centroid_array)[2]
                if centroid_array[j, i, k] != Gray{N0f8}(0.0)
                    overlay[j, i, k] = RGB(1, 0, 1)
                else
                    overlay[j, i, k] = color_array[j, i, k]
                end
            end
        end
    end
    return overlay
end
