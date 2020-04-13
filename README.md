## Beervision.jl
Ever been curious where the bubbles in your beer come from? How they just seem to appear from nowhere? Why there's just so much dang foam?  

 These are all great questions that I'm not going to answer within this repo. Instead, I'm using computer vision to try to quantify the emission rate of beer bubbles as an exponentially distributed random variable.  

An extensive write up of this can be found [here](https://riomcmahon.me/portfolio/beervision/).


## Usage
- Install Julia (https://julialang.org/downloads/)
- Clone this repository to `/some/location/on/your/computer`
```
    $ git clone https://github.com/rmcsqrd/beer-vision.git
```
 - Navigate to the root directory of the cloned repository. Open the Julia REPL (this assumes you set up your path correctly). Instantiate and activate the environment then include the beervision file. Run the program on a file of your choice for some number of frames. (example videos are included in `/data/videos`). Note that there is some bug if you input around `N=20` frames. `N=1` and `N=100` are working.
```
    $ cd /some/location/on/your/computer
    $ julia
    julia> ]
    (v1.xx) pkg> instantiate
    (v1.xx) pkg> activate
    julia> include("beervision.jl")
    julia> beervision("bubbles1.mp4", 100)
```
If you have questions about the usage you can use the help function
```
    julia> ?
    help?> beervision
```

## What is going on?

In a nutshell, the `beervision()` function is extracting the frames from a video, thresholding the image to find the bubbles, locating bubble centroids, and computing the interarrival time as they cross a user prescribed boundary.  

Pictures are worth 1000 words so I've illustrated the image processing pipeline below. The gifs below are in `/aux`. When you run your this on your machine, similar versions of these gifs will be in `/data/output/`  

### Image Processing Pipeline

1. Extract Images

![alt text](https://github.com/rmcsqrd/beer-vision/raw/master/aux/output/bubbles1.mp4.gif "Bubbles")

2. Threshold Images. This threshold value is the variable `threshold_value` in `beervision.jl`. The code for the image threshold operation is the function `background_threshold()` in `src/OpenBeerCV.jl`

![alt text](https://github.com/rmcsqrd/beer-vision/raw/master/aux/output/bubbles1.mp4vanity.gif "Bubbles")

3. Locate bubble centroids. The code for the centroid detection is in the function `BlobCentroidDetect()` located in `src/BlobCentroidDetect.jl`

![alt text](https://github.com/rmcsqrd/beer-vision/raw/master/aux/output/bubbles1.mp4centroids.gif "Bubbles")

4. Count bubbles based on user defined bin parameters (parameters located in `beervision.jl`). Output plot of interarrival times to `data/output/plots`. 

![alt text](https://github.com/rmcsqrd/beer-vision/raw/master/aux/output/bubbles1.mp4distdata.gif "Bubbles")


The end result definitely looks like an exponentially distributed RV. (Note that the plot below was for `N=100`frames. The gifs above were from `N=10` to reduce file size since my encoding is pretty inefficient).

![alt text](https://github.com/rmcsqrd/beer-vision/raw/master/aux/output/plots/plot.png "Bubbles")

