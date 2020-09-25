# Ray Tracer Challenge in Swift 5

My humble attempts to complete the Ray Tracer Challnge in Swift 5.

http://raytracerchallenge.com

## Task List

### From the book

- [x] Tuples, Points, and Vectors

	`Tuple` is struct. `Point` and `Vector` are just plain Tuple with different `w` value because I couldn't find out how to make a single constructor returned different type of struct. Should I have used class or enum instead?
	
- [x] Drawing on a Canvas
- [x] Matrices
- [x] Matrix Transformations

	Transformations are implemented as `Matrix` static func. I'm not sure this is a good idea.
	
- [x] Ray-Sphere Intersections
- [x] Light and Shading
- [x] Making a Scene

	Replace `Float` with `Double`.

- [ ] Shadows
- [ ] Planes
- [ ] Patterns
- [ ] Reflection and Refraction
- [ ] Cubes
- [ ] Cylinders
- [ ] Groups
- [ ] Triangles
- [ ] Constructive Solid Geometry (CSG)
- [ ] Next Steps
- [ ] Rendering the Cover Image


### Not on the book but...

- [ ] Convert render data to image (CGImage?) and put it up inside the app is perferable rather than save to .ppm file.
- [ ] And run the app on every screen possible (iOS, iPadOS, macOS, tvOS and watchOS!).
- [ ] Actually get into what the heck is going on there (other than just completing test cases frantically...).

Licence MIT.
