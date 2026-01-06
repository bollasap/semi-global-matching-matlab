# Semi-Global Matching
A Matlab implementation of Semi-Global Matching (SGM) for stereo matching. It includes the 4-direction, 8-direction and 16-direction versions of the algorithm with a small improvement for better results.
The improvement is that in the calculation of the total cost, the matching cost does not add up. Normally it had to add up once for each direction.

## Input Image
The Tsukuba stereo image that used as input.

<p align="center">
  <img src="left.png"> 
</p>

## Output Image
The disparity map that created at the output using the 4-direction version.

<p align="center">
  <img src="disparity1.png"> 
</p>

The disparity map that created at the output using the 8-direction version.

<p align="center">
  <img src="disparity2.png"> 
</p>

The disparity map that created at the output using the 16-direction version.

<p align="center">
  <img src="disparity3.png"> 
</p>

## Related Repositories

- [Semi-Global Matching (4-direction)](https://github.com/bollasap/semi-global-matching-4-direction)
- [Semi-Global Matching (8-direction)](https://github.com/bollasap/semi-global-matching-8-direction)
- [Semi-Global Matching (16-direction)](https://github.com/bollasap/semi-global-matching-16-direction)
