## IMPORTS
using Colors

function BlobCentroidDetect(video_array)
    # This function takes in an m x n x k array (m x n are frame dimensions, k is number of frames) 
    # it computes the centroid of the blob and returns an m x n x k array of blob centroids
    
    # initialize empty centroid array
    centroid_array = Array{Gray{N0f8}}(undef, size(video_array)[1], size(video_array)[2], size(video_array)[3])

    @showprogress 1 "Computing Centroids..." for k in 1:size(video_array)[3]

        # loop through video_array and compute centroids - ROWS then COLUMNS
        for j in 1:size(video_array)[1]
            centroid_vect = ComputeVectCentroid(video_array[j, :, k])
            centroid_array[j, :, k] += centroid_vect
        end
        
        # loop through video_array and compute centroids - COLUMNS then ROWS
        for i in 1:size(video_array)[2]
            centroid_vect = ComputeVectCentroid(video_array[:, i, k])
            centroid_array[:, i, k] += centroid_vect
        end 
    end

    return centroid_array
end

function ComputeVectCentroid(input_vect)
    # thus function loops through the element in the vector and computes centroids for each discrete item (discrete implies one pixel of separation)
    centroid_vect = Array{Gray{N0f8}}(undef, size(input_vect))
    
    centroid_cnt = 0
    white = Gray{N0f8}(1.0)
    black = Gray{N0f8}(0.0)
    for n in 1:size(centroid_vect)[1]
        # loop through each value and check for centroid conditions
        if n != size(centroid_vect)[1]  # don't do anything at edge condition
            
            # CASE 1: Adjacent black pixels
            if input_vect[n] == black && input_vect[n+1] == black
                centroid_vect[n] = black
            
            # CASE 2: white then black pixels
            elseif input_vect[n] == white && input_vect[n+1] == black
                centroid_vect[n-Int(floor(centroid_cnt/2))] = Gray{N0f8}(0.4999) # if we add 0.5+0.5 it goes to 0.0 based on data type
                centroid_vect[n] = black
                centroid_cnt = 0

            # CASE 3,4: White then white pixels or black then white pixels
            else
                centroid_vect[n] = black
                centroid_cnt += 1
            end
        end
    end
    return centroid_vect
end
