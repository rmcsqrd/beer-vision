## IMPORTS
using Colors

function DistributionEstimate(color_array, centroid_array, y, h, n_bins, fps)
    # generate output gif
    bincrement = Int(floor(size(centroid_array)[2]/n_bins))
    output_array = Array{RGB{N0f8}}(undef, size(color_array)[1], size(color_array)[2], size(color_array)[3])

    # generate bin counting array n_bin x k square matrix, initialize with zeros. This will count the times of arrival.
    # also generate a bin timing array (n_bin x 1) which counts the times between hits for each bin
    bin_hits = zeros(n_bins, size(centroid_array)[3])  
    bin_counts = zeros(n_bins) 
    
    # color info
    magenta = RGB(1, 0, 1)
    green = RGB(0, 1, 0)
    grey = RGB(0.6, 0.6, 0.6)
    blue = RGB(0, 0, 1)

    @showprogress 1 "Doing probability stuff..." for k in 1:size(centroid_array)[3]
        for j in 1:size(centroid_array)[1]
            bincnt = 1 
            for i in 1:size(centroid_array)[2]

                ## GENERATE OUTPUT IMAGE FRAMES
                # Check if centroid marker is in or above counting region
                if j > y+h
                    centroid_color = magenta
                else
                    centroid_color = green
                end
                
                if centroid_array[j, i, k] != Gray{N0f8}(0.0)
                    output_array[j, i, k] = centroid_color
                else
                    # check if within counting region
                    if j < y+h && j > y
                        output_array[j, i, k] = color_array[j, i, k]*0.5  # reduce intensity in counting region
                    else
                        output_array[j, i, k] = color_array[j, i, k]
                    end
                end 

                # chek if at counting region border
                if j == y+h || j == y
                    output_array[j, i, k] = grey
                end
                
                # Check if at some sort of bin line
                if i == bincrement*bincnt
                    output_array[j, i, k] = grey
                    bincnt += 1
                end

                ## DO PROBABILITY STUFF
                if j <= y+h && j >= y
                    if centroid_array[j, i, k] > Gray{N0f8}(0.6)
                        binid = Int(ceil(i/n_bins))  # compute bin location
                        bin_hits[binid, k] = bin_counts[binid]*fps^-1
                        bin_counts[binid] = 0
                    end
                end


            end
        end 
        bin_counts .+= 1  # increment up bin count
    end

    # Process the data
    dist_data = zeros(size(centroid_array)[3], 2)
    for n in 1:size(dist_data)[1]
        dist_data[n, 1] = (n-1)*fps^-1
    end
    
    for j in 1:size(bin_hits)[1]
        for i in 1:size(bin_hits)[2]
            for n in 1:size(dist_data)[1]
                if bin_hits[j, i] == dist_data[n, 1]
                    dist_data[n, 2] += 1  # basically just check for match
                end
            end
        end
    end
    
    #display(dist_data)  # uncomment to see distribution
    dist_data= dist_data[2:size(dist_data)[1], :]  # truncate off zero terms
    return output_array, dist_data
end

function RateOptimization(dist_data)

    # this function loosely follows the notation from http://localhost:1313/content/beervision/#RateEstimate
    lambda = collect(0:0.01:400)  # this is our array of potential lambdas we're trying to optimize (upper bound from experience)
    output = zeros(size(lambda)[1])  # overall variable that we check for min of

    for a in 1:size(output)[1] 
        a_output = zeros(size(dist_data)[1])  # temporary variable we store the output for a given λ_a
        for n in 1:(size(dist_data)[1]-1)  # -1 is only so we don't get an index error for bins (basically no events occur at t > 1s so I don't feel bad about this)
        #for n in 2:(size(dist_data)[1]-0)  # -1 is only so we don't get an index error for bins (basically no events occur at t > 1s so I don't feel bad about this)
            p_hat = dist_data[n, 2]/sum(dist_data[:, 2])
            
            # using the trapezoidal rule per https://tgmstat.wordpress.com/2013/10/02/fast-and-useful-numerical-integration-methods/ (swap indices a,b for i,j)
            i = dist_data[n, 1]
            j = dist_data[n+1, 1]
            fi = lambda[a]*exp(-lambda[a]*i)
            fj = lambda[a]*exp(-lambda[a]*j) 
            p = (j-i)/2*(fi+fj)

            a_output[n] = (p-p_hat)^2
        end
        output[a] = sqrt(sum(a_output))
    end

    mindex = argmin(output)
    lambda_opt = lambda[mindex]

    p_output = zeros(size(dist_data)[1])  # just the experimental probability (for plotting purposes)
    l_output = zeros(size(dist_data)[1])
    for n in (1:size(p_output)[1]-1)
            p_hat = dist_data[n, 2]/sum(dist_data[:, 2])
            
            # using the trapezoidal rule per https://tgmstat.wordpress.com/2013/10/02/fast-and-useful-numerical-integration-methods/ (swap indices a,b for i,j)
            i = dist_data[n, 1]
            j = dist_data[n+1, 1]
            fi = lambda_opt*exp(-lambda_opt*i)
            fj = lambda_opt*exp(-lambda_opt*j) 
            p = (j-i)/2*(fi+fj)

            p_output[n] = p_hat
            l_output[n] = p
    end

        
    return lambda_opt, lambda, output, p_output, l_output
end
